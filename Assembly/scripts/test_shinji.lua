local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE")
      dir.setBase(2)

CLIENT = true
SERVER = false

require("gmodlib")
function game.SinglePlayer() return false end

require("trackasmlib")
local common = require("common")
local asmlib = trackasmlib

CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetLogControl(20000, true)

asmlib.IsModel = function(m) return true end

require("Assembly/autorun/shinji")

local sT = "Shinji85's Rails"

asmlib.RegisterDSV("NEW", "Test_s_track_pack", nil, true)

asmlib.ProcessDSV()

local tC = asmlib.GetOpVar("TABLE_CATEGORIES")
local tS = {[sT] = tC[sT]}
local sP = sT:gsub("[^%w]","_")

asmlib.LogTable(tS, "CATEGORY")

local oR = asmlib.CacheQueryPiece("models/shinji85/train/rail_16x.mdl")
if(oR) then
  asmlib.LogTable(oR, "BEFORE")
  local tO = asmlib.LocatePOA(oR, 1)
  asmlib.LogTable(oR, "AFTER")
end

local oR = asmlib.CacheQueryPiece("models/props_phx/trains/monorail1.mdl")
if(oR) then
  asmlib.LogTable(oR, "BEFORE")
  local tO = asmlib.LocatePOA(oR, 1)
  asmlib.LogTable(oR, "AFTER")
end

asmlib.ExportCategory(3, tS, sP, true)
asmlib.ExportTypeDSV(sT)
