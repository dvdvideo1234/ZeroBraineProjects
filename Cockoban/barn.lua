-- Where the chickens usually sleep and where the nests are stored. Used for level initalizing

local frm = require("ZeroBraineProjects/Cockoban/farmer")
local nst = require("ZeroBraineProjects/Cockoban/nest")
local wll = require("ZeroBraineProjects/Cockoban/wall")
local ckn = require("ZeroBraineProjects/Cockoban/chicken")

local coBarn = {} -- The library name

-- Only these that use space
local gtLevelElements = {
  ["wall"]    = {},
  ["chicken"] = {},
  ["nest"]    = {},
  ["farmer"]  = {}
}

local gtBarnElements = {
  ["#"]   = "wall"        , -- Wall
  ["@"]   = "farmer"      , -- Farmer
  ["+"]   = "farmer/nest" , -- Farmer on a nest
  ["$"]   = "chicken"     , -- Chicken
  ["*"]   = "chicken/nest", -- Chicken on a nest
  ["."]   = "nest"        , -- Nest as is
  [" "]   = "floor"         -- Empty space     
}
gtBarnElements.__index = gtBarnElements[" "] -- All othe symbols are floors

local gtMakeElements = {
  ["wall"] = function(nx,ny)
    local o = wll.makeNew{x=nx,y=ny}
          o:setDefault(); return o end
  ["farmer"] = function(nx,ny)
    local o = frm.makeNew{x=nx,y=ny}
          o:setDefault(); return o end
  ["chicken"] = function(nx,ny)
    local o = ckn.makeNew{x=nx,y=ny}
          o:setDefault(); return o end
  ["nest"] = function(nx,ny)
    local o = nst.makeNew{x=nx,y=ny}
          o:setDefault(); return o end
  ["floor"] = function(nx, ny) return nil end -- Do not creae anything
  ["__index"] = function(nx, ny) return nil end -- Do not creae anything
}

function coBarn.makeElement(selm, nx, ny)
  return gtMakeElements[selm](nx, ny)
end

function coBarn.getElement(self, sE) return gtBarnElements[tostring(sE or ""):sub(1,1)] end

coBarn.getParts = function(self, sF)
  local sNam = tostring(sF or "")
  local fIo = io.open(sNam, "rb")
  if(not fIo) then
    io.write("Barn not found: "..sNam); return nil end
  local sLne, iNum = fIo:read(), 1
  while(sLne) do
    local iCnt = 1
    local sCh  = sLne:sub(iCnt,iCnt)
    while(sCh ~= "") do
      local tMak = self:getElement(sCh)
      iCnt = iCnt + 1
      sCh  = sLne:sub(iCnt,iCnt)
    end
    io.write("\nLine <"..sLne..">")
    sLne, iNum = fIo:read(), (iNum + 1)
  end
end

return coBarn