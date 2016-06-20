local lifelib   = {}

local pairs     = pairs
local tonumber  = tonumber
local tostring  = tostring
local type      = type
local io        = io
local string    = string
local metaShape = {}
local metaField = {}

--------------------------- ALIVE / DEAD / PATH -------------------------------

local Aliv = "O"
local Dead = "-"
local ShapePath = "game-of-life/shapes/"

lifelib.charAliv = function (sA)
  if(not sA) then return Aliv end
  local sA = string.sub(tostring(sA),1,1)
  if(sA ~= "" and sA ~= Dead) then Aliv = sA; return true end
  return false
end

lifelib.charDead = function(sD)
  if(not sD) then return Dead end
  local sD = string.sub(tostring(sD),1,1)
  if(sD ~= "" and sD ~= Aliv) then Dead = sD; return true end
  return false
end

lifelib.shapesPath = function(sData)
  if(not sData) then return ShapePath end
  local Typ = type(sData)
  if(Typ == "string" and sData ~= "") then ShapePath = sData; return true end
  return false
end

--------------------------- RULES -------------------------------

lifelib.getDefaultRule = function() -- Conway
  return { Name = "B3/S23", Data = { B = {3}, S = {2,3} } }
end

lifelib.getRuleBS = function(sStr)
  local cB, cS
  local BS = {B = {}, S = {}}
  local Len = string.len(sStr)
  local BI, bI, sI = 1, 1, 1
  local SI = string.find(sStr,"/")
  if(SI == nil) then return nil end
  SI = SI + 1
  while(cS ~= "" and cB ~= "/") do
    cB = string.sub(sStr,BI,BI)
    cS = string.sub(sStr,SI,SI)
    if(cB ~= "/") then
      if(tonumber(cB)) then
        BS.B[bI] = tonumber(cB)
        bI = bI + 1
      end; BI = BI + 1
    end
    if(cS ~= "") then
      if(tonumber(cS)) then
        BS.S[sI] = tonumber(cS)
        sI = sI + 1
      end; SI = SI + 1
    end
  end
  if(BS.B[1] and BS.S[1]) then return BS end
  return nil
end

lifelib.getRleSettings = function(sStr)
  local Cpy = sStr..","
  local Len = string.len(Cpy)
  local Che = ""
  local Exp = {}
  local S = 1
  local E = 1
  local Key
  while(E <= Len) do
    Che = string.sub(Cpy,E,E)
    if(Che == "=") then
      Key = StrTrimSpaces(string.sub(Cpy,S,E-1))
      S = E + 1
      E = E + 1
    elseif(Che == ",") then
      Exp[Key] = StrTrimSpaces(string.sub(Cpy,S,E-1))
      S = E + 1
      E = E + 1
    end
    E = E + 1
  end
  return Exp
end

------------------- SHAPE INIT --------------------

local function copyShape(argShape,w,h)
  if(not argShape) then return false end
  if(not (w and h)) then return false end   
  if(not (w > 0 and h > 0)) then return false end   
  Rez = arMalloc2D(w,h)
  for i = 0,h-1 do for j = 0,w-1 do
      Rez[i+1][j+1] = tonumber(argShape[i*w+j+1]) or 0
  end end; return Rez
end

