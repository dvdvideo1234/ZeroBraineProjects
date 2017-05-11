local coEgg = {__type = "egg", x=0, y=0, z=0, fix=false, gho=false}
local mtEgg = {} -- Make a proto-chicken for our chicken factory
      mtEgg.__index = {
        makeNew     = function(self, t)
            local o = t and t or {}
                  o = (type(t) ~= "table") and {t} or t
            o.x = tonumber(o.x) or coEgg.x
            o.y = tonumber(o.y) or coEgg.y
            o.z = tonumber(o.z) or coEgg.z
            o.fix = o.fix and true or false
            o.gho = o.gho and true or false
            return setmetatable(o or {}, {__index = self})
        end,
        overState   = function(self, t, methods)
            -- This is the heart of the inheritance: It says:
            -- Look it up in the methods table, and if it's not there, look it up in the parrent class (her called self)
            -- You pass this function the parent class (with :), a table of attributes and a table of methods.
            local mtnew={__index=setmetatable(methods, {__index = self})}
            return setmetatable(t or {}, mtnew)
        end,
        getType     = function(self) return tostring(coEgg.__type) end,
        getPosition = function(self) return self.x, self.y, self.z end,
        setPosition = function(self, nx, ny, nz)
          self.x = (tonumber(nx) or coEgg.x)
          self.y = (tonumber(ny) or coEgg.y)
          self.z = (tonumber(nz) or coEgg.z); return self end,
        isFixed = function(self) return self.fix end,
        isGhost = function(self) return self.gho end,  
        dumpMe  = function(self)
          local x,y,z = self:getPosition()
          io.write("\n")
          io.write("\nTyp: <"..tostring(self:getType())..">")
          io.write("\nFix: <"..tostring(self:isFixed())..">")
          io.write("\nFix: <"..tostring(self:isGhost())..">")
          io.write("\nPos: <"..tostring(x)..","..tostring(y)..","..tostring(z)..">")
          return self
        end
      }

return setmetatable(coEgg, mtEgg)