local Job = '~b~Civillian'
local JobColour = '~g~'
local callsign = "N/A"
local ShowHud = true
local DutyMinutes = 0.0
local DutySeconds = 0.0

local Knight_Duty = {}

Knight_Duty.onDuty = false
Knight_Duty.unit = nil

RegisterNetEvent('knight-duty:onenterduty')
RegisterNetEvent('knight-duty:onexitduty')

AddEventHandler('knight-duty:onenterduty', function(unit)
	Knight_Duty.onDuty = true
	Knight_Duty.unit = unit
    if Knight_Duty.onDuty then
        callsign = unit.callsign
    if unit.dept == "BCSO" then 
        Job = '~o~BCSO'
        JobColour = "~o~"
    elseif unit.dept == "SAST" then 
        Job = '~g~SAST'
        JobColour = "~b~"
    elseif unit.dept == "DHS" then 
        Job = '~b~DHS'
        JobColour = "~b~"
    elseif unit.dept == "CIA" then 
        Job = '~u~CIA'
        JobColour = "~q~"
    elseif unit.dept == "PUBCOP" then 
        Job = '~g~Public Officer'
        JobColour = "~g~"
    elseif unit.dept == "STAFF" then 
        Job = '~r~Staff Team'
        JobColour = "~r~"
    elseif unit.dept == "FAA" then 
        Job = '~f~Pilot'
        JobColour = "~f~"
    elseif unit.dept == "FBI" then 
        Job = '~h~FBI'
        JobColour = "~o~"
    elseif unit.dept == "RANGER" then 
        Job = '~g~San Andreas Park Rangers'
        JobColour = "~g~"
    elseif unit.dept == "USM" then 
        Job = '~w~United States Marshals'
        JobColour = "~w~"
    elseif unit.dept == "G6" then 
        Job = '~g~Gruppe Sechs Security'
        JobColour = "~g~"
    elseif unit.dept == "DOD" then
        Job = '~c~Department Of Defense'
        JobColour = "~c~"
        end
    end
end)

AddEventHandler('knight-duty:onexitduty', function()
	Knight_Duty.onDuty = false
	Knight_Duty.unit = nil
	Job = '~q~Civillian'
    JobColour = '~b~'
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if not displaysHidden then
            if Knight_Duty.onDuty then 
                DrawTxt(1.400, 0.525, 1.0,1.0,0.35,"~t~Job: "..Job.. " ~t~| Callsign: ~b~" ..callsign.. " ~p~~n~ Duty Time (Mins):~b~ " ..DutyMinutes, 255,255,255,255)
            elseif not Knight_Duty.onDuty then
                DrawTxt(1.400, 0.525, 1.0,1.0,0.35,"~t~Job: " ..Job, 255,255,255,255)
            end
        end
    end
end)
    
Citizen.CreateThread(function()
    while true do 
        Wait(1000)
        if Knight_Duty.onDuty then
            Wait(60000)
            if DutyMinutes < 300 then
                DutyMinutes = DutyMinutes + 1
            else 
                DutyMinutes = 0.0
            end
        else
            DutyMinutes = 0.0
        end
    end
end)

function DrawTxt(x,y ,width,height,scale, text, r,g,b,a)
    if ShowHud then
        SetTextFont(6)
        SetTextProportional(1)
        SetTextCentre(0)
        SetTextScale(scale, scale)
        SetTextColour(r, g, b, a)
        SetTextDropShadow(0, 0, 0, 0,255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(x - width/2, y - height/2 + 0.005)
    end
end