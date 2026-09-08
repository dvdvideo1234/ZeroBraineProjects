local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local common = require("common")

local sSrc = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT/lua/weapons/gmod_tool/stools/trackassembly.lua"
-- C:\Users\ddobromirov\Documents\Lua-Projs\VerControl\TrackAssemblyTool_GIT\lua\weapons\gmod_tool\stools\trackassembly.lua
local tPav = {
  {"GetOpVar%s*%(%s*\"[A-Z_][A-Z_]*\"%s*%)", "%(.*%)"},
  {"asmlib*s*%.%s*GetOpVar%s*%(%s*\"[A-Z_][A-Z_]*\"%s*%)", "%(.*%)"}
}
local sCun = common.stringGetChunkPath()

local function repFilePattern(sIn, sOut, tCon)
  local C = common.stringGetChunkPath()
  local M = ("%s/%s.lua"):format(C, sOut)
  local F = assert(io.open(sIn, "rb"))
  local O = assert(io.open(M, "wb"))
  local R, N, U = F:read("*line"), 1, 0
  while(R) do
    local fS, fE = R:find(tCon[1])
    if(fS and fE) then
      local aS, aE = R:sub(fS, fE):find(tCon[2])
      if(aS and aE) then local V -- One liner
        O:write(R:sub(1, fS - 1))
        V = R:sub(fS, fE):sub(aS + 1, aE - 1)
        V = common.stringTrim(V, " ")
        V = common.stringTrim(V, "\"")
        V = common.stringTrim(V, " ")
        O:write(V)
        O:write(R:sub(fE + 1, -1))
        O:write("\n")
        U = U + 1
      else
        O:write(R)
        O:write("\n")
      end
    else
      O:write(R)
      O:write("\n")
    end
    R, N = F:read("*line"), (N + 1)
  end

  O:flush(); O:close()
  F:close()
  
  return U
end

local nS, nT, nI = 1, 10, 1
local nR = repFilePattern(sSrc, "tmp-1", tPav[nI])
while(nR > 0 and nT > 0) do
  print(nS, "--[",nI ,"]-->", nR)
  nR = repFilePattern(sCun.."/tmp-"..nS..".lua", "tmp-"..tostring(nS + 1), tPav[nI])
  nS = nS + 1
  if(nR == 0) then
    nI = nI + 1
    print(nS, "--[",nI ,"]-->", nR)
    nR = repFilePattern(sCun.."/tmp-"..nS..".lua", "tmp-"..tostring(nS + 1), tPav[nI])
    nS = nS + 1
  end
  nT = nT - 1
end

dir.renRec("tmp-"..(nS-1)..".lua", common.stringGetFileName(sSrc), sCun)
dir.ersRec("tmp-*.lua", sCun)


