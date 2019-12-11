local config = stitch "config"
local event = stitch "lua.event"
local show = stitch "lua.show"

local DevConsole = self
local DevBuffer = self:GetChild("DevBuffer")
local DevInput = self:GetChild("DevInput")
local DevTest = self:GetChild("DevTest")
local DevCursor = self:GetChild("DevCursor")
local DevBackground = self:GetChild("DevBackgroud")
local DevInBg = self:GetChild("DevInBg")

local enabled = false
local scale = 0.6

local buffer = {"","","","","","","","","","","","","","",""}
local history = {cur = 0}

local cursor = {
    clock = 0,
    pos = 0,
    insert = true,
    editing = false
}

local height = DevBuffer:GetHeight()
local height2 = DevTest:GetHeight()-height*2
local quadheight = 6+height*20*scale
local inputBase = 20+height*18*scale

DevBuffer:x(10) 
DevBuffer:y(10+height*17*scale)
DevInput:x(10)
DevInput:y(inputBase)
DevCursor:x(10)
DevCursor:y(inputBase)
DevBackground:zoomto(SCREEN_WIDTH*2, quadheight)
DevInBg:zoomto(SCREEN_WIDTH, height*scale+18)
DevInBg:y(quadheight)
DevConsole:y(-quadheight)

local function append(msg)
    table.remove(buffer, 1)
    table.insert(buffer, msg)
    if enabled then
        DevBuffer:settext(table.concat(buffer,"\n"))
    end
end
event.Persist("show", "console", append)

local function eval(code)
    local fn,err,erralt
    fn, err = loadstring(
        string.format("return (function(...) return arg end)(%s)",code),"Console")
    if not fn then
        fn, erralt = loadstring(code,"Console")
    end
    err = erralt or err
    if fn then
        local ret = {pcall(
            function()
                return (function(...)
                    return arg
                end)(fn())
            end
        )}
        if ret[1] then
            return err and ret[2] or ret[2][1]
        else
            err = ret[2]
        end
    end

    show(({string.gsub(err,"^.-:%d-: ","[Error] ")})[1])
end

local function toggleCheck(char, special)
    return char == config.console 
            and special.ctrl and not special.altgr
end

local glyphLen = {}
local splitChar = {
    ["\n"] = "\n"
}
for _, v in ipairs(config.wraps) do
    splitChar[v] = v .. "\n"
end

local function getTextXY(charray)
    local chars = {unpack(charray)}
    local x,y = 10,0
    local sw,cl,sl = SCREEN_WIDTH*1.2,0,1
    local cp = cursor.pos
    
    local lines = { {1, 1}, n=1 }

    for i=1, table.getn(chars) do
        local char = chars[i]
        if not glyphLen[char] then
            DevTest:settext(char)
            glyphLen[char] = DevTest:GetWidth()*scale
        end

        cl = cl + glyphLen[char]

        if char == "\n" then
            sl = i
            cl = sw+1
        elseif splitChar[char] then
            sl = i
        end

        if cl > sw and sl > 1 then
            cl = 0
            chars[sl] = splitChar[chars[sl]]
            if char == "\n" then
                lines[lines.n][2] = sl-1
            else
                for j=sl,i do
                    cl = cl + glyphLen[char]
                end
                lines[lines.n][2] = sl
            end
            lines.n = lines.n + 1
            lines[lines.n] = {sl, i}
            sl = 0
        end
        lines[lines.n][2] = i
    end

    if cp > 0 then
        for i=1, lines.n do
            if cp <= lines[i][2] then
                local text = table.concat(chars,"",lines[i][1], cp)
                DevTest:settext(text)
                x = DevTest:GetWidth()*scale+6
                DevTest:settext(table.concat(chars))
                y = (i*height+(i-1)*height2-DevTest:GetHeight())*scale
                break
            end
        end
    else
        DevTest:settext(table.concat(chars))
        y = (height-DevTest:GetHeight())*scale
    end

    return table.concat( chars ), x, y
end

