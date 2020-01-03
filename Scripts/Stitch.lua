local gsub, lower, find, gfind = string.gsub, string.lower, string.find, string.gfind
local getn, loadfile, type = table.getn, loadfile, type
local setfenv, setmetatable = setfenv, setmetatable
local unpack, sub, pairs = unpack, string.sub, pairs

if _G.stitch then
    Trace("[Stitch] Reusing old stitch")
    Trace('[Stitch] We are on version "' .. stitch._VERSION .. '"')
    return
end

local stitch = {
    _VERSION = 'Stitch 200103 dev'
}

_G.stitch = stitch
_G.stx = stitch

local folder = '/'..THEME:GetCurThemeName()..'/'
local addFolder = lower(PREFSMAN:GetPreference('AdditionalFolders'))
local add = './themes,' .. gsub(addFolder, ',' ,'/themes,') .. '/themes'

local requireCache = {}

local function load(name, prefix)
    local file = gsub(lower(name), '%.', '/') .. '.lua'
    if prefix then
        file = prefix .. file
    end
    local log={}
    for w in gfind(add,'[^,]+') do
        local path = gsub(w .. folder .. file, '/+', '/')
        local func, err = loadfile(path)
        if func then
            Debug('[Loading] ' .. path)
            return func
        end
        log[getn(log)+1] = '[Error] ' .. err --gsub(err,'\n.+','')
    end

    for i=1, getn(log) do
        if not find(log[i], 'cannot read') then Debug(log[i]) return end
    end
    _G.Debug(log[1])
end

function stitch.nocache( name, env, ... )
    name = lower(name)
    local func = load(name)
    if not func then
        return
    end

    env = env or {}
    env.arg = arg

    if not getmetatable(env) then
        setmetatable( env, { __index = _G, __newindex = _G } )
    end
    setfenv( func, env )

    return func()
end

function stitch.RequireEnv(name, env, ...)
    name = lower(name)

    if requireCache[name] then
        return unpack(requireCache[name])
    end
    requireCache[name] = {}

    local func = load(name)
    if not func then
        requireCache[name] = nil
        return
    end

    env = env or {}
    env.arg = arg

    if not getmetatable(env) then
        setmetatable( env, { __index = _G, __newindex = _G } )
    end

    setfenv( func, env )
    requireCache[name] = {func()}
    return unpack(requireCache[name])
end

function stitch.Require( name, ... )
    return stitch.RequireEnv(name, nil, unpack(arg))
end

function stitch:__call(name, ...)
    return stitch.RequireEnv(name, nil, unpack(arg))
end

setmetatable(stitch, stitch)

Trace '[Stitch] Initialized!'
Trace('[Stitch] We are on version "' .. stitch._VERSION .. '"')

-- Preload config
do
    local config = setmetatable({},{})
    stitch.RequireEnv("config", config)
    local dataconf = load("config", "../../Data/")
    if dataconf then
        setfenv( dataconf, config )
        dataconf()
    end
    requireCache["config"] = {config}
end

return stitch