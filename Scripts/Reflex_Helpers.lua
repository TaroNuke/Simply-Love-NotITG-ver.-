hardware_LightsMode = 0

hardware_songselected = 2
hardware_songlist = {
	'(1) - Tutorial',
	'(1) - Tropical Club',
	'(1) - Love Or Lies',
	'(2) - Voxane',
	'(2) - Intro Outro',
	'(X) - Firestorm',
	'(X) - Pon-Pon-Pompoko Dai-Sen-Saw!',
	'(2) - Mind Mapping',
	'(0) - nil',
	'(0) - nil',
	'(0) - nil',
	'(0) - nil',
	'(1) - Princess Mimis Game Corner 2',
	'(?) - Princess Mimis Furious Fuck You TE',
	'(?) - Final Round',
	'(?) - Extra',
}

function StrSplit(str, delim, maxNb)
	-- Eliminate bad cases...
	if string.find(str, delim) == nil then
		return { str }
	end
	if maxNb == nil or maxNb < 1 then
		maxNb = 0    -- No limit
	end
	local result = {}
	local pat = '(.-)' .. delim .. '()'
	local nb = 0
	local lastPos
	for part, pos in string.gfind(str, pat) do
		nb = nb + 1
		result[nb] = part
		lastPos = pos
		if nb == maxNb then break end
	end
	-- Handle the last field
	if nb ~= maxNb then
		result[nb + 1] = string.sub(str, lastPos)
	end
	return result
end

hardware_min = {740,740,740,740,740,680,810,830}
hardware_max = 3520

hardware_playerweight = {none = 2500}
hardware_playerlist = {'none'}

function hardware_addplayer(name,weight)
	if name == 'none' then return end
	hardware_playerweight[name] = weight
	Trace(">Add player '"..name.."', weight "..weight)
	local found = false
	for i=1,table.getn(hardware_playerlist) do
		if hardware_playerlist[i] == name then
			found = true
			break
		end
	end
	if not found then
		table.insert(hardware_playerlist,name)
	end
end

function hardware_saveEntrants()
	local ret = ''
	for i=2,table.getn(hardware_playerlist) do
		ret = ret..hardware_playerlist[i]..','..hardware_playerweight[ hardware_playerlist[i] ]..'\n'
	end
	
	io.output(io.open('Themes/UKSRT/hardware_entrants.txt','w'))
	io.write(ret);
	io.close()
end

function hardware_loadEntrants()

	--collect entrants
	local f=io.open("Themes/UKSRT/hardware_entrants.txt","r")
	
	Trace('Load Entrants from file');
	
	for line in f:lines() do
		local t = StrSplit(tostring(line),",")
		if t and table.getn(t) > 0 and t[1] then
			hardware_addplayer(t[1],tonumber(t[2]))
		end
	end
	
	io.close(f)
end

hardware_loadEntrants()

hardware_players = {'none','none'};

function clamp(val, min, max)
	local ret = val
	if ret < min then ret = min end
	if ret > max then ret = max end
	return ret
end

function hardware_ResetWindows()
	hardware_step_deadzone = .01
	hardware_step_threshold = .03
	hardware_step_window = {.025,.05,.1,.15,mine=0.05}
	hardware_step_window_add = 0.004
	hardware_step_window_scale = 1
	hardware_step_weight = {100,80,50,20,0,mine=-500}
end

hardware_ResetWindows()

function hardware_GetWindow(n)
	return ((hardware_step_window[n]*hardware_step_window_scale)+hardware_step_window_add)*hbtengine_bps
end

function hardware_readPressureNormalizedPersonal(min,max)
	local pressure = {}
	
	--Trace("READ PRESSURE NORMAL CHECKPOINT 0");
	
	if not min then min = 0 end
	if not max then max = 1 end
	
	local sens = {4200/5700,5000/5700,5000/5700,5300/5700}
	
	for i=1,4 do
		
		local total = 0
		
		pressure[i] = clamp((REFLEX:GetPanelValueAboveBaseline(i-1)/sens[i])/5700,0,1)
		
	end
	
	--Trace("READ PRESSURE NORMAL CHECKPOINT 1");
	
	for i=5,16 do
		pressure[i] = 0;
	end
	
	for i=1,16 do
		if pressure[i]<hardware_step_deadzone then
			pressure[i] = 0;
		end	
	end
	
	--Trace("READ PRESSURE NORMAL CHECKPOINT 2");
	
	return pressure
end

function hardware_readPressureNormalizedMax(min,max)
	local pressure = {}
	
	for i=1,16 do
		pressure[i] = 0;
	end
	
	return pressure
end

function hardware_readPressureRaw()
	local pressure = {}
	
	for i=1,16 do
		pressure[i] = 0;
	end
	
	return pressure
end

function reflex_clearLights(pn,panel)
	
	REFLEX:SetLightWholePanel(pn,panel,0,0,0)
	
end

function WriteLight(pn,panel,object)
	
	local tab = {}
	if type(object) ~= 'table' then
		tab = {object:GetX(),object:GetY(),object:GetZ()}
	else
		tab = object
	end
	
	if not tab or type(tab) ~= 'table' or table.getn(tab) < 3 then
		SCREENMAN:SystemMessage('Bad input object...');
		return;
	end
	
	REFLEX:SetLightArrow(pn,panel,
		clamp(math.floor(math.pow(tab[1],2)*255),0,255),
		clamp(math.floor(math.pow(tab[2],2)*255*0.7),0,255),
		clamp(math.floor(math.pow(tab[3],2)*255*0.85),0,255)
	)
	
end

function WriteLED(pn,panel,led,object)
	
	local tab = {}
	if type(object) ~= 'table' then
		tab = {object:GetX(),object:GetY(),object:GetZ()}
	else
		tab = object
	end
	
	if not tab or type(tab) ~= 'table' or table.getn(tab) < 3 then
		SCREENMAN:SystemMessage('Bad input object...');
		return;
	end
	
	--'tab' is a table of r, g, b
	REFLEX:SetLightData(pn,panel,led,
		clamp(math.floor(math.pow(tab[1],2)*255),0,255),
		clamp(math.floor(math.pow(tab[2],2)*255*0.7),0,255),
		clamp(math.floor(math.pow(tab[3],2)*255*0.85),0,255)
	)
	
end