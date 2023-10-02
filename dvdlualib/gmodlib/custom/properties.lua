local common = require("common")

local properties = {}

local mtList = {}
      mtList.__index = mtList
function properties.newList()
  local self = {}; setmetatable(self, mtList)
        self.BOM = {0xEF, 0xBB, 0xBF} -- UTF-8-BOM
        self.BOM.Size = #self.BOM -- BOM size
        self.Prop = "resource/localization/"
  return self
end

function mtList:toPath(dir)
  local dir = tostring(dir or "")
        dir = dir:gsub("\\","/")
        dir = dir:gsub("/+","/")
  if(dir:sub(-1,-1) ~= "/") then
    dir = dir.."/"
  end
  if(dir:sub(1, 1) == "/") then
    dir = dir:sub(2,-1)
  end
  return dir
end

function mtList:setBase(dir)
  self.Base = self:toPath(dir)
  return self
end

function mtList:recItem(dir, nam, ...)
  table.insert(self, {
    Dir = tostring(dir or ""), Tran = {...},
    Name = (type(nam) ~= "table") and {tostring(nam)} or nam
  })
  self.Size = (tonumber(self.Size) or 0) + 1
  self[self.Size].Tran.Size = #self[self.Size].Tran
  self[self.Size].Name.Size = #self[self.Size].Name
  return self
end

function mtList:isPath(src)
  local f = assert(io.open(src, "r"))
  local r, t, b = f:read("*line"), {}, 0
  local q = src:gsub(self.Base, "")
  for i = 1, self.BOM.Size do -- Remove BOM
    if(r:byte() == self.BOM[i]) then
      r, b = r:sub(2, -1), (b + 1)
    end
  end -- Compare without BOM
  if(b ~= self.BOM.Size) then
    error("Byte mask order mismatch ["..b..":"..self.BOM.Size.."]["..q.."]["..r.."]") end
  if(r and r:len() > 0) then
    error("First row must be empty ["..q.."]["..r.."]") end
  while(r) do
    local n = common.stringTrim(r)
    if(n:len() > 0 and n:sub(1,1) ~= "#") then
      local se, ee = n:find("=+")
      if(not se) then error("Equals sign missing ["..q.."]["..r.."]") end
      if(se ~= ee) then error("Equals sign longer ["..q.."]["..r.."]") end
      if(select(2, n:gsub("=","|")) > 1) then
        error("Equals sign multiple ["..q.."]["..r.."]") end
      local key, dat = n:sub(1,se-1), n:sub(ee+1,-1)
      if(t[key]) then error("Key exists at ["..q.."]["..r.."]") end
      local ic, sc = 1, select(1, n:find(":", 1, true))
      while(sc) do
        local es = n:sub(sc-1, sc-1); if(es ~= "\\") then
          error("Colon not escaped ["..ic.."]["..q.."]["..r.."]") end
        sc, ic = select(1, n:find(":", sc + 1, true)), (ic + 1)
      end; t[key] = true
    end
    r = f:read("*line")
  end
  f:close()
  return self
end

function mtList:isItems()
  for i = 1, self.Size do
    local v = self[i]
    for n = 1, v.Name.Size do
      print("Checking: "..v.Name[n].."@"..v.Dir)
      for k = 1, v.Tran.Size do
        local p = self.Base..v.Dir.."/"..
                  self.Prop..v.Tran[k]..
                  "/"..v.Name[n]..".properties"
        self:isPath(p)
        print("OK: "..p)
      end
    end
  end; return self
end

return properties

