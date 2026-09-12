using System;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading;

namespace PixelCalibratorTool
{
    /// <summary>
    /// Standalone console app for calibrating pixel checks against the DeSmuME window.
    /// Build/run this as its own project — it has no dependency on the main bot code.
    ///
    /// Typical workflow:
    ///   1. Pause the emulator on the state you want to check (e.g. battle menu with
    ///      one move disabled by 0 PP).
    ///   2. Run with "grid" to save a labeled PNG overlay — open it to eyeball coordinates.
    ///   3. Run with "probe" to interactively read live pixel colors and confirm values.
    /// </summary>
    internal static class Capture
    {
        [DllImport("user32.dll")]
        private static extern IntPtr FindWindow(string? lpClassName, string lpWindowName);

        [DllImport("user32.dll")]
        private static extern bool SetProcessDPIAware();

        /// <summary>Must be called once, before any window/capture calls, so GetClientRect,
        /// ClientToScreen, and CopyFromScreen all agree on physical (not scaled) pixels.
        /// Without this, non-100% display scaling causes the captured region to be
        /// offset/cut off from the actual window bounds.</summary>
        public static void EnsureDpiAware() => SetProcessDPIAware();

        [DllImport("user32.dll")]
        private static extern bool GetClientRect(IntPtr hWnd, out RECT lpRect);

        [DllImport("user32.dll")]
        private static extern bool ClientToScreen(IntPtr hWnd, ref POINT lpPoint);

        [DllImport("user32.dll")]
        private static extern bool SetForegroundWindow(IntPtr hWnd);

        [StructLayout(LayoutKind.Sequential)]
        private struct RECT { public int Left, Top, Right, Bottom; }

        [StructLayout(LayoutKind.Sequential)]
        private struct POINT { public int X, Y; }

        public static IntPtr FindEmulatorWindow(string windowTitle) => FindWindow(null, windowTitle);

        public static void Focus(IntPtr hWnd)
        {
            SetForegroundWindow(hWnd);
            Thread.Sleep(100);
        }

        public static Bitmap CaptureClientArea(IntPtr hWnd)
        {
            if (hWnd == IntPtr.Zero)
                throw new InvalidOperationException("Invalid window handle — did FindEmulatorWindow succeed?");

            GetClientRect(hWnd, out RECT clientRect);
            int width = clientRect.Right - clientRect.Left;
            int height = clientRect.Bottom - clientRect.Top;

            POINT topLeft = new POINT { X = 0, Y = 0 };
            ClientToScreen(hWnd, ref topLeft);

            var bmp = new Bitmap(width, height, PixelFormat.Format32bppArgb);
            using var g = Graphics.FromImage(bmp);
            g.CopyFromScreen(topLeft.X, topLeft.Y, 0, 0, new Size(width, height));
            return bmp;
        }

        public static Color GetPixel(IntPtr hWnd, int x, int y)
        {
            using Bitmap bmp = CaptureClientArea(hWnd);
            return bmp.GetPixel(x, y);
        }
    }

    internal static class PixelCalibrator
    {
        /// <summary>Captures the client area and overlays a labeled grid so you can
        /// read off (x,y) coordinates visually instead of guessing.</summary>
        public static void SaveGridOverlay(IntPtr hWnd, string outputPath, int gridSpacing = 20)
        {
            using Bitmap frame = Capture.CaptureClientArea(hWnd);
            using Graphics g = Graphics.FromImage(frame);
            using var gridPen = new Pen(Color.FromArgb(160, Color.Red), 1);
            using var font = new Font("Consolas", 7);
            using var textBrush = new SolidBrush(Color.Yellow);

            for (int x = 0; x < frame.Width; x += gridSpacing)
            {
                g.DrawLine(gridPen, x, 0, x, frame.Height);
                g.DrawString(x.ToString(), font, textBrush, x + 1, 0);
            }
            for (int y = 0; y < frame.Height; y += gridSpacing)
            {
                g.DrawLine(gridPen, 0, y, frame.Width, y);
                g.DrawString(y.ToString(), font, textBrush, 0, y + 1);
            }

            frame.Save(outputPath, ImageFormat.Png);
            Console.WriteLine($"Saved grid overlay to {outputPath}");
        }

