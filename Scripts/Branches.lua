function GetArcadeStartScreen()
	-- If we havn't loaded the input driver, do that first; until this finishes, we have
	-- no input or lights.
	if GetInputType() == "" then return "ScreenArcadeStart" end

	if not PROFILEMAN:GetMachineProfile():GetSaved().TimeIsSet then
		return "ScreenSetTime"
	end

	return "ScreenLove"
end

function ScreenTitleBranch()
	if GAMESTATE:GetCoinMode() == COIN_MODE_HOME then return "ScreenTitleMenu" end
	return "ScreenTitleJoin"
end

function SelectColorNextScreen()
	if GAMESTATE:GetCoinMode() == COIN_MODE_HOME then return "ScreenSelectPlayModeNITG" end
	return "ScreenSelectPlayMode"
end

function EvaluationNextScreen()

	if GAMESTATE:IsCourseMode() then
		GAMESTATE:ApplyGameCommand('mod,metal');
	end

	if GetPref('EventMode') then return SongSelectionScreen() end
	if IsTimedSet() then
		if Clock( TimedSet.End ) < 0 then 
			return SongSelectionScreen()
		else
			return "ScreenNameEntryTraditional" 
		end
	end
	if AllFailed() or IsFinalStage() then return "ScreenNameEntryTraditional" end
	return SongSelectionScreen();
end

function GetGameplayNextScreen()
	if GAMESTATE:IsSyncDataChanged() then 
		return "ScreenSaveSync"
	end
		
	-- Never show evaluation for training.
	if GAMESTATE:GetCurrentSong():GetSongDir() == "Songs/In The Groove/Training1/" then 
		if GAMESTATE:IsEventMode() then 
			return SongSelectionScreen()
		else
			return EvaluationNextScreen()
		end
	else
		return SelectEvaluationScreen() 
	end
	
	return "GetGameplayNextScreen: YOU SHOULD NEVER GET HERE"
end

function SelectEvaluationScreen()
	Mode = PlayModeName()
	screen = "ScreenEvaluationStage"
	if( Mode == "Nonstop" ) then screen = "ScreenEvaluationNonstop" end
	if( Mode == "Oni" ) then screen = "ScreenEvaluationOni" end
	return screen .. Color()
end

function SelectEndingScreen()
	if GAMESTATE:GetEnv("ForceGoodEnding") == "1" or GetBestFinalGrade() <= GRADE_TIER05 then return "ScreenEndingGood" end
	return "ScreenEndingNormal"
end


function GetGameplayScreen()
	local Song = GAMESTATE:GetCurrentSong();
	if Song and Song:GetSongDir() == "Songs/In The Groove/Training1/" then
		return "ScreenGameplayTraining"
	end

	return "ScreenGameplay"
end

function SongSelectionScreen()
	local s = "ScreenSelectMusic";
	if GAMESTATE:IsCourseMode() then s = s.."Course" end
	return s
end

function ScreenSelectMusicPrevScreen() return ScreenTitleBranch() end

function OptionsMenuAvailable()
	if GAMESTATE:IsExtraStage() or GAMESTATE:IsExtraStage2() then return false end
	if GAMESTATE:GetPlayMode()==PLAY_MODE_ONI then return false end
	return true
end

function GetSetTimeNextScreen()
	-- This is called only when we move to the next screen, so we only mark the time set
	-- when the screen is cleared.  That way, if the game is started by the operator and
	-- powered down before setting the screen, we still go to ScreenSetTime on the next boot.
	PROFILEMAN:GetMachineProfile():GetSaved().TimeIsSet = true
	PROFILEMAN:SaveMachineProfile()

	return "ScreenOptionsMenu"
end

function GetDiagnosticsScreen()
	return "ScreenOptionsMenu"
end

function GetUpdateScreen()
	return "ScreenOptionsMenu"
end
