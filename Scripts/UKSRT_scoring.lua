smooooch_p1bonus = 0;
smooooch_p2bonus = 0;
pid_p1bonus = 0;
pid_p2bonus = 0;
zeru_p1bonus = 0;
zeru_p2bonus = 0;
wtf_p1bonus = 0;
wtf_p2bonus = 0;
octo_p1bonus = 0;
octo_p2bonus = 0;
uksrt5_p1bonus = 0;
uksrt5_p2bonus = 0;
uksrt65_p1bonus = 0;
uksrt65_p2bonus = 0;

uksrt_p1bonus = 0;
uksrt_p2bonus = 0;
uksrt_p1moneyscore = 0;
uksrt_p2moneyscore = 0;

for i=1,6 do
	_G['srt_p1w'..i] = 0;
	_G['srt_p2w'..i] = 0;
end

function round2(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function GetScoreOfPlayer(pn)
	if GAMESTATE:IsHumanPlayer(pn) then
		return "("..GetDiff(pn)..") "..round2(100*math.max(STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetPercentDancePoints(),0),2).."%"
	else
		return "--.--%"
	end
end

function GetScoreOfPlayerNoP(pn)
	if GAMESTATE:IsHumanPlayer(pn) then
		return round2(100*math.max(STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetPercentDancePoints(),0),2)
	else
		return "--.--"
	end
end

-- vyhd wrote this, lightning broke it and made it less optimized

local function GetTapScore(pn, category)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
	return pss:GetTapNoteScores(category)
end

local function GetHoldScore(pn, category)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
	return pss:GetHoldNoteScores(category)
end

local function GetTapScoreCouples(pn, category)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
	return pss:GetTapNoteScoresForPlayer(pn+1,category)
end

local function GetHoldScoreCouples(pn, category)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())
	return pss:GetHoldNoteScoresForPlayer(pn+1,category)
end

local function SetValueForChild( self, name, value )
	local child = self:GetChild(name)
	if not child then return end

	child:settext( tostring(value) )
end

-- This maps from a TapNoteScore to a child in the ActorFrame.
local TapNoteMap =
{
	[TNS_MARVELOUS]	= "Fantastic",
	[TNS_PERFECT]	= "Excellent",
	[TNS_GREAT]	= "Great",
	[TNS_GOOD]		= "Decent",
	[TNS_BOO]		= "Way Off",
	[TNS_MISS]		= "Miss",
	[TNS_HITMINE]	= "Mine",
	LowRated		= "LowRated",
	HitNotes		= "HitNotes",
};

local HoldNoteMap =
{
	[HNS_OK]	= "HoldOK",
	[HNS_NG]	= "HoldMiss"
};

-- 103 is a sentinel for beta 2. There should be a better way to do this...
-- local function IsSupported() return OPENITG and OPENITG_VERSION >= 103 end
-- Forcing the function to return 1. This is causing MANY builds to crash when Player 1 tries to use In-Game Stats alone. Removing until new builds are distributed to the public, or a better of way of checking builds is found.
local function IsSupported() return 1 end

function SetJudgmentFrameForPlayer( self, pn )
	if not IsSupported() then return nil end

	for tns,name in pairs(TapNoteMap) do
		
		if tns == "LowRated" then SetValueForChild( self, name, GetTapScore(pn, TNS_GREAT) + GetTapScore(pn, TNS_GOOD) + GetTapScore(pn, TNS_BOO) ) 
		elseif tns == "HitNotes" then SetValueForChild( self, name, GetTapScore(pn, TNS_MARVELOUS) + GetTapScore(pn, TNS_PERFECT) + GetTapScore(pn, TNS_GREAT) + GetTapScore(pn, TNS_GOOD)) 
		else SetValueForChild( self, name, GetTapScore(pn, tns) ) end
	end

	for hns,name in pairs(HoldNoteMap) do
		SetValueForChild( self, name, GetHoldScore(pn, hns) )
	end
