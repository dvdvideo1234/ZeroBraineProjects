local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(1)
      
local com = require("common")

require("gmodlib")
require("laserlib")

local gtREFRACT = LaserLib.DataRefract("*")
local DATA = LaserLib.GetData()

local e = ents.Create('gmod_laser')

local t = util.TraceLine()
t.a = {1,1,1}

local gtCOPYCOV = {
  ["boolean"] = function(arg) return arg end,
  ["number" ] = function(arg) return arg end,
  ["string" ] = function(arg) return arg end,
  ["Entity" ] = function(arg) return arg end,
  ["Player" ] = function(arg) return arg end,
  ["Vector" ] = Vector,
  ["Angle"  ] = Angle
}

--[[
 * Copies data contents from a table
 * tSrc > Array to copy from
 * tSkp > Skipped fields list
 * tOny > Selected fields list
 * tAsn > Fields to use assignment for
 * tCpn > Fields to use table.Copy for
 * tDst > Destination table when provided
]]
local function CopyData(tSrc, tSkp, tOny, tAsn, tCpn, tDst)
  local tCpy = (tDst or {}) -- Destination data
  for nam, vsm in pairs(tSrc) do
    if((not tOny or (tOny and tOny[nam])) or
       (not tSkp or (tSkp and not tSkp[nam]))
    ) then -- Field is selected to be copied
      local typ = type(vsm) -- Read data type
      local fcn = gtCOPYCOV[typ] -- Constructor
      if(fcn) then -- Copy-conversion exists
        tCpy[nam] = fcn(vsm) -- Copy-convert
      else -- Table or other case
        if(tAsn and tAsn[nam]) then
          tCpy[nam] = vsm -- Assign enable for field
        elseif(tCpn and tCpn[nam]) then
          tCpy[nam] = table.Copy(vsm) -- General copy table
        else -- Unhandled field. Report error to the user
          error("Unhandled value ["..typ.."]["..nam.."]: "..tostring(vsm))
        end -- Assign a copy table
      end -- The snapshot is completed
  end; end; return tCpy
end



com.logTable(CopyData(t, nil, nil, {["a"]=true}), "COPY", nil, {["Vector"] = tostring, ["Angle"] = tostring})




