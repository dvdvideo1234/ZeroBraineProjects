local com = require("dvdlualib/common")
local gmd = require("dvdlualib/gmodlib")
local gtDataBase = {}

--[[---------------------------------------------------------
   Returns year, month and day as a formatted string.
   You can also provide an argument to be conveted.
-----------------------------------------------------------]]
function util.Date(vD)
	return os.date("%Y-%m-%d", vD)
end

--[[---------------------------------------------------------
   Returns hour, minute, seconds as a formatted string.
   You can also provide an argument to be conveted.
-----------------------------------------------------------]]
function util.Time(vT)
	return os.date("%H:%M:%S", vT)
end

--[[---------------------------------------------------------
   Returns year, month, day, hour, minute and seconds as a formatted string.
   You can also provide an argument to be conveted.
-----------------------------------------------------------]]
function util.DateStamp(vS)
	return os.date("%Y-%m-%d %H:%M:%S", vS)
end

print(util.Date(123123))
print(util.Time(123123))
print(util.DateStamp(123123))

print(util.Date(os.time()))


