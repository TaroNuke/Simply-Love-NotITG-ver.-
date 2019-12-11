local event = stitch "lua.event"

local sm = {mt = getmetatable(_G.SCREENMAN)}
sm.SystemMessage = sm.mt.SystemMessage
sm.OverlayMessage = sm.mt.OverlayMessage

local show = {
    Trace = _G.Trace,
    Debug = _G.Debug,
    print = _G.print,
    SystemMessage = function (msg)
        sm.SystemMessage(_G.SCREENMAN, msg)
    end,
    OverlayMessage = function (msg)
        sm.OverlayMessage(_G.SCREENMAN, msg)
    end
}

function _G.Trace(msg)
    show.Trace(msg)
    event.Call("show", msg)
    return true
end

function _G.Debug(msg)
    show.Debug(msg)
    event.Call("show", msg)
    return true
end

function _G.print(...)
    show.print(unpack(arg))
    for i=1,arg.n do
        arg[i] = tostring(arg[i])
    end
    event.Call("show", table.concat(arg, "  "))
end

function sm.mt:SystemMessage(msg)
    show.SystemMessage(msg)
    event.Call("show", msg)
end

function sm.mt:OverlayMessage(msg, time)
    show.OverlayMessage(msg)
    event.Call("show", msg)
    if time then
        event.PeristTimer(time, function()
            _G.SCREENMAN:HideOverlayMessage()
        end)
    end
end

local function tab(num, con)
    return string.rep("  ", num or 0) .. con
end

-- 3.2 forward compat
if not ActorFrame.GetChildren then
    function ActorFrame:GetChildren()
        local res = {}
        for i=1, self:GetNumChildren() do
            res[i] = self:GetChildAt(i-1)
        end
        return res
    end
end

function show.table(t, deep, rec)
    rec = rec or {}
    rec[t] = t
    local vs
    if type(t) == "userdata" then
        if t.GetName then
            vs = string.format("%s[%s]", string.gfind(tostring(t),"[^%s]+")(), t:GetName())
            if t.GetNumChildren and t:GetNumChildren() > 0 then
                t = t:GetChildren()
                print(tab(deep, vs..":"))
            elseif t.GetTexture and t:GetTexture() then
                vs = vs..": ".. t:GetTexture():GetPath()
                print(tab(deep, vs))
                return
            elseif t.GetText then
                vs = vs..": ".. t:GetText()
                print(tab(deep, vs))
                return
            else
                print(tab(deep, vs))
                return
            end
        else
            print(tab(deep, string.gfind(tostring(t),"[^%s]+")()))
            t = getmetatable(t) or {}
        end
    end
    print(tab(deep,"{"))
    for k,v in pairs(t) do
        local vt = type(v)
        vs = nil
        if vt == "userdata" and v.GetName then
            vs = string.format("%s[%s]", string.gfind(tostring(v),"[^%s]+")(), v:GetName())
            if v.GetNumChildren then
                local num = v:GetNumChildren()
                if num > 0 and deep then
                    vs = vs..":"
                elseif num > 0 then
                    vs = vs..": " .. num .. (num>1 and " children" or " child")
                end
            elseif v.GetTexture and v:GetTexture() then
                vs = vs..": ".. v:GetTexture():GetPath()
            elseif v.GetText then
                vs = vs..": ".. v:GetText()
            end
        end
        print(tab(deep,"  " .. tostring(k) .. " = " .. tostring(vs or v)))
        if deep and (vt == "table" or vt == "userdata" and v.GetNumChildren) and not rec[v] then
            if vt == "table" then
                show.table(v,deep+1, rec)
            elseif v:GetNumChildren() > 0 then
                show.table(v:GetChildren(), deep+1, rec)
            end
        end
    end
    print(tab(deep,"}"))
end

function show:__call( ... )
    if arg.n == 1 then
        local v = arg[1]
        local c = type(v)
        if c == "table" or c == "userdata" then
            return show.table(v, event.Call("show deep") and 0)
        end
    end
    return print(unpack(arg))
end

return setmetatable(show, show)