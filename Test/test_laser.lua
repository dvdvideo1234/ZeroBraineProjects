local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)
      
local com = require("common")

require("gmodlib")
require("laserlib")

local prop  = ents.Create("prop_physics")
local entity = ents.Create("gmod_laser")
local trace = util.TraceLine()

local DATA = {KEYD = LaserLib.GetData("KEYD")}

local function GetMaterialEntry(mat, set)
  if(not mat) then return nil end
  if(not set) then return nil end
  local mat = tostring(mat):lower()
  -- Read the first entry from table
  local key, val = mat, set[mat]
  -- Check for overriding with default
  if(mat == DATA.KEYD) then return set[val], val end
  -- Check for element overrides found
  if(val) then return val, key end
  -- Check for disabled entry (false)
  if(val ~= nil) then return nil end
  -- Check for miss element category (nil)
  for idx = 1, set.Size do key = set[idx]
    if(mat:find(key)) then -- Cache the material
      set[mat] = set[key] -- Cache the material found
      return set[mat], key -- Compare the entry
    end -- Read and compare the next entry
  end; set[mat] = (val ~= nil) -- Undefined material
  return nil -- Return nothing when not found
end

local gtREFRACT = LaserLib.DataRefract("*")
local k1 = "models/1props_combine/stasisshield_sheet"
local k2 = "phoenix_storms/glass1"

local function test(n, k)
  print("["..n.."] Test:")
  local a = GetMaterialEntry(k, gtREFRACT)
  if(a) then
    print("["..n.."] Y:", a, a.Key, a.ID, a[1])
  else
    print("["..n.."] N:", a)
    print("["..n.."] K:", k, gtREFRACT[k])
  end
end

test(1, "models/props_combine/stasisshield_sheet")
test(2, "models/1props_combine/stasisshield_sheet")
test(3, "models/1props_combine/stasisshield_sheet")
test(4, "phoenix_storms/glass")
test(5, "phoenix_storms/glass1")
test(6, "phoenix_storms/glass1")

