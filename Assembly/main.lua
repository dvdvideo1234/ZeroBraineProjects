require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")
require("ZeroBraineProjects/dvdlualib/asmlib")

local stringExplode = string.Explode
local stringSub   =  string.sub
local stringFind  = string.find
local stringFormat = string.format

asmlib.InitBase("track","assembly")

asmlib.SetOpVar("MODE_DATABASE" , "SQL")

asmlib.CreateTable("PIECES",{
  --Timer = asmlib.TimerSetting(gaTimerSet[1]),
  Index = {{1},{4},{1,4}},
  [1] = {"MODEL" , "TEXT"   , "LOW", "QMK"},
  [2] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [3] = {"NAME"  , "TEXT"   ,  nil , "QMK"},
  [4] = {"LINEID", "INTEGER", "FLR",  nil },
  [5] = {"POINT" , "TEXT"   ,  nil ,  nil },
  [6] = {"ORIGIN", "TEXT"   ,  nil ,  nil },
  [7] = {"ANGLE" , "TEXT"   ,  nil ,  nil },
  [8] = {"CLASS" , "TEXT"   ,  nil ,  nil }
},true,true)

local defTable = asmlib.GetOpVar("DEFTABLE_PIECES")
 
asmlib.DefaultType("Test",[[function(m)]]) --[===[
    local r = m:gsub("models/bobsters_trains/rails/2ft/",""):gsub("_","/")
    local s = r:find("/"); r = (s and r:sub(1,s-1) or "other");
          r = r:gsub("^%l", string.upper); return r end]]) ]===]

asmlib.DefaultType("Bobster's two feet rails",[[function(m)
  local r = m:gsub("models/bobsters_trains/rails/2ft/",""):gsub("_","/")
  local s = r:find("/"); r = (s and r:sub(1,s-1) or "other");
        r = r:gsub("^%l", string.upper); return r end]])

---------------------------------------------------
function expCaegoty(sNam, vEq)
  local nEq = tonumber(vEq) or 0
  if(nEq <= 0) then
    return asmlib.StatusLog(nil, "Wrong equality <"..tostring(vEq)..">") end
  local sEq, nLen = ("="):rep(nEq), (nEq+2)
  local tCat = asmlib.GetOpVar("TABLE_CATEGORIES")
  local ioF  = fileOpen(sNam, "w")
  for cat, rec in pairs(tCat) do
    if(asmlib.IsString(rec.Txt)) then
      local exp = "["..sEq.."["..cat..sEq..rec.Txt.."]"..sEq.."]"
      if(not rec.Txt:find("\n")) then
        return asmlib.StatusLog(nil, "Category one-liner <"..cat..">") end
      ioF:write(exp.."\n")
    end
  end; ioF:flush(); ioF:close()
end

function impCategory(sNam, vEq)
  local nEq = tonumber(vEq) or 0
  if(nEq <= 0) then
    return asmlib.StatusLog(nil, "Wrong equality <"..tostring(vEq)..">") end
  local sEq, sLin, nLen = ("="):rep(nEq), "", (nEq+2)
  local cFr, cBk, sCh = "["..sEq.."[", "]"..sEq.."]", "X"
  local tCat = asmlib.GetOpVar("TABLE_CATEGORIES")
  local ioF, sPar, isPar = fileOpen(sNam, "r"), "", false
  while(sCh) do
    sCh = ioF:read(1)
    if(not sCh) then break end
    if(sCh == "\n") then
      if(sLin:sub(-1,-1) == "\r") then
        sLin = sLin:sub(1,-2) end
      local sFr, sBk = sLin:sub(1,nLen), sLin:sub(-nLen,-1)
      if(sFr == cFr and sBk == cBk) then
        return asmlib.StatusLog(nil, "Category one-liner <"..sLin..">")
      elseif(sFr == cFr and not isPar) then
        sPar, isPar = sLin:sub(nLen+1,-1).."\n", true
      elseif(sBk == cBk and isPar) then
        sPar, isPar = sPar..sLin:sub(1,-nLen-1), false
        local tBoo = stringExplode(sEq,sPar)
        local key, txt = tBoo[1], tBoo[2]
        if(key == "") then
          return asmlib.StatusLog(nil, "Name missing <"..txt..">") end
        if(not txt:find("function")) then
          return asmlib.StatusLog(nil, "Function missing <"..key..">") end
        tCat[key] = {}; tCat[key].Txt = txt
        tCat[key].Cmp = CompileString("return ("..txt..")",key)
      else
        sPar = sPar..sLin.."\n"
      end; sLin = ""
    else sLin = sLin..sCh end
  end; ioF:close()
  return tCat
end
---------------------------------------------------

expCaegoty("E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/ZeroBraineProjects/Assembly/cat.txt", 4)

--asmlib.SetOpVar("TABLE_CATEGORIES",{})

--logTable(impCategory("E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/ZeroBraineProjects/Assembly/cat.txt", 4),"tCat")

--expCaegoty("E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/ZeroBraineProjects/Assembly/cat2.txt", 4)


