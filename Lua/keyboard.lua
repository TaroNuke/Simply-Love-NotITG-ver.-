local config = stitch "config"
local event = stitch "lua.event"
local keyboard = {}

local metabuf = {}
keyboard.buffer = setmetatable({}, metabuf)

local map = stitch "lua.layout"
keyboard.map = map
keyboard.lang = config.layout

local special = {
    shift = false,
    ctrl = false,
    alt = false,
    win = false,
    altgr = false
}
keyboard.special = special

local function check(c)
    local map = map[keyboard.lang]
    local char = map.remap[c] or c
    local out = char
    if special.shift then
        out = map.shift[char] or string.upper(char)
    end
    if special.altgr then
        out = map.altgr[char]
    end
    if special.alt and map.alt[char] then
        out = special.shift and map.alt[map.alt[char]] or map.alt[char]
    end
    return out
end

local cmd = {
    ["left shift"] = true, ["right shift"] = true,
    ["left ctrl"] = true, ["right ctrl"] = true,
    ["right meta"] = true, ["left meta"] = true,
    ["left alt"] = true, ["right alt"] = true,
    backspace = true, menu = true, escape = true,
    left = true, right = true, up = true, down = true,
    ["caps lock"] = true, ["num lock"] = true, ["scroll lock"] = true,
    pgdn = true, pgup = true, ["end"] = true, home = true,
    prtsc = true, insert = true, pause = true, delete = true
}
for i=1,12 do
    cmd["F"..i] = true
end

local text = ""
function keyboard:KeyHandler()
    text = self:GetText()
end

event.Persist("update", "keyboard", function()
    local keys = string.gfind(text,'Key_K?P? ?(.-) %-')
    if not keys then return end

    local new = {}
    for match in keys do
        new[match] = true
    end

    special.shift = new["left shift"] or new["right shift"] or false
    special.ctrl = new["left ctrl"] or new["right ctrl"] or false
    special.alt = new["left alt"] or new["right alt"] or false
    special.win = new["left meta"] or new["right meta"] or false
    special.altgr = new["right alt"] or special.alt and special.ctrl or false

    local buffer = keyboard.buffer

    for k in pairs(new) do
        if not buffer[k] then
            if not cmd[k] then
                local c = check(k)
                if c then
                    event.Call("key char", c, special)
                end
            else
                event.Call("key func", k, special)
            end
        end
    end

    metabuf.__index = new
    text = ""
end)

return keyboard