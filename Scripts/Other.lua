-- Override these in other themes.
function Platform() return "arcade" end
function IsHomeMode() return false end

command = {}
for i = 1,42 do command[i] = '' end

command[1]='Up,Up'
command[2]='MenuUp,MenuUp'
command[3]='Down,Down'
command[4]='MenuDown,MenuDown'

command[9]='MenuLeft-MenuRight-Start'
command[10]='Up,Down,Up,Down'

command[38]='Left,Right,Left,Right,Left,Right'
command[39]='MenuLeft,MenuLeft,MenuRight,MenuRight,MenuLeft,MenuLeft,MenuRight,MenuRight'
command[40]='MenuLeft+MenuRight'
command[41]='Select'


function ModeLoop(self) self:linear((53+self:GetY())/75) self:y(-53); self:sleep(0) self:addy(150) self:queuecommand('Loop') end
function ModeLoop2(self) self:decelerate((53+self:GetY())/75) self:y(-53); self:sleep(0) self:addy(150) self:queuecommand('Loop') end
function ModeColor(self) local a = self:getaux(); a = math.mod(a+6,12) self:aux(a) if self:GetZ() == 0 then self:diffuse(ColorRGB(a)) end end
function ModeColorOn(self) self:z(0) if self:getaux() < 0 then self:diffuse(1,1,1,1) else self:queuecommand('Loop') end end
function ModeColorOff(self) self:diffuse(0.20,0.24,0.26,1) self:z(1) end

File = 'loveheart'
function BGShape() 
	if not BGnum then BGnum = 1 end
	path = THEME:GetPath( EC_BGANIMATIONS,'','_shared background images')
	path = path .. '/' .. File
	return path
end

function DifficultyListCommand(self,t) i = self:getaux() self:y((i-1)*(19.3)) self:shadowlength(0) if t == 'meter' then self:x(-16) self:zoom(.28) else self:horizalign('left') end DifficultyListRow(self,i,t) end

function TitleMenuOut(self) self:sleep(.2) self:linear(.5) self:diffusealpha(0) end
function OutCommand(self) self:linear(.5) self:diffusealpha(0) end
function FadeIn(self) self:diffusealpha(0) self:sleep(.2) self:linear(.5) self:diffusealpha(1) end
function FadeIn2(self) self:ztest(1) self:diffusealpha(0) self:sleep(.2) self:linear(.5) self:diffusealpha(1) end

function DetectGame()
	local w = SCREENMAN:GetTopScreen():GetChild('Logo'):GetWidth()
	if w == 640 then game = 'dance'; PREFSMAN:SetPreference('AutogenSteps',false) end
	if w == 642 then game = 'pump'; PREFSMAN:SetPreference('AutogenSteps',false) end
	if w == 644 then game = 'techno'; TechnoPrefs() end
end

function TechnoPrefs()
	PREFSMAN:SetPreference('AutogenSteps',true)
	PREFSMAN:SetPreference('ComboContinuesBetweenSongs',false)
	PREFSMAN:SetPreference('BGBrightness',0.01)
	PREFSMAN:SetPreference('SoloSingle',true)
end

function StyleIcon()
	if not game then game = 'dance' end
	s = "icon " .. game .. " " .. CurStyleName()
	path = THEME:GetPath( EC_GRAPHICS, "MenuElements" , s)
	i = SCREENMAN:GetTopScreen():GetChild('StyleIcon')
	i:Load(path)
end
	
function StyleScrollerX()
	if StyleChoices() == "1,2" then return SCREEN_CENTER_X+120 end
	if StyleChoices() == "1,2,3" then return SCREEN_CENTER_X+65 end
	if game == "pump" then return SCREEN_CENTER_X-15 end
	return SCREEN_CENTER_X
end


function StyleChoices()
	if GetInputType then return "1,2,3" end
	if game == "techno" then return "1,2" end
	return "1,2,3,4"
end

