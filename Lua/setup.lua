local event = stitch 'lua.event'
local self = self:GetParent()

self:xy(0,0)
self:zoom(1)
self:horizalign("left")
self:vertalign("top")

-- Uksrt tournament stuff
event.Persist("key char","uksrt", function(c)
    if string.find(c, "%w") then
        MESSAGEMAN:Broadcast("KeyPress"..c)
    end
end)

-- Widescreen centering hack
event.Persist("update","afts sucks", function ()
    DISPLAY:ChangeCentering(
        PREFSMAN:GetPreference("CenterImageTranslateX"),
        PREFSMAN:GetPreference("CenterImageTranslateY"),
        PREFSMAN:GetPreference("CenterImageAddWidth"),
        PREFSMAN:GetPreference("CenterImageAddHeight")
    )
end)