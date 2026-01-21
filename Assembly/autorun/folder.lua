require("gmodlib")
require("trackasmlib")
local asmlib = trackasmlib
if(not asmlib) then error("No library") end

local oservr = asmlib.SetOpVar
asmlib.SetOpVar = function(n, v)
  if(n ~= "DIRPATH_BAS") then oservr(n, v) else
    oservr(n, "Assembly/trackassembly/")
  end
end