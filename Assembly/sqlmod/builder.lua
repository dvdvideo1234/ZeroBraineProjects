local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(1)
                
local com = require("common")

rawset(_G, "CLIENT", true)

require("gmodlib")
require("trackasmlib")

asmlib = trackasmlib
if(not asmlib) then error("No library") end

asmlib.IsModel = function(m) return isstring(m) end

if(not asmlib.InitBase("track","assembly")) then error("Init fail") end

asmlib.NewAsmConvar("timermode", "CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1", nil, gnIndependentUsed, "Memory management setting when DB mode is SQL")
CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetLogControl(20000, false)

local PIECES = asmlib.GetBuilderNick("PIECES")

local M = PIECES:Match("model", 1, true)
local Q = PIECES:Delete():Where({1,M},{2,2}):Get()

print(Q)
