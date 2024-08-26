local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("gmodlib")
require("trackasmlib")
asmlib = trackasmlib
local com = require("common")

if(not asmlib) then error("No library") end

asmlib.IsModel = function(m) return isstring(m) end

if(not asmlib.InitBase("track","assembly")) then error("Init fail") end

asmlib.NewAsmConvar("timermode", "CQT@1800@1@1/CQT@900@1@1/CQT@600@1@1", nil, gnIndependentUsed, "Memory management setting when DB mode is SQL")

print("TM:", asmlib.GetAsmConvar("timermode","STR"))

CreateConVar("gmod_language")
require("Assembly/autorun/config")

local r = asmlib.CacheQueryPiece("models/props_phx/trains/monorail1.mdl")

com.logTable(r, "REC")
com.logTable(asmlib.GetBuilderNick("PIECES"):GetDefinition(), "DEF_PIECES")
com.logTable(asmlib.GetBuilderNick("PIECES"):GetCommand(), "CMD_PIECES")
com.logTable(asmlib.GetOpVar("QUERY_STORE"), "QUERY_STORE")



