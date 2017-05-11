-- What is a nest like, a nest object, where an egg should go
local st = require("ZeroBraineProjects/Cockoban/egg")
local mtNest = {
  moveMe = function(self, dx, dy, dz) return self end, -- Nests cannot be moved
  setChar = function(self, ch) return self end,        -- Nests cannot change char direction
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

local coNest = st:overState({ch="X"},mtNest)
      coNest.__type = "nest"
      coNest.__type = coNest:getType()..":"..coNest.__type
      mtNest.getType = function(self) return tostring(coNest.__type) end

return coNest
