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

-- Scale Debug screen (should be in metrics, but maybe not)
for k,v in pairs(SCREENMAN:GetOverlayScreens()) do
    if v:GetName() == "ScreenDebugOverlay" then
        v:zoomx(3/4)
        v:GetChildAt(0):zoomx(SCREEN_WIDTH*4/3)
        v:x((SCREEN_WIDTH-SCREEN_WIDTH*3/4)/2)
    end
end