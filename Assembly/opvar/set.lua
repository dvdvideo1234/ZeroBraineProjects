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

local sSrc = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT/lua/"

local tBas = {
  "trackassembly/trackasmlib.lua",
  "autorun/trackassembly_init.lua",
  "weapons/gmod_tool/stools/trackassembly.lua",
}

-- C:\Users\ddobromirov\Documents\Lua-Projs\VerControl\TrackAssemblyTool_GIT\lua\trackassembly\trackasmlib.lua

local nBas = 3
local sBas = "SetOpVar%s*%(%s*\"[A-Z][0-9A-Z_]*\"%s*,%s*.*%)"

local tPav = {
  {sBas, "%(.*%)"},
  {"asmlib*s*%.%s*"..sBas, "%(.*%)"}
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
      if(aS and aE) then local V = {1, 2} -- One liner
        local D = R:sub(fS, fE):sub(aS + 1, aE - 1)
        local C = D:find(",", 1, true)
        V[1] = D:sub(1,  C - 1)
        V[1] = common.stringTrim(V[1], " ")
        V[1] = common.stringTrim(V[1], "\"")
        V[1] = common.stringTrim(V[1], " ")
        V[2] = D:sub(C + 1, -1)
        V[2] = common.stringTrim(V[2], " ")
        O:write(R:sub(1, fS - 1))
        O:write(V[1])
        O:write(" = ")
        O:write(V[2])
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
local nR = repFilePattern(sSrc..tBas[nBas], "tmp-1", tPav[nI])
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

dir.renRec("tmp-"..(nS-1)..".lua", common.stringGetFileName(sSrc..tBas[nBas]), sCun)
dir.ersRec("tmp-*.lua", sCun)


