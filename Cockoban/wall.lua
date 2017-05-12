-- What is a nest like, a nest object, where an egg should go
local egg = require("ZeroBraineProjects/Cockoban/egg")
local coWall = {}
local mtWall = {
  moveMe = function(self, dx, dy, dz) return self end, -- Walls cannot be moved
  setDefault = function(self)
    self.fix = coWall.fix
    self.gho = coWall.gho
    self.ch  = coWall.ch; return self end,
  setChar = function(self, ch) return self end,        -- Walls cannot change char direction
  getChar = function(self) return self.ch end,
  setPosition = function(self, nx, ny) return self end,
  getType = function(self) return tostring(coWall.__type) end,
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

coWall = egg:overState({ch="#",fix=true,gho=false},mtWall)
coWall.__type = egg:getType()..":wall"

return coWall
