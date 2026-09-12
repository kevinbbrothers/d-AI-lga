using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;
using System.Text.Json;
using System.Threading;

namespace EmulatorBot
{
    /// <summary>A single step: which key, how long to hold it, and how long to wait after.</summary>
    public class RoutingStep
    {
        public string Key { get; set; } = "";
        public int DurationMs { get; set; } = 100;
        public int DelayAfterMs { get; set; } = 0;
    }

    /// <summary>
    /// A named, loadable/saveable sequence of key presses for one section of the game
    /// (e.g. "IntroToFirstBattle"). Load a JSON file and call Execute() to replay it.
    /// </summary>
    public class RoutingNugget
    {
        public string Name { get; set; } = "";
        public List<RoutingStep> Steps { get; set; } = new();

        private static readonly JsonSerializerOptions JsonOptions = new()
        {
            WriteIndented = true
        };

        public static RoutingNugget Load(string filePath)
        {
            string json = File.ReadAllText(filePath);
            return JsonSerializer.Deserialize<RoutingNugget>(json, JsonOptions)
                   ?? throw new InvalidDataException($"Could not parse routing nugget: {filePath}");
        }

        public void Save(string filePath)
        {
            File.WriteAllText(filePath, JsonSerializer.Serialize(this, JsonOptions));
        }

        /// <summary>Plays back every step in order via InputSimulator.</summary>
        public void Execute()
        {
            foreach (RoutingStep step in Steps)
            {
                if (!Enum.TryParse<InputSimulator.Key>(step.Key, ignoreCase: true, out var key))
                {
                    Console.WriteLine($"Skipping unknown key '{step.Key}' in nugget '{Name}'.");
                    continue;
                }

                InputSimulator.PressKey(key, step.DurationMs);

                if (step.DelayAfterMs > 0)
                    Thread.Sleep(step.DelayAfterMs);
            }
        }
    }

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

        [DllImport("user32.dll")]
        private static extern IntPtr GetForegroundWindow();

        [StructLayout(LayoutKind.Sequential)]
        private struct RECT { public int Left, Top, Right, Bottom; }

        [StructLayout(LayoutKind.Sequential)]
        private struct POINT { public int X, Y; }

        /// <summary>Find the emulator window by exact title (e.g. "DeSmuME"). Returns IntPtr.Zero if not found.</summary>
        public static IntPtr FindEmulatorWindow(string windowTitle)
        {
            return FindWindow(null, windowTitle);
        }

        /// <summary>Attempts to focus the window and returns whether it actually took —
        /// SetForegroundWindow can fail silently, so don't trust it without checking.</summary>
        public static bool Focus(IntPtr hWnd)
        {
            SetForegroundWindow(hWnd);
            Thread.Sleep(100);
            return GetForegroundWindow() == hWnd;
        }

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

        [DllImport("user32.dll")]
        private static extern uint MapVirtualKey(uint uCode, uint uMapType);

        private const uint MAPVK_VK_TO_VSC = 0;

        //[StructLayout(LayoutKind.Sequential)]
        //private struct INPUT
        //{
        //    public uint type;
        //    public InputUnion U;
        //}   

        //[StructLayout(LayoutKind.Explicit)]
        //private struct InputUnion
        //{
        //    [FieldOffset(0)] public KEYBDINPUT ki;
        //}

        //[StructLayout(LayoutKind.Sequential)]
        //private struct KEYBDINPUT
        //{
        //    public ushort wVk;
        //    public ushort wScan;
        //    public uint dwFlags;
        //    public uint time;
        //    public IntPtr dwExtraInfo;
        //}
        [StructLayout(LayoutKind.Sequential)]
        private struct INPUT
        {
            public uint type;
            public InputUnion U;
        }

        [StructLayout(LayoutKind.Explicit)]
        private struct InputUnion
        {
            [FieldOffset(0)]
            public MOUSEINPUT mi;

            [FieldOffset(0)]
            public KEYBDINPUT ki;

            [FieldOffset(0)]
            public HARDWAREINPUT hi;
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

        [StructLayout(LayoutKind.Sequential)]
        private struct MOUSEINPUT
        {
            public int dx;
            public int dy;
            public uint mouseData;
            public uint dwFlags;
            public uint time;
            public IntPtr dwExtraInfo;
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct HARDWAREINPUT
        {
            public uint uMsg;
            public ushort wParamL;
            public ushort wParamH;
        }
        private const uint INPUT_KEYBOARD = 1;
        private const uint KEYEVENTF_KEYUP = 0x0002;
        private const uint KEYEVENTF_SCANCODE = 0x0008;
        private const uint KEYEVENTF_EXTENDEDKEY = 0x0001;

        // Arrow keys (and a few others) are "extended" keys on the keyboard's second scan code set.
        private static bool IsExtendedKey(ushort vk) =>
            vk is 0x25 or 0x26 or 0x27 or 0x28; // Left, Up, Right, Down

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
            ushort scanCode = (ushort)MapVirtualKey(vk, MAPVK_VK_TO_VSC);
            uint flags = KEYEVENTF_SCANCODE | (keyDown ? 0 : KEYEVENTF_KEYUP);
            if (IsExtendedKey(vk))
                flags |= KEYEVENTF_EXTENDEDKEY;

            var input = new INPUT
            {
                type = INPUT_KEYBOARD,
                U = new InputUnion
                {
                    ki = new KEYBDINPUT
                    {
                        wVk = 0,           // 0 when using KEYEVENTF_SCANCODE
                        wScan = scanCode,
                        dwFlags = flags,
                        time = 0,
                        dwExtraInfo = IntPtr.Zero
                    }
                }
            };
            uint result = SendInput(
                        1,
                        new[] { input },
                        Marshal.SizeOf<INPUT>());

            if (result == 0)
            {
                Console.WriteLine(
                    $"Error: {Marshal.GetLastWin32Error()}");
            }
            Console.WriteLine($"Key {(keyDown ? "DOWN" : "UP")} - VK=0x{vk:X2} ({vk})");
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

            if (!WindowCapture.Focus(hWnd))
                Console.WriteLine("Warning: could not confirm emulator window has focus. Click it manually and re-run.");
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

            // Example: load and play a routing nugget
            // JSON format:
            // {
            //   "Name": "OpenPartyMenu",
            //   "Steps": [
            //     { "Key": "Start", "DurationMs": 100, "DelayAfterMs": 300 },
            //     { "Key": "Down",  "DurationMs": 100, "DelayAfterMs": 150 },
            //     { "Key": "A",     "DurationMs": 100, "DelayAfterMs": 500 }
            //   ]
            // }
            string nuggetPath = "routes/TestMenuNugget.json";
            if (File.Exists(nuggetPath))
            {
                RoutingNugget nugget = RoutingNugget.Load(nuggetPath);
                Console.WriteLine($"Playing nugget: {nugget.Name} ({nugget.Steps.Count} steps)");
                nugget.Execute();
            }
            else
            {
                Console.WriteLine("File Not Found");
            }

            
        }
    }
}