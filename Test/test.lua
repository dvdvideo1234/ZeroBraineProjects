local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(1)

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")

local TOOL = {GetStackMode = function() return 11 end, SetOperation = function(...) print("MODE", ...) end}
local CLIENT = false
local asmlib = {GetCorrectID = print}
local SMode = 77


function TOOL:Deploy()
  if(CLIENT) then return end
  self:SetOperation(asmlib.GetCorrectID(self:GetStackMode(),SMode))
end

TOOL:Deploy()
