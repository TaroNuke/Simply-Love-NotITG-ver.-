layout = "QwertyUS"
console = "0"
deep = "!"
bare = ","
skip = 10
wraps = {
    " ", "{", "}", "[", "]", 
    ",", ":", "(", ")", "+",
    "*", "-", "/", "^", "="
}
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