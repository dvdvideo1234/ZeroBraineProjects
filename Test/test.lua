local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")

local self = {Parent = {}}
self.Parent.CustomOnLoseFocus = function() end

 self.TextEntry = vgui.Create("DTextEntry", self)
  self.TextEntry:SetSize(0, 0)
  self.TextEntry.Parent = self

self.TextEntry.OnLoseFocus1 = function(self)
  self.Parent:CustomOnLoseFocus()
end

function self.TextEntry:OnLoseFocus2()
  self.Parent:CustomOnLoseFocus()
end

self.TextEntry.OnLoseFocus1(self)
self.TextEntry.OnLoseFocus2()