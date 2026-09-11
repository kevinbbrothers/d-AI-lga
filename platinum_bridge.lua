--------------------------------------------------------------------------------
-- platinum_bridge.lua
--
-- Dumb sensor/actuator bridge between BizHawk (melonDS NDS core) and an external
-- C# console app. All game logic lives in C#; this script only reads memory,
-- ships it out, and applies whatever buttons it's told to.
--
-- SETUP
--   1. Start the C# app first. It is the TCP *server*; BizHawk dials in.
--   2. Launch BizHawk with the socket flags:
--        EmuHawk.exe --socket_ip=127.0.0.1 --socket_port=9999
--   3. Load Pokemon Platinum, then Tools > Lua Console > Open Script > this file.
--
-- PROTOCOL (both directions are "key=value" pairs separated by spaces;
--           BizHawk adds/expects a "<length> " prefix on the wire automatically)
--
--   Lua -> C#   frame=12345 playerX=312 playerY=88
--   C#  -> Lua   watch=playerX:0x02100000:u16,playerY:0x02100004:u16 press=A hold=2
--
--   watch  comma-separated name:address:type. type is u8/s8/u16/s16/u32/s32.
--          Addresses are the absolute NDS addresses you see in BizHawk's
--          RAM Search / Hex Editor (0x02......). Sent once; persists until resent.
--   press  comma-separated button names, or "-" for none.
--   hold   how many frames to keep holding them.
--------------------------------------------------------------------------------

local POLL_EVERY = 1     -- frames between reports. Raise this if emulation crawls.
local TIMEOUT_MS = 10000

--------------------------------------------------------------------------------
-- guards
--------------------------------------------------------------------------------

if comm == nil or comm.socketServerSend == nil then
	error("No socket server. Relaunch EmuHawk with " ..
	      "--socket_ip=127.0.0.1 --socket_port=9999")
end

--------------------------------------------------------------------------------
-- state
--------------------------------------------------------------------------------

local watches  = {}      -- { {name=, addr=, typ=}, ... }
local pressed  = {}      -- { A = true, Right = true }
local holdLeft = 0

--------------------------------------------------------------------------------
-- memory
--------------------------------------------------------------------------------

-- NDS main RAM is 4 MB based at 0x02000000, and `mainmemory` indexes it from 0.
-- 0x02000000 is an exact multiple of 0x400000, so a plain modulo converts an
-- absolute address to a domain offset without needing bitops.
local function toOffset(addr)
	return addr % 0x400000
end

local function readWatch(w)
	local off = toOffset(w.addr)
	if     w.typ == "u8"  then return mainmemory.read_u8(off)
	elseif w.typ == "s8"  then return mainmemory.read_s8(off)
	elseif w.typ == "u16" then return mainmemory.read_u16_le(off)
	elseif w.typ == "s16" then return mainmemory.read_s16_le(off)
	elseif w.typ == "u32" then return mainmemory.read_u32_le(off)
	elseif w.typ == "s32" then return mainmemory.read_s32_le(off)
	end
	return 0
end

--------------------------------------------------------------------------------
-- protocol
--------------------------------------------------------------------------------

local function buildState()
	local parts = { "frame=" .. emu.framecount() }
	for _, w in ipairs(watches) do
		parts[#parts + 1] = w.name .. "=" .. readWatch(w)
	end
	return table.concat(parts, " ")
end

local function setWatches(spec)
	watches = {}
	for entry in string.gmatch(spec, "[^,]+") do
		local name, addr, typ = string.match(entry, "([^:]+):([^:]+):([^:]+)")
		local n = addr and tonumber(addr)   -- tonumber handles "0x..." natively
		if name and n then
			watches[#watches + 1] = { name = name, addr = n, typ = typ }
		else
			console.log("bridge: bad watch entry: " .. entry)
		end
	end
	console.log("bridge: watching " .. #watches .. " address(es)")
end

local function setButtons(spec)
	pressed = {}
	if spec ~= "-" then
		for b in string.gmatch(spec, "[^,]+") do
			pressed[b] = true
		end
	end
end

local function applyCommand(msg)
	if msg == nil or msg == "" then return end

	-- Depending on version, the response may still carry its "<len> " prefix.
	local stripped = string.match(msg, "^%d+%s(.*)$")
	if stripped then msg = stripped end

	for key, value in string.gmatch(msg, "(%w+)=(%S+)") do
		if     key == "watch" then setWatches(value)
		elseif key == "press" then setButtons(value)
		elseif key == "hold"  then holdLeft = tonumber(value) or 0
		elseif key == "quit"  then error("bridge: quit requested by C# client")
		end
	end
end

--------------------------------------------------------------------------------
-- main loop
--------------------------------------------------------------------------------

comm.socketServerSetTimeout(TIMEOUT_MS)

console.log("bridge: button names this core accepts ->")
for name, _ in pairs(joypad.get()) do
	console.log("  " .. tostring(name))
end

while true do
	if emu.framecount() % POLL_EVERY == 0 then
		local ok, err = pcall(function()
			comm.socketServerSend(buildState())
			applyCommand(comm.socketServerResponse())
		end)
		if not ok then
			console.log("bridge: socket error -> " .. tostring(err))
			break
		end
	end

	if holdLeft > 0 then
		joypad.set(pressed)
		holdLeft = holdLeft - 1
	end

	emu.frameadvance()
end
