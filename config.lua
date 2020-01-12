-- config.lua:
-- Read contents by doing stitch("config").YourPref

-- For console, instructions further down
layout = "QwertyUS"
console = "9"
deep = "!"
bare = ","
skip = 10
wraps = {
    " ", "{", "}", "[", "]", 
    ",", ":", "(", ")", "+",
    "*", "-", "/", "^", "="
}

-- 0: off
-- 1: YOU DIED
-- 2: Wasted
-- Scroll through them with Action5
FailOverlay = 1

-- Used by OpenITG only; see NotITGPrefs.ini for the NotITG variant
-- Hides song title and banner in ScreenEdit
EditorShowSongTitle=true

-- Debug: Lua heap viewer
ViewGC = false
--[[
layout:
    The keyboard layout you use.
    Available layouts:
        QwertyUS
        QwertyUK
        QwertyNO

    You can add more in /Overlay/lua/keyboard.lua

console:
    Hold ctrl+<key> to open the console
    Example:
        console = "`"
    Would make ctrl+` as the console toggle

deep:
    Prefix used for deep prints
    Must be a single char

bare:
    Prefix for bare prints
    Must be single char

skip:
    How many characters you want your cursor to skip when holding shift

wraps:
    Symbols where it is apropriate to place word wrapping
    The newline will be placed after the symbol
    Word wrapped newlines won't affect code, it's purely visual
]]