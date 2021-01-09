local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki").addBase("D:/LuaIDE").setBase(1)
                
local com = require("common")
local asmlib = require("trackasmlib")
local cpx = require("complex")
local tableRemove = table and table.remove

local new = function(m)
    local n = m:gsub("models/anytracks/","")
    local r = n:match("^%a+"); n = n:gsub("%.mdl","")
          n = n:gsub(r, ""):sub(2, -1); return r, n
end
    
    

    
local m = "models/anytracks/straight/hs_4096.mdl"
--local m = "models/bobsters_trains/rails/2ft/curves/curve_bank_90_left_2048.mdl"
-- print("ggg", new(m))
local to, nn = new(m)
print("Name", nn)
com.logTable(to, "NEW")