local charray = {}
event.Persist("key char","dev console",function(char, special)
    if not toggleCheck(char, special) then return end
    enabled = not enabled
    DevConsole:finishtweening()
    if not enabled then
        DevConsole:accelerate (0.3)
        DevConsole:y(-quadheight)
        event.Timer(0.4,function()
            if enabled then return end
            DevConsole:hidden(1)
            cursor.editing = false
            if SCREENMAN.SetInputMode then
                SCREENMAN:SetInputMode(0)
            end
        end)
        event.Remove("key char", "dev input")
        event.Remove("key func", "dev input")
        event.Remove("update", "dev cursor")
        return
    end

    event.Persist("update", "dev cursor", function()
        DevCursor:hidden(math.mod(math.floor((event.GetClock()-cursor.clock)*2),2))
    end)

    DevBuffer:settext(table.concat(buffer,"\n"))
    DevConsole:visible(1)
    DevConsole:decelerate(0.3)
    DevConsole:y(0)

    if SCREENMAN.SetInputMode then
        SCREENMAN:SetInputMode(2)
    end

    event.Timer(0.5, function()
        event.Persist("key char", "dev input", function(char, special)
            if toggleCheck(char, special) then return end
            cursor.clock = event.GetClock()
            local text
            if char == "\n" and not special.shift then
                local deep = charray[1] == config.deep
                local bare = charray[1] == config.bare
                text = getTextXY(charray)
                DevInput:settext("")
                DevTest:settext("")
                if charray[1] then
                    show("> " .. text)
                    history[table.getn(history) + 1] = charray
                    history.cur = table.getn(history)+1
                else
                    append(">")
                end
                local res = eval(table.concat(charray,"",(deep or bare) and 2 or 1 ))
                if res and table.getn(res) > 0 then
                    event.Add("show deep", "console", function()
                        event.Remove("show deep", "console")
                        return deep
                    end)
                    if bare then
                        print(unpack(res))
                    else
                        show(unpack(res))
                    end
                end
                charray = {}
                cursor.pos = 0
                DevCursor:x(10)
                DevCursor:y(inputBase)
                DevInBg:zoomto(SCREEN_WIDTH, height*scale+18 )
                cursor.editing = false
            else
                if cursor.pos == 0 and char == "\n" then return end
                history.cur = table.getn(history)
                if charray[cursor.pos+1] and not cursor.insert then
                    table.remove(charray, cursor.pos+1)
                end
                table.insert(charray, cursor.pos+1, char)
                cursor.pos = cursor.pos +1
                local text,cx,cy = getTextXY(charray)
                DevInput:settext(text)
                if charray[1] then
                    DevCursor:x(cx)
                    DevCursor:y(inputBase+cy)
                end
                DevInBg:zoomto(SCREEN_WIDTH, DevInput:GetHeight()*scale+18)
                cursor.editing = true
            end
        end)

        event.Persist("key func","dev input", function(char, special)
            cursor.clock = event.GetClock()

            local scroll = {
                x = char == "left" and -1 or char == "right" and 1 or 0,
                y = char == "up" and -1 or char == "down" and 1 or 0
            }

            local text, cx, cy

            if char == "backspace" and cursor.pos > 0 then
                if cursor.pos == 1 and charray[2] == "\n" then 
                    table.remove(charray, 2)
                end
                table.remove(charray, cursor.pos)
                cursor.pos = math.max(cursor.pos-1,0)
                text, cx, cy = getTextXY(charray)
                DevInput:settext(text)
                if charray[1] then
                    DevCursor:x(cx)
                    DevCursor:y(inputBase+cy)
                else
                    DevCursor:x(cx)
                    DevCursor:y(inputBase+cy)
                    cursor.editing = false
                end
            elseif scroll.x ~= 0 then
                if charray[1] then
                    cursor.pos = math.min(math.max(
                        cursor.pos + (special.shift and config.skip or 1)*scroll.x, 0), 
                        table.getn(charray)
                    )
                    text, cx, cy = getTextXY(charray)
                    DevCursor:x(cx)
                    DevCursor:y(inputBase+cy)
                end
            elseif scroll.y ~= 0 and not cursor.editing then
                local cur = history.cur + scroll.y
                if not history[cur] then return end
                history.cur = cur
                charray = {unpack(history[cur])}
                cursor.pos = table.getn(charray)
                text, cx, cy = getTextXY(charray)
                DevInput:settext(text)
                DevCursor:x(cx)
                DevCursor:y(inputBase+cy)
            elseif char == "escape" then
                DevInput:settext("")
                charray = {}
                history.cur = table.getn(history)+1
                cursor.pos = 0
                DevCursor:x(10)
                DevCursor:y(inputBase)
                DevInBg:zoomto(SCREEN_WIDTH, height*scale+18 )
                cursor.editing = false
                return
            elseif char == "home" then
                cursor.pos = 0
                text, cx, cy = getTextXY(charray)
                DevCursor:x(cx)
                DevCursor:y(inputBase+cy)
            elseif char == "end" then
                cursor.pos = table.getn(charray)
                if cursor.pos > 0 then
                    text, cx, cy = getTextXY(charray)
                    DevCursor:x(cx)
                    DevCursor:y(inputBase+cy)
                end
            elseif char == "delete" and charray[cursor.pos+1] then
                if cursor.pos == 0 and charray[2] == "\n" then 
                    table.remove(charray, 2)
                end
                table.remove(charray, cursor.pos+1)
                text, cx, cy = getTextXY(charray)
                DevInput:settext(text)
                DevCursor:x(cx)
                DevCursor:y(inputBase+cy)
                if not charray[1] then
                    cursor.editing = false
                end
            elseif char == "insert" then
                cursor.insert = not cursor.insert
                if cursor.insert then
                    DevCursor:settext("|")
                else
                    DevCursor:settext("_")
                end
            end
            DevInBg:zoomto(SCREEN_WIDTH, DevInput:GetHeight()*scale+18 )
        end)
    end)
end)