local com = require("dvdlualib/common")
local gmd = require("dvdlualib/gmodlib")
require("../dvdlualib/asmlib")
local asmlib = trackasmlib

local tableConcat = table.concat

local mtVector = getmetatable(Vector())

--[[---------------------------------------------------------
Recalculates the orthogonality of an up vector according to the
other vector given as forward direction direction. The call
changes the self vector assigned as an up direction
 * self > The up direction being orthogonalized
 * vF   > The forward direction for the orthogonalization process
 * vR   > The function returns the right vector on success
Note: The normalization of the three vectors 
-----------------------------------------------------------]]
print(meta)

mtVector.__index = mtVector

mtVector.Orthogonal = function(self, vF, bN)
  local vR = vF:Cross(self)
  self:Set(vR:Cross(vF))
  if(bN) then
    vF:Normalize()
    vR:Normalize()
    self:Normalize()
  end
  return vR
end

local x = Vector(5,0,0)
local z = Vector(4,0,4)
local y = z:Orthogonal(x)
print(x)
print(y)
print(z)







