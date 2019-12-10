function PlayerColor( pn )
	if pn == PLAYER_1 then return DifficultyColor(3) end
	if pn == PLAYER_2 then return DifficultyColor(1) end
	return "1,1,1,1"
end

function DefaultColor()
	if Color() > 9 then return Color() end
	return '0'..Color()
end
	
function Color(c)
	if not Profile(0) then return 1 end
	if not Profile(0).Love then Profile(0).Love = { Color = 1 } end
	if c then Profile(0).Love.Color = c end
	return Profile(0).Love and Profile(0).Love.Color or 1
end

function FeetPosition()
	y = 13 + 120 - 120*Color()
	return y
end

function IconY()
	y = 260 - 40*Color()
	return y
end

function IconCrop(self)
	self:croptop((Color()-1)/12)
	self:cropbottom(1-Color()/12)
end

function DifficultyColor( dc )
	if dc == DIFFICULTY_EDIT then return "#B4B7BA" end
	local color = dc + Color() + 10
	color = math.mod(color-1,12)+1
	if color == 1 then return "#FF7D00" end
	if color == 2 then return "#FF3C23" end
	if color == 3 then return "#FF003C" end
	if color == 4 then return "#C1006F" end
	if color == 5 then return "#8200A1" end
	if color == 6 then return "#413AD0" end
	if color == 7 then return "#0073FF" end
	if color == 8 then return "#00ADC0" end
	if color == 9 then return "#5CE087" end
	if color == 10 then return "#AEFA44" end
	if color == 11 then return "#FFFF00" end
	if color == 12 then return "#FFBE00" end
	return "#FFFFFF"
end

function BubbleColorRGB ( pn )
	if GAMESTATE:IsPlayerEnabled( pn ) then
		local steps = GAMESTATE:GetCurrentSteps( pn )
		if not steps then return 1,1,1,0 end
		steps = steps:GetDifficulty()
		if steps == DIFFICULTY_EDIT	then return 0.71,0.72,0.73,1 end
		return ColorRGB(steps-2)
	end
	return 1,1,1,1
end

function DifficultyColorRGB( n ) if n < 5 then return ColorRGB( n - 2 ) else return 0.71,0.72,0.73,1 end end

function ColorRGB ( n )
	local color = n + Color() + 12
	color = math.mod(color-1,12)+1
	if color == 1 then return 1,0.49,0,1 end
	if color == 2 then return 1,0.24,0.14,1 end
	if color == 3 then return 1,0,0.24,1 end
	if color == 4 then return 0.76,0,0.44,1 end
	if color == 5 then return 0.51,0,0.63,1 end
	if color == 6 then return 0.25,0.23,0.82,1 end
	if color == 7 then return 0,0.45,1,1 end
	if color == 8 then return 0,0.68,0.75,1 end
	if color == 9 then return 0.36,0.88,0.53,1 end
	if color == 10 then return 0.68,0.98,0.27,1 end
	if color == 11 then return 1,1,0,1 end
	if color == 12 then return 1,0.75,0,1 end
	return 1,1,1,1
end

-- Get a color to show text on top of difficulty frames.
function ContrastingDifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER	then return "#000000" end
	if dc == DIFFICULTY_EASY		then return "#000000" end
	if dc == DIFFICULTY_MEDIUM		then return "#000000" end
	if dc == DIFFICULTY_HARD		then return "#000000" end
	if dc == DIFFICULTY_CHALLENGE	then return "#000000" end
	if dc == DIFFICULTY_EDIT		then return "#000000" end
	return "1,1,1,1"
end

function TextOnColor (n)
	local color = Color() + 12
	if n then color = color + n end
	color = math.mod(color-1,12)+1
	if color == 9 then return 0,0,0,1 end
	if color == 10 then return 0,0,0,1 end
	if color == 11 then return 0,0,0,1 end
	if color == 12 then return 0,0,0,1 end
	return 1,1,1,1
end

function BubbleColorText ( pn )
	if GAMESTATE:IsPlayerEnabled( pn ) then
		local steps = GAMESTATE:GetCurrentSteps( pn )
		if not steps then return 1,1,1,0 end
		steps = steps:GetDifficulty()
		if steps == DIFFICULTY_EDIT	then return 0,0,0,1 end
		local color = Color() + 10 + steps
		color = math.mod(color-1,12)+1
		if color == 9 then return 0.20,0.24,0.26,1 end
		if color == 10 then return 0.20,0.24,0.26,1 end
		if color == 11 then return 0.20,0.24,0.26,1 end
		if color == 12 then return 0.20,0.24,0.26,1 end
	end
	return 1,1,1,1
end