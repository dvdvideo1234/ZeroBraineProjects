local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("gmodlib")
local com = require("common")

local src = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/LaserSTool/lua/entities/gmod_wire_expression2/core/custom/laserbeam.lua"
local idx = {"e2function", "getReportKey", "return"}
local f = assert(io.open(src, "r"))

local r, i, ty = f:read("*line"), 1
while(r) do
  if(r:find(idx[1], 1, true)) then
    ty = com.stringTrim(r:sub(r:find(idx[1].."%s+[a-z]+%s+")))
    ty = ty:gsub(idx[1].."%s+", "")
    print(("%0000d"):format(i)..":", ty)
  end
  if(ty and r:find(idx[2], 1, true)) then
    print(("%0000d"):format(i)..":", r)
  end
  if(ty and r:find(idx[3], 1, true)) then
    print(("%0000d"):format(i)..":", r)
  end
  r = f:read("*line")
  i = i + 1
end

f:close()
