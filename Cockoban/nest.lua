-- What is a nest like, a nest object, where an egg should go
local egg = require("ZeroBraineProjects/Cockoban/egg")
local coNest = {}
local mtNest = {
  setDefault = function(self)
    self.fix = coNest.fix
    self.gho = coNest.gho
    self.ch  = coNest.ch; return self end,
  moveMe = function(self, dx, dy, dz) return self end, -- Nests cannot be moved
  setChar = function(self, ch) return self end,        -- Nests cannot change char direction
  getChar = function(self) return self.ch end,
  getType = function(self) return tostring(coNest.__type) end,
  dumpMe  = function(self, sN)
    local x,y,z = self:getPosition()
    if(sN) then io.write("\nNam: <"..tostring(sN)..">") end
    io.write("\nTyp: <"..tostring(self:getType()).."> ["..self:getChar().."]")
    io.write("\nFix: <"..tostring(self:isFixed())..">")
    io.write("\nFix: <"..tostring(self:isGhost())..">")
    io.write("\nPos: <"..tostring(x)..","..tostring(y)..","..tostring(z)..">")
    io.write("\n")
    return self
  end
}

coNest = egg:overState({ch="X",fix=true,gho=true},mtNest)
coNest.__type = egg:getType()..":nest"

return coNest
