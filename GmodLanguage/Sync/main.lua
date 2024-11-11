local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local com = require("common")
io.stdout:setvbuf("no")

local res = {__index = {}, __en = {}, __key = {}}
local ssrc, isrc = dir.getBase()
local pth = dir.getNorm(com.stringGetChunkPath())
local prf = {"TrackAssemblyTool_GIT", "trackassembly"}

local src = {
  "D:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons",
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl"
}

local function getResource(sL)
  local R = assert(io.open(src[isrc].."/"..prf[1].."/resource/localization/"..sL.."/"..prf[2]..".properties"))
  local L = R:read("*line"); res[sL] = {}; table.insert(res.__index, sL)
  while(L) do
    local M = L:find("=", 1, true)
    if(M) then
      local K = L:sub(1, M-1)
      local V = L:sub(M+1,-1)
      res[sL][K] = V
    end
    L = R:read("*line")
  end; return res[sL]
end

dir.ersDir("localization", pth)
dir.newDir("localization", pth)

local tF = dir.conDir("localization", src[isrc].."/"..prf[1].."/resource/")

getResource("en")

for k, v in pairs(res[res.__index[1]]) do table.insert(res.__en, k) end
table.sort(res.__en)


for iD = 1, #tF.Tree do
  local n = tF.Tree[iD].Name
  if(n:sub(1,1) ~= "." and n ~= "en") then
    getResource(tF.Tree[iD].Name)
  end
end


for iL = 2, #res.__index do
  local N = res.__index[iL]
  local F = assert(io.open(pth.."/localization/"..N..".txt", "wb"))
  F:write("# New translations to be added to ["..N.."]\n\n")
  for iE = 1, #res.__en do
    local K = res.__en[iE]
    if(not res[N][K]) then
      F:write(K.."="..res["en"][K].."\n")
    end
  end
  F:write("\n\n")
  F:flush()
  F:close()
end


for iL = 2, #res.__index do
  local N = res.__index[iL]; res.__key = {}
  local F = assert(io.open(pth.."/localization/"..N..".txt", "ab"))
  F:write("# The translations to be removed from ["..N.."]\n\n")
  for k, v in pairs(res[N]) do table.insert(res.__key, k) end
  table.sort(res.__key)
  for iE = 1, #res.__key do
    local K = res.__key[iE]
    if(not res["en"][K]) then
      F:write(K.."="..res[N][K].."\n")
    end
  end
  F:write("\n\n")
  F:flush()
  F:close()
end