end

function GetNotesHit( self, pn )
	return GetTapScore(pn, TNS_MARVELOUS) + GetTapScore(pn, TNS_PERFECT) + GetTapScore(pn, TNS_GREAT)
end	

function GetNotesFantasticHit( self, pn )
	return GetTapScore(pn, TNS_MARVELOUS)
end	

function GetNotesExcellentHit( self, pn )
	return GetTapScore(pn, TNS_PERFECT)
end

function GetNotesGreatHit( self, pn )
	return GetTapScore(pn, TNS_GREAT)
end	

function GetNotesDecentHit( self, pn )
	return GetTapScore(pn, TNS_GOOD)
end	

function GetNotesWayOffHit( self, pn )
	return GetTapScore(pn, TNS_BOO)
end	

function GetNotesMissed( self, pn )
	return GetTapScore(pn, TNS_MISS)
end	

function GetMinesHit( self, pn )
	return GetTapScore(pn, TNS_HITMINE)
end	

function GetNotesFantasticHitCouples( self, pn )
	return GetTapScoreCouples(pn, TNS_MARVELOUS)
end	

function GetNotesExcellentHitCouples( self, pn )
	return GetTapScoreCouples(pn, TNS_PERFECT)
end

function GetNotesGreatHitCouples( self, pn )
	return GetTapScoreCouples(pn, TNS_GREAT)
end	

function GetNotesDecentHitCouples( self, pn )
	return GetTapScoreCouples(pn, TNS_GOOD)
end	

function GetNotesWayOffHitCouples( self, pn )
	return GetTapScoreCouples(pn, TNS_BOO)
end	

function GetNotesMissedCouples( self, pn )
	return GetTapScoreCouples(pn, TNS_MISS)
end	

function GetMinesHitCouples( self, pn )
	return GetTapScoreCouples(pn, TNS_HITMINE)
end	

function GetNotesExcellentComboHit( self, pn )
	if GetTapScore(pn, TNS_PERFECT) >=1 then 
		return GetTapScore(pn, TNS_PERFECT) + GetTapScore(pn, TNS_MARVELOUS) end
	return 0
end	

function GetNotesGreatComboHit( self, pn )
	if GetTapScore(pn, TNS_GREAT) >=1 then 
		return GetTapScore(pn, TNS_PERFECT) + GetTapScore(pn, TNS_MARVELOUS) + GetTapScore(pn, TNS_GREAT) end
	return 0
end	

function GetNotesOtherHit( self, pn )
	return GetTapScore(pn, TNS_GREAT) + GetTapScore(pn, TNS_GOOD) + GetTapScore(pn, TNS_BOO)
end

function GetPlayerPercentage( pn )


if GAMESTATE:IsPlayerEnabled(pn) then

	local NotesHitScore = 0;
	local NotesPossibleScore = 0;
	local PlayerPercentage = 0;
	local Selection = GAMESTATE:GetCurrentSteps(pn);
	local TotalSteps = tonumber( Radar( Selection:GetRadarValues(),6 ) );
	local TotalHolds = tonumber( Radar( Selection:GetRadarValues(),2) );
	local TotalRolls = tonumber( Radar( Selection:GetRadarValues(),5 ) );
	
	NotesPossibleScore = (TotalSteps * 5 ) + ((TotalHolds + TotalRolls) * 5 );
	NotesHitScore = 	(GetTapScore(pn, TNS_MARVELOUS) * 5 ) + 
				(GetTapScore(pn, TNS_PERFECT) * 4 ) +
				(GetTapScore(pn, TNS_GREAT) * 2 ) +
				(GetTapScore(pn, TNS_BOO) * -6 ) +
				(GetTapScore(pn, TNS_MISS) * -12 ) +
				(GetHoldScore(pn, HNS_OK) * 5 ) +
				(GetTapScore(pn, TNS_HITMINE) * -6 )
				

				
	PlayerPercentage = NotesHitScore/NotesPossibleScore *100

	--return "Song Completion Percentage: " .. string.sub(string.format("%.5f", PlayerPercentage),1,5) .. "%"
	return PlayerPercentage end	
