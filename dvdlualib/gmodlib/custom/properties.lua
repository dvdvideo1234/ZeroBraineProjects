local common      = require("common")
local directories = require("directories")

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

function properties.syncLocalizations(par)
  
  local res = {__index = {}, __primary = {}, __key = {}, __dupK = {}, __dupV = {}}
  
  local function setDupe(t, i, k, v)
    if(not t[i]) then t[i] = {} end -- Language wise
    if(not t[i][k]) then t[i][k] = {} end -- Keys wise
    table.insert(t[i][k], v)
  end
  
  local function getResource(sL)
    local sdir = par.run_src.."/"..par.prf_src[1].."/resource/localization/"..sL.."/"
    local snam = par.prf_src[2]..".properties"
    directories.cpyRec(snam, sL.."_ "..snam, sdir, par.run_pth.."/localization/orig/")
    local R = assert(io.open(sdir..snam, "rb"))
    local L = R:read("*line"); res[sL] = {}; table.insert(res.__index, sL)
    while(L) do
      local M = L:find("=", 1, true)
      if(M) then
        local K = L:sub(1, M-1)
        local V = L:sub(M+1,-1)
        res[sL][K] = V
        setDupe(res.__dupK, sL, K, V)
        setDupe(res.__dupV, sL, V, K)
      end
      L = R:read("*line")
    end; return res[sL]
  end

  directories.ersDir("localization", par.run_pth)
  directories.newDir("localization", par.run_pth)
  directories.newDir("orig", par.run_pth.."/localization")
  directories.newDir("sync", par.run_pth.."/localization")

  local tF = directories.conDir("localization", par.run_src.."/"..par.prf_src[1].."/resource/")

  getResource(par.prm_lng)

  for iD = 1, #tF.Tree do
    local n = tF.Tree[iD].Name
    if(n:sub(1,1) ~= "." and n ~= par.prm_lng) then
      getResource(n)
    end
  end

  for k, v in pairs(res[par.prm_lng]) do table.insert(res.__primary, k) end
  table.sort(res.__primary)

  do
    local F = assert(io.open(par.run_pth.."/localization/k_dupe.txt", "wb"))
    for l = 1, #res.__index do
      local n = res.__index[l]
      F:write("\n# Values having the same keys ["..n.."]\n\n")
      for k, v in pairs(res.__dupK[n]) do
        if(#v > 1) then
          for i = 1, #v do
            F:write(("%"..par.cnt_len.."d : %s : %s"):format(#v, common.stringPadR(k, par.key_len), v[i]).."\n")
          end
          F:write("\n")
        end
      end
    end
    F:write("\n")
    F:flush()
    F:close()
  end

  do
    local F = assert(io.open(par.run_pth.."/localization/v_dupe.txt", "wb"))
    for l = 1, #res.__index do
      local n = res.__index[l]
      local dp = res.__dupV[n]
      F:write("\n# Keys having the same value ["..n.."]\n\n")
      for k, v in pairs(dp) do
        local nv = #v
        if(nv > 1) then
          local dup_ign = false
          if(par.dup_ign.en) then
            local cnt_ign = 0
            for i = 1, nv do
              for j = 1, #par.dup_ign do
                if(v[i]:find(par.dup_ign[j])) then
                  cnt_ign = cnt_ign + 1
                end
              end
            end
            dup_ign = (cnt_ign == nv)
          end
          if(not dup_ign) then
            for i = 1, nv do
              F:write(("%"..par.cnt_len.."d : %s : %s"):format(#v, common.stringPadR(v[i], par.key_len), k).."\n")
            end
            F:write("\n")
          end
        end
      end
    end
    F:write("\n")
    F:flush()
    F:close()
  end

  for iL = 2, #res.__index do
    local N = res.__index[iL]
    local F = assert(io.open(par.run_pth.."/localization/sync/"..N..".txt", "wb"))
    F:write("\n# New translations to be added to ["..N.."]\n\n")
    for iE = 1, #res.__primary do
      local K = res.__primary[iE]
      if(not res[N][K]) then
        F:write(K.."="..res[par.prm_lng][K].."\n")
      end
    end
    F:flush()
    F:close()
  end

  for iL = 2, #res.__index do
    local N = res.__index[iL]; res.__key = {}
    local F = assert(io.open(par.run_pth.."/localization/sync/"..N..".txt", "ab"))
    F:write("\n# The translations to be removed from ["..N.."]\n\n")
    for k, v in pairs(res[N]) do table.insert(res.__key, k) end
    table.sort(res.__key)
    for iE = 1, #res.__key do
      local K = res.__key[iE]
      if(not res[par.prm_lng][K]) then
        F:write(K.."="..res[N][K].."\n")
      end
    end
    F:flush()
    F:close()
  end
end

return properties
