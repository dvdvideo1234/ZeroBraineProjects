local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)
local f
require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")

local source = "laseremitter.properties"

if(source:find("/") or source:find("\\")) then
  local name = source:gsub("\\", "/"):gsub("/+", "/")
  f = assert(io.open(source, "r"))
else
  local name = com.stringGetChunkPath().."Data\\"..source
        name = name:gsub("\\", "/"):gsub("/+", "/")
  f = assert(io.open(name, "r"))
end

local r, t = f:read("*line"), {}
if(r and r:len() > 0) then
  error("First row must be empty ["..r.."]") end
while(r) do
  local n = com.stringTrim(r)
  if(n:len() > 0 and n:sub(1,1) ~= "#") then
    local s, e = n:find("=", 1, true)
    if(not s) then error("Equals sign missing ["..r.."]") end
    if(s ~= e) then error("Equals sign is longer at ["..r.."]") end
    local key, dat = n:sub(1,s-1), n:sub(e+1,-1)
    if(t[key]) then error("Key exists at ["..r.."]") end
    t[key] = true; print(key, dat)
  end
  r = f:read("*line")
end

f:close()
