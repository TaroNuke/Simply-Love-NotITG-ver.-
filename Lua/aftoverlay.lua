local aft = {}
local users = 0

function aft:Init()
    if not self:GetTexture() then
        -- DISPLAY does not exist at this point
        self:SetWidth( PREFSMAN:GetPreference("DisplayWidth") )
        self:SetHeight( PREFSMAN:GetPreference("DisplayHeight") )
        self:EnableDepthBuffer( false )
        self:EnableAlphaBuffer( true )
        self:EnableFloat( false )
        self:EnablePreserveTexture( true )
        self:Create()
        self:hidden(1)
    end
end

function aft:Ready()
    aft.actor = self
    aft.texture = self:GetTexture()
end

function aft.On()
    aft.actor:hidden(0)
    users = users + 1
end

function aft.Off()
    if users > 0 then
        users = users - 1
    end
    if users == 0 then
        aft.actor:hidden(1)
    end
end

function aft.ForceOff()
    users = 0
    aft.actor:hidden(1)
end

return aft