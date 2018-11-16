local com = require("dvdlualib/common")

function IsTable(vVal)
  return (type(vVal) == "table")
end

local t = {}

print(IsTable(t))

com.logTable(debug.getinfo(1))