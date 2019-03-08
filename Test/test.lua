local com = require("dvdlualib/common")
local gmd = require("dvdlualib/gmodlib")

local function foo(a,b)
  return 1, 2, 3
end

local function bar(x,y,z)
  print(x,y,z)
end

bar(1,"TYPE",foo(0,0))

print(nil~=0)