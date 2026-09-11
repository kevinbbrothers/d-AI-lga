using System.Net;
using System.Net.Sockets;
using System.Text;

namespace PlatinumBot;

internal static class Program
{
    private const int Port = 9999;

    /// <summary>
    /// Addresses to stream out of the emulator, as name / absolute NDS address / type.
    /// Start empty: the very first run should just prove the pipe works by echoing
    /// the frame counter. Fill these in as you find them with BizHawk's RAM Search.
    /// Types: u8 s8 u16 s16 u32 s32.
    /// </summary>
    private static readonly Watch[] Watches =
    [
        // new Watch("playerX", 0x02100000, "u16"),
        // new Watch("playerY", 0x02100004, "u16"),
        // new Watch("mapId",   0x02100008, "u16"),
    ];

    private static void Main()
    {
        var listener = new TcpListener(IPAddress.Loopback, Port);
        listener.Start();

        Console.WriteLine($"Listening on 127.0.0.1:{Port}");
        Console.WriteLine("Now launch: EmuHawk.exe --socket_ip=127.0.0.1 --socket_port=" + Port);
        Console.WriteLine("then load lua/platinum_bridge.lua in the Lua Console.\n");

        using var client = listener.AcceptTcpClient();
        using var stream = client.GetStream();
        Console.WriteLine("BizHawk connected.\n");

        var bot = new Bot();
        var sentWatches = false;
        string? lastPrinted = null;

        while (true)
        {
            var line = ReadMessage(stream);
            if (line is null)
            {
                Console.WriteLine("\nBizHawk disconnected.");
                break;
            }

            var state = GameState.Parse(line);

            // Only redraw when a watched value actually changed, or the console
            // becomes the bottleneck at 60 reports/second.
            if (state.Signature != lastPrinted)
            {
                Console.WriteLine(state);
                lastPrinted = state.Signature;
            }

            var reply = new StringBuilder();

            if (!sentWatches)
            {
                reply.Append("watch=").Append(Watch.Encode(Watches)).Append(' ');
                sentWatches = true;
            }

            reply.Append(bot.Decide(state));
            SendMessage(stream, reply.ToString());
        }

        listener.Stop();
    }

    // ---------------------------------------------------------------- wire format
    // BizHawk 2.6.2+ frames every message as "<decimal length> <payload>".

    private static string? ReadMessage(NetworkStream stream)
    {
        var lengthText = new StringBuilder();

        while (true)
        {
            var b = stream.ReadByte();
            if (b < 0) return null;
            if (b == ' ') break;
            lengthText.Append((char)b);
        }

        if (!int.TryParse(lengthText.ToString(), out var length) || length < 0)
            throw new InvalidDataException($"Bad length prefix: '{lengthText}'");

        var buffer = new byte[length];
        var read = 0;
        while (read < length)
        {
            var n = stream.Read(buffer, read, length - read);
            if (n <= 0) return null;
            read += n;
        }

        return Encoding.ASCII.GetString(buffer);
    }

    private static void SendMessage(NetworkStream stream, string message)
    {
        // Keep payloads ASCII: BizHawk counts chars, not UTF-8 bytes.
        var bytes = Encoding.ASCII.GetBytes($"{message.Length} {message}");
        stream.Write(bytes, 0, bytes.Length);
        stream.Flush();
    }
}

internal readonly record struct Watch(string Name, uint Address, string Type)
{
    public static string Encode(IReadOnlyCollection<Watch> watches)
    {
        if (watches.Count == 0) return "-";
        return string.Join(",", watches.Select(w => $"{w.Name}:0x{w.Address:X8}:{w.Type}"));
    }
}

/// <summary>Whatever the Lua side reported this frame.</summary>
internal sealed class GameState
{
    private readonly Dictionary<string, long> _values = new(StringComparer.Ordinal);

    public long Frame => Get("frame");

    public long Get(string name) => _values.TryGetValue(name, out var v) ? v : 0;

    public bool Has(string name) => _values.ContainsKey(name);

    public static GameState Parse(string line)
    {
        var state = new GameState();

        foreach (var token in line.Split(' ', StringSplitOptions.RemoveEmptyEntries))
        {
            var split = token.IndexOf('=');
            if (split <= 0) continue;

            var key = token[..split];
            if (long.TryParse(token[(split + 1)..], out var value))
                state._values[key] = value;
        }

        return state;
    }

    /// <summary>Everything except the frame counter, so callers can detect real change.</summary>
    public string Signature =>
        string.Join("  ", _values.Where(kv => kv.Key != "frame")
                                 .Select(kv => $"{kv.Key}={kv.Value}"));

    public override string ToString()
    {
        var body = Signature;
        return $"[{Frame,8}] {(body.Length > 0 ? body : "(no watches configured)")}";
    }
}

/// <summary>
/// The brain. Right now it does nothing but hold A every couple of seconds so
/// you can confirm input is actually reaching the game.
/// </summary>
internal sealed class Bot
{
    public string Decide(GameState state)
    {
        if (state.Frame % 120 == 0)
            return "press=A hold=3";

        return "press=- hold=0";
    }
}