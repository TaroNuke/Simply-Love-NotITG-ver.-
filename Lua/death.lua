local death = {}
local current = stitch("config").FailOverlay

local types = {{
    Name = "Off"
}}

local players = 0

local isReady = false

function death.Next()
	if not GAMESTATE:IsEditMode() then
		current = current%#types+1
		if types[current].Prepare then
			types[current].Prepare(types[current].Frame)
		end
		SCREENMAN:SystemMessage('FailOverlay '..types[current].Name)
	end
end

function death.Trigger()
    if types[current].Dead then
        types[current].Dead(types[current].Frame)
    end
end

function death:Ready()
    if isReady then return end

    for i=1,#self do
        local actor = self(i)
        local name = actor:GetName()
        local style = stitch("lua.death."..name)
        style.Name = style.Name or name
        style.Frame = actor
        if style.Setup then style.Setup(actor) end
        types[i+1] = style
    end

    if self:hascommand("StepP1Action5Press") then return end

    for i=1,2 do
        local pn = i
        self:addcommand("FailP"..pn.."Message",function()
            players = players - 1
            if players == 0 then
                death.Trigger()
            end
        end)
    end

    self:addcommand("StepP1Action5PressMessage", death.Next)
end

function death.Start()
    players = GAMESTATE:GetNumPlayersEnabled()
    if types[current].Prepare then
        types[current].Prepare(types[current].Frame)
    end
end

return death