end

function CompareScoresRange( difference, range )
	local Player1Score=GetPlayerPercentage( PLAYER_1 )
	local Player2Score=GetPlayerPercentage( PLAYER_2 )
	local ScoreDifference = GetPlayerPercentage( PLAYER_1 ) - GetPlayerPercentage( PLAYER_2 )
	local ReturnValue = scale(ScoreDifference, -difference, difference, range, -range)

if ReturnValue <= -range then return -range
elseif ReturnValue >= range then return range
else return ReturnValue end

end


function PlayerFullComboed(pn)

	if GAMESTATE:IsPlayerEnabled(pn) then
		local Selection = GAMESTATE:GetCurrentSteps(pn);
		local TotalSteps = tonumber( Radar( Selection:GetRadarValues(),6 ) );
		local TotalHolds = tonumber( Radar( Selection:GetRadarValues(),2) );
		local TotalRolls = tonumber( Radar( Selection:GetRadarValues(),5 ) );
		
		if GetNotesHit( self, pn ) == TotalSteps and GetHoldScore(pn, HNS_OK) == (TotalHolds + TotalRolls) then
			return true end
	end	
return false

end


function AnyPlayerFullComboed(self)

	if PlayerFullComboed(PLAYER_1) or PlayerFullComboed(PLAYER_2) then 
	return true end

end

function GetHoldsHeldTotal(pn)
return GetHoldScore(pn, HNS_OK) end


function PlayComboSound()
local Path = THEME:GetPath( EC_SOUNDS, '', "FullComboSplash" )
	SOUND:PlayOnce( Path )
end

function GetLastScoresP1(num)
	if LastScoresP1[num] == "-" or num > table.getn(LastScoresP1) or LastScoresP1[num] == nil then
		return "--.--%"
	else
		return LastScoresP1[num]
	end
end

function GetLastScoresP2(num)
	if LastScoresP2[num] == "-" or num > table.getn(LastScoresP2) or LastScoresP2[num] == nil then
		return "--.--%"
	else
		return LastScoresP2[num]
	end
end

function GetLastSongs(num)
	
	if LastSongs == nil then
		LastScoresP1 = {}
		LastScoresP2 = {}
		LastSongs = {}
	end
	
	if LastSongs[num] == "-" or num > table.getn(LastSongs) or LastSongs[num] == nil then
		return "----------/----------"
	else
		return LastSongs[num]
	end
end

function GetStage1Tip()
	GetBests()
	if bestScore > .8 then return 3 end
	if bestScore > .65 then return 2 end
	return 1
end

function GetSRT1Stage1Quote(n)
	if n == 1 then return '"FUCK"' end
	if n == 2 then return '"I`ll be back!"' end
	return '"Orya~!"'
end

function GetSRT2SneakySpiritsTip()
	GetBests()
	if bestScore > .8 then return 3 end
	if bestScore > .65 then return 2 end
	return 1
end

function GetSRT2SneakySpiritsQuote(n)
	if n == 1 then return '"We`re freee~"' end
	if n == 2 then return '"That was a good meal."' end
	return '"No ghost escapes on your watch!"'
end

function GetSRT2FillbotsTip()
	--GetBests()
	if FILLED_P1 > 40 or FILLED_P2 > 40 then return 3 end
	if FILLED_P1 > 25 or FILLED_P2 > 25 then return 2 end
	return 1
end

function GetSRT2FillbotsQuote(n)
	if n == 1 then return '"What the hell is this!?"' end
	if n == 2 then return '"::I dont care how well you hit arrows!::This is about the robots!"' end
	return '"N...not good at all!"'
end

function GetSRT2KarateMan2Tip()
	GetBests()
	return bestScoreP;
end