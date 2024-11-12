local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local com = require("common")
io.stdout:setvbuf("no")

local par = {
  -- Key patterns being ignored when searching dor dupes
  dup_ign = { en = true, -- Enable ot disable the ignore
    "left%.%d", "right_use%.%d",
    "reload%.%d", "right%.%d", "reload_use%.%d"
  },
  prm_lng = "en",    -- English is primary gmod language
  cnt_len = 2,       -- How many symbols to display dupes count
  key_len = 60,      -- How many symbols to display keys
  prf_nam ="sync_",  -- Syncronization files prefix
  prf_too = "tool.trackassembly." -- Tool prefix for the keys
}

local res = {__index = {}, __en = {}, __key = {}, __dupe = {}}
local ssrc, isrc = dir.getBase()
local pth = dir.getNorm(com.stringGetChunkPath())
local prf = {"TrackAssemblyTool_GIT", "trackassembly"}

local src = {
  "D:/Games/Steam/steamapps/common/GarrysMod/garrysmod/addons",
  "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl"
}

local function getResource(sL)
  local sdir = src[isrc].."/"..prf[1].."/resource/localization/"..sL.."/"
  local snam = prf[2]..".properties"
  dir.cpyRec(snam, sL.."_ "..snam, sdir, pth.."/localization/")
  local R = assert(io.open(sdir..snam, "rb"))
  local L = R:read("*line"); res[sL] = {}; table.insert(res.__index, sL)
  while(L) do
    local M = L:find("=", 1, true)
    if(M) then
      local K = L:sub(1, M-1)
      local V = L:sub(M+1,-1)
      res[sL][K] = V
      if(sL == par.prm_lng) then
        local dp = res.__dupe[K]
        if(not dp) then
          res.__dupe[K] = {}
          dp = res.__dupe[K]
        end; table.insert(dp, V)
      end
    end
    L = R:read("*line")
  end; return res[sL]
end

dir.ersDir("localization", pth)
dir.newDir("localization", pth)

local tF = dir.conDir("localization", src[isrc].."/"..prf[1].."/resource/")

for iD = 1, #tF.Tree do
  local n = tF.Tree[iD].Name
  if(n:sub(1,1) ~= ".") then
    getResource(tF.Tree[iD].Name)
  end
end

for k, v in pairs(res[par.prm_lng]) do table.insert(res.__en, k) end
table.sort(res.__en)

do
  local F = assert(io.open(pth.."/localization/k_dupe.txt", "wb"))
  F:write("# Values having the same keys\n\n")
  for k, v in pairs(res.__dupe) do
    if(#v > 1) then
      for i = 1, #v do
        F:write(("%"..par.cnt_len.."d : %+"..par.key_len.."s : %s"):format(#v, k, v[i]).."\n")
      end
      F:write("\n")
    end
  end
  F:write("\n")
  F:flush()
  F:close()
end

do
  res.__dupe = {}
  for k, v in pairs(res[par.prm_lng]) do
    local dp = res.__dupe[v]
    if(not dp) then
      res.__dupe[v] = {}; dp = res.__dupe[v]
    end; table.insert(dp, k)
  end
  local F = assert(io.open(pth.."/localization/v_dupe.txt", "wb"))
  F:write("# Keys having the same value\n\n")
  for k, v in pairs(res.__dupe) do
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
          F:write(("%"..par.cnt_len.."d : %+"..par.key_len.."s : %s"):format(#v, v[i], k).."\n")
        end
        F:write("\n")
      end
    end
  end
  F:write("\n")
  F:flush()
  F:close()
end

for iL = 2, #res.__index do
  local N = res.__index[iL]
  local F = assert(io.open(pth.."/localization/"..par.prf_nam..N..".txt", "wb"))
  F:write("# New translations to be added to ["..N.."]\n\n")
  for iE = 1, #res.__en do
    local K = res.__en[iE]
    if(not res[N][K]) then
      F:write(K.."="..res[par.prm_lng][K].."\n")
    end
  end
  F:write("\n\n")
  F:flush()
  F:close()
end

for iL = 2, #res.__index do
  local N = res.__index[iL]; res.__key = {}
  local F = assert(io.open(pth.."/localization/"..par.prf_nam..N..".txt", "ab"))
  F:write("# The translations to be removed from ["..N.."]\n\n")
  for k, v in pairs(res[N]) do table.insert(res.__key, k) end
  table.sort(res.__key)
  for iE = 1, #res.__key do
    local K = res.__key[iE]
    if(not res[par.prm_lng][K]) then
      F:write(K.."="..res[N][K].."\n")
    end
  end
  F:write("\n\n")
  F:flush()
  F:close()
end

-- com.logTable(res)
