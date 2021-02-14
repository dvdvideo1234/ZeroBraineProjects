local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Users/ddobromirov/Documents/Lua-Projs/ZeroBraineIDE").setBase(1)

require("gmodlib")
local common = require("common")

local function isValid(vE, vT)
  if(vT) then local sT = tostring(vT or "")
    if(sT ~= type(vE)) then return false end end
  return (vE and vE.IsValid and vE:IsValid())
end

local function pickTable(tT)
  if(not tT) then return nil end
  return ((next(tT) ~= nil) and tT or nil)
end

local logStatus = print

local gsFormFlt = " Flt: [%s]{%s}"
local tF = pickTable({ents.Create("xx"), ents.Create("aa")})
local nF = 15
local fF = gsFormFlt:format("%"..tostring(nF):len().."d", "%s")

for iF = 1, nF do
  local vE, sC = tF[iF]
  if(isValid(vE)) then sC = vE:GetClass() end
  logStatus(fF:format(iF, tostring(sC)), oChip, nP)
end