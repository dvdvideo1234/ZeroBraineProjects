package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/?.lua"

CLIENT = true

local common = require("common")
require("dvdlualib/gmodlib")
require("dvdlualib/asmlib")
local asmlib = trackasmlib

asmlib.InitBase("track", "assembly")
asmlib.SetLogControl(1000,false)



local TOOL = {}

TOOL.ClientConVar = {
  [ "weld"       ] = 1,
  [ "mass"       ] = 25000,
  [ "model"      ] = "models/props_phx/trains/tracks/track_1x.mdl",
  [ "nextx"      ] = 0,
  [ "nexty"      ] = 0,
  [ "nextz"      ] = 0,
  [ "freeze"     ] = 1,
  [ "anchor"     ] = gsNoAnchor,
  [ "igntype"    ] = 0,
  [ "spnflat"    ] = 0,
  [ "angsnap"    ] = 15,
  [ "sizeucs"    ] = 20,
  [ "pointid"    ] = 1,
  [ "pnextid"    ] = 2,
  [ "nextpic"    ] = 0,
  [ "nextyaw"    ] = 0,
  [ "nextrol"    ] = 0,
  [ "spawncn"    ] = 0,
  [ "bgskids"    ] = "0/0",
  [ "gravity"    ] = 1,
  [ "adviser"    ] = 1,
  [ "elevpnt"    ] = 0,
  [ "activrad"   ] = 50,
  [ "pntasist"   ] = 1,
  [ "surfsnap"   ] = 0,
  [ "exportdb"   ] = 0,
  [ "forcelim"   ] = 0,
  [ "ignphysgn"  ] = 0,
  [ "ghostcnt"   ] = 1,
  [ "stackcnt"   ] = 5,
  [ "maxstatts"  ] = 3,
  [ "nocollide"  ] = 1,
  [ "nocollidew" ] = 0,
  [ "physmater"  ] = "metal",
  [ "enpntmscr"  ] = 1,
  [ "engunsnap"  ] = 0,
  [ "workmode"   ] = 0,
  [ "appangfst"  ] = 0,
  [ "applinfst"  ] = 0,
  [ "enradmenu"  ] = 0,
  [ "incsnpang"  ] = 5,
  [ "incsnplin"  ] = 5
}

local gtConvarList = asmlib.GetConvarList(TOOL.ClientConVar)

local oPly = LocalPlayer()

for key, val in pairs(asmlib.GetConvarList()) do
  asmlib.SetAsmConvar(oPly, "*"..key, val)
end










