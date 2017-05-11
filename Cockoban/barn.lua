-- Where the chickens usually sleep and where the nests are stored. Used for level initalizing

local frm = require("ZeroBraineProjects/Cockoban/farmer")
local nst = require("ZeroBraineProjects/Cockoban/nest")
local wll = require("ZeroBraineProjects/Cockoban/wall")

local barnElements = {
  ["#"]   = "wall"        , -- Wall
  ["@"]   = "farmer"      , -- Farmer
  ["+"]   = "farmer/nest" , -- Farmer on a nest
  ["$"]   = "chicken"     , -- Chicken
  ["*"]   = "chicken/nest", -- Chicken on a nest
  ["."]   = "nest"        , -- Nest as is
  [" "]   = "floor"         -- Empty space     
}

local propList = {}

local makeElements = {
  ["wall"] = function(nx,ny) return wll.makeNew{x=nx,y=ny} end
}

barnElements.__index = barnElements[" "] -- All othe symbols are floors

local coBarn = {}

function coBarn.makeElement()
  
end

function coBarn.getElement(self, sE) return barnElements[tostring(sE or "")] end

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