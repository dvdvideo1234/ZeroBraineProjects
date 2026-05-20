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

require("Assembly/autorun/shinji")

asmlib.IsFlag("file_read_once", false)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end

asmlib.ImportDSV("PIECES", true, "shinji85_s_rails")

local oM = "models/shinji85/train/rail_l_switch.mdl"
local tS = {"BEFORE", "AFTER"}

local function logPrint(SD, TY, ...)
  asmlib.LogInstance(asmlib.GetReport(SD, TY, ...))
end

local oR = asmlib.CacheQueryPiece(oM)
if(oR) then 
  local iD, iO = 3, "P"
  local oP = oR.Offs[iD]
  if(oP and oP[iO]) then
    asmlib.LogTable(oR, tS[1])
    asmlib.LocatePOA(oR, 1)
    asmlib.LogTable(oR, tS[2])
  end
else
  asmlib.LogIstance("Model missing: "..oM)
end

-- ExportTypeDSV

