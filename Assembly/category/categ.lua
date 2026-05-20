local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
                
local com = require("common")

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)

require("gmodlib")
require("trackasmlib")
local asmlib = trackasmlib
if(not asmlib) then error("No library") end
require("Assembly/autorun/folder")
require("Assembly/autorun/config")
asmlib.SetLogControl(20000, false)

local function convert(m)
local n = math.floor(tonumber(2) or 0)
local m = m:gsub("models", "")
local t, x = {n = 0}, m:find("/", 1, true)
while(x and x > 0) do
  t.n = t.n + 1; t[t.n] = m:sub(1, x-1)
  m = m:sub(x+1, -1); x = m:find("/", 1, true)
  end; m = m:gsub("%.mdl$","")
  if(n == 0) then return t, m end; local a = math.abs(n)
  if(a > t.n) then return t, m end; local s = #t-a
  if(n < 0) then for i = 1, a do t[i] = t[i+s] end end
  while(s > 0) do table.remove(t); s = s - 1 end
  return t, m
end

local a, b = convert("models/scene_building/sewer_system/tunnel_big_bend.mdl")
asmlib.LogTable(a)
print("Name:", b)