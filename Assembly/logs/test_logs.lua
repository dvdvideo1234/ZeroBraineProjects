local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local tableConcat = table and table.concat

local common = require("common")

require("gmodlib")
require("trackasmlib")
require("common")

local asmlib     = trackasmlib
local gaTimerSet = {} -- ("/"):Explode("CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1")
asmlib.InitBase("track", "assembly")
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.SetOpVar("DATE_FORMAT","%d-%m-%y")
asmlib.SetOpVar("TIME_FORMAT","%H:%M:%S")
asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("S",4,5,6,7)
asmlib.SetOpVar("DIRPATH_BAS", "Assembly/")
asmlib.SetLogControl(1000,false)

  local gsLogsPopul = "*PopulateEntityMenu"
  local function PopulateEntityMenu(nLen)
    local oEnt = netReadEntity()
    asmlib.LogInstance("Entity<"..tostring(oEnt)..">", gsLogsPopul)
    for iD = 1, conContextMenu:GetSize() do
      local tLine = conContextMenu:Select(iD)
      local sKey, wDraw = tLine[1], tLine[5]
      if(type(wDraw) == "function") then
        asmlib.LogInstance("Handler<"..sKey..">", gsLogsPopul)
        local bS, vE = pcall(wDraw, oEnt, oPly); if(not bS) then
          asmlib.LogInstance("Request <"..sKey.."> fail: "..vE, gsLogsPopul); end
        asmlib.LogInstance("Value <"..vE..">!")
        oEnt:SetNWString(sKey, vE)
      end 
    end
  end

function GetReport(...)
  local sD = asmlib.GetOpVar("OPSYM_VERTDIV")
  local tV, sV = {...}, sD -- Use vertical divider
  local nV = select("#", ...) -- Read report count
  if(nV == 0) then return sV end -- Nothing to report
  if(nV == 1) then sV = "{"..type(tV[1]).."}"..sV end
  for iV = 1, nV do sV = sV..tostring(tV[iV])..sD end
  return sV -- Concatenate vararg and return a string
end

local a = false

print(tostring(a or "X"))