local function initStruct(sName)
  local Shapes = {
  ["heart"]       = { 1,0,1,
                      1,0,1,
                      1,1,1;
                      w = 3, h = 3 },
  ["glider"]      = { 0,0,1,
                      1,0,1,
                      0,1,1;
                      w = 3, h = 3 },
  ["explode"]     = { 0,1,0,
                      1,1,1,
                      1,0,1,
                      0,1,0;
                      w = 3, h = 4 },
  ["fish"]        = { 0,1,1,1,1,
                      1,0,0,0,1,
                      0,0,0,0,1,
                      1,0,0,1,0;
                      w = 5, h = 4 },
  ["butterfly"]   = { 1,0,0,0,1,
                      0,1,1,1,0,
                      1,0,0,0,1,
                      1,0,1,0,1,
                      1,0,0,0,1;
                      w = 5, h = 5 },
  ["glidergun"]   = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
                     0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
                     1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                     1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
                     w = 36,h = 9},
  ["block"]       = {1,1,1,1;
                     w = 2, h = 2},
  ["blinker"]     = {1,1,1;
                     w = 3, h = 1},
  ["r_pentomino"] = {0,1,1,
                     1,1,0,
                     0,1,0;
                     w = 3, h = 3},
  ["pulsar"]      ={0,0,1,1,1,0,0,0,1,1,1,0,0,
                    0,0,0,0,0,0,0,0,0,0,0,0,0,
                    1,0,0,0,0,1,0,1,0,0,0,0,1,
                    1,0,0,0,0,1,0,1,0,0,0,0,1,
                    1,0,0,0,0,1,0,1,0,0,0,0,1,
                    0,0,1,1,1,0,0,0,1,1,1,0,0,
                    0,0,0,0,0,0,0,0,0,0,0,0,0,
                    0,0,1,1,1,0,0,0,1,1,1,0,0,
                    1,0,0,0,0,1,0,1,0,0,0,0,1,
                    1,0,0,0,0,1,0,1,0,0,0,0,1,
                    1,0,0,0,0,1,0,1,0,0,0,0,1,
                    0,0,0,0,0,0,0,0,0,0,0,0,0,
                    0,0,1,1,1,0,0,0,1,1,1,0,0;
                    w = 13, h = 13}
  }
  return Shapes[string.upper(sName)]
end

