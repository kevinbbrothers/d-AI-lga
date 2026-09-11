using System;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Threading;

namespace dAIlga
{
    /// <summary>
    /// Captures the emulator window, reads pixel colors, and simulates key presses.
    /// No memory access — input via SendInput, state via screen pixels only.
    /// </summary>
    public static class WindowCapture
    {
        [DllImport("user32.dll")]
        private static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll")]
        private static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

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

        /// <summary>Find the emulator window by exact title (e.g. "DeSmuME"). Returns IntPtr.Zero if not found.</summary>
        public static IntPtr FindEmulatorWindow(string windowTitle)
        {
            return FindWindow(null, windowTitle);
        }

        public static void Focus(IntPtr hWnd) => SetForegroundWindow(hWnd);

        /// <summary>
        /// Captures the CLIENT area of the window (excludes title bar/borders), so pixel
        /// coordinates you hardcode will match what you see in the emulator's render area.
        /// </summary>
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
            using (var g = Graphics.FromImage(bmp))
            {
                g.CopyFromScreen(topLeft.X, topLeft.Y, 0, 0, new Size(width, height));
            }
            return bmp;
        }

        /// <summary>Convenience: grab one pixel color without holding onto the full bitmap.</summary>
        public static Color GetPixel(IntPtr hWnd, int x, int y)
        {
            using Bitmap bmp = CaptureClientArea(hWnd);
            return bmp.GetPixel(x, y);
        }
    }

    public static class InputSimulator
    {
        [DllImport("user32.dll", SetLastError = true)]
        private static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

        [StructLayout(LayoutKind.Sequential)]
        private struct INPUT
        {
            public uint type;
            public InputUnion U;
        }

        [StructLayout(LayoutKind.Explicit)]
        private struct InputUnion
        {
            [FieldOffset(0)] public KEYBDINPUT ki;
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct KEYBDINPUT
        {
            public ushort wVk;
            public ushort wScan;
            public uint dwFlags;
            public uint time;
            public IntPtr dwExtraInfo;
        }

        private const uint INPUT_KEYBOARD = 1;
        private const uint KEYEVENTF_KEYUP = 0x0002;

        /// <summary>
        /// Common virtual-key codes for DeSmuME default bindings — adjust to match your config.
        /// </summary>
        public enum Key : ushort
        {
            Up = 0x26,
            Down = 0x28,
            Left = 0x25,
            Right = 0x27,
            A = 0x58,      // 'X' key, common DeSmuME default for A
            B = 0x5A,      // 'Z' key, common DeSmuME default for B
            Start = 0x0D,  // Enter
            Select = 0x08  // Backspace
        }

        private static void SendKeyEvent(ushort vk, bool keyDown)
        {
            var input = new INPUT
            {
                type = INPUT_KEYBOARD,
                U = new InputUnion
                {
                    ki = new KEYBDINPUT
                    {
                        wVk = vk,
                        wScan = 0,
                        dwFlags = keyDown ? 0 : KEYEVENTF_KEYUP,
                        time = 0,
                        dwExtraInfo = IntPtr.Zero
                    }
                }
            };
            SendInput(1, new[] { input }, Marshal.SizeOf<INPUT>());
        }

        /// <summary>Press and release a key, holding for durationMs (default one emulator "tap").</summary>
        public static void PressKey(Key key, int durationMs = 100)
        {
            SendKeyEvent((ushort)key, true);
            Thread.Sleep(durationMs);
            SendKeyEvent((ushort)key, false);
        }

        /// <summary>Hold a key down without releasing — call ReleaseKey manually.</summary>
        public static void HoldKey(Key key) => SendKeyEvent((ushort)key, true);

        public static void ReleaseKey(Key key) => SendKeyEvent((ushort)key, false);
    }

    internal class Program
    {
        private static void Main()
        {
            // Adjust to your emulator window's exact title (check Task Manager / Spy++ if unsure)
            IntPtr hWnd = WindowCapture.FindEmulatorWindow("DeSmuME 0.9.13 x64 SSE2 | Pokémon Platinum");
            if (hWnd == IntPtr.Zero)
            {
                Console.WriteLine("Emulator window not found. Is it running?");
                return;
            }

            WindowCapture.Focus(hWnd);
            Thread.Sleep(300); // let focus settle before sending input

            // Example: move right, then read a pixel (e.g. an HP bar sample point)
            InputSimulator.PressKey(InputSimulator.Key.Right, 150);
            Thread.Sleep(200); // let the frame update

            Color pixel = WindowCapture.GetPixel(hWnd, 120, 45);
            Console.WriteLine($"Pixel at (120,45): R={pixel.R} G={pixel.G} B={pixel.B}");

            // Example: sample multiple points at once (useful for reading an HP bar's width)
            using (Bitmap frame = WindowCapture.CaptureClientArea(hWnd))
            {
                for (int x = 100; x <= 140; x += 10)
                {
                    Color c = frame.GetPixel(x, 45);
                    Console.WriteLine($"  x={x}: R={c.R} G={c.G} B={c.B}");
                }
            }
        }
    }
}