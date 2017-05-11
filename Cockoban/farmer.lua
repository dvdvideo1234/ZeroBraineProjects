local st = require("ZeroBraineProjects/Cockoban/egg")
local mtFarmer = {
  moveMe = function(self, dx, dy, dz)
    local x,y,z = self:getPosition()
          x,y,z = (x + (tonumber(dx) or 0)), (y + (tonumber(dy) or 0)), (z + (tonumber(dz) or 0))
    -- Check if we can move
    -- End the check
    self:setPosition(x,y,z)    
    if(dx > 0) then self.ch = ">" end
    if(dx < 0) then self.ch = "<" end
    if(dy > 0) then self.ch = "v" end
    if(dy < 0) then self.ch = "^" end
    if(dz > 0) then self.ch = "*" end
    if(dz < 0) then self.ch = "+" end
    return self
  end,
  setChar = function(self, ch) self.ch = tostring(ch or ">"):sub(1,1); return self end,
  getChar = function(self) return self.ch end,
  dumpMe  = function(self)
    local x,y,z = self:getPosition()
    io.write("\n")
    io.write("\nTyp: <"..tostring(self:getType()).."> ["..self:getChar().."]")
    io.write("\nFix: <"..tostring(self:isFixed())..">")
    io.write("\nFix: <"..tostring(self:isGhost())..">")
    io.write("\nPos: <"..tostring(x)..","..tostring(y)..","..tostring(z)..">")
    return self
  end
}

local coFarmer = st:overState({ch=">"},mtFarmer)
      coFarmer.__type = "farmer"
      coFarmer.__type = coFarmer:getType()..":"..coFarmer.__type
      mtFarmer.getType = function(self) return tostring(coFarmer.__type) end

return coFarmer
