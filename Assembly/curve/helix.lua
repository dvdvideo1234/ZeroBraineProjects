local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
                .addBase("D:/Programs/LuaIDE")
                .addBase("C:/Programs/ZeroBraineIDE").setBase(2)
                
local complex = require("complex")
local common  = require("common")
local col     = require("colormap")
local crt     = require("chartmap")

local rev = "C:/Users/ddobromirov/Documents/Lua-Projs/VerControl/TrackAssemblyTool_GIT/lua/"
local bas = dir.getBase().."/ZeroBraineProjects/"

rawset(_G, "CLIENT", true)
rawset(_G, "SERVER", (not CLIENT))
require("gmodlib")

game.SinglePlayer(false)

local function CongigureLIB(sRev, bEnv)
  -- single source of truth
  dofile(sRev.."trackassembly/trackasmlib.lua")
  local asmlib = trackasmlib 
  if not asmlib then error("No library") end
  local tP = common.tableIndexProxy(asmlib, function(i, k, v)
    return ((k == "DIRPATH_BAS") and (bas.."Assembly/trackassembly/") or v)
  end)
  local gnIndependentUsed = bit.bor(FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_PRINTABLEONLY)
  local NewAsmConvar = asmlib.NewAsmConvar
  CreateConVar("trackassembly_logsmax", 1, gnIndependentUsed, "Maximum logging lines being written before the counter is reset", 0, 100000)
  CreateConVar("trackassembly_logsbrs", 0, gnIndependentUsed, "Maximum logging lines being written in every I/O write flush", 0, 100000)
  asmlib.NewAsmConvar = function(n, ...)
    if (n ~= "logsmax" and n ~= "logsbrs") then
      return NewAsmConvar(n, ...)
    end
  end
  dofile(sRev.."autorun/trackassembly_init.lua")
  asmlib.SetLogControl(1,0)
  for k, v in pairs(tP) do
    if(bEnv or not k:find("^%L")) then 
      asmlib.LogTable(asmlib, "asmlib")
      asmlib.LogTable(tP, "proxy")
      break
    end
  end
  return asmlib
end

local asmlib = CongigureLIB(rev)

asmlib.IsFlag("file_read_once", true)
asmlib.MODE_DATABASE = "LUA"
asmlib.IsModel = function(m) return isstring(m) end

-------- CUSTOM TEST --------
local turtle  = require("turtle")

local dX,dY = 1,1
local W , H = 800, 600
local minX, maxX = -20, 20
local minY, maxY = -20, 20
local greyLevel  = 200
local intX  = crt.New("interval","WinX", minX, maxX, 0, W)
local intY  = crt.New("interval","WinY", minY, maxY, H, 0)
local clGry = colr(greyLevel,greyLevel,greyLevel)
local clB = colr(col.getColorBlueRGB())
local clS = colr(col.getColorRedRGB())
local clH = colr(col.getColorMagenRGB())
local clBlk = colr(col.getColorBlackRGB())
local scOpe = crt.New("scope"):setInterval(intX, intY):setBorder(minX, maxX, minY, maxY)
      scOpe:setSize(W, H):setColor(clBlk, clGry):setDelta(dX, dY)

local oPly = LocalPlayer()
local vO   = Vector(0,0,0)
local aO   = Angle()--; aO:RotateAroundAxis(aO:Up(), 180)
local nA   = 90
local nR   = 5
local vD   = Vector(0,0,1)
local aD   = Angle()
local vT   = 4
local tO   = {}

local cO = complex.getNew(vO:Unpack())

local cD, vR = complex.getNew(aO:Forward():Unpack()), complex.getNew(vD:Unpack())
local tS, oB1 = complex.getCircleArc(cO, cD, nR, vR, nA, vT)

local tC = asmlib.CalculateHelixCurve(oPly, vO, aO, nA, nR + 1, vT, vD, aD)

local tH, tN, oB2, nN = tC.CNode, tC.CNorm, tC.Info.Ors[1], tC.MSize

local tP = tH

if(tS and tH) then
  common.logStatus("The distance between every grey line on X is: "..tostring(dX))
  common.logStatus("The distance between every grey line on Y is: "..tostring(dY))
  
  local cS, cE = complex.getNew(), complex.getNew()
  
  local function drawComplexLine(S, E, Cl)
    if(not (S and E)) then return end 
    local x1 = intX:Convert(S:getReal()):getValue()
    local y1 = intY:Convert(S:getImag()):getValue()
    local x2 = intX:Convert(E:getReal()):getValue()
    local y2 = intY:Convert(E:getImag()):getValue()
    pncl(Cl); line(x1, y1, x2, y2)
  end; complex.setAction("ab", drawComplexLine)
  
  local sName = "Spiral helix generation"
  open(sName)
  size(W,H); zero(0, 0); updt(false) -- disable auto updates

  local wTop = wx.wxGetApp():GetTopWindow()
  local fTop = wTop and wTop.FindWindowByLabel(sName)
  if(not fTop) then return end
  fTop:SetPosition(wx.wxPoint(2800, 100))
  
  scOpe:Draw(false, false, true, true)

  local x, y = oB1:getParts()
  scOpe:drawCircle(x, y, nR)
  local x, y = complex.getNew(oB2:Unpack()):getParts()
  scOpe:setColorOrg(clH)
  scOpe:drawCircle(x, y, nR + 1)

  local h, s = getmetatable(tH[1]), getmetatable(tS[1])
   
  for iD = 1, #tS do
    local vS, vE = tS[iD], tS[iD+1]
    scOpe:drawComplexPoint(vS, clS)
    vS:Action("ab", vE, clS)
    local iS = ((iD - 1) * nN + iD)
    local iE = (iS + nN)
    for iN = iS, iE do
      local vS, vE = tP[iN], tP[iN+1]
      if(vS) then --vS:Mul(10)
        cS:Set(vS:Unpack())
        scOpe:drawComplexPoint(cS, clH)
        if(vE) then --vE:Mul(10)
          cE:Set(vE:Unpack())
          cS:Action("ab", cE, clH)
        end
      end
      updt(); wait(0.01)
    end
    updt(); wait(0.1)
  end
  
  common.logTable(tC.Node , "HN3D", nil, {[h] = tostring})
  common.logTable(tC.CNode, "HM3D", nil, {[h] = tostring})
  
  wait()
else
  common.logStatus("Your curve parameters are invalid !")
end


