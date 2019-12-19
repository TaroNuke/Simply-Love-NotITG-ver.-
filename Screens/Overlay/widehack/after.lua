local aft = self:GetChild("aft")
local spr = self:GetChild("spr")
local sbg1 = self:GetChild("sbg1")
local sbg2 = self:GetChild("sbg2")
local prx1 = self:GetChild("prx1")
local prx2 = self:GetChild("prx2")

prx1:addcommand("prox", function()
    local ts = SCREENMAN:GetTopScreen()
    local bg = ts:GetChild("SongBackground")
        or SCREENMAN:GetSharedBGA()
    prx1:SetTarget(bg)

    local bg2 = ts:GetChild("SongBackground2")
    if bg2 then
        prx2:SetTarget(bg2)
    end
    prx2:visible(bg2 and 1 or 0)
end)
prx1:luaeffect("prox")

prx1:zoomx(3/4)
prx1:x((SCREEN_WIDTH-SCREEN_WIDTH*3/4)/2)
prx2:zoomx(3/4)
prx2:x((SCREEN_WIDTH-SCREEN_WIDTH*3/4)/2)


aft:SetWidth(DISPLAY:GetDisplayWidth())
aft:SetHeight(DISPLAY:GetDisplayHeight())
aft:EnableDepthBuffer(false)
aft:EnableAlphaBuffer(false)
aft:EnableFloat(false)
aft:EnablePreserveTexture(true)
aft:Create()

spr:SetTexture(aft:GetTexture())
spr:align(0,1)
spr:zoomto(SCREEN_WIDTH*3/4,-SCREEN_HEIGHT)
spr:x((SCREEN_WIDTH-SCREEN_WIDTH*3/4)/2)

sbg1:diffuse(1,1,1,1)
sbg1:diffuseleftedge(0,0,0,1)
sbg1:align(0,0)
sbg1:zoomto(SCREEN_WIDTH/2, SCREEN_HEIGHT)

sbg2:diffuse(0,0,0,1)
sbg2:diffuseleftedge(1,1,1,1)
sbg2:align(0,0)
sbg2:x(SCREEN_WIDTH/2)
sbg2:zoomto(SCREEN_WIDTH/2, SCREEN_HEIGHT)