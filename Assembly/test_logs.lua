package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/?.lua"

local tableConcat = table and table.concat

local common = require("common")
require("dvdlualib/gmodlib")
require("dvdlualib/asmlib")
require("dvdlualib/common")

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



