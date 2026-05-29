local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
                
local com = require("common")
local rev = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT/lua/"

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", false)
require("gmodlib")

local function CongigureLIB(sRev)
  print("----------------LIBS----------------")
  -- single source of truth
  dofile(sRev.."trackassembly/trackasmlib.lua")
  local asmlib = trackasmlib 
  if not asmlib then error("No library") end
  local oservr = asmlib.SetOpVar
  asmlib.SetOpVar = function(n, v)
    if n ~= "DIRPATH_BAS" then
      return oservr(n, v)
    else
      print("CUSTOM-VAR", n)
      return oservr(n, "Assembly/trackassembly/")
    end
  end
  -- _G.SetOpVar = asmlib.SetOpVar
  print("SetOpVar 0 identity:", SetOpVar)
  print("SetOpVar 1 identity:", _G.SetOpVar)
  print("SetOpVar 2 identity:", asmlib.SetOpVar)
  print("SetOpVar 3 identity:", trackasmlib.SetOpVar)
  print("----------------INIT----------------")
  -- init must operate on the SAME instance
  dofile(sRev.."autorun/trackassembly_init.lua")
  return asmlib
end

local asmlib = CongigureLIB(rev)
asmlib.SetLogControl(20000, false)

asmlib.IsFlag("file_read_once", false)
asmlib.SetOpVar("MODE_DATABASE", "LUA")
asmlib.IsModel = function(m) return isstring(m) end

-------- CUSTOM TEST --------

require("Assembly/autorun/z_autorun_[shinji85_s_rails]")

asmlib.ImportDSV("PIECES", true, "shinji85_s_rails")

local oM = "models/shinji85/train/rail_l_switch.mdl"
local tS = {"BEFORE", "AFTER"}

local function logPrint(SD, TY, ...)
  asmlib.LogInstance(asmlib.GetReport(SD, TY, ...))
end

local oR = asmlib.CacheQueryPiece(oM)
if(oR) then 
  local iD, iO = 3, "P"
  local oP = oR.Offs[iD]
  if(oP and oP[iO]) then
    asmlib.LogTable(oR, tS[1])
    asmlib.LocatePOA(oR, 1)
    asmlib.LogTable(oR, tS[2])
  end
else
  asmlib.LogIstance("Model missing: "..oM)
end

local foo1 = {}
local foo2 = {}
local foo3 = {}
local foo4 = {}

foo1[1] = string.GetFileFromFilename
foo2[1] = string.GetPathFromFilename
foo3[1] = string.GetExtensionFromFilename
foo4[1] = string.StripExtension

function string.StripExtension(path)
    for i = #path, 1, -1 do
        local c = path:byte(i)

        if c == 47 or c == 92 then -- / or \
            return path
        elseif c == 46 then -- .
            return path:sub(1, i - 1)
        end
    end

    return path
end

function string.GetFileFromFilename(path)
    for i = #path, 1, -1 do
        local c = path:byte(i)

        if c == 47 or c == 92 then -- / or \
            return path:sub(i + 1)
        end
    end

    return path
end

function string.GetExtensionFromFilename(path)
    for i = #path, 1, -1 do
        local c = path:byte(i)

        if c == 47 or c == 92 then -- / or \
            return nil
        end

        if c == 46 then -- .
            return path:sub(i + 1)
        end
    end

    return nil
end

function string.GetPathFromFilename(path)
    for i = #path, 1, -1 do
        local c = path:byte(i)

        if c == 47 or c == 92 then -- / or \
            return path:sub(1, i)
        end
    end

    return ""
end

foo1[2] = string.GetFileFromFilename
foo2[2] = string.GetPathFromFilename
foo3[2] = string.GetExtensionFromFilename
foo4[2] = string.StripExtension

local t = {
"/aaa/bbb/ccc/te.st.mdl",
"aaa/bbb/ccc/te.st.mdl",
"/bbb/ccc/te.st.mdl",
"bbb////cc/te.st.mdl",
"/ccc/te.st.mdl",
"ccc///te.st.mdl",
"/te.st.mdl",
"te.st.mdl",
"te.st",
".mdl",
"."
}


function compare(bar)
  print("----------")
  print(bar[1], "~=", bar[2])
  for i = 1, #t do
    local o = bar[1](t[i])
    local n = bar[2](t[i])
    print(o == n, o, " = ", n)
  end
end

compare(foo1)
compare(foo2)
compare(foo3)
compare(foo4)



