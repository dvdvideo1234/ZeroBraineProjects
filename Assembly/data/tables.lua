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

SERVER = true
CLIENT = true

require("gmodlib")
require("trackasmlib")
asmlib = trackasmlib

CreateConVar("gmod_language")
require("Assembly/autorun/config")

asmlib.SetLogControl(20000, false)

local function IsValid(a) return a~=nil end 

local P = asmlib.GetBuilderNick("PIECES")
local D = P:GetDefinition()
local V = {}; for iD = 1, D.Size do V[D[iD][1]] = iD end

V["MODEL"] = nil
V["LINEID"] = 0

print(P:GetColumnList(nil,1,2,3))

print(P:GetConcat(V, "|",function(iCT, sCT, vCT) return P:Match(vCT,iCT,true,"\"",true) end))