function Style(n)
	local k = n
	local list = { "single" , "versus" , "double" , "solo" , "single" , "versus" , "double" , "halfdouble" , "single8" , "versus8" }
	if game == "pump" then k = k + 4 elseif game == "techno" then k = k + 8 end
	return list[k]
end

function DoublesOffset()
	if GAMESTATE:PlayerUsingBothSides() then
		if GAMESTATE:IsPlayerEnabled(PLAYER_1) then	return 157.5 end
		if GAMESTATE:IsPlayerEnabled(PLAYER_2) then	return -157.5 end
	end
	return 0
end

function GetStepsDescriptionText(n)
	local steps = GAMESTATE:GetCurrentSteps(n)
	if not steps then
		text = ''
	else
		text = steps:GetDescription()
	end
	if string.lower(text) == 'blank' then text = '' end
	return text
end

function SelectButtonAvailable()
	return true
end


function ScreenEndingGetDisplayName( pn )
	if PROFILEMAN:IsPersistentProfile(pn) then return GAMESTATE:GetPlayerDisplayName(pn) end
	return "No Card"
end

function GetCreditsText()
	local song = GAMESTATE:GetCurrentSong()
	if not song then return "ALALALA" end

	return 
		song:GetDisplayFullTitle().."\n"..
		song:GetDisplayArtist().."\n"..
		GetStepsDescriptionTextP1().."\n"..
		GetStepsDescriptionTextP2()
end

function StopCourseEarly()
	-- Stop gameplay between songs in Fitess: Random Endless if all players have 
	-- completed their goals.
	if not GAMESTATE:GetEnv("Workout") then return "0" end
	if GAMESTATE:GetPlayMode() ~= PLAY_MODE_ENDLESS then return "0" end
	for pn = PLAYER_1,NUM_PLAYERS-1 do
		if GAMESTATE:IsPlayerEnabled(pn) and not GAMESTATE:IsGoalComplete(pn) then return "0" end
	end
	return "1"
end


function SetDifficultyFrameFromSteps( Actor, pn )
	Trace( "SetDifficultyFrameFromSteps" )
	local steps = GAMESTATE:GetCurrentSteps( pn );
	if steps then 
		Actor:setstate(steps:GetDifficulty()) 
	end
end

function SetDifficultyFrameFromGameState( Actor, pn )
	Trace( "SetDifficultyFrameFromGameState" )
	local trail = GAMESTATE:GetCurrentTrail( pn );
	if trail then 
		Actor:setstate(trail:GetDifficulty()) 
	else
		SetDifficultyFrameFromSteps( Actor, pn )
	end
end

function SetFromSongTitleAndCourseTitle( actor )
	Trace( "SetFromSongTitleAndCourseTitle" )
	local song = GAMESTATE:GetCurrentSong();
	local course = GAMESTATE:GetCurrentCourse();
	local text = ""
	if song then
		text = song:GetDisplayFullTitle()
	end
	if course then
		text = course:GetDisplayFullTitle() .. " - " .. text;
	end

	actor:settext( text )
end


-- This is overridden in the PS2 theme to set the options difficulty.
function GetInitialDifficulty()
	return "beginner"
end

function DifficultyChangingIsAvailable()
	return GAMESTATE:GetPlayMode() ~= PLAY_MODE_ENDLESS and GAMESTATE:GetPlayMode() ~= PLAY_MODE_ONI and GAMESTATE:GetSortOrder() ~= SORT_MODE_MENU
end

function ModeMenuAvailable()
	if GAMESTATE:IsCourseMode() then return false end
	--Trace( "here1" )
	if GAMESTATE:GetSortOrder() == SORT_MODE_MENU then return false end
	--Trace( "here2" )
	return true
end

function GetEditStepsText()
	local steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
	if steps == nil then 
		return ""
	elseif steps:GetDifficulty() == DIFFICULTY_EDIT then 
		return steps:GetDescription()
	else 
		return DifficultyToThemedString(steps:GetDifficulty())
	end
end

function GetScreenSelectStyleDefaultChoice()
	if GAMESTATE:GetNumPlayersEnabled() == 1 then return "1" else return "2" end
