
feetBaseZoom = .275
JudgeY = 20

lifeBarSizeAdd.Height = lifeBarSizeAdd.Height - 80
lifeBarSizeAdd.OffsetY = lifeBarSizeAdd.OffsetY + 40

judgmentFontList = { 'Love' , 'Tactics', 'Chromatic', 'Deco', 'GrooveNights', 'FP', 'ITG2' }
voiceOption = true

rateModsPay = { "1.0x", "1.1x", "1.2x", "1.3x", "1.4x", "1.5x", "1.6x", "1.7x", "1.8x", "1.9x", "2.0x" }
rateModsFree = { "1.0x", "1.1x", "1.2x", "1.3x", "1.4x", "1.5x", "1.6x", "1.7x", "1.8x", "1.9x", "2.0x", "0.5x", "0.6x", "0.7x" , "0.8x", "0.9x" }

screenList = { Gameplay = 'ScreenStage' , SelectMusic = 'ScreenSelectMusic' , PlayerOptions = 'ScreenPlayerOptions' , TitleMenu = ScreenTitleBranch  , NameEntry = 'ScreenNameEntryTraditional' , Evaluation = SelectEvaluationScreen , Summary = 'Summary' , Ending = SelectEndingScreen }

playerOptions[1] = { 'SpeedType','SpeedNumber','Mini','Perspective','NoteSkin','Turn','JudgmentFont','Voice','Rate' }
playerOptions[2] = { 'Accel','Scroll','Effect','Appearance','Handicap','InsertTaps','InsertOther','Hide','Ghost','Compare','Measure','LifeBar' }

function CompareTextFormat(self,n) self:zoom(.3) end -- This is added on top of the base positioning etc.

ShowAllInRow = true

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

-- not even used, but whatever.
function wrap(val,max,min)
	if not min then min = 0 end
	return math.mod(val+(max-min+1)-min,max-min+1)+min
end

