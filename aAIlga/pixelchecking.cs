using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

namespace PixelChecking
{
    /// <summary>
    /// Self-contained pixel-color check — no Main, no console I/O, no dependency on the
    /// PixelCalibrator console project. Drop this file into any project and call CheckPixel.
    ///
    /// Requires System.Drawing.Common (and UseWindowsForms=true / net8.0-windows target,
    /// same as the calibrator project) since it uses Bitmap/Graphics for capture.
    /// </summary>
    public static class PixelChecker
    {
        [DllImport("user32.dll")]
        private static extern IntPtr FindWindow(string? lpClassName, string lpWindowName);

        [DllImport("user32.dll")]
        private static extern bool GetClientRect(IntPtr hWnd, out RECT lpRect);

        [DllImport("user32.dll")]
        private static extern bool ClientToScreen(IntPtr hWnd, ref POINT lpPoint);

        [DllImport("user32.dll")]
        private static extern bool SetProcessDPIAware();

        [StructLayout(LayoutKind.Sequential)]
        private struct RECT { public int Left, Top, Right, Bottom; }

        [StructLayout(LayoutKind.Sequential)]
        private struct POINT { public int X, Y; }

        private static bool _dpiAwareSet;

        /// <summary>
        /// Must be called once before the first capture, so GetClientRect/ClientToScreen/CopyFromScreen
        /// agree on physical (not display-scaled) pixels. Safe to call multiple times — only takes
        /// effect once per process. Call this explicitly at startup if your host app does its own
        /// window/UI setup before the first CheckPixel call; otherwise CheckPixel calls it for you.
        /// </summary>
        public static void EnsureDpiAware()
        {
            if (_dpiAwareSet) return;
            SetProcessDPIAware();
            _dpiAwareSet = true;
        }

        /// <summary>Finds a window by exact title. Returns IntPtr.Zero if not found.</summary>
        public static IntPtr FindWindowByTitle(string windowTitle) => FindWindow(null, windowTitle);

        /// <summary>
        /// Checks one pixel in the given window's client area against an expected RGB color
        /// within a per-channel tolerance. Returns true if it matches, false otherwise —
        /// no console output, safe to call in a tight loop.
        /// </summary>
        public static bool CheckPixel(IntPtr hWnd, int x, int y, byte r, byte g, byte b, int tolerance = 10)
        {
            EnsureDpiAware();

            if (hWnd == IntPtr.Zero)
                throw new InvalidOperationException("Invalid window handle — did FindWindowByTitle succeed?");

            Color actual = GetClientPixel(hWnd, x, y);
            return Math.Abs(actual.R - r) <= tolerance &&
                   Math.Abs(actual.G - g) <= tolerance &&
                   Math.Abs(actual.B - b) <= tolerance;
        }

        /// <summary>
        /// Same as CheckPixel, but also finds the window by title first — convenient for
        /// one-off calls where the caller doesn't already have an hWnd cached. Throws if the
        /// window can't be found; use FindWindowByTitle + the hWnd overload if you're polling
        /// repeatedly, to avoid re-searching for the window every call.
        /// </summary>
        public static bool CheckPixel(string windowTitle, int x, int y, byte r, byte g, byte b, int tolerance = 10)
        {
            IntPtr hWnd = FindWindowByTitle(windowTitle);
            if (hWnd == IntPtr.Zero)
                throw new InvalidOperationException($"Window not found: \"{windowTitle}\"");

            return CheckPixel(hWnd, x, y, r, g, b, tolerance);
        }

        /// <summary>Returns the actual color at (x,y) in the window's client area, for callers
        /// that want the raw value instead of a bool (e.g. logging, debugging a failed check).</summary>
        public static Color GetPixelColor(IntPtr hWnd, int x, int y)
        {
            EnsureDpiAware();
            return GetClientPixel(hWnd, x, y);
        }

        private static Color GetClientPixel(IntPtr hWnd, int x, int y)
        {
            GetClientRect(hWnd, out RECT clientRect);
            int width = clientRect.Right - clientRect.Left;
            int height = clientRect.Bottom - clientRect.Top;

            POINT topLeft = new POINT { X = 0, Y = 0 };
            ClientToScreen(hWnd, ref topLeft);

            // Capture just the single pixel's row-column region rather than the whole client
            // area, since this may be called frequently (e.g. every turn during a battle loop).
            using var bmp = new Bitmap(width, height, PixelFormat.Format32bppArgb);
            using (var g = Graphics.FromImage(bmp))
            {
                g.CopyFromScreen(topLeft.X, topLeft.Y, 0, 0, new Size(width, height));
            }
            return bmp.GetPixel(x, y);
        }
    }
}