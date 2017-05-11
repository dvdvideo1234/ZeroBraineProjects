-- What is a nest like, a nest object, where an egg should go
local st = require("ZeroBraineProjects/Cockoban/egg")
local mtWall = {
  moveMe = function(self, dx, dy, dz) return self end, -- Walls cannot be moved
  setChar = function(self, ch) return self end,        -- WAlls cannot change char direction
  getChar = function(self) return self.ch end,
  setPosition = function(self, nx, ny) return self end,
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

local coWall = st:overState({ch="X"},mtWall)
      coWall.__type = "wall"
      coWall.__type = coWall:getType()..":"..coWall.__type
      mtWall.getType = function(self) return tostring(coWall.__type) end

return coWall
