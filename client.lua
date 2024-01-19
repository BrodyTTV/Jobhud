--------------------
--- Badssentials ---
--------------------
function DrawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(6)
    SetTextProportional(0)
	SetTextCentre(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

tickDegree = 0;
local nearest = nil;
local postals = Postals;
function round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end
currentTime = "0:00";
RegisterNetEvent('Badssentials:SetTime')
AddEventHandler('Badssentials:SetTime', function(time)
	currentTime = time;
end)
currentDay = 1;
RegisterNetEvent('Badssentials:SetDay')
AddEventHandler('Badssentials:SetDay', function(day)
	currentDay = day;
end)
currentMonth = 1;
RegisterNetEvent('Badssentials:SetMonth')
AddEventHandler('Badssentials:SetMonth', function(month)
	currentMonth = month;
end)
currentYear = "2023";
RegisterNetEvent('Badssentials:SetYear')
AddEventHandler('Badssentials:SetYear', function(year)
	currentYear = year;
end)

playerHeadTag = "None Set";
GangHeadTag = "None Set";
function setPlayerHeadTagGui(value)
 	playerHeadTag = value
 	return
end
exports('setPlayerHeadTagGui', function(pHT)
	local pTag = tostring(pHT) or "~r~None set";
	if pTag == " " then
		pTag = "~r~None"
	end
	playerHeadTag = pTag
end)

exports('setGangHeadTagGui', function(pHT)
	local gTag = tostring(pHT) or "~r~None set";
	if gTag == " " then
		gTag = "~r~None"
	end
	GangHeadTag = gTag
end)

displaysHidden = false;

zone = nil;
streetName = nil;
postal = nil;
postalDist = nil;
degree = nil;
Citizen.CreateThread(function()
	while true do 
		Wait(150);
		local pos = GetEntityCoords(PlayerPedId())
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z));
		degree = degreesToIntercardinalDirection(GetCardinalDirection());
		streetName = GetStreetNameFromHashKey(var1);
	end 
end)

function getNearestPostal ()
	return postal
end

Citizen.CreateThread(function()
	Wait(800);
	while true do 
		Wait(0);
		
		for _, v in pairs(Config.Displays) do 
			local enabled = v.enabled;
			if enabled and not displaysHidden then 
				local disp = v.display;
				local scale = v.textScale;
				local x = v.x;
				local y = v.y;

				if (disp:find("{STREET_NAME}")) then 
					disp = disp:gsub("{STREET_NAME}", streetName);
				end 
				if (disp:find("{CITY}")) then 
					disp = disp:gsub("{CITY}", zone);
				end
				if (disp:find("{COMPASS}")) then 
					disp = disp:gsub("{COMPASS}", degree);
				end
				if (disp:find("{PLAYERID}")) then
					disp = disp:gsub("{PLAYERID}", GetPlayerServerId(PlayerId()))
				end
				if (disp:find("{PLAYERNAME}")) then
					disp = disp:gsub("{PLAYERNAME}", GetPlayerName(PlayerId()))
				end
				if (disp:find("{EST_TIME}")) then
					disp = disp:gsub("{EST_TIME}", currentTime)
				end
				if (disp:find("{US_DAY}")) then
					disp = disp:gsub("{US_DAY}", currentDay)
				end
				if (disp:find("{US_MONTH}")) then
					disp = disp:gsub("{US_MONTH}", currentMonth)
				end
				if (disp:find("{US_YEAR}")) then
					disp = disp:gsub("{US_YEAR}", currentYear)
				end
				if (disp:find("{HEADTAG}")) then
					disp = disp:gsub("{HEADTAG}", playerHeadTag) 
				end
				if (disp:find("{GANGHEADTAG}")) then
					disp = disp:gsub("{GANGHEADTAG}", GangHeadTag) 
				end
				DrawTxt(x, y, 1.0, 1.0, scale, disp, 255,255,255,255);
			end

			tickDegree = tickDegree + 9.0;
		end
	end
end)

function GetCardinalDirection()
	local camRot = Citizen.InvokeNative( 0x837765A25378F0BB, 0, Citizen.ResultAsVector() )
    local playerHeadingDegrees = 360.0 - ((camRot.z + 360.0) % 360.0)
    local tickDegree = playerHeadingDegrees - 180 / 2
    local tickDegreeRemainder = 9.0 - (tickDegree % 9.0)
   
    tickDegree = tickDegree + tickDegreeRemainder
    return tickDegree;
end

function degreesToIntercardinalDirection( dgr )
	dgr = dgr % 360.0
	
	if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then
		return " E "
	elseif dgr >= 22.5 and dgr < 67.5 then
		return "SE"
	elseif dgr >= 67.5 and dgr < 112.5 then
		return " S "
	elseif dgr >= 112.5 and dgr < 157.5 then
		return "SW"
	elseif dgr >= 157.5 and dgr < 202.5 then
		return " W "
	elseif dgr >= 202.5 and dgr < 247.5 then
		return "NW"
	elseif dgr >= 247.5 and dgr < 292.5 then
		return " N "
	elseif dgr >= 292.5 and dgr < 337.5 then
		return "NE"
	end
end