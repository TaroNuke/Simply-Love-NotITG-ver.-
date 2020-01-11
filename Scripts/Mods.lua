---------------------------------------------------------------------------------------------------
--  __  __			 _   __  __		  _   _   _		  _					 _   _			  _	  
-- |  \/  | __ _  __| | |  \/  | __ _| |_| |_( )___  | |   _   _  __ _  | | | | __ _  ___| | _____
-- | |\/| |/ _` |/ _` | | |\/| |/ _` | __| __|// __| | |  | | | |/ _` | | |_| |/ _` |/ __| |/ / __|
-- | |  | | (_| | (_| | | |  | | (_| | |_| |_  \__ \ | |__| |_| | (_| | |  _  | (_| | (__|   <\__ \
-- |_|  |_|\__,_|\__,_| |_|  |_|\__,_|\__|\__| |___/ |_____\__,_|\__,_| |_| |_|\__,_|\___|_|\_\___/
---------------------------------------------------------------------------------------------------

--------------------------------
-- Metrics
--------------------------------

-- [SCREEN PLAYER OPTIONS]
-- LineNames=@lineNames
-- LineMod=lua,OptionFromList()
-- LineNoteSkins=list,NoteSkins
-- OptionMenuFlags=@playerOptions.Flags
-- AllowRepeatingChangeValueInput=PlayerOptionsInit()
-- ThemeTitles=0
-- FrameOnCommand=%FrameOn
-- FrameCaptureCommand=%FrameCapture

-- CancelAllP1ShowCommand=%CancelAll
-- CancelAllP2ShowCommand=%CancelAll
-- CancelAllP1OnCommand=aux,1;TWEENS
-- CancelAllP2OnCommand=aux,2;TWEENS

-- [Option Menu that changes machine profile preferences]
-- FrameOffCommand=%SaveProfile
-- FrameSaveProfileCommand=%function() PROFILEMAN:SaveMachineProfile() end

-- [ScreenSongOptions]
-- NextScreen=@nextScreen

-- [ScreenPlayerOptionsEdit]
-- LabelsOnCommand=%function(self) TWEENS CaptureEditBPM(self)

-- [ScreenSongOptionsEdit]
-- FrameOnCommand=TWEENS - When falling back to ScreenPlayerOptionsEdit, without declaring this command, the special functions will change text based on the PlayerOption rows.

-- [Judgment]
-- MarvelousCommand=%function(self) JudgmentCommand(self,1) end
-- PerfectCommand=%function(self) JudgmentCommand(self,2) end
-- GreatCommand=%function(self) JudgmentCommand(self,3) end
-- GoodCommand=%function(self) JudgmentCommand(self,4) end
-- BooCommand=%function(self) JudgmentCommand(self,5) end
-- MissCommand=%function(self) JudgmentCommand(self,6) end

-- [HoldJudgment]				  
-- OKCommand=%function(self) HoldCommand(self,7) end
-- NGCommand=%function(self) HoldCommand(self,8) end
						
--------------------------------
-- BGAnimations
--------------------------------

-- SCREEN SELECT MUSIC
-- <ActorFrame InitCommand="%SelectMusicInit" FirstUpdateCommand="%SelectMusic" CaptureCommand="%SongInfo" CurrentSongChangedMessageCommand="queuecommand,Capture" CurrentStepsP1ChangedMessageCommand="queuecommand,Capture" CurrentStepsP2ChangedMessageCommand="queuecommand,Capture" />

-- SCREEN EVALUATION
-- <ActorFrame InitCommand="%EvaluationInit" FirstUpdateCommand="%Evaluation" />

-- SCREEN GAMEPLAY
-- <ActorFrame Command="%GameplayInit" FirstUpdateCommand="%Gameplay" UpdateCommand="%GameplayUpdate"/>

-- SCREEN EDIT
-- <ActorFrame Command="%ScreenEditInit" FirstUpdateCommand="%ScreenEdit" />

-----------------------
-- Default Values
-----------------------

-- Redefine these in Theme.lua if other values are desired.

-- Used with GoTo option for PlayerOptions and with Summary screen. These can return either functions or strings.
	screenList = { TitleMenu = 'TitleMenu' , SelectMusic = 'SelectMusic' , PlayerOptions = 'PlayerOptions' , Stage = 'Stage' , Gameplay = 'Gameplay' , Evaluation = 'Evaluation' , NameEntry = 'NameEntry' , Summary = 'Summary' , Ending = 'TitleMenu' }
	function ScreenList(str) if type(screenList[str]) == 'function' then return screenList[str]() else return screenList[str] end end

-- Judgment tween commands.
	function JudgmentTween(self) self:zoom(1.05) self:decelerate(.1) self:zoom(1) self:sleep(.6) self:accelerate(.2) self:zoom(0) end
	function HoldTween(self) self:diffuse(1,1,1,1) self:zoom(.5); self:sleep(.5) self:zoom(0) end

-- Used with Judgment Graphs.
	judgeGraphWidth = 44
	judgeGraphHeight = 20

-- Used with Synthetic Difficulty List
	twoDifficultyListRows = false
	maxRows = 5
	blankMeter = '?'
	maxFeet = 20
	minFeet = 0
	feetBaseZoom = 1

-- Judgment Font List
	judgmentFontList = { 'Default' , 'Love' , 'Tactics', 'Chromatic', 'Deco', 'GrooveNights', 'FP', 'ITG2' }

-- Used with ThemeFiles function
	themeDir = '_ThemeFiles'

-- Used with LifeBar option 
	lifeBarSizeAdd = { Width = 0, Height = 4, OffsetX = 0, OffsetY = -2 } -- Allows size adjustments for cases like Meatboy's progress bar.

-- Used with CompareScore and Measure display
	DPLimit = 9 -- Max of DP the compare score feature will display before switching to percent.
	function CompareTextColor(n) if n < 0 then return 1,.3,1,1 end return 0.3,1,0.3,1 end
	function ModTextFormat(self,n) end -- This is added on top of the base positioning etc.

-- Used with Speed Mods, to determine selected mod and as limits for slider speed mods.
	speedMax = 2000
	speedSpread = 5
	speedMin = 5

-- These will be the option rows available on the [nth] option screen. The 'NextScreen' row will be automatically added as long as there is more than 1 option screen.
	playerOptions = {}
	playerOptions[1] = { 'SpeedType','SpeedNumber','Mini','Perspective','NoteSkin','Turn','LifeBar','Compare','Rate' }
	playerOptions[2] = { 'Turn','Accel','Scroll','Effect','Appearance','Handicap','InsertTaps','InsertOther','Hide','Ghost' }
	playerOptions.Edit = { 'SpeedType','SpeedNumber','Mini','Perspective','NoteSkin','Turn' }
	ShowAllInRow = false

-----------------------
-- Utility Functions
-----------------------
function number(n) return tonumber(tostring(n)) or loadstring('return '..n)() or 0 end
function SM(str) SCREENMAN:SystemMessage(str) end
function BM(str) MESSAGEMAN:Broadcast(str) end
function Screen() return SCREENMAN:GetTopScreen() end
function Sound(str) SOUND:PlayOnce( Path("sounds",str )) end
function Path(ec,str) return THEME:GetPath( _G['EC_'..string.upper(ec)] , '' , str ) end
local function Player(pn) return GAMESTATE:IsPlayerEnabled(pn-1) end
function PlayerIndex(pn) if pn == GAMESTATE:GetNumPlayersEnabled() then return pn end return 1 end
function Profile(pn) if not PROFILEMAN then return {} end if pn == 0 then return PROFILEMAN:GetMachineProfile():GetSaved() else return PROFILEMAN:GetProfile(pn-1):GetSaved() end end
function GetPref(str) return PREFSMAN:GetPreference(str) end
function SetPref(str,val) return PREFSMAN:SetPreference(str,val) end
function ThemeFile( file ) return THEME:GetPath( EC_GRAPHICS, '' , themeDir..'/'..file ) end
function ThemeName() local str = string.sub(THEME:GetPath(2,'','_blank.png'),9) return string.sub(str,1,string.find(str,'/')-1) end   
function VocalizePath() return '/Themes/' .. tostring(Profile(0).Love and Profile(0).Love.Dir or 'Simply Love') .. '/Vocalize/' end
function IsType(a,t) return string.find(tostring(a),t) end
function TableToString(t) local s = '' for i,v in ipairs(t) do s = s .. tostring(v) end return s end
function GetStartScreen() SetPref("DelayedScreenLoad",false) if GetPref('BreakComboToGetItem') and GetInputType and GetInputType() == "" then return "ScreenArcadeStart" end return THEME:GetMetric('Common','FirstAttractScreen') end
function GetArcadeStartScreen() if GetInputType() == "" then return "ScreenArcadeStart" end	return THEME:GetMetric('Common','FirstAttractScreen') end
function MaxLength(str,l) if string.len(str) > l then str = string.sub(str,0,l-3) .. '...' end return str end
function RowMetric(b,a,r) if r then rowYNum = 0 rowYAdd = a rowYBase = b rowYOffTop = rowYBase + rowYAdd*0.5 return r elseif a then rowYNum = rowYNum + a end rowYNum = rowYNum + 1 if b ~= 'Exit' then rowYOffCenter = rowYBase + rowYAdd*(rowYNum+1+math.mod(rowYNum,2))/2 rowYOffBottom = rowYBase + rowYAdd*(rowYNum+1/2) end return rowYBase+rowYAdd*rowYNum end
function SecondsToMSS(n) local t = SecondsToMSSMsMs(math.abs(n)) t = string.sub(t,0,string.len(t)-3) if tonumber(n) < 0 then t = '-' .. t end return t end
function MSSMsMsToSeconds(t) return string.sub(t,string.len(t)-4,string.len(t)) + string.sub(t,1,string.len(t)-6)*60 end
function ForceSongAndSteps() if not GAMESTATE:GetCurrentSong() then local song = SONGMAN:GetRandomSong() GAMESTATE:SetCurrentSong(song) steps = song:GetAllSteps() GAMESTATE:SetCurrentSteps(0,steps[1]) GAMESTATE:SetCurrentSteps(1,steps[1]) end end
function Diffuse(self,c,n) if not c[4] then c[4] = 1 end if n == 1 then self:diffuseupperleft(c[1],c[2],c[3],c[4]) elseif n == 2 then self:diffuseupperright(c[1],c[2],c[3],c[4]) elseif n == 3 then self:diffuselowerleft(c[1],c[2],c[3],c[4]) elseif n == 4 then self:diffuselowerright(c[1],c[2],c[3],c[4]) else self:diffuse(c[1],c[2],c[3],c[4]) end end
function ApplyMod(mod,pn,f) local m = mod if m then if f then m = f .. '% ' .. m end GAMESTATE:ApplyGameCommand('mod,'..m,pn) end end
function CheckMod(pn,mod) return mod and GAMESTATE:PlayerIsUsingModifier(pn,mod) end
function SummaryBranch() ForceSongAndSteps() if not scoreIndex then scoreIndex = 1 end if scoreIndex <= table.getn(AllScores) then return ScreenList('Summary') else scoreIndex = 1 return ScreenList('Ending') end end
function Clock(val) local t = GlobalClock:GetSecsIntoEffect() if val then t = t - val end return t end
--function Clock(val) local t = 0 if val then t = t - val end return t end
function MusicClock() return Screen():GetSecsIntoEffect() end

--------------------------------
-- BGAnimation Functions
--------------------------------

function SelectMusicInit(self) TimedSet.Class = 0; InitializeMods() optionIndex = 0; GhostDataCache = { }; for pn=1,2 do GhostData(pn,"Cache") end; self:queuecommand('FirstUpdate') end
function SelectMusic(self) self:queuecommand('Capture') end

function GameplayInit(self) TimedSet.Class = 1; Combo = {} lifeNormal = {} lifeHot = {} holdJudgments = {} ApplyRateAdjust() self:queuecommand('FirstUpdate') end
function Gameplay(self) EditMode = false; JudgmentInit() SurroundLife() Danger.Time = {0,0} Danger.State = { false, false} Dead.Time = {0,0} Dead.State = { false, false } Screen():effectclock('music') self:luaeffect('Update') end

function EvaluationInit(self) TimedSet.Class = 2; RevertHideBG() RevertRateAdjust() self:queuecommand('FirstUpdate') end
function Evaluation() CaptureJudgment() AddScoreToListFromEval() ApplyHideBG() SaveToProfile() end

function ScreenEditInit(self) InitializeMods() holdJudgments = {} JudgmentInit() optionIndex = 'Edit' GameplayInit(self) end
function ScreenEdit() EditMode = true; end

---------------------------------------
-- Judgment/Gameplay/GhostData Functions
---------------------------------------

function JudgmentInit()
	
	if FakeCombo == nil or not FakeCombo then
		FakeCombo = {0,0};
	end
	
	judge = {}; ghost = {};
	for pn = 1,2 do judge[pn] = {0,0,0,0,0,0,0,0,0, T = 0, MaxDP = 0, CurDP = 0, Data = {}, Score = 0, Steps = {}, Stream = {{{0,0}}} } GhostData(pn,'Decompress') for i,v in ipairs(trackedStreams) do judge[pn].Stream[i] = {} end end
	for i,v in ipairs(holdJudgments) do if i <= table.getn(holdJudgments)/2 then if Player(1) then v:aux(1) else v:aux(2) end else if Player(2) then v:aux(2) else v:aux(1) end end end
	for pn = 1,2 do local px = Screen():GetChild('PlayerP'..pn) if px then px = px:GetChild('Judgment'):GetChild(''); px:aux(pn); if ModCustom.JudgmentFont[pn] ~= 1 then px:Load( THEME:GetPath( EC_GRAPHICS, '', '_Judgments/'..judgmentFontList[ModCustom.JudgmentFont[pn]] )) end end end
end

function GameplayUpdate(self)
	
	for pn=1,2 do
		if Player(pn) then
			UpdateCheck('Danger',pn)
			UpdateCheck('Dead',pn)
			if GAMESTATE:IsCourseMode() then
				return
			end
			if (MaxDP[pn] or -1) > 0 then
				if (GetScore(pn) <= 100*judge[pn].CurDP/MaxDP[pn] - 0.01) and GetScore(pn) ~= judge[pn].Score then
					TrackJudgment(false,9,pn)
				end -- Score must have changed to reflect judgment, machines update slower.
				UpdateGhostData(pn)
				UpdateStreams(pn)
				UpdateCompareText(pn)
				UpdateMeasureText(pn)
			end
			if Dead.State[pn] and not judge[pn].Dead then
				judge[pn].Dead = table.getn(judge[pn].Data)
			end -- Record judgment of death, checked after mine detection.
		end
	end
	
end

function JudgmentCommand(self,n) TrackJudgment(self,n) JudgmentTween(self) end
function HoldCommand(self,n) TrackJudgment(self,n) HoldTween(self) end

function TrackJudgment(self,j,p)
	local pn = p or math.max(self:getaux(),1)
	
	judge[pn].Score = GetScore(pn)
	judge[pn][j] = judge[pn][j] + 1
	judge[pn].CurDP = judge[pn].CurDP + ScoreWeight(j)
	judge[pn].MaxDP = judge[pn].MaxDP + MaxScoreWeight(j)
	local r = j
	if j == 9 then r = 7 -- Large number of ok/ng judgments accounting for columns, set mines to 7 and start holds from 8.
	elseif j > 6 then
		judge[pn].Delay = true
		for i,v in ipairs(holdJudgments) do
			if self == v then r = (math.mod(i-1,16) + 1) + (NumColumns(pn) * (j-7)) + (7) end  -- (Column number, modded by columns per player) + (columns used in this chart, for NG) + (number of judgments in list before 1st ok)
		end
	else
		judge[pn].T = judge[pn].T + 1
		AddStepToStream(pn,j)
	end
	table.insert( judge[pn].Data , { r , MusicClock() } ) -- compressed to ghost data
	
	--fake combo shit
	if j < 7 then
		if j < 4 then
			FakeCombo[pn] = FakeCombo[pn]+1
		else
			FakeCombo[pn] = 0
		end
		MESSAGEMAN:Broadcast('UpdateFakeComboP'..pn);
	end
	
end

trackedStreams = {0,1,4,8,12,16,24,32}
function AddStepToStream(pn,j) -- Each note frequency gets a table of {start beat,end beat} pairs.
	table.insert(judge[pn].Steps,{GAMESTATE:GetSongBeat(),MusicClock(),j})
	for i,v in ipairs(trackedStreams) do
		if table.getn(judge[pn].Steps) >= v then
			local s = judge[pn].Stream[i][table.getn(judge[pn].Stream[i])]
			if not judge[pn].Stream[i][0] then -- New stream.
				if not s or s[2] < judge[pn].Steps[1][1] then -- If new stream starts before old stream ends, continue old stream. Should improve consistancy.
					table.insert(judge[pn].Stream[i],{judge[pn].Steps[1][1],GAMESTATE:GetSongBeat()})
				end
				judge[pn].Stream[i][0] = true;
			else
				s[2] = GAMESTATE:GetSongBeat() -- Newest step is the current last step in the stream.
			end
		end
	end
	judge[pn].Stream[1] = {{0,GAMESTATE:GetSongBeat()}}
end

function UpdateStreams(pn)
	if judge[pn].Steps[1] then
		local b = GAMESTATE:GetSongBeat() - judge[pn].Steps[1][1]
		local t = (MusicClock() - judge[pn].Steps[1][2])/modRate -- Clock() uses song time, which updates faster with rate mods.
		if b > 4 then -- Saves a little work on most updates, and avoids calculating timing windows in beats when t == 0.
			local w = (judge[pn].Steps[1][3] == 6 and 0) or math.min(b/t*(JudgeWindow(judge[pn].Steps[1][3])+JudgeWindow(5)),4)	-- Miss cancels the offset from a later possible miss. Any other judgment is assumed early to be inclusive. Clamped at 4 beats in case of large jumps.
			if b - w > 4 then
				table.remove(judge[pn].Steps,1)
				for i,v in ipairs(trackedStreams) do
					if table.getn(judge[pn].Steps) < v then judge[pn].Stream[i][0] = nil end
				end
			end
		end
	end
end

function UpdateCheck(str,pn)
	if _G[str] and _G[str].State and _G[str].Time then
		if _G[str].State[pn] ~= (_G[str].Time[pn] ~= _G[str][pn]:GetSecsIntoEffect()) then BM(str..'P'..pn) end -- State is going to change, but has not changed yet.
		_G[str].State[pn] = _G[str].Time[pn] ~= _G[str][pn]:GetSecsIntoEffect() -- true if updating.
		_G[str].Time[pn] = _G[str][pn]:GetSecsIntoEffect()
	end
end

function UpdateGhostData(pn) -- Keep tap number synced, handle non-taps as they occur.
	while ghost[pn].Data[ghost[pn].I] and (ghost[pn].T < judge[pn].T or (ghost[pn].Data[ghost[pn].I][1] > 6 and ghost[pn].Data[ghost[pn].I][2] < MusicClock())) do
		local j = ghost[pn].Data[ghost[pn].I][1]
		if j > 7+NumColumns(pn) then j = 8 elseif j > 7 then j = 7 judge[pn].Delay = true elseif j == 7 then j = 9 else ghost[pn].T = ghost[pn].T + 1 end
		if (ghost[pn].Dead or table.getn(ghost[pn].Data)) > ghost[pn].I then ghost[pn].CurDP = ghost[pn].CurDP + ScoreWeight(j) end -- Don't update DP count for the deceased.
		ghost[pn][j] = ghost[pn][j] + 1
		ghost[pn].I = ghost[pn].I + 1
		for i,v in ipairs(ghost[pn].Stream) do if v[v[0]+1] and v[v[0]+1][1] < GAMESTATE:GetSongBeat() then v[0] = v[0]+1 end end
	end
end

function UpdateCompareText(pn) -- upgrade to deal with 'no maxdp' situations? Pure DP comparison or calc DP from score?
	if judge[pn].Delay then judge[pn].Delay = nil return end -- This is used to reduce jitter caused by time quantization of ghost data for holds.
	local n = 0
		if ModCustom.Compare[pn] == 2 then if ghost[pn].pn ~= pn then n = math.floor(ghost[pn].Score*judge[pn].MaxDP) elseif judge[pn].T == ghost[pn].T then n = ghost[pn].CurDP end end
		if ModCustom.Compare[pn] == 3 then if ghost[pn].pn ~= 0 then n = math.floor(ghost[pn].Score*judge[pn].MaxDP) elseif judge[pn].T == ghost[pn].T then n = ghost[pn].CurDP end end
		if ModCustom.Compare[pn] == 4 then n = judge[pn].MaxDP end
		if (ModCustom.Compare[pn] == 5 and judge[1].T == judge[2].T) then n = judge[math.mod(pn,2) + 1].CurDP end
	if n ~= 0 then 
		n = math.max(judge[pn].CurDP - n,GetScore(pn)*MaxDP[pn]/100-judge[pn].MaxDP) 
		local str = (math.abs(n) > DPLimit and string.format('%+4.2f',100*n/MaxDP[pn]+0.005*n/math.abs(n)) .. '%') or string.format('%+1.0f',n) -- convert to percent if ceil positives, floor negatives.
		if math.abs(n) < 0.1 then str = '' end
		compareText[pn]:diffuse(CompareTextColor(n)) compareText[pn]:settext(str)
	end
end

function UpdateMeasureText(pn)
	if ModCustom.Measure[pn] ~= 1 then
		local str = ''
		for i,v in ipairs(trackedStreams) do if ModsMaster.Measure.modlist[ModCustom.Measure[pn]] == v then
			local z,k = judge[pn].Stream[i],ghost[pn].Stream[i]
			if z[0] or (table.getn(z) > 0 and judge[pn].Steps[1] and z[table.getn(z)][2] > judge[pn].Steps[1][1]) or v == 0 then -- Streaming, or stream ended in the last measure. Prevents blinking at threshold.
				if v == 0 then -- Use current beat for total song length, use most recent step for specific note frequencies.
					str = math.floor(GAMESTATE:GetSongBeat()/4)
				else
					str = math.floor((z[table.getn(z)][2] - z[table.getn(z)][1])/4) if str < 2 then str = '' end
				end
			end
			if tonumber(str) and k and k[k[0]] and k[k[0]][1] <= GAMESTATE:GetSongBeat() then
				str = str .. '/' .. math.max(math.floor((k[k[0]][2] - z[table.getn(z)][1])/4),str) -- If current stream is longer than recorded, use current length.
			end
		end end
		measureText[pn]:settext(str)
	end
end

function CompareText(self) local pn = self:getaux() compareText[pn] = self self:shadowlength(0) self:horizalign('left') self:zoom(0.4) local p = Screen():GetChild('PlayerP'..pn) if p then local j = p:GetChild('Judgment') self:x(p:GetX()+j:GetX()+80) self:y(p:GetY()+j:GetY()+30) else self:zoom(0) end ModTextFormat(self,pn) end
function MeasureText(self) local pn = self:getaux() measureText[pn] = self self:shadowlength(0) self:horizalign('right') self:zoom(0.4) local p = Screen():GetChild('PlayerP'..pn) if p then local j = p:GetChild('Judgment') self:x(p:GetX()+j:GetX()-60) self:y(p:GetY()+j:GetY()+30) else self:zoom(0) end ModTextFormat(self,pn) end

function NumColumns(pn) local cols = {4,8,8,6,5,6,10,10,5,10,7,5,10,8,6,12,8,16,4,8,4,5,8,8,10,5,9} local s = GAMESTATE:GetCurrentSteps(pn-1) return s and cols[s:GetStepsType()+1] or 0 end

function GhostData(pn,fnctn,check)
	if GAMESTATE:IsCourseMode() then return end -- Too much of a headache for now.

	if not Profile(pn).Ghost then Profile(pn).Ghost = { } end
	if not Profile(0).Ghost then Profile(0).Ghost = { } end

	local b = {0,10,13,34,38,39,60,62,92} -- bad characters.
	local m = 255 - table.getn(b) -- number of characters.
	local j = 7+2*NumColumns(pn) -- number of tracked judgments (6 taps, 1 mine, ok/ng per column)
	local z = m-1 - math.mod(m-1,j) -- max value of a judgment+time character, forcing at least 1 time-only character
	local c = 0 -- time segment count

	local function ParseString(s,b)
		local z,f,k = tostring(s),{}
		while string.len(z) > 0 do
			k = string.sub(z,1,(string.find(z,b) or string.len(z)+1)-1)
			table.insert(f,tonumber(k) or k)
			z = string.sub(z,(string.find(z,b) or string.len(z))+1)
		end
		return f
	end
	  
	local function CompareParams(v) -- Score, MaxDP, Difficulty, Columns, SongDir
		local f = ParseString(v[0],string.char(1))
		if f[2] == MaxDP[pn] and f[3] == GAMESTATE:GetCurrentSteps(pn-1):GetDifficulty() and f[4] == NumColumns(pn) and f[5] == GAMESTATE:GetCurrentSong():GetSongDir() then return tonumber(f[1]) or 0 else return false end
	end

	local function char(n) -- Skip characters that would require escape characters.
		local a = 0
		for i=1,table.getn(b) do if n+a >= b[i] then a = a + 1 end end
		return string.char(n+a)
	end

	local function num(n) -- Account for skipped characters.
		if n == string.char(0) then return -1 end
		local a = string.byte(n)
		for i=table.getn(b),1,-1 do if a >= b[i] then a = a - 1 end end
		return a
	end

	if fnctn == 'Compress' and (Profile(0).Ghost.Save or Profile(pn).Ghost.Save) then
		local slot = {}
		for k = 0,pn,pn do -- If data for the song is already saved, find the index. If the new score is higher save in it's place, otherwise don't save.
			if not Profile(k).Ghost then Profile(k).Ghost = {} end
			slot[k] = table.getn(Profile(k).Ghost)+1
			for i,v in ipairs(Profile(k).Ghost) do
				if CompareParams(v) then if CompareParams(v) < GetScore(pn) then slot[k] = i else slot[k] = 0 end end
			end
		end
		if judge[pn].Data[1] and (slot[0] ~= 0 or slot[pn] ~= 0) and MaxDP[pn] then  -- Only compress if it will be saved somewhere.
			local tab = {'',''}
			tab[0] = GetScore(pn) .. string.char(1) .. MaxDP[pn] .. string.char(1) .. GAMESTATE:GetCurrentSteps(pn-1):GetDifficulty() .. string.char(1) .. NumColumns(pn) .. string.char(1) .. GAMESTATE:GetCurrentSong():GetSongDir()
			for k,d in ipairs(judge[pn].Data) do
				local n = string.format('%i',math.max(d[2],0)*32+1/2)*j + d[1] - 1 -- total value
				local t = ( n - math.mod(n,z) )/ z -- time segments passed before this judgment
				for i=m-1-z,0,-1 do while t >= c + 2^i do c = c + 2^i; tab[1] = tab[1] .. char(m-i) end end -- Add time characters as needed.
				tab[1] = tab[1] .. char(n - t*z)
				if k == judge[pn].Dead then tab[1] = tab[1] .. string.char(0) end -- Indicate that most recent judgment was fatal.
			end
			for i,v in ipairs(judge[pn].Stream) do
				tab[2] = tab[2] .. (i~=1 and string.char(1) or '')
				for j,z in ipairs(v) do tab[2] = tab[2] .. string.char(2) .. '{' .. math.floor(z[1]) .. ',' .. math.floor(z[2]) .. '}' end
			end

			if Profile(0).Ghost.Save and slot[0] ~= 0 then Profile(0).Ghost[slot[0]] = tab end
			if Profile(pn).Ghost.Save and slot[pn] ~= 0 then Profile(pn).Ghost[slot[pn]] = tab end

		end
	end

	if fnctn == 'Decompress' then
		ghost[pn] = {0,0,0,0,0,0,0,0,0, T = 0, I = 1, CurDP = 0, Data = {}, Stream = {}, pn = -1, Score = 0 }
		if Player(pn) and (ModCustom.Compare[pn] == 2 or ModCustom.Compare[pn] == 3 or ModCustom.Measure[pn] ~= 1) then
			local s,b,p = '',{},(ModCustom.Compare[pn] == 3 and {0,pn}) or {pn,0} -- Order to check for data. Compare score has priority but if its missing use backup for other features.
			for n,k in ipairs(p) do if s == '' then
				for i,v in ipairs(Profile(k).Ghost or {}) do
					if CompareParams(v) then s = tostring(v[1]); b = ParseString(v[2],string.char(1)); ghost[pn].pn = k; ghost[pn].Score = CompareParams(v) end
				end
			end end

			while string.len(s) > 0 do
				local n = num(string.sub(s,1,1))
				if n > z then
					c = c + 2^(m-n)
				elseif n >= 0 then
					table.insert(ghost[pn].Data, { math.mod(n,j) + 1 , ( n - math.mod(n,j) + z*c )/j/32 } ) -- insert { judgment , seconds*32 }
				else
					ghost[pn].Dead = table.getn(ghost[pn].Data) -- Previous judgment was fatal.
				end
				s = string.sub(s,2)
			end

			for i,v in ipairs(b) do
				table.insert(ghost[pn].Stream,{}); ghost[pn].Stream[i][0] = 1
				local a = ParseString(v,string.char(2))
				for j,z in ipairs(a) do if j > 1 then table.insert(ghost[pn].Stream[i],loadstring('return '..z)())end end
			end

			if p[1] ~= ghost[pn].pn then if p[1] == 0 then ghost[pn].Score = (tonumber(MachineHighScoreText[pn]) or 0)/100 else ghost[pn].Score = (tonumber(ProfileHighScoreText[pn]) or 0)/100 end end
			if ghost[pn].Score == 0 then ghost[pn].pn = -1; ghost[pn].Score = 1 end -- If compared score is 0, use subtractive instead.
		end
	end

	if fnctn == 'Cache' then
		for n,k in ipairs({pn,0}) do
			if not GhostDataCache[k] then
				local t = { }
				for i,v in ipairs(Profile(k).Ghost or {}) do
					local f = ParseString(v[0],string.char(1)) -- Score, MaxDP, Difficulty, Columns, SongDir
					local dir = f[5]
					local dif = f[3]
					if not dir then -- erase old style data.
						Profile(k).Ghost[i] = nil
					else
						if not t[dir] then t[dir] = { } end
						t[dir][dif] = { Col = f[4]; MaxDP = f[2] }
					end
				end
				for i,v in pairs(t) do
				end
				GhostDataCache[k] = t
			end
		end
	end

	if fnctn == 'Check' then
		local t = GhostDataCache[check]
		if not t then return false end
		
		local song = GAMESTATE:GetCurrentSong()
		if not song then return false end

		t = t[song:GetSongDir()]
		if not t then return false end

		local steps = GAMESTATE:GetCurrentSteps(pn-1)
		if not steps then return false end

		t = t[steps:GetDifficulty()]
		if not t then return false end
		
		if t.Col ~= NumColumns(pn) then return false end

		if t.MaxDP ~= MaxDP[pn] then return false end
		
		return true

	end

end

-- judgeGraphArray[pn][j][i] = number of judgment j you got in i-th frame
-- judgeGraphArray[pn][0][i] = total judgments in i-th frame
-- judgeGraphArray[pn][j][0] = largest number of judgment j you got in any single frame
function JudgeGraphArray()
	judgeGraphArray = {{},{}}
	for pn=1,2 do
		for j=0,6 do judgeGraphArray[pn][j] = {}; judgeGraphArray[pn][j][0] = 1
			for i=1,judgeGraphWidth do judgeGraphArray[pn][j][i] = 0 end
		end
		if judge[pn].Data[1] then
			for k,d in ipairs(judge[pn].Data) do
				local i = math.min(math.floor(1+judgeGraphWidth*d[2]/judge[pn].Data[table.getn(judge[pn].Data)][2]),judgeGraphWidth)
				local j = d[1]
				if j <= 6 then -- tap judgments only
					judgeGraphArray[pn][j][i] = judgeGraphArray[pn][j][i] + 1
					judgeGraphArray[pn][0][i] = judgeGraphArray[pn][0][i] + 1
					judgeGraphArray[pn][j][0] = math.max(judgeGraphArray[pn][j][0],judgeGraphArray[pn][j][i])
				end
			end
		end   
	end
end

function JudgeGraphCondition() judgeFrame = judgeFrame + 1 if judgeGraphArray[n][j][judgeFrame] ~= 0 then return true end end

function JudgeGraph(self)
	local t = (judgeGraphHeight-1)*judgeGraphArray[n][j][judgeFrame]/judgeGraphArray[n][0][judgeFrame]
	if t ~= 0 then t = t + 1 end
	self:stretchto(judgeFrame-1,0,judgeFrame,-t)
end

function JudgmentColor( n , alpha )
	if alpha then a = alpha else a = 1 end
	if n == 1 then return 0,.86,1,a end
	if n == 2 then return 1,.60,0,a end
	if n == 3 then return .04,1,0,a end
	if n == 4 then return .62,0,.97,a end
	if n == 5 then return 1,.42,0,a end
	if n == 6 then return 1,0,0,a end
	return 1,1,1,1
end

function ResetScores() AllScores = {} end
function AddScoreToListFromEval()
	local add = false
	local score = {}
	local fail = {}
	local steps = {}
	local judge = {{},{}}
	for pn=1,2 do if Player(pn) then
		for i=1,9 do table.insert(judge[pn],_G[judgmentList[i]][pn]) end
		score[pn] = GetScore(pn)		   
		fail[pn] = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn-1):GetGrade() == GRADE_FAILED
		steps[pn] = GAMESTATE:GetCurrentSteps(pn-1)
		if score[pn] ~= 0 then add = true end
	end end
	if add then
		local list = {
			Song = GAMESTATE:GetCurrentSong(),
			Steps = steps,
			Score = score,
			Rate = modRate,
			Fail = fail,
			BPM = bpm,
			Judge = judge,
			Time = Clock( TimedSet.Start )
		}
	table.insert(AllScores,list)
	end
end  

------------------------
-- Capturing Functions
------------------------

function InitializeMods()
	if GAMESTATE:GetEnv('Mods') then return end
	ModsPlayer = { }
	ModCustom = { LifeBar = {1,1}, JudgmentFont = {1,1}, Compare = {1,1}, Measure = {1,1} }
	modRate = 1
	CalculateSpeedMod()
	ResetScores()
	TimedSet.Reset()
	LoadFromProfile()
	if Profile(0).TimedSets and not GAMESTATE:IsEventMode() then GAMESTATE:SetTemporaryEventMode(true) end
	GAMESTATE:SetEnv('Mods',1)
end

function LoadFromProfile()
	for pn = 1,2 do if Player(pn) then local t = Profile(pn) if not t.Mods then t.Mods = {} end
		for s,v in pairs(ModCustom) do v[pn] = tonumber(t.Mods[s]) or 1 end
		for i,v in ipairs(judgmentFontList) do if t.Mods.JudgmentFont == v then ModCustom.JudgmentFont[pn] = i end end
		if vocalize and Profile(pn).Voice then vocalize[pn] = Profile(pn).Voice end
		LoadFloatFromProfile(pn,'Mini',t)
		if t.Mods.Cover then ApplyMod('cover',pn) end
	end end
end

function LoadFloatFromProfile(pn,m,t)
	if not ModsPlayer[m] then ModsPlayer[m] = {0,0} end
	if t.Mods[m] then 
		ApplyMod(m,pn,t.Mods[m])
		ModsPlayer[m][pn] = t.Mods[m]
	end
end

function SaveToProfile()
	for pn = 1,2 do if Player(pn) then local t = Profile(pn)
		if not t.Mods then t.Mods = {} end
		for s,v in pairs(ModCustom) do t.Mods[s] = v[pn] end
		if vocalize then Profile(pn).Voice = vocalize[pn] end
		t.Mods.JudgmentFont = judgmentFontList[ModCustom.JudgmentFont[pn]]
		t.Mods.Mini = OptionFromEvalPlayerOptions(pn,'mini')
		GhostData(pn,'Compress')
	end end
end

function OptionFromEvalPlayerOptions(pn,m)
	if not Player(pn) then return 0 end
	local mods = string.lower(Screen():GetChild('PlayerOptionsP'..pn):GetText())
	local s = { string.find(mods,'-*%d*%%*%s*'..m) }
	if not s[1] then return 0 end
	if s[2]-s[1] == string.len(m) then return 100 end
	s = string.sub(mods,s[1],s[2]-2-string.len(m))
	return s
end
	
function CapturePlayerMetric(self,str) if _G[str][1] or not Player(1) then _G[str][2] = self; self:aux(2) else _G[str][1] = self; self:aux(1) end end

function SongInfo(self)
	CapturePane()
	CaptureBPM()
	CaptureMeter()
	SongLength = Screen():GetChild('TotalTime'):GetText()
	CaptureSteps()
	self:queuemessage('SongInfo')
end

function JudgeWindow(j) local names = {'Marvelous','Perfect','Great','Good','Boo','Miss','OK','NG','HitMine'} return GetPref('JudgeWindowSeconds'..names[j]) end
function ScoreWeight(j) local names = {'Marvelous','Perfect','Great','Good','Boo','Miss','OK','NG','HitMine'} return GetPref('PercentScoreWeight'..names[j]) end
function MaxScoreWeight(j) if j == 9 then return 0 end if j > 6 then return ScoreWeight(7) end	return ScoreWeight(1) end
paneItemListDance = {'SongNumStepsText' , 'SongJumpsText' , 'SongHoldsText' , 'SongRollsText' , 'SongMinesText' , 'SongHandsText' , 'MachineHighScoreText' , 'ProfileHighScoreText' , 'MachineHighNameText' }
paneItemListCourse = {'CourseNumStepsText' , 'CourseJumpsText' , 'CourseHoldsText' , 'CourseRollsText' , 'CourseMinesText' , 'CourseHandsText' , 'CourseMachineHighNameText' , 'CourseMachineHighScoreText' , 'CourseProfileHighScoreText' }
judgmentList = { 'MarvelousNumber' , 'PerfectNumber' , 'GreatNumber' , 'GoodNumber' , 'BooNumber' , 'MissNumber' , 'HoldsText' , 'RollsText' , 'MinesText' , 'JumpsText' , 'HandsText' }
Difficulty = {}
Meter = {}
MaxDP = {}

for i,v in ipairs(paneItemListDance) do _G[v] = {} end
for i,v in ipairs(paneItemListCourse) do _G[v] = {} end
for i,v in ipairs(judgmentList) do _G[v] = {} end

function CapturePane()
	if GAMESTATE:IsCourseMode() then paneItemList = paneItemListCourse else paneItemList = paneItemListDance end
	for pn = 1, 2 do if Player(pn) then
		for i,v in ipairs(paneItemList) do _G[v][pn] = Screen():GetChild('PaneDisplayP'..pn):GetChild(''):GetChild(v):GetText() if i == 7 or i == 8 then _G[v][pn] = string.gsub(_G[v][pn],'%%','') end end
		if tonumber(_G[paneItemList[1]][pn]) then MaxDP[pn] = _G[paneItemList[1]][pn]*ScoreWeight(1) + _G[paneItemList[3]][pn]*ScoreWeight(7) + _G[paneItemList[4]][pn]*ScoreWeight(7) else	MaxDP[pn] = nil	end
	end end
end

function CaptureJudgment() for pn = 1, 2 do if Player(pn) then for i,v in ipairs(judgmentList) do local j = Screen():GetChild(v .. 'P' .. pn) if j then _G[v][pn] = j:GetText() end end end end end

function CaptureMeter()
	for pn = 1, 2 do if Player(pn) then
		s = GAMESTATE:GetCurrentSteps(pn-1)
		if s then Difficulty[pn] = s:GetDifficulty() else Difficulty[pn] = Screen():GetChild('MeterP'.. pn):GetChild('Difficulty'):GetText() end
		for i=0,5 do if DifficultyToThemedString(i) == Difficulty[pn] or string.upper(DifficultyToThemedString(i)) == Difficulty[pn] then Difficulty[pn] = i break end end
		Meter[pn] = Screen():GetChild('MeterP'.. pn):GetChild('Meter'):GetText()
	end end
end

function CaptureSteps()
	for pn = 1, 2 do if GAMESTATE:GetCurrentSteps(pn-1) then st = GAMESTATE:GetCurrentSteps(pn-1):GetStepsType() break end end 
	steps = {}
	if GAMESTATE:GetCurrentSong() then
		steps = GAMESTATE:GetCurrentSong():GetStepsByStepsType( st )
		t = {} -- Sorting manually. For whatever reason table.sort was returning true for a:GetMeter() == b:GetMeter() on some edits when that was NOT true. Maybe the function was too long? The length was required.
		for n=1,table.getn(steps) do
			m = 1
			for i,a in ipairs(steps) do
				local b = steps[m]
				if a:GetDifficulty()< b:GetDifficulty() or (a:GetDifficulty() == b:GetDifficulty() and (a:GetMeter() < b:GetMeter() or (a:GetMeter() == b:GetMeter() and a:GetDescription()<b:GetDescription()))) then m = i end
			end
			table.insert(t,steps[m])
			table.remove(steps,m)
		end
		steps = t
	end
end

function CaptureBPM()
	bpm = {}
	local s = SCREENMAN:GetTopScreen():GetChild('BPMDisplay')
	if s then
		s = s:GetChild('Text'):GetText()
		bpm[1] = string.gsub(s,'^(-?%d+)-?[-%d]*$','%1')
		bpm[2] = string.gsub(s,'^'..bpm[1]..'%-?','')
	end
end

function CaptureEditBPM(self) -- Captures the BPM from the player options menu.
	local s = self:GetText()
	if string.find(s,'Speed ') then
		bpm = {}
		s = string.sub(s,8,string.len(s)-1)
		bpm[1] = string.gsub(s,'^(-?%d+)-?[-%d]*$','%1')
		bpm[2] = string.gsub(s,'^'..bpm[1]..'%-?','')
		self:settext('Speed Mod Type')
	end
end

function GetSongName()
	if GAMESTATE:GetCurrentCourse() then return GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() end
	if GAMESTATE:GetCurrentSong() then return GAMESTATE:GetCurrentSong():GetDisplayMainTitle() end
	return ""
end

function GetScore(pn)
	
	if EditMode or GAMESTATE:IsCourseMode() then return 0 end
	
	local s = 0
	if Screen():GetChild('PercentP'..pn) then s = Screen():GetChild('PercentP'..pn):GetChild('PercentP'..pn):GetText() end
	if Screen():GetChild('ScoreP'..pn) then s = Screen():GetChild('ScoreP'..pn):GetChild('ScoreDisplayPercentage Percent'):GetChild('PercentP'..pn):GetText() end
	s = string.gsub(s,'%%','')
	return tonumber(s) or 0
	
end

function ModPulse(self,mod)
	for pn=0,1 do if CheckMod(pn,mod) then ApplyMod('no '..mod,pn+1); modPulsePlayer = pn self:playcommand('Mod') end end
	self:sleep(.1)
	self:queuecommand('Pulse')
end

-------------------------------------
-- BPM format and display functions
-------------------------------------

function BPMlabelRate(self)	s = AdjustedBPM() .. ' BPM ' .. RateModAppend() if self then self:settext(s) else return s end end
function BPMandRate(self) s = AdjustedBPM() .. ' ' .. RateModAppend() if self then self:settext(s) else return s end end
function RateBPMlabel(self) s = RateModText() if s ~= '' then s = s .. ' (' .. AdjustedBPM() .. ' BPM)' end	if self then self:settext(s) else return s end end 

function RateModText(self) s = '' if modRate ~= 1 then s = string.format('%01.1f',modRate) .. 'x Music Rate' end if self then self:settext(s) else return s end end
function RateModAppend(self) s = RateModText() if s ~= '' then s = '(' .. s .. ')' end if self then self:settext(s) else return s end end

function AdjustedBPM(self)
	s = bpm[1]
	if tonumber(s) then
		s = math.floor(bpm[1] * modRate + 0.5)
		if tonumber(bpm[2]) then s = s .. '-' .. math.floor(bpm[2] * modRate + 0.5) end
	end
	if self then self:settext(s) else return s end
end

function DisplaySpeedMod(pn)
	local s = ''
	if modType[pn] == 'x' and tonumber(bpm[1]) then
		s = math.floor(modSpeed[pn] / 100 * bpm[1] + 0.5)
		if tonumber(bpm[2]) then s = s ..  '-' .. math.floor(modSpeed[pn] / 100 * bpm[2] + 0.5) end
		s = ' (' .. s .. ')'
	end
	return SpeedString(pn) .. s
end

function GameplayBPM(self)
	local b = Screen():GetChild('BPMDisplay')
	if b then b = b:GetChild('Text'):GetText() end
	if b and bpm then
		bpm[3] = Screen():GetChild('BPMDisplay'):GetChild('Text'):GetText()
		if not OPENITG then bpm[3] = math.floor(bpm[3] * modRate + 0.5) end
		self:settext(bpm[3])
		self:sleep(.05)
		self:queuecommand('Update')
	end
end

-------------------------------------
-- Lua Option Row support functions
-------------------------------------

baseSpeed = { "C700", "C800", "C900", "C1000", "C1100", "C1200", "C1300", "C1400", "1x", "2x", "3x", "4x", "5x", "6x", "7x", "C400", "C500", "C600" }
extraSpeed = { "0", "+C10", "+C20", "+C30", "+C40", "+C50", "+C60", "+C70", "+C80", "+C90", "+.75x", "+.50x", "+.25x" }

rateMods = { "1.0x", "1.1x", "1.2x", "1.3x", "1.4x", "1.5x", "1.6x", "1.7x", "1.8x", "1.9x", "2.0x" }
rateModsEdit = { "1.0x", "1.1x", "1.2x", "1.3x", "1.4x", "1.5x", "1.6x", "1.7x", "1.8x", "1.9x", "2.0x", "0.3x", "0.4x", "0.5x", "0.6x", "0.7x", "0.8x", "0.9x" }

modRate = 1

ModsPlayer = {}
ModsMaster = {}
ModsMaster.Perspective =	{ modlist = {'Overhead','Hallway','Distant','Incoming','Space'}, Select = 1 }
ModsMaster.NoteSkin =		{ modlist = {'Scalable','Metal','Cel','Flat','Vivid','Cyber','DivinEntity','couples'}, Select = 1 }
ModsMaster.Turn =			{ modlist = {'Mirror','SoftShuffle','SmartBlender','Blender',}, default = 'no mirror,no left,no right,no shuffle,no supershuffle,no softshuffle, no spookyshuffle, no smartblender', mods = {'mirror','softshuffle','smartblender','supershuffle'} }
ModsMaster.Hide = 			{ modlist = {'Hide Targets','Hide Judgments','Hide Background'}, default ='no dark,no blind,no cover', mods = {'dark','blind','cover'} }
ModsMaster.Accel =			{ modlist = {'Accel','Decel','Wave','Boomerang','Expand','Bump'}, default = 'no boost,no brake,no wave,no boomerang,no expand,no bumpy', mods = {'Boost','Brake','Wave','Boomerang','Expand','Bumpy'} }
ModsMaster.Scroll = 		{ modlist = {'Reverse','Split','Alternate','Cross','Centered'}, default = 'no reverse,no split,no alternate,no cross,no centered' }
ModsMaster.Effect = 		{ modlist = {'Drunk','Dizzy','Flip','Invert';'Tornado','Tipsy','Beat'}, default = 'no drunk,no dizzy,no flip,no invert,no tornado,no tipsy,no beat, no big', mods = {'drunk','dizzy','flip','invert','60% tornado','tipsy','beat'} }
ModsMaster.Appearance = 	{ modlist = {'Sudden','Hidden','Blink','Stealth'}, default ='no hidden,no sudden,no blink,no stealth' }
ModsMaster.Handicap = 		{ modlist = {'No Mines','No Rolls','No Holds','No Hands','No Jumps','No Stretch'}, default ='no nomines,no noholds,no norolls,no nohands,no nojumps,no nostretch', mods = {'nomines','norolls','noholds','nohands','nojumps','nostretch'} } 
ModsMaster.InsertTaps =		{ name = 'Insert', modlist = {'Little','Big','Quick','Skippy','Echo','Wide','Stomp'}, default = 'no little,no big,no quick,no skippy,no echo,no stomp,no wide', mods = {'Little','Big','Quick','Skippy','Echo','Wide','Stomp'} }
ModsMaster.InsertOther =	{ name = 'Other', modlist = {'Planted','Floored','Twister','Mines'}, default = 'no planted,no floored,no twister,no mines' }

ModsMaster.NoMines =		{ name = 'No Mines' }
ModsMaster.NoJumps =		{ name = 'No Jumps' }
ModsMaster.NoHolds =		{ name = 'No Holds' }
ModsMaster.NoHands =		{ name = 'No Hands' }
ModsMaster.NoRolls =		{ name = 'No Rolls' }
ModsMaster.Dark =			{ name = 'Hide Targets' }
ModsMaster.Blind =			{ name = 'Hide Judgments' }
ModsMaster.Cover =			{ name = 'Hide Background' }
ModsMaster.Mines =			{ name = 'Add Mines' }

ModsMaster.Boost =			{ name = 'Accel', float = true }
ModsMaster.Break =			{ name = 'Decel', float = true }
ModsMaster.Wave =			{ float = true }
ModsMaster.Expand =			{ float = true }
ModsMaster.Boomerang =		{ float = true }
ModsMaster.Bumpy =			{ float = true }
ModsMaster.Drunk =			{ float = true }
ModsMaster.Dizzy =			{ float = true }
ModsMaster.Tornado =		{ float = true }
ModsMaster.Tipsy =			{ float = true }
ModsMaster.Beat =			{ float = true }
ModsMaster.Mini =			{ float = true }

ModsMaster.SpeedType =		{ fnctn = 'SpeedType' }
ModsMaster.SpeedNumber =	{ fnctn = 'SpeedNumber' }
ModsMaster.Next =			{ fnctn = 'NextScreenOption' }
ModsMaster.Ghost = 			{ fnctn = 'EnableGhostData' }
ModsMaster.Measure =		{ fnctn = 'MeasureOption', modlist = {-1,0,8,12,16,24,32} }
ModsMaster.Compare =		{ fnctn = 'CompareOption' }
ModsMaster.LifeBar =		{ fnctn = 'LifeBarOption' }
ModsMaster.JudgmentFont =	{ fnctn = 'JudgmentOption' }
--ModsMaster.Voice =			{ fnctn = 'VocalizeOption' }
ModsMaster.Rate =			{ fnctn = 'RateMods' }
ModsMaster.RateEdit =		{ fnctn = 'RateMods', arg = 'Edit' }
ModsMaster.SpeedBase =		{ fnctn = 'SpeedMods' }
ModsMaster.SpeedExtra =		{ fnctn = 'SpeedMods', arg = 'Extra' }

function OptionRowBase(name,modList)
	local t = {
		Name = name or 'Unnamed Options',
		LayoutType = (ShowAllInRow and 'ShowAllInRow') or 'ShowOneInRow',
		SelectType = 'SelectOne',
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = modList or {'Off','On'},
		LoadSelections = function(self, list, pn) list[1] = true end,
		SaveSelections = function(self, list, pn)	 end
	}
	return t
end

function PlayerOptionsInit() LineNames() SetPlayerOptionFlags() return not string.find(playerOptions.Flags,'toggle') end
function SetPlayerOptionFlags() local f = 'toggle' for i,v in ipairs(optionsList) do if ModsMaster[v] and ModsMaster[v].float then f = '' end end playerOptions.Flags = playerOptions[optionIndex].Flags or f end

function LineNames()
	optionIndex = tonumber(optionIndex) and math.mod(optionIndex,table.getn(playerOptions))+1 or optionIndex
	optionsList = {}
	lineNames = ''

	for i,v in ipairs(playerOptions[optionIndex]) do
		table.insert(optionsList,v)
		lineNames = lineNames .. 'Mod' .. ','
	end

	lineNames = string.sub(lineNames,1,string.len(lineNames)-1)
	if table.getn(playerOptions) > 1 and optionIndex ~= 'Edit' then table.insert(optionsList,'Next') lineNames = lineNames .. ',' .. 'Mod' else nextScreen = ScreenList('Gameplay') end
end

function OptionFromList()
	local t = {}
	local mod = table.remove(optionsList,1)
	if not ModsMaster[mod] then ModsMaster[mod] = {} end
		if ModsMaster[mod].fnctn	then t = _G[ModsMaster[mod].fnctn](ModsMaster[mod].arg)
	elseif ModsMaster[mod].float	then t = OptionFloat(mod)
	elseif ModsMaster[mod].modlist	then t = OptionList(mod)
									else t = OptionBool(mod) end
	return t
end

function OptionFloat(mod)
	if not ModsPlayer[mod] then ModsPlayer[mod] = {0,0} end
	local name = ModsMaster[mod].name or mod
	local function display( text , pn ) text:settext( ModsPlayer[mod][pn] .. '%' ) end
	local function move(pn,dir,cnt) ModsPlayer[mod][pn+1] = AddSnap(ModsPlayer[mod][pn+1], dir , cnt , { 1 , 5 , 25 }) ApplyMod(mod,pn+1,ModsPlayer[mod][pn+1]) end
	return SliderOption(name,move,display)
end

function OptionBool(mod)
	local t = OptionRowBase( ModsMaster[mod].name or mod )
	t.LoadSelections = function(self, list, pn) list[2] = CheckMod(pn,mod) list[1] = not list[2] end
	t.SaveSelections = function(self, list, pn) if list[2] then ApplyMod(mod,pn+1) else ApplyMod('no '..mod,pn+1) end end
	return t
end

function OptionList(mod)
	local Select = string.find(playerOptions.Flags,'toggle') and ModsMaster[mod].Select ~= 1
	local mods = {}; for i,v in ipairs(ModsMaster[mod].mods or ModsMaster[mod].modlist) do table.insert(mods,v) end
	local t = OptionRowBase( ModsMaster[mod].name or mod)
	t.Choices = {} for i,v in ipairs(ModsMaster[mod].modlist) do table.insert(t.Choices,v) end
	if Select then t.SelectType = 'SelectMultiple' end
	if not Select and ModsMaster[mod].Select ~= 1 then table.insert(mods,1,false) table.insert(t.Choices,1,'None') end
	t.LoadSelections = function(self, list, pn) local k = Select and 0 or 1 for i,v in ipairs(mods) do if CheckMod(pn,v) then k = i list[i] = Select end end list[k] = true end
	t.SaveSelections = function(self, list, pn) ApplyMod(ModsMaster[mod].default,pn+1) for i,v in ipairs(list) do if v then ApplyMod(mods[i],pn+1) end end end
	return t
end

function CustomMod(name,modVar,choices)
	if not ModCustom[modVar] then ModCustom[modVar] = {1,1} end
	local t = OptionRowBase(name,choices)
	t.LoadSelections = function(self, list, pn) list[ModCustom[modVar][pn+1]] = true end
	t.SaveSelections = function(self, list, pn) for i,v in ipairs(list) do if v then ModCustom[modVar][pn+1] = i end end end
	return t
end

function BoolPrefRow(name,pref,tab)
	local t = OptionRowBase(name)
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list, pn) list[1] = not GetPref(pref) list[2] = GetPref(pref) end
	t.SaveSelections = function(self, list, pn) SetPref(pref,list[2]) for i,p in ipairs(tab or {}) do SetPref(p,list[2]) end end
	return t
end

-- have clock track larger time
-- if second is 1 higher but ms is still within range, neither increment or reset. Make some indication of second increase
-- if this happens twice in a row, guarantee 
-- on negative 

SliderDisplayFunction = { }
function SliderOption(name,move,display,share)

	-- allows SetOptionRow to access display functions based on row name, so initial setting can be made.
	SliderDisplayFunction[name] = display
	if THEMED_TITLES then SliderDisplayFunction[THEME:GetMetric("OptionTitles",name)] = display end

	local slider = {{1,1,0},{1,1,0}} -- {position, counts, clock}
	local t = OptionRowBase(name,{' ',' ',' '})
	t.OneChoiceForAllPlayers = share
	t.LayoutType = 'ShowOneInRow'
	t.LoadSelections = function(self, list, pn) list[1] = true slider[pn+1][1] = 1 end
	t.SaveSelections = function(self, list, pn)
			if share and pn ~= GAMESTATE:GetMasterPlayerNumber() then return end
			if Clock(slider[pn+1][3]) < 0.1 then slider[pn+1][2] = math.min(slider[pn+1][2]+1) else slider[pn+1][2] = 1 end
			slider[pn+1][3] = Clock()
			for i=1,3 do if list[i] then
				if slider[pn+1][1] == math.mod(i+2,3) then move(pn, 1,slider[pn+1][2]) SetOptionRow(name) end
				if slider[pn+1][1] == math.mod(i+1,3) then move(pn,-1,slider[pn+1][2]) SetOptionRow(name) end
				slider[pn+1][1] = math.mod(i,3)
			end end
		end
	return t
end

function AddSnap( val , dir , cnt , speed )
	local n = clamp( math.floor( cnt / 5 ) + 1 , 1 , table.getn( speed ) )
	local add = dir * speed[n]
	local ret = val + add
	return ret - math.mod( ret , add )
end

--------------------
-- Lua Option Rows
--------------------

function SpeedType()
	local t = OptionRowBase((optionIndex == 'Edit' and 'Speed') or 'Speed Mod Type',{ 'x' , 'C' , 'm' })
	t.LoadSelections = function(self, list, pn) for i,v in ipairs(self.Choices) do if modType[pn+1] == v then list[i] = true end end end
	t.SaveSelections = function(self, list, pn) for i,v in ipairs(list) do if v then modType[pn+1] = self.Choices[i] end end SetSpeedMod(pn+1) SetOptionRow('Adjust Speed',true) end
	t.LayoutType = 'ShowOneInRow'
	return t
end

function SpeedNumber()
	local function display( text , pn ) text:settext( DisplaySpeedMod(pn) ) end
	local function move(pn,dir,cnt) modSpeed[pn+1] = clamp( AddSnap(modSpeed[pn+1] , dir , cnt , { 5 , 25 , 100 } ) , speedMin , speedMax ); SetSpeedMod(pn+1) end
	return SliderOption('Adjust Speed',move,display)
end

function RateMods( s )
	local t = OptionRowBase('Music Rate',s and rateModsEdit or rateMods)
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list, pn)	for i,m in ipairs(self.Choices) do if CheckMod(pn,m..'music') then list[i] = true; s = string.gsub(m,'x','') modRate = tonumber(s) end end end
	t.SaveSelections = function(self, list, pn)
		for i,m in ipairs(self.Choices) do if list[i] then s = string.gsub(m,'x',''); modRate = tonumber(s) end end
		ApplyMod(s..'xmusic',pn+1)
		MESSAGEMAN:Broadcast('RateModChanged')
	end
	return t
end

function NextScreenOption()
	local t = OptionRowBase('Next Screen',{'Gameplay','Select Music','More Options'})
	t.OneChoiceForAllPlayers = true
	t.LoadSelections = function(self, list, pn) list[1] = true end
	t.SaveSelections = function(self, list, pn)
			if list[1] then nextScreen = ScreenList('Gameplay') end
			if list[2] then nextScreen = ScreenList('SelectMusic') end
			if list[3] then nextScreen = ScreenList('PlayerOptions') end
		end
	return t
end

function EnableGhostData(a) -- Use an argument of 0 for the operator menu option, to affect machine profile.
	local t = OptionRowBase('Save Ghost Data',{'No','Yes'})
	if a then t.OneChoiceForAllPlayers = true end
	t.LoadSelections = function(self, list, pn) if not Profile(a or pn+1).Ghost then Profile(a or pn+1).Ghost = {} end list[2] = Profile(a or pn+1).Ghost.Save; list[1] = not list[2] end
	t.SaveSelections = function(self, list, pn) Profile(a or pn+1).Ghost.Save = list[2] end
	if a then CheckProfile.Ghost = { Save = Profile(0).Ghost and Profile(0).Ghost.Save } end
	return t
end

function PlayModeType()
	local t = OptionRowBase('Play Mode Type',{'Stages','Timer'})
	t.OneChoiceForAllPlayers = true 
	t.LoadSelections = function(self, list) list[2] = Profile(0).TimedSets; list[1] = not list[2] end
	t.SaveSelections = function(self, list) Profile(0).TimedSets = list[2] end
	CheckProfile.TimedSets = Profile(0).TimedSets
	return t
end

function SessionTimer()
	Profile(0).SessionTimer = Profile(0).SessionTimer or 0
	local function display( text ) text:settext( SecondsToMSS( Profile(0).SessionTimer ) ) end
	local function move(pn,dir,cnt) Profile(0).SessionTimer = math.max( AddSnap( Profile(0).SessionTimer, dir , cnt , { 1 , 15 , 60 , 300 } ) , 0 ) end
	local t = SliderOption('Play Timer',move,display,true)
	CheckProfile.SessionTimer = Profile(0).SessionTimer
	return t
end

function CutOffTime()
	Profile(0).CutOffTime = Profile(0).CutOffTime or 0
	local function display( text ) text:settext( SecondsToMSS( Profile(0).CutOffTime ) ) end
	local function move(pn,dir,cnt) Profile(0).CutOffTime = math.max( AddSnap( Profile(0).CutOffTime, dir , cnt , { 1 , 15 , 60 , 300 } ) , 0 ) end
	local t = SliderOption('Cut Off Time',move,display,true)
	CheckProfile.CutOffTime = Profile(0).CutOffTime
	return t
end

function JudgmentOption() return CustomMod('Judgment Font','JudgmentFont',judgmentFontList) end
function LifeBarOption() return CustomMod('Life Bar Type','LifeBar',{'Normal','Surround'}) end
function CompareOption()
	local t = CustomMod('Compare Score','Compare',{ 'None' , 'Personal' , 'Machine' , 'Subtractive' })
	if Player(1) and Player(2) and GAMESTATE:GetCurrentSteps(0) == GAMESTATE:GetCurrentSteps(1) then table.insert(t.Choices,'Opponent') end
	for pn=1,2 do if ModCustom.Compare[pn] > table.getn(t.Choices) then ModCustom.Compare[pn] = 2 end end
	return t
end
function MeasureOption() 
	local t = CustomMod('Measure Count','Measure',{ 'Off' , 'All' } )
	for i,v in ipairs(ModsMaster.Measure.modlist) do if i > 2 then if v == 32 or v == 192 then table.insert(t.Choices,v..'nds') else table.insert(t.Choices,v..'ths') end end end
	return t
end

function DQ() return BoolPrefRow('DQ','Disqualification') end
function Merciful() return BoolPrefRow('Merciful','MercifulBeginner',{'FailOffInBeginner','FailOffForFirstStageEasy'}) end

--------------------------
-- Mod Specific functions
--------------------------

function CalculateSpeedMod()
	modType = {'C','C'}
	modSpeed = {700,700}
	for pn=1,2 do if Player(pn) then
		for i=speedMin,speedMax,speedSpread do
			if CheckMod(pn-1,'C'..i) then modType[pn] = 'C'; modSpeed[pn] = i elseif CheckMod(pn-1,(i/100)..'x') then modType[pn] = 'x'; modSpeed[pn] = i elseif CheckMod(pn - 1, 'm' .. i) then modType[pn] = 'm'; modSpeed[pn] = i end
		end
	end end
end

function SpeedString(pn,speed) local s = speed or modSpeed[pn] or ''; if modType[pn] == 'x' then return string.format('%g',s/100) .. 'x' else return modType[pn] .. s end end
function SetSpeedMod(pn) ApplyMod('1x',pn) ApplyMod(SpeedString(pn),pn) BM('SpeedModChanged') end

function ApplyRateAdjust()
	for pn=1,2 do
		if Player(pn) and modSpeed then
			ApplyMod(SpeedString(pn,math.ceil(modSpeed[pn]/modRate)),pn)
		end
	end
end

function RevertRateAdjust() for pn=1,2 do if modSpeed then ApplyMod(SpeedString(pn),pn) end end end

function SurroundLife()
	for pn=1,2 do if ModCustom.LifeBar and ModCustom.LifeBar[pn] == 2 then
		local meter = Screen():GetChild('LifeP'..pn)
		local width = THEME:GetMetric('LifeMeterBar','MeterHeight')
		local height = THEME:GetMetric('LifeMeterBar','MeterWidth')
		meter:rotationz(-90)
		meter:rotationy(0)
		meter:GetChild(''):zoom(0)
		meter:GetChild('Frame'):zoom(0)
		meter:GetChild('Background'):zoom(0)
		meter:y(SCREEN_CENTER_Y+lifeBarSizeAdd.OffsetY) meter:zoomy((SCREEN_HEIGHT+lifeBarSizeAdd.Height)/height)
		if GAMESTATE:PlayerUsingBothSides() or ( GAMESTATE:GetNumPlayersEnabled() == 1 and GetPref('SoloSingle') ) then 
			meter:x(SCREEN_CENTER_X) 
			meter:zoomx((SCREEN_WIDTH+lifeBarSizeAdd.Width)/width)
			lifeNormal[pn]:Load(ThemeFile('doublebar.png')); lifeNormal[pn]:diffuse(0.2,0.2,0.2,1)
			lifeHot[pn]:Load(ThemeFile('doublebar.png')); lifeHot[pn]:diffuse(0.2,0.2,0.2,1)
		else
			meter:x(SCREEN_CENTER_X+((SCREEN_WIDTH*320/640)+lifeBarSizeAdd.OffsetX)*(pn-1.5)) 
			meter:zoomx((SCREEN_WIDTH+lifeBarSizeAdd.Width)/2/width)
			lifeNormal[pn]:Load(ThemeFile('white.png')); lifeNormal[pn]:diffuse(0.2,0.2,0.2,1)
			lifeHot[pn]:Load(ThemeFile('white.png')); lifeHot[pn]:diffuse(0.2,0.2,0.2,1)
			if pn == 1 then 
				lifeNormal[pn]:fadebottom(0.8) lifeHot[pn]:fadebottom(0.8)
			else 
				lifeNormal[pn]:fadetop(0.8) lifeHot[pn]:fadetop(0.8)
			end
		end
	end end
end

-- Removes Cover on ScreenEvaluation InitCommand to prevent disqualification, reapplies it immediately after.
function RevertHideBG() modCover = {} for pn=1, 2 do if Player(pn) then if CheckMod(pn-1,'cover') then modCover[pn] = true end local t = Profile(pn) if not t.Mods then t.Mods = {} end t.Mods.Cover = modCover[pn] ApplyMod('no cover',pn) end end end
function ApplyHideBG() for pn=1, 2 do if modCover[pn] then ApplyMod('cover',pn) end end end

----------------------------------------
-- Synthetic DifficultyListRow functions
----------------------------------------

-- NOTE: If using Feet Icons, they must be arranged in a column in the graphics file. The dimensions of the file must be powers of 2 ( 128x1024, for example).
-- Divide the column into 8ths vertically, place the "no chart" icon in the top 8th, the 'novice' icon in the 2nd 8th ... the edit icon in the 7th 8th, and leave the last one blank.
-- It must be done this way because "customtexturerect" removes your ability to "setstate".

listPointer = {}
listPointerY = {}

function DifficultyList()
	difficultyList = {}
	local r = maxRows or (not maxRows and 5)
	local a = math.floor(r/4) + 1
	local b = r+1-a
	local c = math.floor(r/2) + 1
	if not GAMESTATE:GetCurrentSong() then
		for pn=1,2 do
			if Player(pn) then
				if not Difficulty[pn]==5 then
					listPointerY[pn] = Difficulty[pn] + 1
				else
					listPointerY[pn] = 5
				end
			end
		end
		return
	end
	if FixedDifficultyRows() then
		for i,v in ipairs(steps) do
			q = v:GetDifficulty()+1
			if q < 6 then
				difficultyList[q] = v
			else
				for k=1,table.getn(steps) do q = 5+k if not difficultyList[q] then difficultyList[q] = v break end end
			end
		end
	else
		difficultyList = steps
		q = table.getn(steps)
	end
--  q is the index of the last entry of difficultyList. We need to save this instead of using table.getn because when you have "FixedDifficultyRow" you often have nil values in the middle of the table.
	for n=1,2 do if Player(n) then
		for i=1,q do if difficultyList[i] == GAMESTATE:GetCurrentSteps(n-1) then listPointer[n] = i end end
		if listPointer[n] <= c then listPointerY[n] = listPointer[n] elseif listPointer[n] >= (q+1)-(r-c) then listPointerY[n] = listPointer[n]-q+r else listPointerY[n] = c end
		if FixedDifficultyRows() then listPointerY[n] = listPointer[n] end
	end end
	if not twoDifficultyListRows and GAMESTATE:GetNumPlayersEnabled() == 2 and q > r then
		listPointerY[1] = math.max(math.min(math.ceil((r+listPointer[1]-listPointer[2])/2),b),a)
		listPointerY[2] = math.max(math.min(math.ceil((r+listPointer[2]-listPointer[1])/2),b),a)
		if listPointer[1] + listPointer[2] < r+2 and listPointer[1] <= b and listPointer[2] <= b then listPointerY[1] = listPointer[1]; listPointerY[2] = listPointer[2] end
		if listPointer[1] + listPointer[2] > 2*(q+1)-(r+2) and listPointer[1] >= (q+1)-b and listPointer[2] >= (q+1)-b then listPointerY[1] = listPointer[1]-q+r; listPointerY[2] = listPointer[2]-q+r end
		for i=1,2 do if listPointer[i] <= a then listPointerY[i] = listPointer[i] elseif listPointer[i] >= (q+1)-a then listPointerY[i] = listPointer[i]-q+r end end
	end
end

function DifficultyListRow(self,k,t,pn)
	local r = maxRows or (not maxRows and 5)
	local b = blankMeter or (not blankMeter and '?')
	local m = maxFeet or (not maxFeet and 20)
	local n = minFeet or (not minFeet and 0)
	local z = feetBaseZoom or (not feetBaseZoo and 1)
	local d = {}
	
	self:stopeffect()
	
	if Player(1) then d[1] = k+listPointer[1]-listPointerY[1] else d[1] = 0 end
	if Player(2) then d[2] = k+listPointer[2]-listPointerY[2] else d[2] = 0 end
	if not GAMESTATE:GetCurrentSong() then
		if t == 'difficulty' then if k - 1 < 5 then self:settext(string.upper(DifficultyToThemedString( k - 1 ))) self:diffuse(DifficultyColorRGB( k - 1 )) else self:settext('') end end
		if t == 'meter' then if k - 1 < 5 then self:settext(b) self:diffuse(DifficultyColorRGB( k - 1 )) else self:settext('') end end
		if t == 'feet' then self:zoomy(z) self:zoomx(n*z) self:customtexturerect(0,0,n,1/8) end
	elseif FixedDifficultyRows() then
		s = difficultyList[k]
		if s then
			if t == 'difficulty' then if k - 1  < 5 then self:settext(string.upper(DifficultyToThemedString( k - 1 ))) else self:settext(s:GetDescription()) end self:diffuse(DifficultyColorRGB( k - 1 )) end
			if t == 'meter' then self:settext(s:GetMeter()) self:diffuse(DifficultyColorRGB( k - 1 )) end
			if t == 'feet' then self:zoomy(z) self:zoomx(math.min(s:GetMeter(),m)*z) self:customtexturerect(0,k/8,math.min(s:GetMeter(),m),(k+1)/8) end
			if Song.GetUnlockMethod then
				if t and GAMESTATE:GetCurrentSong():GetUnlockMethod(s:GetDifficulty()) ~= '' then
					self:glowshift() self:effectcolor1(1,.8,0,1) self:effectcolor2(1,.8,0,0) self:effectclock('bgm') self:effectperiod(1)
					--Trace('fixed '..t)
				else
					self:stopeffect()
				end
			end
		else
			if t == 'difficulty' then if k - 1 < 5 then self:settext(string.upper(DifficultyToThemedString( k - 1 ))) else self:settext('') end self:diffuse(DifficultyColorRGB()) end
			if t == 'meter' then self:settext('') self:diffuse(DifficultyColorRGB( k - 1 )) end
			if t == 'feet' then self:zoomy(z) self:zoomx(n*z) self:customtexturerect(0,0,n,1/8) end
			self:stopeffect()
		end
	else
		if pn then s = d[pn]
		elseif not Player(2) then s = d[1]
		elseif not Player(1) then s = d[2]
		elseif k <= math.floor(r/2) then
			if listPointer[1] <= listPointer[2] then s = d[1] else s = d[2] end
		else
			if listPointer[1] >= listPointer[2] then s = d[1] else s = d[2] end
		end
		s = difficultyList[s]
		if s then
			if t == 'difficulty' then if s:GetDifficulty() < 5 then self:settext(string.upper(DifficultyToThemedString(s:GetDifficulty()))) else self:settext(s:GetDescription()) end self:diffuse(DifficultyColorRGB( s:GetDifficulty() )) end
			if t == 'meter' then self:settext(s:GetMeter()) self:diffuse(DifficultyColorRGB( s:GetDifficulty() )) end
			if t == 'feet' then self:zoomy(z) self:zoomx(math.min(s:GetMeter(),m)*z) self:customtexturerect(0,(s:GetDifficulty()+1)/8,math.min(s:GetMeter(),m),(s:GetDifficulty()+2)/8) end
			if Song.GetUnlockMethod then
				if t and GAMESTATE:GetCurrentSong():GetUnlockMethod(s:GetDifficulty()) ~= '' then
					self:glowshift() self:effectcolor1(1,.8,0,1) self:effectcolor2(1,.8,0,0) self:effectclock('bgm') self:effectperiod(1)
					--Trace('nofixed '..t)
				else
					self:stopeffect()
				end
			end
		else
			if t == 'difficulty' then self:settext('') end
			if t == 'meter' then self:settext('') end
			if t == 'feet' then self:zoom(0) end
			self:stopeffect()
		end
	end
end

function FixedDifficultyRows()
	l = table.getn(steps)
	if l > 5 then return false end
	for i,v in ipairs(steps) do
		if v:GetDifficulty() > 4 then return false end
	end
	for i=1,l-1 do
		for j=i+1,l do
			if steps[i]:GetDifficulty() == steps[j]:GetDifficulty() then return false end
		end
	end
	return true
end

--------------------------------
-- Option Row Display Functions
--------------------------------

function FrameOn(self,ThemedTitles)
	THEMED_TITLES = ThemedTitles
	frameIgnore = {}
	optionRow = {}
	optionRowText = {}
	optionRowTextCache = {}
	optionUnderlineSprite = {}
	optionCursor = {}
	optionCursorSprite = {}
	optionHighlight = {}
	captureIndex = 0
	self:propagate(1)
	for i=1,3 do self:queuecommand('Capture') end
end

function FrameCapture(self) -- I had a simpler version which checked parent, but on ITG machines parent is not an argument of propagated commands.
	if Screen():GetChild('Frame'):GetChild('Page') == self then captureIndex = captureIndex + 1 return end
	for j,v in ipairs({'More','DisqualifiedP1','DisqualifiedP2'}) do if Screen():GetChild('Frame'):GetChild(v) == self then return end end
	for j,v in ipairs(frameIgnore) do if v == self then return true end end

	if captureIndex == 1 then -- option rows, cursors, and line highlights
 
		if IsType(self,'ActorFrame') then
			if IsType(self:GetChild(''),'ActorFrame') then table.insert(optionRow,self:GetChild('')) self:propagate(1) self:GetChild(''):propagate(1) end
			if IsType(self:GetChild(''),'Sprite') then table.insert(optionCursor,self) table.insert(optionCursorSprite,{}) self:propagate(1) end
		elseif IsType(self,'Sprite') then
			table.insert(optionHighlight,self)
		end
	 
	elseif captureIndex == 2 then -- cursor sprites, title and item text, and underlines
 
		if IsType(self,'Sprite') then
			for j,v in ipairs(optionCursorSprite) do if not v[3] then table.insert(v,self) table.insert(frameIgnore,self) return end end
			table.insert(optionRowText,{}) -- This will be the Bullets, one per option row, and they come before the text.
		elseif IsType(self,'BitmapText') then -- First index is the row Title, the rest of the items.
			table.insert(optionRowText[table.getn(optionRowText)],self)
			if table.getn(optionRowText[table.getn(optionRowText)]) == 1 then optionRowTextCache[self:GetText()] = table.getn(optionRowText) end
		elseif IsType(self,'ActorFrame') and self:GetNumChildren() == 3 then
			table.insert(optionUnderlineSprite,{Row = table.getn(optionRowText)}) self:propagate(1)
		end
	 
	elseif captureIndex == 3 then  -- underline sprites
		Screen():GetChild('Frame'):propagate(0)
		for j,v in ipairs(optionUnderlineSprite) do if not v[3] then table.insert(v,self) if v[3] then InitializeOptionRow(j) end return end end
	end

	table.insert(frameIgnore,self)
end

function InitializeOptionRow(i) -- If (this is a slider option) and (we have all of its underlines) then run the Set underlines, text, and cursors.
	local k = optionUnderlineSprite[i].Row
	local t = optionRowText[k] -- t[2] is the first item text. If this is a slider option then the string will be ' '.
	local p = i+1-GAMESTATE:GetNumPlayersEnabled() -- previous index for 2 players
	if t[2]:GetText() == ' ' and (p > 0 and k == optionUnderlineSprite[p].Row) then SetOptionRow(k) end
end

function SetOptionRow(row,c) -- If c is true this will not adjust cursor size. Used for when changing speed mod type, which alters the text of a non-selected row.

	if not optionRowText[1] then return end -- "SaveSelections" is played when loading option rows, before tables are set. This prevents crash.

	local r = row;
	local name = row;
   
	if type(row) == 'string' then
		r = optionRowTextCache[row]
		if THEMED_TITLES then r = optionRowTextCache[THEME:GetMetric("OptionTitles",name)] end	
	else
		name = optionRowText[r][1]:GetText()
	end

	local function Size(u,t)
		local z = t:GetWidth()*t:GetZoom()
		u[1]:zoomtowidth(z)
		u[2]:x(-(z + u[1]:GetWidth())/2)
		u[3]:x((z + u[1]:GetWidth())/2)
	end

	local display = SliderDisplayFunction[name]

	for pn=1,2 do if Player(pn) then local p = PlayerIndex(pn) -- Must always check all players. When an option changes the entire row has its text set, not just the changing player.
		if not optionRowText[r][p+1] then optionRowText[r][p+1] = optionRowText[r][p] end -- false when "One Choice for all players"
		display( optionRowText[r][p+1] , pn )
		if not c and optionCursor[p]:GetY() > (optionRow[r-1]:GetY() or 0) and optionCursor[p]:GetY() < (optionRow[r+1]:GetY() or 0) then Size(optionCursorSprite[p],optionRowText[r][p+1]) end
		for i,u in ipairs(optionUnderlineSprite) do if u.Row == r then Size(optionUnderlineSprite[i-1+p],optionRowText[r][p+1]) break end end
	end end
end

function CancelAll(self)
	local pn = self:getaux()
	CalculateSpeedMod()
	for s,v in pairs(ModCustom) do v[pn] = 1 end
	for s,v in pairs(ModsPlayer) do if tonumber(v[pn]) then v[pn] = 0 else v[pn] = nil end end
	for i,v in ipairs(playerOptions[optionIndex]) do InitializeOptionRow(i) end
	self:queuecommand('Go')
end

--------------------------------
-- Timed Set Functions
--------------------------------

function MenuTimerSeconds( s ) TimedSet.MenuTimer = s; if IsTimedSet() or not GetPref('MenuTimer') then return -1 else return s end end
function IsTimedSet() return not GAMESTATE:IsCourseMode() and Profile(0).TimedSets end

TimedSet = { }
TimedSet.Divider = ' / '
TimedSet.Reset = function() 
	TimedSet.Start = Clock(); 
	if ( Profile(0).SessionTimer or 0 ) > 0 then
		TimedSet.End = TimedSet.Start + Profile(0).SessionTimer
		TimedSet.CutOff = TimedSet.End + Profile(0).CutOffTime
	else
		TimedSet.End = nil
	end;
end

TimedSet.Display = function(self,t,f)
	local time = t or Clock()
	
	local stop = ( f or TimedSet.End )
	if stop then 
		local length = ( f or ( TimedSet.End - TimedSet.Start ) )
		time = stop - time
		time = SecondsToMSS(time) .. TimedSet.Divider .. SecondsToMSS( length )
	else
		time = SecondsToMSS( time - TimedSet.Start )
	end
	
	self:settext(time)
	
end

TimedSet.Timer = function(self)

	TimedSet.Display(self)

	if not GetPref('EventMode') then

		local time = -Clock( TimedSet.End )

		-- Class 0 == menu, end game when timer ends
		if TimedSet.Class == 0 and time < 0 then
			SCREENMAN:SetNewScreen(ScreenList('NameEntry'))
		end

		-- Class 1 == gameplay, end game when CutOff time ends
		if TimedSet.Class == 1 then
			TimedSet.GameplayTime = Clock()
			if time <= 0 then 
				ApplyMod('FailImmediate',1)
				self:diffuse(1,0,0,1)
				TimedSet.Display(self,-time,Profile(0).CutOffTime)
				if Clock( TimedSet.CutOff ) > 0 then
					SCREENMAN:SetNewScreen(ScreenList('Evaluation'))
				end
			end
		end

		-- Class 2 == evaluation, allow at least TimedSet.MenuTimer seconds.
		if TimedSet.Class == 2 and time < 0 then
			local t = Clock( TimedSet.GameplayTime )
			TimedSet.Display(self,t,TimedSet.MenuTimer)
			if t > TimedSet.MenuTimer then
				SCREENMAN:SetNewScreen(ScreenList('NameEntry'))
			end
		end

	end
	
	self:sleep(1)
	self:queuecommand('Timer')
	
end

function SaveProfile(self)
	if not CheckProfile then return end
	
	local bSave = false
	for i,v in pairs( CheckProfile ) do
		if type(v) == "table" then
			for j,z in pairs( v ) do
				if Profile(0)[i][j] ~= z then bSave = true end
			end
		else
			if Profile(0)[i] ~= v then bSave = true end
		end
	end
	
	if bSave then
		BM('SaveProfile')
		self:queuecommand("SaveProfile")
	end
end