        /// <summary>Checks a single pixel against an expected RGB color within a per-channel tolerance.
        /// Returns true/false and prints the actual color either way.</summary>
        public static bool CheckPixelMatch(IntPtr hWnd, int x, int y, byte r, byte g, byte b, int tolerance)
        {
            Color actual = Capture.GetPixel(hWnd, x, y);
            bool matches =
                Math.Abs(actual.R - r) <= tolerance &&
                Math.Abs(actual.G - g) <= tolerance &&
                Math.Abs(actual.B - b) <= tolerance;

            if (matches)
            {
                Console.WriteLine($"MATCH: ({x},{y}) is R={actual.R} G={actual.G} B={actual.B} — within tolerance {tolerance} of expected R={r} G={g} B={b}");
            }
            else
            {
                Console.WriteLine($"NO MATCH: ({x},{y}) expected R={r} G={g} B={b} (tolerance {tolerance}), actual R={actual.R} G={actual.G} B={actual.B}");
            }
            return matches;
        }

        /// <summary>Interactive loop: type "x,y,r,g,b[,tolerance]" repeatedly to check different
        /// pixels/colors without relaunching. Type "q" to quit.</summary>
        public static void RunCheckLoop(IntPtr hWnd)
        {
            Console.WriteLine("Pixel check loop — enter 'x,y,r,g,b[,tolerance]' (tolerance defaults to 10, or 'q' to quit):");
            while (true)
            {
                string? input = Console.ReadLine();
                if (input is null || input.Trim().ToLower() == "q") return;

                int[] vals;
                try
                {
                    vals = input.Split(',').Select(v => int.Parse(v.Trim())).ToArray();
                }
                catch (FormatException)
                {
                    Console.WriteLine("Couldn't parse that — expected x,y,r,g,b[,tolerance] as numbers.");
                    continue;
                }

                if (vals.Length < 5)
                {
                    Console.WriteLine("Need at least x,y,r,g,b — got fewer values than that.");
                    continue;
                }

                int tolerance = vals.Length >= 6 ? vals[5] : 10;
                CheckPixelMatch(hWnd, vals[0], vals[1], (byte)vals[2], (byte)vals[3], (byte)vals[4], tolerance);
            }
        }

        /// <summary>Interactive console probe: type "x,y" while the game is paused on the
        /// state you care about, get the live color back. Type "q" to quit.</summary>
        public static void RunPixelProbe(IntPtr hWnd)
        {
            Console.WriteLine("Pixel probe — enter 'x,y' (or 'q' to quit):");
            while (true)
            {
                string? input = Console.ReadLine();
                if (input is null || input.Trim().ToLower() == "q") return;

                string[] parts = input.Split(',');
                if (parts.Length != 2 ||
                    !int.TryParse(parts[0].Trim(), out int x) ||
                    !int.TryParse(parts[1].Trim(), out int y))
                {
                    Console.WriteLine("Format: x,y");
                    continue;
                }

                Color c = Capture.GetPixel(hWnd, x, y);
                double lum = 0.299 * c.R + 0.587 * c.G + 0.114 * c.B;
                Console.WriteLine($"({x},{y}) => R={c.R} G={c.G} B={c.B}  |  Luminance={lum:F0}");
            }
        }
    }

    internal static class Program
    {
        private static void Main(string[] args)
        {
            Capture.EnsureDpiAware();

            IntPtr hWnd = Capture.FindEmulatorWindow("DeSmuME 0.9.13 x64 SSE2 | Pokémon Platinum");
            if (hWnd == IntPtr.Zero)
            {
                Console.WriteLine("Emulator window not found. Is it running?");
                return;
            }
            Capture.Focus(hWnd);
            Thread.Sleep(200);

            string mode = args.Length > 0 ? args[0].ToLower() : "";

            switch (mode)
            {
                case "grid":
                    string outPath = args.Length > 1 ? args[1] : "grid_overlay.png";
                    int spacing = args.Length > 2 && int.TryParse(args[2], out int s) ? s : 40;
                    PixelCalibrator.SaveGridOverlay(hWnd, outPath, spacing);
                    break;

                case "probe":
                    PixelCalibrator.RunPixelProbe(hWnd);
                    break;

                case "check":
                    PixelCalibrator.RunCheckLoop(hWnd);
                    break;

                default:
                    Console.WriteLine("Usage:");
                    Console.WriteLine("  PixelCalibrator grid [outputPath.png] [gridSpacing]   - save labeled grid overlay (default spacing 40)");
                    Console.WriteLine("  PixelCalibrator probe                                  - interactively read pixel colors");
                    Console.WriteLine("  PixelCalibrator check                                  - interactively check pixel/color/tolerance combos");
                    break;
            }
        }
    }
}