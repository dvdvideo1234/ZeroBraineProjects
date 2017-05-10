local coState = {}
local mtState = {__index = coState, __type = "state"}
          
function coState:newState(nx, ny, bfix, bgho)
  
  local obj = {}
  obj.x  , obj.y   = (tonumber(nx) or 0), (tonumber(ny) or 0)
  obj.fix, obj.gho = (bfix and true or false), (bgho and true or false) -- Fixed, Transperent
  
  setmetatable(obj, mtState)
      
  return obj
end

function coState:getPosition() return self.x, self.y end
function coState:setPosition(nx, ny)  self.x, self.y = (tonumber(nx) or 0), (tonumber(ny) or 0) end

function coState:getFlags() return self.fix, self.gho end
function coState:setFlags(bfix, bgho) self.fix, self.gho = (bfix and true or false), (bgho and true or false) end

function coState:getType() return tostring(mtState.__type) end  

function coState:Dump()
  io.write("\n")
  io.write("Typ: "..tostring(self:getType()).."\n")
  io.write("Pos: "..tostring(self.x)..", "..tostring(self.y).."\n")
  io.write("Flg: "..tostring(self.fix)..", "..tostring(self.gho).."\n")
end

return coState