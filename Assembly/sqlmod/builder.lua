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
local I = PIECES:Match('asdf', 4, true)
local Q = PIECES:Delete():Get()

asmlib.LogInstance(PIECES:Begin():Get(), "QUERY")
asmlib.LogInstance(PIECES:Commit():Get(), "QUERY")

asmlib.LogInstance(Q, "QUERY")

local IDX = PIECES:Index():Get()
asmlib.LogTable(IDX, "IDX")

local CMD = PIECES:GetCommand()
asmlib.LogTable(CMD, "CMD")