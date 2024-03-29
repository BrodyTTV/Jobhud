Citizen.CreateThread(function()
    while true do 
      Wait(1000);
      local time = format_time(os.time(), "%H:%M", "+00:00", "GMT");
      local date = format_time(os.time(), "%d %m %Y", "+00:00", "GMT");
      local timeHour = split(time, ":")[1]
      local dateData = split(date, " ");
      TriggerClientEvent('Badssentials:SetMonth', -1, dateData[1])
      TriggerClientEvent('Badssentials:SetDay', -1, dateData[2])
      TriggerClientEvent('Badssentials:SetYear', -1, dateData[3])

      if tonumber(timeHour) > 12 then 
        local timeStr = tostring(tonumber(timeHour) - 12) .. ":" .. split(time, ":")[2]
        TriggerClientEvent('Badssentials:SetTime', -1, timeStr);
      end
      if timeHour == "00" then 
        local timeStr = "12" .. ":" .. split(time, ":")[2]
        TriggerClientEvent('Badssentials:SetTime', -1, timeStr);
      end 
      if timeHour ~= "00" and tonumber(timeHour) <= 12 then 
        TriggerClientEvent('Badssentials:SetTime', -1, time);
      end
    end
end)

function split(source, sep)
    local result, i = {}, 1
    while true do
        local a, b = source:find(sep)
        if not a then break end
        local candidat = source:sub(1, a - 1)
        if candidat ~= "" then 
            result[i] = candidat
        end i=i+1
        source = source:sub(b + 1)
    end
    if source ~= "" then 
        result[i] = source
    end
    return result
end

function format_time(timestamp, format, tzoffset, tzname)
    print(tzoffset)
    if tzoffset == "local" then  -- calculate local time zone (for the server)
       local now = os.time()
       local local_t = os.date("*t", now)
       local utc_t = os.date("!*t", now)
       local delta = (local_t.hour - utc_t.hour)*60 + (local_t.min - utc_t.min)
       local h, m = math.modf( delta / 60)
       tzoffset = string.format("%+.4d", 100 * h + 60 * m)
    end

    tzoffset = tzoffset or "GMT"
    format = format:gsub("%%z", tzname or tzoffset)
    if tzoffset == "GMT" then
       tzoffset = "+0000"
    end
    tzoffset = tzoffset:gsub(":", "")
 
    local sign = 1
    if tzoffset:sub(1,1) == "-" then
       sign = -1
       tzoffset = tzoffset:sub(2)
    elseif tzoffset:sub(1,1) == "+" then
       tzoffset = tzoffset:sub(2)
    end
    tzoffset = sign * (tonumber(tzoffset:sub(1,2))*60 +
 tonumber(tzoffset:sub(3,4)))*60
    return os.date(format, timestamp + tzoffset)
 end

function format_time(timestamp, format, tzoffset, tzname)
   if tzoffset == "local" then  -- calculate local time zone (for the server)
      local now = os.time()
      local local_t = os.date("*t", now)
      local utc_t = os.date("!*t", now)
      local delta = (local_t.hour - utc_t.hour)*60 + (local_t.min - utc_t.min)
      local h, m = math.modf( delta / 60)
      tzoffset = string.format("%+.4d", 100 * h + 60 * m)
   end
   tzoffset = tzoffset or "GMT"
   format = format:gsub("%%z", tzname or tzoffset)
   if tzoffset == "GMT" then
      tzoffset = "+0000"
   end
   tzoffset = tzoffset:gsub(":", "")

   local sign = 1
   if tzoffset:sub(1,1) == "-" then
      sign = -1
      tzoffset = tzoffset:sub(2)
   elseif tzoffset:sub(1,1) == "+" then
      tzoffset = tzoffset:sub(2)
   end
   tzoffset = sign * (tonumber(tzoffset:sub(1,2))*60 +
tonumber(tzoffset:sub(3,4)))*60
   return os.date(format, timestamp + tzoffset)
end