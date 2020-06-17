local dir = require("directories").setBase(1)
local com = require("common")



local test = function(m)
    local function split(s)
      local o, k = {s}, 1
      local f, b = o[k]:find("/")
      while(f and b) do
        o[k + 1] = o[k]:sub(b + 1, -1)
        o[k] = o[k]:sub(1, f -1):gsub("^%l", string.upper)
        k = k + 1; f, b = o[k]:find("/")
      end; o[k] = o[k]:gsub("^%l", string.upper); return o
    end; local r = m:gsub("models/joe/jtp/",""):gsub("[\\/]*([^\\/]+)$","")
    return ((r ~= "") and split(r) or nil)
  end
  
  
local m = "models/joe/jtz/aaa/bbb/4096_64_right.mdl"

print("lol", m:find("[\\/]([^\\/]+)$"))

com.logTable(test(m), "R")