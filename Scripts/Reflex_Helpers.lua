local function clamp(val, min, max)
	local ret = val
	if ret < min then ret = min end
	if ret > max then ret = max end
	return ret
end

function hardware_readPressureNormalizedPersonal(min,max)
	local pressure = {}
	
	if not min then min = 0 end
	if not max then max = 1 end
	
	local sens = {4200/5700,5000/5700,5000/5700,5300/5700} --FIXING VALUES FROM THE BETA (WIP)
	
	for i=1,4 do
		
		local total = 0
		
		pressure[i] = clamp((REFLEX:GetPanelValueAboveBaseline(i-1)/sens[i])/5700,0,1)
		
	end
	
	for i=5,16 do
		pressure[i] = 0;
	end
	
	for i=1,16 do
		if pressure[i]<hardware_step_deadzone then
			pressure[i] = 0;
		end	
	end
	
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

function WriteLight(pn,panel,object, mul)

	if not mul then mul = 1 end
	
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
		clamp(math.floor(math.pow(tab[1],2)*255*mul),0,255),
		clamp(math.floor(math.pow(tab[2],2)*255*0.7*mul),0,255),
		clamp(math.floor(math.pow(tab[3],2)*255*0.85*mul),0,255)
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