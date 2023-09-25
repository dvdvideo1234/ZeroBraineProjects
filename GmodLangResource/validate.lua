local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(1)
require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")

local bom = {0xEF, 0xBB, 0xBF} -- UTF-8-BOM
local tP = {
  Base = "D:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons/",
  Prop = "resource/localization/",
  {
    Dir  = "TrackAssemblyTool_GIT",
    Name = "trackassembly",
    Tran = {"en", "bg", "ru", "fr", "ja"}
  },
  {
    Dir  = "LaserSTool",
    Name = "laseremitter",
    Tran = {"en", "bg"}
  }
}; tP.Size = #tP

function checkProperties(src)
  local src, nam, f = tostring(src or ""), nil
  if(src:find("/") or src:find("\\")) then
    nam = src:gsub("\\", "/"):gsub("/+", "/")
    f = assert(io.open(src, "r"))
  else
    nam = com.stringGetChunkPath().."PROPERTIES\\"..src
    nam = nam:gsub("\\", "/"):gsub("/+", "/")
    f = assert(io.open(nam, "r"))
  end
  local r, t = f:read("*line"), {}
  for i = 1, 3 do -- Remove BOM
    if(r:byte() == bom[i]) then r = r:sub(2, -1) end
  end -- Compare without BOM
  if(r and r:len() > 0) then
    error("First row must be empty ["..nam.."]["..r.."]") end
  while(r) do
    local n = com.stringTrim(r)
    if(n:len() > 0 and n:sub(1,1) ~= "#") then
      local se, ee = n:find("=", 1, true)
      if(not se) then error("Equals sign missing ["..nam.."]["..r.."]") end
      if(se ~= ee) then error("Equals sign is longer at ["..nam.."]["..r.."]") end
      local key, dat = n:sub(1,se-1), n:sub(ee+1,-1)
      if(t[key]) then error("Key exists at ["..nam.."]["..r.."]") end
      local ic, sc, ec = 1, n:find(":", 1, true)
      while(sc and ec and sc <= ec) do
        local esc = n:sub(sc-1, sc-1)
        if(esc ~= "\\") then
          error("Colon not escaped ["..nam.."]["..r.."]") end
        sc = sc + 1
      end; t[key] = true
    end
    r = f:read("*line")
  end
  f:close()
end

for i = 1, tP.Size do
  local v = tP[i]
  print("Checking: "..v.Name.."@"..v.Dir)
  for k = 1, #v.Tran do
    local p = tP.Base..v.Dir.."/"..
              tP.Prop..v.Tran[k]..
              "/"..v.Name..".properties"
    checkProperties(p)
    print("OK: "..p)
  end
end
