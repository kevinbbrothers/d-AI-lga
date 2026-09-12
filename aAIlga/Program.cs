using aAIlga;
using dAIlga;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text.Json;
using System.Threading;
using static aAIlga.Pokemon;


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

    /// <summary>One party slot's HP snapshot, as written by BattleDump.lua.</summary>
    public class PartySlotState
    {
        public int Slot { get; set; }
        public int Hp { get; set; }
        public int MaxHp { get; set; }
    }

    /// <summary>
    /// Mirrors the JSON written by BattleDump.lua (the DeSmuME Lua script). Poll
    /// Load() during battle to get current HP for player, opponent, and full party.
    /// </summary>
    public class BattleState
    {
        public bool InBattle { get; set; }
        public int PlayerHP { get; set; }
        public int PlayerMaxHP { get; set; }
        public int OpponentHP { get; set; }
        public int OpponentMaxHP { get; set; }
        public List<PartySlotState> Party { get; set; } = new();

        private static readonly JsonSerializerOptions JsonOptions = new()
        {
            PropertyNameCaseInsensitive = true
        };

        /// <summary>
        /// Reads the JSON file the Lua script writes. Returns null (rather than throwing)
        /// if the file doesn't exist yet or is mid-write — callers should just retry next tick.
        /// </summary>
        public static BattleState? Load(string filePath)
        {
            try
            {
                string json = File.ReadAllText(filePath);
                return JsonSerializer.Deserialize<BattleState>(json, JsonOptions);
            }
            catch (IOException)
            {
                return null; // file locked mid-write by the Lua script; try again next poll
            }
            catch (JsonException)
            {
                return null; // partial/corrupt write caught mid-flush; try again next poll
            }
        }
    }

    /// <summary>Raw battle-relevant stat block from a snapshot (values as Plat_Qol.lua wrote them).</summary>
    public class RawBattleStats
    {
        public long Attack { get; set; }
        public long Defense { get; set; }
        public long Speed { get; set; }
        public long SpAttack { get; set; }
        public long SpDefense { get; set; }
    }

    /// <summary>One active battler (player or enemy) from a BattleSnapshot-##### dump.</summary>
    public class ActiveBattler
    {
        public int Battler { get; set; }
        public string Side { get; set; } = "";
        public int ActivePartySlot { get; set; }
        public long BattleMonAddr { get; set; }
        public long PartyMonAddr { get; set; }
        public long Pid { get; set; }
        public string Species { get; set; } = "";
        public int CurrentHp { get; set; }
        public List<string> Moves { get; set; } = new();
        public string Ability { get; set; } = "";
        public string Nature { get; set; } = "";
        public string HeldItem { get; set; } = "";
        public string Status { get; set; } = "";
        public int StatusRaw { get; set; }
        public List<int> MovePPs { get; set; } = new();
        public RawBattleStats RawBattleStats { get; set; } = new();
    }

    /// <summary>
    /// Mirrors the JSON written to \dumps\BattleSnapshot-##### when 't' is pressed in-game.
    /// Note: the sample dump has no MaxHp field, only CurrentHp — if you need max HP,
    /// pull it from your party JSON (PartyHpDump.lua) and match by ActivePartySlot.
    /// </summary>
    public class BattleSnapshot
    {
        public int TrainerId { get; set; }
        public int SecretId { get; set; }
        public long BattleSys { get; set; }
        public long BattleCtx { get; set; }
        public int BattleType { get; set; }
        public List<ActiveBattler> PlayerActive { get; set; } = new();
        public List<ActiveBattler> TrainerActive { get; set; } = new();
    }

    /// <summary>
    /// Presses 't' to trigger a Plat_Qol.lua battle snapshot, waits for the new
    /// BattleSnapshot-##### file to appear in the dumps folder, parses it, and
    /// deletes it so the next capture can be told apart from this one.
    /// </summary>
    public static class BattleSnapshotReader
    {
        private static readonly JsonSerializerOptions JsonOptions = new()
        {
            PropertyNameCaseInsensitive = true
        };

        /// <summary>
        /// Triggers and reads one battle snapshot. Returns null if no new file
        /// appeared within timeoutMs (e.g. not actually in battle).
        /// </summary>
        public static BattleSnapshot? CaptureSnapshot(
            string dumpsDir = @"C:\Users\tacoc\Desktop\dumps",
            int timeoutMs = 5000,
            int pollIntervalMs = 100)
        {
            var existingFiles = Directory.Exists(dumpsDir)
                ? new HashSet<string>(Directory.GetFiles(dumpsDir, "BattleSnapshot-*"))
                : new HashSet<string>();

            InputSimulator.PressKey(InputSimulator.Key.T, 100);

            string? newFile = FindNewSnapshotFile(dumpsDir, existingFiles, timeoutMs, pollIntervalMs);
            if (newFile == null)
            {
                Console.WriteLine("Timed out waiting for battle snapshot — are you actually in a battle?");
                return null;
            }

            BattleSnapshot? snapshot = ReadSnapshotWithRetry(newFile);
            TryDeleteFile(newFile);
            return snapshot;
        }

        private static string? FindNewSnapshotFile(
            string dumpsDir, HashSet<string> existingFiles, int timeoutMs, int pollIntervalMs)
        {
            var sw = Stopwatch.StartNew();
            while (sw.ElapsedMilliseconds < timeoutMs)
            {
                if (Directory.Exists(dumpsDir))
                {
                    foreach (string f in Directory.GetFiles(dumpsDir, "BattleSnapshot-*"))
                    {
                        if (!existingFiles.Contains(f))
                            return f;
                    }
                }
                Thread.Sleep(pollIntervalMs);
            }
            return null;
        }

        /// <summary>Retries briefly in case the Lua script is still mid-write when we first see the file.</summary>
        private static BattleSnapshot? ReadSnapshotWithRetry(string filePath, int maxAttempts = 10, int retryDelayMs = 50)
        {
            for (int attempt = 0; attempt < maxAttempts; attempt++)
            {
                try
                {
                    string json = File.ReadAllText(filePath);
                    return JsonSerializer.Deserialize<BattleSnapshot>(json, JsonOptions);
                }
                catch (IOException)
                {
                    Thread.Sleep(retryDelayMs);
                }
                catch (JsonException)
                {
                    Thread.Sleep(retryDelayMs);
                }
            }
            Console.WriteLine($"Failed to read/parse snapshot after {maxAttempts} attempts: {filePath}");
            return null;
        }

        private static void TryDeleteFile(string path)
        {
            try
            {
                File.Delete(path);
            }
            catch (IOException)
            {
                Console.WriteLine($"Warning: could not delete snapshot file (may still be locked): {path}");
            }
        }

        /// <summary>
        /// Reads a specific snapshot file directly (no key press, no polling, no delete) and
        /// prints species + type for both the player's and opponent's active Pokémon.
        /// </summary>
        public static void PrintBattleTypes(string filePath)
        {
            if (!File.Exists(filePath))
            {
                Console.WriteLine($"Snapshot file not found: {filePath}");
                return;
            }

            string json = File.ReadAllText(filePath);
            BattleSnapshot? snapshot = JsonSerializer.Deserialize<BattleSnapshot>(json, JsonOptions);
            if (snapshot == null)
            {
                Console.WriteLine($"Could not parse snapshot: {filePath}");
                return;
            }

            PrintSideTypes("Player", snapshot.PlayerActive);
            PrintSideTypes("Opponent", snapshot.TrainerActive);
        }

        /// <summary>Convenience overload: builds "dumps/BattleSnapshot-{trainerId}.json" and reads it.</summary>
        public static void PrintBattleTypes(int trainerId, string dumpsDir = "C:\\Users\\tacoc\\Desktop\\dumps")
        {
            PrintBattleTypes(Path.Combine(dumpsDir, $"BattleSnapshot-{trainerId}.json"));
        }

        private static void PrintSideTypes(string label, List<ActiveBattler> battlers)
        {
            foreach (ActiveBattler mon in battlers)
            {
                PokemonTypeInfo? typeInfo = PokemonTypes.GetTypes(mon.Species);
                string typeText = typeInfo?.ToString() ?? "Unknown";
                Console.WriteLine($"{label}: {mon.Species} ({typeText}) — HP: {mon.CurrentHp}");

                foreach (string moveName in mon.Moves)
                {
                    if (moveName == "--")
                        continue;

                    MoveData.MoveInfo? move = MoveData.GetMove(moveName);
                    if (move is { } m)
                        Console.WriteLine($"    - {m.Name} ({m.Type}, {m.Power} power)");
                    else
                        Console.WriteLine($"    - {moveName} (unknown move)");
                }
            }
        }
    }

    /// <summary>
    /// Finds the emulator window and focuses it so key input actually reaches it.
    /// No screen capture / pixel reading — game state comes from the Lua dumps instead.
    /// </summary>
    public static class WindowCapture
    {
        [DllImport("user32.dll")]
        private static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        [DllImport("user32.dll")]
        private static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        private static extern IntPtr GetForegroundWindow();

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
    }

    public static class InputSimulator
    {
        [DllImport("user32.dll", SetLastError = true)]
        private static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

        [DllImport("user32.dll")]
        private static extern uint MapVirtualKey(uint uCode, uint uMapType);

        private const uint MAPVK_VK_TO_VSC = 0;

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
            Select = 0x08, // Backspace
            T = 0x54       // Triggers Plat_Qol.lua's battle snapshot dump
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
            //// Adjust to your emulator window's exact title (check Task Manager / Spy++ if unsure)
            IntPtr hWnd = WindowCapture.FindEmulatorWindow("DeSmuME 0.9.13 x64 SSE2 | Pokémon Platinum");
            if (hWnd == IntPtr.Zero)
            {
                Console.WriteLine("Emulator window not found. Is it running?");
               return;
            }

            if (!WindowCapture.Focus(hWnd))
                Console.WriteLine("Warning: could not confirm emulator window has focus. Click it manually and re-run.");
            Thread.Sleep(300); // let focus settle before sending input

            //// Example: load and play a routing nugget
            //// JSON format:
            //// {
            ////   "Name": "OpenPartyMenu",
            ////   "Steps": [
            ////     { "Key": "Start", "DurationMs": 100, "DelayAfterMs": 300 },
            ////     { "Key": "Down",  "DurationMs": 100, "DelayAfterMs": 150 },
            ////     { "Key": "A",     "DurationMs": 100, "DelayAfterMs": 500 }
            ////   ]
            //// }
            //string nuggetPath = "routes/TestMenuNugget.json";
            //if (File.Exists(nuggetPath))
            //{
            //    RoutingNugget nugget = RoutingNugget.Load(nuggetPath);
            //    Console.WriteLine($"Playing nugget: {nugget.Name} ({nugget.Steps.Count} steps)");
            //    nugget.Execute();
            //}
            //else
            //{
            //    Console.WriteLine("File Not Found");
            //}

            //// Example: poll the battle state JSON dumped by BattleDump.lua
            //string battleStatePath = "battle_state.json";
            //BattleState? battle = BattleState.Load(battleStatePath);
            //if (battle is { InBattle: true })
            //{
            //    Console.WriteLine($"Player HP: {battle.PlayerHP}/{battle.PlayerMaxHP}");
            //    Console.WriteLine($"Opponent HP: {battle.OpponentHP}/{battle.OpponentMaxHP}");
            //    foreach (var slot in battle.Party)
            //        Console.WriteLine($"  Party[{slot.Slot}]: {slot.Hp}/{slot.MaxHp}");
            //}

            //// Example: trigger a Plat_Qol.lua battle snapshot and read it
            //BattleSnapshot? snapshot = BattleSnapshotReader.CaptureSnapshot(@"C:\Users\tacoc\Desktop\dumps");
            //if (snapshot != null)
            //{
            //    foreach (var mon in snapshot.PlayerActive)
            //        Console.WriteLine($"Player active: {mon.CurrentHp} HP, moves: {string.Join(", ", mon.Moves)}");
            //    foreach (var mon in snapshot.TrainerActive)
            //        Console.WriteLine($"Enemy active: {mon.CurrentHp} HP, moves: {string.Join(", ", mon.Moves)}");
            //}

            //// Example: read a specific known snapshot file and print both sides' types
            //BattleSnapshotReader.PrintBattleTypes(27920);
            //// Or, if you already know the trainerId at runtime:
            //// BattleSnapshotReader.PrintBattleTypes(27920);
            ///


            // Create your Pokémon
            BattleSnapshot? snapshot = BattleSnapshotReader.CaptureSnapshot(@"C:\Users\tacoc\Desktop\dumps");

            if (snapshot == null)
            {
                Console.WriteLine("No snapshot available.");
                return;
            }

            // Build Pokémon objects automatically using your constructor
            Pokemon myMon = new Pokemon(snapshot.PlayerActive[0]);
            Pokemon oppMon = new Pokemon(snapshot.TrainerActive[0]);

            // Decide what to do
            int action = BattleLogic.ChooseAction(myMon, oppMon);

            // Act on the decision
            if (action == 5)
            {
                Console.WriteLine("Switching Pokémon...");
                //InputSimulator.PressKey(InputSimulator.Key.B);   // example switch input
            }
            else
            {
                Console.WriteLine($"Using move #{action}: {myMon.Moves[action - 1].Name}");
                //InputSimulator.PressKey(InputSimulator.Key.A);   // example "use move" input
            }
        }
    }
}