require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")


local a = {1,2,3,4,5,{},{},{}}

for i = 1, #a, 1 do
  logStatus("",tostring(a[i]))
end

local s = "@@@aaa@bbb@ccc@@"
local t = strExplode(s:sub(2,-1):Trim("@"), "@")
for i = 1, #t, 1 do
  logStatus("",tostring(t[i]))
end