local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")
local tableRemove = table and table.remove

function use(t, n)
  com.logTable(t, n)
end

local this = {}
this.mFlt = {}
this.mFlt.Enu = {1,2,3}


local a = {b = 4}
local b = {1,2 ,3}
local c = {4,5,6}
local d = {e = 99}

this.mFlt.Enu = c
use(this.mFlt.Enu, "A")

c[4] = 999
use(this.mFlt.Enu, "B")