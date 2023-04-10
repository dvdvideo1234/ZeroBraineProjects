local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("dvdlualib/gmodlib")
local testexec = require("testexec")

local po = ents.Create("seamless_portal")
local pl = ents.Create("player")
local pd = ents.Create("other")

local seamless_table = {
	["seamless_portal"] = true,
	["player"         ] = true
}

local seamless_check1 = function(t)
  local e = t[1]
  return not (e:GetClass() == "seamless_portal" or e:GetClass() == "player")
end -- for traces

local function seamless_check2(t)
    local e = t[1]
	return not (seamless_table[e:GetClass()] or false)
end -- for traces

local function seamless_check3(t)
    local e = t[1]
  if(seamless_table[e:GetClass()]) then return false end; return true
end -- for traces

--[[
local stEstim = {
  testexec.Case("original", seamless_check1),
  testexec.Case("modified", seamless_check2),
  testexec.Case("modif-IF", seamless_check3)
}

local stCard = {
  AcTime = 1, -- Draw a dot after X seconds
  FnCount = 2000, -- Amount of loops to be done for the test card
  FnCycle = 3000, -- Amount of loops to be done for the function tested
  ExPercn = .1, -- Draw percent completed every X margin ( 0 to 1 )
  {"portal", {po}, false},
  {"player", {pl}, false},
  {"other" , {pd}, true}
}

testexec.Run(stCard,stEstim)
]]

t = testexec.New()
t:setCase(seamless_check1, "original")
t:setCase(seamless_check2, "modified")
t:setCase(seamless_check3, "modif-IF")
t:setProgress(1, 0.1)
t:setCount(12000, 12000)
t:setCard({po}, false, "portal")
t:setCard({pl}, false, "player")
t:setCard({pd}, true , "other" )
t:runMeasure()
