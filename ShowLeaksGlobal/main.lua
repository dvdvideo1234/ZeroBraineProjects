local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local common = require("common")

local P = {
  O = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT/lua/trackassembly/trackasmlib.lua",
  M = "^[a-zA-Z].*=",
  N = {
    "local.*=",
    "self.*=",
    "[a-zA-Z].*>=",
    "[a-zA-Z].*<=",
    "[a-zA-Z].*==",
    "for.*=",
    "if.*=",
    "while.*=",
    ".*%[.*%].*=",
    "[%a_][%w_%.]*%s*%("
  },
  D = { -- Assume there are no globals between functions
    "^local.*=",
    "^local.*;",
    "^local.*$"
  },
  G = {}, -- Global local variables
  C = {}, -- Chunk local variables
  F = nil, -- Not yet a function
  A = nil  -- Function arguments
}

local F = assert(io.open(P.O, "rb"))
local R, N = F:read("*line"), 1
while(R) do
  R = common.stringTrim(R)
  if(R:find("function", 1, true) == 1) then
    common.tableDry(P.C)
    P.F = R:gsub("^function%s+", "")
    P.F = P.F:gsub("%(.+$", "")
    P.A = R:match("%(.*%)")
    if(not P.A) then
      P.A = R:match("%(.*$"):sub(2, -1)
      R, N = F:read("*line"), (N + 1)
      while(R) do
        R = common.stringTrim(R)
        local S, E = R:find(".*%)")
        if(S and E) then
          P.A = P.A .. R:sub(S, E - 1)
          break
        else
          P.A = P.A .. R
        end
      end
      R, N = F:read("*line"), (N + 1)
    end

    local V = common.stringExplode(P.A:sub(2, -2), ",")
    for iV = 1, #V do
      local U = common.stringTrim(V[iV])
      P.C[U] = true
    end
  end
  if(P.F) then -- While a function
    for iD = 1, #P.D do
      local nS, nE = R:find(P.D[iD])
      if(nS and nE) then
        local S = R:sub(nS, nE):gsub("local%s+", ""):gsub("%s*=", "")
        local V = common.stringExplode(S, ",")
        for iV = 1, #V do
          local U = common.stringTrim(V[iV])
          P.C[U] = true
        end
        break
      end
    end
  else
    for iD = 1, #P.D do
      local nS, nE = R:find(P.D[iD])
      if(nS and nE) then
        local S = R:sub(nS, nE):gsub("local%s+", ""):gsub("%s*=", "")
        local V = common.stringExplode(S, ",")
        for iV = 1, #V do
          local U = common.stringTrim(V[iV])
          P.G[U] = true
        end
        break
      end
    end
  end
  if(R:find(P.M)) then
    local bN = false
    for iD = 1, #P.N do
      if(R:find(P.N[iD])) then
        bN = true; break
      end
    end
    if(not bN) then
      local bR = false
      local S = R:gsub("%s*=.*$", "")
      local V = common.stringExplode(S, ",")
      for iV = 1, #V do
        local U = common.stringTrim(V[iV])
        U = U:gsub("%..*$", "")
        if(P.G[U] or P.C[U]) then bR = true; break end
      end
      if(not bR) then
        print(N,"|", P.F,"|", R)
      end
    end
  end
  R, N = F:read("*line"), (N + 1)
end

F:close()