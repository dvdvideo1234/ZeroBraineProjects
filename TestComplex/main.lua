local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki").addBase("D:/LuaIDE").setBase(1)
                
io.stdout:setvbuf("no")

local complex = require("complex")
local common = require("common")

local c1 = complex.getNew(-15,-15)
local c2 = complex.getNew( -5,  5)
local c3 = complex.getNew( -1,  8)
local c4 = complex.getNew(  1, -8)
local c5 = complex.getNew(  5, -5)
local c6 = complex.getNew(15, 15)

-- These calls produce the same curve for interpolation length <n-samples> and power <alpha>
-- The default curve interpolation sample count is 100
-- The default curve power interpolation coefficient <alpha> is 0.5
-- local tC = complex.getCatmullRomCurve( p1, p2, ..., pn, n-samples, alpha)
-- local tC = complex.getCatmullRomCurve({p1, p2, ..., pn}, n-samples, alpha)

local tc = {c1,c1,c2,c3,c3} --,c2,c3,c3,c3,c3,c4,c4,c4,c5,c6}
local tF, tN = complex.getCatmullRomCurveDupe(tc,2,0.1)

local mt = getmetatable(tc[1])

common.logTable(tN, "NODE", nil, {["complex.complex"] = tostring})
common.logTable(tF, "LIST", nil, {["complex.complex"] = tostring})




