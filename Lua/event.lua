local event = {}

local getn = table.getn
local unpack = unpack


local subs = {}
local persist = {}
local remove = {}
local ignore = {}
local stacksize = 0
local hasRemove = false

function event.Reset()
    subs = {}
end

function event.Ignore( name, bool )
    ignore[name] = bool and true
end

function event.Call( name, ... )
    if ignore[name] then return end
    stacksize = stacksize+1

    if persist[name] then
        for _, fn in pairs(persist[name]) do
            local r = {fn(unpack(arg))}
            if getn(r) > 0 then
                return unpack(r)
            end
        end
    end
    if subs[name] then
        for _, fn in pairs(subs[name]) do
            local r = {fn(unpack(arg))}
            if getn(r) > 0 then
                return unpack(r)
            end
        end
    end

    stacksize = stacksize-1
    if stacksize < 1 and hasRemove then
        for key,tab in pairs(remove) do
            for id in pairs(tab) do
                if persist[key] then
                    persist[key][id] = nil
                end
                if subs[key] then
                    subs[key][id] = nil
                end
            end
        end
        remove = {}
        hasRemove = false
    end
end

local isOverlayReady = false
function event.OverlayReady()
    if not isOverlayReady then
        isOverlayReady = true
        print("Preparing overlay")
        MESSAGEMAN:Broadcast("OverlayReady")
    end
end

function event.ForceOverlayReady()
    MESSAGEMAN:Broadcast("OverlayReady")
end

function event.Add( name, id, fn )
    subs[name] = subs[name] or {}
    subs[name][id] = fn
end

function event.Persist( name, id, fn )
    persist[name] = persist[name] or {}
    persist[name][id] = fn
end

local function nop() end
function event.Remove( name, id )
    if subs[name] then
        subs[name][id] = nop
    end
    if persist[name] then
        persist[name][id] = nop
    end
    remove[name] = remove[name] or {}
    remove[name][id] = true
    hasRemove = true
end

local clock
local pt

function event.Timer( time, fn )
    local start = clock:GetSecsIntoEffect()
    event.Add("update",fn,function(_,now)
        if (now-start) >= time then
            event.Remove("update",fn)
            fn()
        end
    end)
end

function event.PeristTimer( time, fn )
    local start = clock:GetSecsIntoEffect()
    event.Persist("update",fn,function(_,now)
        if (now-start) >= time then
            event.Remove("update",fn)
            fn()
        end
    end)
end

function event.GetClock()
    return clock:GetSecsIntoEffect()
end

local function update()
    local time = clock:GetSecsIntoEffect()
    local dt = time - pt
    pt = time
    event.Call("update", dt, time)
end

function event:Update()
    clock = self
    pt = self:GetSecsIntoEffect()-0.01
    event.Update = update
    update(self)
end

return event