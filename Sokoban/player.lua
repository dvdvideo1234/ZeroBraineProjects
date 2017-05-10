local state = require("ZeroBraineProjects/Sokoban/state")

local coPlayer = {}
local mtPlayer = {}
      mtPlayer.__type  = "player > "..state:getType()
      mtPlayer.__proto = {fix=false, gho=false}
      mtPlayer.__index = coPlayer

function coPlayer:Move(dx,dy)
  local x, y = self:getPosition()
        x, y = x + dx, y + dy
  -- Pushing begin
  
  -- Pushing end
  self:setPosition(x,y)    
  if(dx > 0) then self.ch = ">" end
  if(dx < 0) then self.ch = "<" end
  if(dy > 0) then self.ch = "v" end
  if(dy < 0) then self.ch = "^" end
end

function coPlayer:getType() return tostring(mtPlayer.__type) end  

function coPlayer:Dump()
  io.write("\n")
  io.write("Typ: "..tostring(self:getType()).."\n")
  io.write("Pos: "..tostring(self.x)..", "..tostring(self.y).."\n")
  io.write("Flg: "..tostring(self.fix)..", "..tostring(self.gho).."\n")
end

function coPlayer:newPlayer(nx, ny)
  local obj = state:newState(nx, ny, mtPlayer.__proto.fix, mtPlayer.__proto.gho)
  local omt = getmetatable(obj)
  obj.ch = ">"
  
  logTable(omt, "omt")
  
  setmetatable(obj, mtPlayer)
  
  coPlayer.__index = omt.__index
  
  logStatus(nil,"MT: "..tostring(mtPlayer))
  
  return obj
end

return coPlayer