local function initStringText(sStr,sDel)
  local sStr = tostring(sStr or "")
  local sDel = string.sub(tostring(sDel or "\n"),1,1)
  local Rows = StrExplode(sStr,sDel)
  local Rall = StrImplode(Rows) 
  local Shape = {w = string.len(Rows[1]), h = #Rows}
  for k = 1,(Shape.w * Shape.h) do
    Shape[k] = (string.sub(Rall,k,k) == Aliv) and 1 or 0
  end; return Shape
end

local function initStringRle(sStr, sDel, sEnd)
  local nS, nE, Ch
  local Cnt, Ind, Lin = 1, 1, true
  local Len = string.len(sStr)
  local Num, toNum, isNum = 0, 0, false
  local Shape = {w = 0, h = 0}
  local sDel = string.sub(tostring(sDel or "$"),1,1)
  local sEnd = string.sub(tostring(sEnd or "!"),1,1)
  while(Cnt <= Len) do
    Ch = string.sub(sStr,Cnt,Cnt)
    if(Ch == sEnd) then Shape.h = Shape.h + 1; break end
    toNum = tonumber(Ch)
    if(not isNum and toNum) then
      -- Start of a number
      isNum = true; nS = Cnt
    elseif(not toNum and isNum) then
      -- End of a number
      isNum = false; nE = Cnt - 1
      Num   = tonumber(string.sub(sStr,nS,nE)) or 0
    end
    if(Num > 0) then
      if(Lin) then Shape.w = Shape.w + Num end
      while(Num > 0) do
        Shape[Ind] = (((Ch == Aliv) and 1) or 0)
        Ind = Ind + 1
        Num = Num - 1
      end; 
    elseif(Ch ~= sDel and
           Ch ~= sEnd and not isNum) then
      if(Lin) then Shape.w = Shape.w + 1 end
      Shape[Ind] = (((Ch == Aliv) and 1) or 0)
      Ind = Ind + 1
    elseif(Ch == sDel) then Shape.h = Shape.h + 1; Lin = false end
    Cnt = Cnt + 1
  end; return Shape
end

local function initFileLif105(sName)
  local N = ShapePath.."lif/"..string.lower(sName).."_105.lif"; F = io.open(N,"r")
  if(not F) then LogLine("initFileLif105: Invalid file: <"..N..">"); return nil end
  local Line, Ind = "", 1
  local FilePos
  local Shape = {
    w = 0,
    h = 0,
    Header = {},
    Offset = {
      Cent = {}
    }
  }
  while(Line) do
    Line = StrTrimSpaces(F:read())
    if(not Line) then break end
    if(Line == "") then break end
    cFirst = string.sub(Line,1,1)
    leLine = string.len(Line)
    if(cFirst == "#") then
      FilePos = F:seek("cur",0)
      local cSecond = string.sub(Line,2,2)
      if(cSecond == "P") then
        local sCoord = StrTrimSpaces(string.sub(Line,3,leLine))
        local Center = string.find(sCoord," ")
        Shape.Offset.Cent[1] = -tonumber(string.sub(sCoord,1,Center-1))
        Shape.Offset.Cent[2] = -tonumber(string.sub(sCoord,Center+1,string.len(sCoord)))
      else Shape.Header[Ind] = string.sub(Line,2,leLine); Ind = Ind + 1 end
    elseif(cFirst == Aliv or cFirst == Dead) then
      Shape.h = Shape.h + 1
      if(leLine >= Shape.w) then Shape.w = leLine end
    end
  end
  Line, Ind = "", 1
  F:seek("set",FilePos)
  for y = 1,Shape.h do 
    Line = StrTrimSpaces(F:read())
    if(not Line) then break end
    for x = 1,Shape.w do
      cFirst = string.sub(Line,x,x)
      if(cFirst == Aliv) then Shape[Ind] = 1
      else Shape[Ind] = 0 end; Ind = Ind + 1
    end  
  end; F:close(); return Shape
end

local function initFileLif106(sName)
  local N = ShapePath.."lif/"..string.lower(sName).."_106.lif"; F = io.open(N,"r")
  if(not F) then LogLine("initFileLif106: Invalid file: <"..N..">"); return nil end
  local FilePos
  local Line, Ind = "", 1
  local MinX, MaxX, MinY, MaxY, x, y
  local Shape = {
    w      = 0,
    h      = 0,
    Header = {},
    Offset = {
      Cent = {},
      TopL = {},
      TopR = {},
      BotL = {},
      BotR = {}
    }
  }
  while(Line) do
    Line = StrTrimSpaces(F:read())
    if(not Line) then break end
    if(Line == "") then break end
    cFirst = string.sub(Line,1,1)
    leLine = string.len(Line)
    if(not (tonumber(cFirst) or cFirst == "+" or cFirst == "-" )) then
      FilePos = F:seek("cur",0)
      Shape.Header[Ind] = string.sub(Line,2,leLine) or ""
      Ind = Ind + 1
    else
      Ind = string.find(Line,"%s")
      if(MinX and MaxX and MinY and MaxY and x and y) then
        x = tonumber(string.sub(Line,1,Ind-1))
        y = tonumber(string.sub(Line,Ind+1,leLine))
        if(x and y) then
          if(x > MaxX) then MaxX = x end
          if(x < MinX) then MinX = x end
          if(y > MaxY) then MaxY = y end
          if(y < MinY) then MinY = y end
        else LogLine("Coordinates conversion failed !"); return nil end
      else
        x = tonumber(string.sub(Line,1,Ind-1)) or 0
        y = tonumber(string.sub(Line,Ind+1,leLine)) or 0
        MaxX, MinX = x, x
        MaxY, MinY = y, y
      end      
    end
  end
  Shape.w = MaxX - MinX + 1
  Shape.h = MaxY - MinY + 1
  Shape.Offset.TopL = { MinX, MinY } 
  Shape.Offset.TopR = { MaxX, MinY } 
  Shape.Offset.BotL = { MinX, MaxY } 
  Shape.Offset.BotR = { MaxX, MaxY } 
  Shape.Offset.Cent = { 
    math.floor(Shape.w/2),
    math.floor(Shape.h/2)
  }
  Line = ""
  F:seek("set",FilePos)
  while(Line) do
    Line = StrTrimSpaces(F:read())
    if(not Line) then break end
    if(Line == "") then break end
    cFirst = string.sub(Line,1,1)
    leLine = string.len(Line)
    Ind    = string.find(Line,"%s")
    x = tonumber(string.sub(Line,1,Ind-1))
    y = tonumber(string.sub(Line,Ind+1,leLine))
    if(x and y) then
      Shape[(Shape.Offset.Cent[2]+y)*Shape.w+Shape.Offset.Cent[1]+x+1] = 1
    else LogLine("Convert failed: >"..Line.."<"); return nil end
  end
  Ind = 1 
  while(Ind <= Shape.w * Shape.h) do
    if(not Shape[Ind]) then Shape[Ind] = 0 end
    Ind = Ind + 1
  end; F:close(); return Shape
end

local function initFileRle(sName)
  local N = ShapePath.."rle/"..string.lower(sName)..".rle"; F = io.open(N,"r")
  if(not F) then LogLine("initFileRle: Invalid file: <"..N..">"); return nil end
  local FilePos, ChCnt, leLine
  local Line, cFirst =  "",  ""
  local nS, nE, Ind, Cel = 1, 1, 1, 1
  local Num, isNum, toNum = 0, false, nil
  local Shape = {w = 0, h = 0, Rule = { Name = "", Data = {}}, Header = {}}
  while(Line) do
    Line = StrTrimSpaces(F:read())
    if(not Line)   then break end
    if(Line == "") then break end
    cFirst = string.sub(Line,1,1)
    leLine = string.len(Line)
    if(cFirst == "#") then
      FilePos = F:seek("cur",0)
      Shape.Header[Ind] = string.sub(Line,2,leLine)
      Ind = Ind + 1
    elseif(cFirst == "x") then
      FilePos = F:seek("cur",0)
      local Settings = lifelib.getRleSettings(Line)
      Shape.w = tonumber(Settings["x"])
      Shape.h = tonumber(Settings["y"])
      Shape.Rule.Name = Settings["rule"]
      Shape.Rule.Data = lifelib.getRuleBS(Shape.Rule.Name)
    end
  end
  Line = ""
  F:seek("set",FilePos)
  while(Line) do
    Line = StrTrimSpaces(F:read())
    if(not Line)   then break end
    if(Line == "") then break end
    nS, nE, ChCnt = 1, 1, 1
    leLine = string.len(Line)
    while(ChCnt <= leLine) do
      cFirst = string.sub(Line,ChCnt,ChCnt)
      if(cFirst == "!") then break end
      toNum = tonumber(cFirst)
      if    (not isNum and toNum) then isNum = true ; nS = ChCnt -- Start of a number
      elseif(not toNum and isNum) then isNum = false; nE = ChCnt - 1 -- End of a number
        Num = tonumber(string.sub(Line,nS,nE)) or 0 end
      if(Num > 0) then
        while(Num > 0) do
          Shape[Cel] = (((cFirst == Aliv) and 1) or 0)
          Cel = Cel + 1; Num = Num - 1
        end
      elseif(cFirst ~= "$" and cFirst ~= "!" and not isNum ) then
        Shape[Cel] = (((cFirst == Aliv) and 1) or 0); Cel = Cel + 1
      end; ChCnt = ChCnt + 1
    end
  end; F:close(); return Shape
end

local function initFileCells(sName)
  local N = ShapePath.."cells/"..string.lower(sName)..".cells"; F = io.open(N,"r")
  if(not F) then LogLine("initFileCells: Invalid file: <"..N..">"); return nil end
  local FilePos
  local Firs, Line = "", ""
  local x, y, Lenw, Ind = 0, 0, 0, 1
  local Shape = {w = 0, h = 0, Header = {}}
  while(Line) do
    Line = StrTrimSpaces(F:read())
    if(not Line) then break end
    Firs = string.sub(Line,1,1)
    Lenw = string.len(Line)
    if(Firs ~= "!") then
      Shape.h = Shape.h + 1
      if(Lenw >= Shape.w) then Shape.w = Lenw end
    else
      Shape.Header[Ind] = string.sub(Line,2,Lenw)
      FilePos = F:seek("cur",0)
    end
  end
  Line, Ind = "", 1
  F:seek("set",FilePos)
  for y = 1,Shape.h do
    Line = F:read()
    if(not Line) then break end
    for x = 1,Shape.w do
      Firs = string.sub(Line,x,x)
      if(Firs == Aliv) then Shape[Ind] = 1
      else Shape[Ind] = 0 end
      Ind = Ind + 1
    end  
  end; F:close(); return Shape
end

local function drawConsole(F)
  local tArr = F:getArray()
  local fx   = F:getW()
  local fy   = F:getH()
  LogLine("Generation: "..(F:getGenerations() or "N/A"))
  local Line="" 
  for y = 1, fy do for x = 1, fx do
      Line = Line..(((tArr[y][x]~=0) and Aliv) or Dead)
  end; LogLine(Line); Line = "" end
end

local function getSumStatus(nStatus,nSum,tRule)
  if(nStatus == 1) then -- Check survive
    for _, v in ipairs(tRule.Data["S"]) do
      if(v == nSum) then return 1 end
    end; return 0
  elseif(nStatus == 0) then -- Check born
    for _, v in ipairs(tRule.Data["B"]) do
      if(v == nSum) then return 1 end
    end; return 0
  end
end
  --[[
   * Creates a field object used for living environment for the shapes ( organisms )
  ]]-- 
lifelib.makeField = function(w,h,sRule)  
  local self  = {}
  local w = tonumber(w) or 0
        w = (w >= 1) and w or 1
  local h = tonumber(h) or 0
        h = (h >= 1) and h or 1
  local Gen, Rule = 0
  local Old = arMalloc2D(w,h) 
  local New = arMalloc2D(w,h)
  local Draw = {["text"] = drawConsole}   
  if(type(sRule) ~= "string") then
    Rule = lifelib.getDefaultRule()
  else
    Rule = {}
    Rule.Name = sRule
    Rule.Data = getRuleBS(sRule)
    if(Rule.Data == nil) then
      LogLine("Field creator: Please redefine your life rule !")
      return nil
    end
  end
  --[[
   * Internal data primitives
  ]]-- 
  function self:getW() return w end 
  function self:getH() return h end
  function self:getSellCount() return (w * h) end
  function self:getRuleName() return Rule.Name end
  function self:getRuleData() return Rule.Data end  
  function self:shiftXY (nX,nY) arShift2D (Old,w,h,(tonumber(nX) or 0),(tonumber(nY) or 0)) end
  function self:rollXY  (nX,nY) arRoll2D  (Old,w,h,(tonumber(nX) or 0),(tonumber(nY) or 0)) end
  function self:mirrorXY(bX,bY) arMirror2D(Old,w,h,bX,bY) end
  function self:getArray()       return Old end
  function self:getGenerations() return Gen end
  function self:rotRght() arRotateR(Old,w,h); h,w = w,h end
  function self:rotLeft() arRotateL(Old,w,h); h,w = w,h end
  --[[
   * Give birth to a shape inside the field array
  ]]-- 
  function self:setShape(Shape,Px,Py)
    local Px = (Px or 1) % w
    local Py = (Py or 1) % h
    if(Shape == nil) then 
      LogLine("Field.setShape(Shape,PosX,PosY): Shape: Not present !")
      return nil
    end
    if(getmetatable(Shape) ~= metaShape) then 
      LogLine("Field.setShape(Shape,PosX,PosY): Shape: SHAPE obj invalid !")
      return nil
    end
    if(Rule.Name ~= Shape:getRuleName()) then 
      LogLine("Field.setShape(Shape,PosX,PosY): Shape: Different kind of life !")
      return nil
    end
    local sw = Shape:getW()
    local sh = Shape:getH()
    local ar = Shape:getArray()
    for i = 1,sh do for j = 1,sw do
      local x, y = Px+j-1, Py+i-1
      if(x > w) then x = x-w end
      if(x < 1) then x = x+w end
      if(y > h) then y = y-h end
      if(y < 1) then y = y+h end
      Old[y][x] = ar[i][j]
    end end
  end
  --[[
   * Calcolates the next generation
  ]]-- 
  function self:evoNext()
    local ym1, y, yp1, yi = (h - 1), h, 1, h
    while yi > 0 do
      local xm1, x, xp1, xi = (w - 1), w, 1, w
      while xi > 0 do
        local sum = Old[ym1][xm1] + Old[ym1][x] + Old[ym1][xp1] +
                    Old[ y ][xm1]               + Old[ y ][xp1] +
                    Old[yp1][xm1] + Old[yp1][x] + Old[yp1][xp1]
        New[y][x] = getSumStatus(Old[y][x],sum,Rule)
        xm1, x, xp1, xi = x, xp1, (xp1 + 1), (xi - 1)
      end; ym1, y, yp1, yi = y, yp1, (yp1 + 1), (yi - 1)
    end; Old, New, Gen = New, Old, (Gen + 1)
  end
  --[[
   * Registers a draw method under a particular key
  ]]-- 
  function self:regDraw(sKey,fFoo)
    if(type(sKey) == "string" and type(fFoo) == "function") then Draw[sKey] = fFoo
    else LogLine("Field.drwLife(sMode,tArgs): Drawing method {"..tostring(sKey)..","..tostring(fFoo).."} registration skipped !") end
  end
  --[[
   * Visualizates the field on the screen using the draw method given
  ]]--
  function self:drwLife(sMode,tArgs)   
    local Mode = tostring(sMode or "text")
    local Args = tArgs or {}
    if(Draw[Mode]) then Draw[Mode](self,Args)
    else LogLine("Field.drwLife(sMode,tArgs): Drawing mode <"..Mode.."> not found !") end
  end
  --[[
   * Converts the field to a number, beware they are big
  ]]--
  function self:toNumber()
    local Pow, Num, Flg = 0, 0, 0
    for i = h,1,-1 do for j = w,1,-1 do
      Flg = (Old[i][j] ~= 0) and 1 or 0 
      Num = Num + Flg * 2 ^ Pow; Pow  = Pow + 1
    end end; return Num
  end
  --[[
   * Exports a field to a non-delimited string format
  ]]--
  function self:toString()
    local Line = ""
    for i = 1,h do for j = 1,w do
        Line = Line .. tostring((Old[i][j] ~= 0) and Aliv or Dead)
    end end; return Line
  end
  setmetatable(self, metaField); return self
end
  --[[
   * Crates a shape ( life form ) object
  ]]--
lifelib.makeShape = function(sName, sSrc, sExt, tArg)
  local sName = tostring(sName or "")
  local sSrc  = tostring(sSrc  or "")
  local sExt  = tostring(sExt  or "")
  local tArg  = tArg or {}
  local isEmpty, iCnt, tInit = true, 1, nil
  if(sSrc == "file") then
    if    (sExt == "rle"   ) then tInit = initFileRle(sName)
    elseif(sExt == "cells" ) then tInit = initFileCells(sName)
    elseif(sExt == "lif105") then tInit = initFileLif105(sName)
    elseif(sExt == "lif106") then tInit = initFileLif106(sName)
    else LogLine("makeShape(sName, sSrc, sExt, tArg): Extension <"..sExt.."> not supported on the source <"..sSrc.."> for <"..sName">"); return nil end
  elseif(sSrc == "string") then
    if    (sExt == "rle" ) then tInit = initStringRle(sName,tArg[1],tArg[2])
    elseif(sExt == "txt" ) then tInit = initStringText(sName,tArg[1])
    else LogLine("makeShape(sName, sSrc, sExt, tArg): Extension <"..sExt.."> not supported on the source <"..sSrc.."> for <"..sName">"); return nil end
  elseif(sSrc == "strict") then tInit = initStruct(sName)
  else LogLine("makeShape(sName, sSrc, sExt, tArg): Source <"..sSrc.."> not suported for <"..sName..">"); return nil end
  
  if(not tInit) then 
    LogLine("makeShape(sName, sSrc, sExt, tArg): No initialization table"); return nil end
  if(not (tInit.w and tInit.h)) then
    LogLine("makeShape(sName, sSrc, sExt, tArg): Initialization table bad dimensions\n"); return nil end
  if(not (tInit.w > 0 and tInit.h > 0)) then
    LogLine("makeShape(sName, sSrc, sExt, tArg): Check Shape unit structure !\n"); return nil end
  
  while(tInit[iCnt]) do
    if(tInit[iCnt] == 1) then isEmpty = false end
    iCnt = iCnt + 1
  end
  if(isEmpty) then LogLine("makeShape(sName, sSrc, sExt, tArg): Shape <"..sName.."> empty for <"..sExt.."> <"..sSrc..">"); return nil end
  local self = {}
        self.Init = tInit
  local w    = tInit.w
  local h    = tInit.h
  local Data = copyShape(tInit,w,h)
  local Draw = { ["text"] = drawConsole }
  local Rule = "" 
  if(type(sRule) == "string") then
    local Data = getRuleBS(sRule)
    if(Data ~= nil) then Rule = sRule
    else LogLine("makeShape(sName, sSrc, sExt, tArg): Check creator's Rule !"); return nil end
  elseif(type(tInit.Rule) == "table") then
    if(type(tInit.Rule.Name) == "string") then
      local Data = lifelib.getRuleBS(Rule)
      if(Data ~= nil) then Rule = tInit.Rule.Name
      else Rule = lifelib.getDefaultRule().Name end
    else LogLine("makeShape(sName, sSrc, sExt, tArg): Check init Rule !") return nil end
  else Rule = lifelib.getDefaultRule().Name end
  --[[
   * Internal data primitives
  ]]--
  function self:getW() return w end
  function self:getH() return h end
  function self:rotRigh() arRotateR(Data,w,h); h,w = w,h end
  function self:rotLeft() arRotateL(Data,w,h); h,w = w,h end
  function self:getArray() return Data end
  function self:getRuleName() return Rule end
  function self:getCellCount() return (w * h) end
  function self:getGenerations() return nil end  
  function self:mirrorXY(bX,bY) arMirror2D(Data,w,h,bX,bY) end
  function self:rollXY(nX,nY) arRoll2D(Data,w,h,tonumber(nX) or 0,tonumber(nY) or 0) end
  --[[
   * Registers a draw method under a particular key
  ]]--
  function self:regDraw(sKey,fFoo)
    if(type(sKey) == "string" and type(fFoo) == "function") then Draw[sKey] = fFoo
    else LogLine("Drawing method {"..tostring(sKey)..","..tostring(fFoo).."} registration skipped !") end
  end
  --[[
   * Visualizates the shape on the screen using the draw method given
  ]]--
  function self:drwLife(sMode,tArgs)   
    local Mode = sMode or "text"
    local Args = tArgs or {}
    if(Draw[Mode]) then Draw[Mode](self, Args)
    else LogLine("Shape.drwLife(sMode,tArgs): Drawing mode not found !\n") end
  end
  --[[
   * Converts the shape to a number, beware they are big
  ]]--
  function self:toNumber()
    local Pow, Num = 0, 0
    for i = h,1,-1 do for j = w,1,-1 do
      Flg = (Data[i][j] ~= 0) and 1 or 0 
      Num = Num + Flg * 2 ^ Pow; Pow = Pow + 1
    end end; return Num
  end
  --[[
   * Exports the shape in non-delimited string format
  ]]--
  function self:toString()
    local Line = ""
    for i = 1,h do for j = 1,w do
        Line = Line .. tostring((Data[i][j] ~= 0) and Aliv or Dead)
    end end; return Line
  end
  --[[
   * Exports the shape in RLE format
  ]]--
  function self:toStringRle()
    local BaseCh, CurCh, Line, Cnt  = "", "", "", 0
    for i = 1,h do
      BaseCh = tostring(((Data[i][1] ~= 0) and Aliv) or Dead); Cnt = 0
      for j = 1,w do
        CurCh = tostring(((Data[i][j] ~= 0) and Aliv) or Dead)
        if(CurCh == BaseCh) then Cnt = Cnt + 1
        else
          if(Cnt > 1) then Line  = Line..Cnt..BaseCh
          else Line  = Line..BaseCh end
          BaseCh, Cnt = CurCh, 1
        end
      end
      if(Cnt > 1) then Line  = Line..Cnt..BaseCh
      else Line  = Line .. BaseCh end
      if(i ~= h) then Line = Line.."$" end
    end; return Line.."!"
  end
  --[[
   * Exports the shape in text format
   * sDel the delemiter for the lines
   * bAll Draw the shape to the end of the line
  ]]--
  function self:toStringText(sDel,bAll)
    if(sDel == Aliv) then LogLine("Shape.toStringText(sMode,tArgs) Delimiter <"..sDel.."> matches alive"); return "" end
    if(sDel == Dead) then LogLine("Shape.toStringText(sMode,tArgs) Delimiter <"..sDel.."> matches dead") ; return "" end
    local Line, Len = ""
    for i = 1,h do Len = w
      if(bAll) then while(Data[i][Len] == 0) do Len = Len - 1 end end
      for j = 1,Len do
        Line = Line..tostring(((Data[i][j] ~= 0) and Aliv) or Dead)
      end; Line = Line..sDel
    end; return Line
  end
  setmetatable(self, metaShape); return self
end

return lifelib