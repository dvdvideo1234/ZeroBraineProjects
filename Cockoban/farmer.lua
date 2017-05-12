local egg = require("ZeroBraineProjects/Cockoban/egg")
local coFarmer = {}
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
  setDefault = function(self)
    self.fix = coFarmer.fix
    self.gho = coFarmer.gho
    self.ch  = coFarmer.ch; return self end,
  setChar = function(self, ch) self.ch = tostring(ch or ">"):sub(1,1); return self end,
  getChar = function(self) return self.ch end,
  getType = function(self) return tostring(coFarmer.__type) end,
  dumpMe  = function(self, sN)
    local x,y,z = self:getPosition()
    if(sN) then io.write("\nNam: <"..tostring(sN)..">") end
    io.write("\nTyp: <"..tostring(self:getType()).."> ["..self:getChar().."]")
    io.write("\nFix: <"..tostring(self:isFixed())..">")
    io.write("\nGho: <"..tostring(self:isGhost())..">")
    io.write("\nPos: <"..tostring(x)..","..tostring(y)..","..tostring(z)..">")
    io.write("\n")
    return self
  end
}

coFarmer = egg:overState({ch=">",fix=false,gho=false},mtFarmer)
coFarmer.__type  = egg:getType()..":farmer"

return coFarmer