end

-- Wag for ScreenSelectPlayMode scroll choice3.  This should use
-- EffectMagnitude, and not a hardcoded "5".
function TweenedWag(self)
	local time = self:GetSecsIntoEffect()
	local percent = time / 4
	local rx, ry, rz
	rx,ry,rz = self:getrotation()
	rz = rz + 5 * math.sin( percent * 2 * 3.141 ) * self:getaux()
	self:rotationz( rz )
end

-- For DifficultyMeterSurvival:
function SetColorFromMeterString( self )
	local meter = self:GetText()
	if meter == "?"  then return end

	local i = (meter+0);
	local cmd;
	if i <= 1 then cmd = "Beginner"
	elseif i <= 3 then cmd = "Easy"
	elseif i <= 6 then cmd = "Regular"
	elseif i <= 9 then cmd = "Difficult"
	else cmd = "Challenge"
	end
	
	self:playcommand( "Set" .. cmd .. "Course" )
end

-- used by BGA/ScreenEvaluation overlay
-- XXX: don't lowercase commands on parse
function ActorFrame:difficultyoffset()
	if not GAMESTATE:PlayerUsingBothSides() then return end

	local XOffset = 75
	if GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then XOffset = XOffset * -1 end
	self:addx( XOffset )
	self:addy( -55 )
end

function GameState:PlayerDifficulty( pn )
	if GAMESTATE:IsCourseMode() then
		local trail = GAMESTATE:GetCurrentTrail(pn)
		return trail:GetDifficulty()
	else
		local steps = GAMESTATE:GetCurrentSteps(pn)
		return steps:GetDifficulty()
	end
end

function Get2PlayerJoinMessage()
	if not GAMESTATE:PlayersCanJoin() then return "" end
	if GAMESTATE:GetCoinMode()==COIN_MODE_FREE then return "2 Player mode available" end
	
	local numSidesNotJoined = NUM_PLAYERS - GAMESTATE:GetNumSidesJoined()
	if GAMESTATE:GetPremium() == PREMIUM_JOINT then numSidesNotJoined = numSidesNotJoined - 1 end	
	local coinsRequiredToJoinRest = numSidesNotJoined * PREFSMAN:GetPreference("CoinsPerCredit")
	local remaining = coinsRequiredToJoinRest - GAMESTATE:GetCoins();
		
	if remaining <= 0 then return "2 Player mode available" end
	
	local s = "For 2 Players, insert " .. remaining .. " more coin"
	if remaining > 1 then s = s.."s" end
	return s
end

function Spin(self) 
	r = math.min(math.random(3,51),36)
	s = math.random()*7+1 
	z = self:GetZ();  
	l = r/36; 
	if z >= 36 then  
		z = z-36
		self:z(z)
		self:rotationz(z*10)
	end
	z = z + r
	self:linear(l)
	self:rotationz(z*10)
	self:z(z)
	self:sleep(s)
	self:queuecommand('Spin')
end

function NonCombos()
	local t = OptionRowBase('NonCombos')
	t.OneChoiceForAllPlayers = true
	t.Choices = { "On", "Decents Only", "Off" }
	t.LoadSelections = function(self, list, pn) if not Decents() then list[3] = true elseif not WayOffs() then list[2] = true else list[1] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then SetPref('JudgeWindowSecondsGood',0.135) SetPref('JudgeWindowSecondsBoo',0.180) end
		if list[2] then SetPref('JudgeWindowSecondsGood',0.135)	SetPref('JudgeWindowSecondsBoo',0.135) end
		if list[3] then	SetPref('JudgeWindowSecondsGood',0.102)	SetPref('JudgeWindowSecondsBoo',0.102) end
	end
	return t
end

function Decents() if math.abs(PREFSMAN:GetPreference('JudgeWindowSecondsGood') - 0.135) < .001 then return true end end
function WayOffs() if math.abs(PREFSMAN:GetPreference('JudgeWindowSecondsBoo') - 0.180) < .001 then return true end end