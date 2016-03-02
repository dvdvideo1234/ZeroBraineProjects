-- Remember to add "COMMON" in the main file
local pairs     = pairs
local tonumber  = tonumber
local tostring  = tostring
local type      = type
local io        = io
local string    = string
local MetaShape = {}
local MetaField = {}

io.stdout:setvbuf("no")

local function getRuleBS(sStr)
  local cB,cS
  local BS = {B = {}, S = {}}
  local Len = string.len(sStr)
  local BI = 1
  local bI = 1
  local sI = 1
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
      end
      BI = BI + 1
    end
    if(cS ~= "") then
      if(tonumber(cS)) then
        BS.S[sI] = tonumber(cS)
        sI = sI + 1
      end
      SI = SI + 1
    end
  end
  if(BS.B[1] and BS.S[1]) then
    return BS
  end
  return nil
end

local function getRleSettings(sStr)
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

local function CopyShape(argShape,w,h)
  if(not argShape) then return false end
  if(not (w and h)) then return false end   
  if(not (w > 0 and h > 0)) then return false end   
  Rez = arMalloc2D(w,h)
  for i = 0,h-1 do
    for j = 0,w-1 do
      Rez[i+1][j+1] = tonumber(argShape[i*w+j+1]) or 0
    end
  end
  return Rez
end

local function getDefaultRule()
  -- Conway
  return { Name = "B3/S23", Data = { B = {3}, S = {2,3} } }
end

---------------------------LIBRARY-------------------------------

local Aliv = "O"
local Dead = "-"
local ShapePath = "game-of-life/shapes/"
Life = {}

Life.Aliv = function(sA)
  if(not sA) then return Aliv end
  local sA   = string.sub(tostring(sA),1,1)
  if( sA ~= "" and
      sA ~= Dead ) then
    Aliv = sA
    return true
  end
  return false
end

Life.Dead = function(sD)
  if(not sD) then return Dead end
  local sD = string.sub(tostring(sD),1,1)
  if( sD ~= "" and
      sD ~= Aliv ) then 
    Dead = sD
    return true
  end
  return false
end

Life.ShapesPath = function(sData)
  if(not sData) then return ShapePath end
  local Typ = type(sData)
  if( Typ == "string" and sData ~= "" ) then
    ShapePath = sData
    return true
  end
  return false
end

Life.InitStruct = function(sName)
  local Shapes = {
  ["HEART"]       = { 1,0,1,
                      1,0,1,
                      1,1,1;
                      w = 3, h = 3 },
  ["GLIDER"]      = { 0,0,1,
                      1,0,1,
                      0,1,1;
                      w = 3, h = 3 },
  ["EXPLODE"]     = { 0,1,0,
                      1,1,1,
                      1,0,1,
                      0,1,0;
                      w = 3, h = 4 },
  ["FISH"]        = { 0,1,1,1,1,
                      1,0,0,0,1,
                      0,0,0,0,1,
                      1,0,0,1,0;
                      w = 5, h = 4 },
  ["BUTTERFLY"]   = { 1,0,0,0,1,
                      0,1,1,1,0,
                      1,0,0,0,1,
                      1,0,1,0,1,
                      1,0,0,0,1;
                      w = 5, h = 5 },
  ["GLIDERGUN"]   = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
                     0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
                     1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                     1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                     0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
                     w = 36,h = 9},
  ["BLOCK"]       = {1,1,1,1;
                     w = 2, h = 2},
  ["BLINKER"]     = {1,1,1;
                     w = 3, h = 1},
  ["R_PENTOMINO"] = {0,1,1,
                     1,1,0,
                     0,1,0;
                     w = 3, h = 3},
  ["PULSAR"]      ={0,0,1,1,1,0,0,0,1,1,1,0,0,
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

function Life.InitStringText(sStr,sDelimiter)
  if( not (sStr and sDelimiter)) then return false end
  if(type(sStr) ~= "string") then return false end
  if(type(sDelimiter) ~= "string" and
     type(sDelimiter) ~= "number") then return false end
  local sDelimiter = tostring(sDelimiter)
  local Len = string.len(sStr)
  if(string.sub(sStr,Len,Len) ~= sDelimiter) then
    return false
  end
  local Ch = ""
  local Cnt = 1  
  local x = 0
  local y = 0
  local Shape = {w = 0, h = 0}
  while(Cnt <= Len) do
    Ch = string.sub(sStr,Cnt,Cnt)
    if(Ch == sDelimiter) then
      Shape.h = Shape.h + 1
      if(Shape.w <= x) then
        Shape.w = x
      end
      x = 0
    else
      x = x + 1
    end
    Cnt  = Cnt  + 1
  end
  Cnt = 1
  x = 0
  y = 0
  while(Cnt <= Len) do
    Ch = string.sub(sStr,Cnt,Cnt)
    if(Ch == sDelimiter) then
      x = 0
      y = y + 1
    else
      Shape[y*Shape.w + x + 1] = ((Ch == "o") and 1) or 0
      x = x + 1
    end
    Cnt  = Cnt  + 1
  end
  return Shape
end

function Life.InitStringRle(sStr)
  local nS
  local nE
  local Ch
  local Cnt = 1
  local Ind = 1
  local Len = string.len(sStr)
  local Number = 0
  local IsNumber = false
  local ToNumber = 0
  local Shape = {w = 0, h = 0}
  while(Cnt <= Len) do
    Ch = string.sub(sStr,Cnt,Cnt)
    if(Ch == "!") then
      Shape.h = Shape.h + 1
      break
    end
    ToNumber = tonumber(Ch)
    if(not IsNumber and ToNumber) then
      -- Start of a number
      IsNumber = true
      nS       = Cnt
    elseif(not ToNumber and IsNumber) then
      -- End of a number
      IsNumber = false
      nE = Cnt - 1
      Number = tonumber(string.sub(sStr,nS,nE)) or 0
    end
    if(Number > 0) then
      while(Number > 0) do
        Shape[Ind] = (((Ch == Aliv) and 1) or 0)
        Ind = Ind + 1
        Number   = Number   - 1
      end
    elseif(Ch ~= "$" and
           Ch ~= "!" and not
           IsNumber
    ) then
      Shape[Ind] = (((Ch == Aliv) and 1) or 0)
      Ind = Ind + 1
    elseif(Ch == "$") then
      Shape.h = Shape.h + 1
    end
    Cnt = Cnt + 1
  end
  Shape.w = math.floor(Ind / Shape.h)
  return Shape
end

Life.InitFileLif105 = function(sName, sAddFormat)
  F = io.open(ShapePath.."lif/"..string.lower(sName).."_105.lif"..string.lower(sAddFormat or ""), "r")
  if(not F) then return false end
  local Line = ""
  local FileShapePos
  local Ind = 1
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
      FileShapePos = F:seek("cur",0)
      local cSecond = string.sub(Line,2,2)
      if(cSecond == "P") then
        local sCoord = StrTrimSpaces(string.sub(Line,3,leLine))
        local Center = string.find(sCoord," ")
        Shape.Offset.Cent[1] = -tonumber(string.sub(sCoord,1,Center-1))
        Shape.Offset.Cent[2] = -tonumber(string.sub(sCoord,Center+1,string.len(sCoord)))
      else
        Shape.Header[Ind] = string.sub(Line,2,leLine)
        Ind = Ind + 1
      end
    elseif(cFirst == "*" or cFirst == ".") then
      Shape.h = Shape.h + 1
      if(leLine >= Shape.w) then
        Shape.w = leLine
      end
    end
  end
  Line = ""
  F:seek("set",FileShapePos)
  Ind = 1
  for y = 1,Shape.h do 
    Line = StrTrimSpaces(F:read())
    if(not Line) then break end
    for x = 1,Shape.w do
      cFirst = string.sub(Line,x,x)
      if(cFirst == "*") then
        Shape[Ind] = 1
      else
        Shape[Ind] = 0    
      end
      Ind = Ind + 1
    end  
  end
  F:close()
  return Shape
end

Life.InitFileLif106 = function(sName, sAddFormat)
  F = io.open(ShapePath.."lif/"..string.lower(sName).."_106.lif"..string.lower(sAddFormat or ""), "r")
  if(not F) then return false end
  local Line = ""
  local MinX, MaxX
  local MinY, MaxY
  local x,y
  local FileShapePos
  local Ind = 1
  local Shape = {
    w = 0,
    h = 0,
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
    if(not (tonumber(cFirst) or
            cFirst == "+" or
            cFirst == "-" )
    ) then
      FileShapePos = F:seek("cur",0)
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
        else
          LogLine("Coordinates conversion failed !")
          return false
        end
      else
        x = tonumber(string.sub(Line,1,Ind-1)) or 0
        y = tonumber(string.sub(Line,Ind+1,leLine)) or 0
        MaxX = x
        MinX = x
        MaxY = y
        MinY = y
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
  F:seek("set",FileShapePos)
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
    else
      LogLine("Convert failed: >"..Line.."<")
      return false
    end
  end
  Ind = 1 
  while(Ind <= Shape.w * Shape.h) do
    if(not Shape[Ind]) then Shape[Ind] = 0 end
    Ind = Ind + 1
  end
  F:close()
  return Shape
end

Life.InitFileRle = function(sName, sAddFormat)
  F = io.open(ShapePath.."rle/"..string.lower(sName)..".rle"..string.lower(sAddFormat or ""), "r")
  if(not F) then return false end
  local Shape = {w = 0, h = 0, Rule = { Name = "", Data = {}}, Header = {}}
  local nS = 1
  local nE = 1
  local ChCnt
  local leLine
  local Ind = 1
  local ToNumber
  local Line = ""
  local Number = 0
  local CellsInd = 1
  local IsNumber = false
  local cFirst = ""
  local FileShapePos
  while(Line) do
    Line = StrTrimSpaces(F:read())
    if(not Line)   then break end
    if(Line == "") then break end
    cFirst = string.sub(Line,1,1)
    leLine = string.len(Line)
    if(cFirst == "#") then
      FileShapePos = F:seek("cur",0)
      Shape.Header[Ind] = string.sub(Line,2,leLine)
      Ind = Ind + 1
    elseif(cFirst == "x") then
      FileShapePos = F:seek("cur",0)
      local Settings = getRleSettings(Line)
      Shape.w = tonumber(Settings["x"])
      Shape.h = tonumber(Settings["y"])
      Shape.Rule.Name = Settings["rule"]
      Shape.Rule.Data = getRuleBS(Shape.Rule.Name)
    end
  end
  Line = ""
  F:seek("set",FileShapePos)
  while(Line) do
    Line = StrTrimSpaces(F:read())
    if(not Line)   then break end
    if(Line == "") then break end
    nS = 1
    nE = 1
    ChCnt = 1
    leLine = string.len(Line)
    while(ChCnt <= leLine) do
      cFirst = string.sub(Line,ChCnt,ChCnt)
      if(cFirst == "!") then
        break
      end
      ToNumber = tonumber(cFirst)
      if(not IsNumber and ToNumber) then
        -- Start of a number
        IsNumber = true
        nS     = ChCnt
      elseif(not ToNumber and IsNumber) then
        -- End of a number
        IsNumber = false
        nE = ChCnt - 1
        Number = tonumber(string.sub(Line,nS,nE)) or 0
      end
      if(Number > 0) then
        while(Number > 0) do
          Shape[CellsInd] = (((cFirst == "o") and 1) or 0)
          CellsInd = CellsInd + 1
          Number   = Number   - 1
        end
      elseif(cFirst ~= "$" and
             cFirst ~= "!" and not
             IsNumber
      ) then
        Shape[CellsInd] = (((cFirst == "o") and 1) or 0)
        CellsInd = CellsInd + 1
      end
      ChCnt = ChCnt + 1
    end
  end
  F:close()
  return Shape
end

Life.InitFileCells = function(sName, sAddFormat)
  F = io.open(ShapePath.."cells/"..string.lower(sName)..".cells"..string.lower(sAddFormat or ""), "r")
  if(not F) then return false end
  local Line = ""
  local x = 0
  local y = 0
  local Ind = 1
  local cFirst = ""
  local FileShapePos
  local Shape = {w = 0, h = 0, Header = {}}
  while(Line) do
    Line = StrTrimSpaces(F:read())
    if(not Line) then break end
    cFirst = string.sub(Line,1,1)
    leLine = string.len(Line)
    if(cFirst ~= "!") then
      Shape.h = Shape.h + 1
      if(leLine >= Shape.w) then
        Shape.w = leLine
      end
    else
      Shape.Header[Ind] = string.sub(Line,2,leLine)
      FileShapePos = F:seek("cur",0)
    end
  end
  Line = ""
  F:seek("set",FileShapePos)
  Ind = 1
  for y = 1,Shape.h do
    Line = F:read()
    if(not Line) then break end
    for x = 1,Shape.w do
      cFirst = string.sub(Line,x,x)
      if(cFirst == "O") then
        Shape[Ind] = 1
      else
        Shape[Ind] = 0    
      end
      Ind = Ind + 1
    end  
  end
  F:close()
  return Shape
end

local function DrawConsole(F)
  local tArr = F:getArray()
  local fx   = F:getW()
  local fy   = F:getH()
  LogLine("Generation: "..(F:getGenerations() or "N/A"))
  local Line="" 
  for y = 1, fy do
   for x = 1, fx do
      Line = Line..(((tArr[y][x]~=0) and Aliv) or Dead)
    end
    LogLine(Line)
    Line = ""
  end
end

local function getSumStatus(nStatus,nSum,tRule)
  if(nStatus == 1) then
    for _, v in ipairs(tRule.Data["S"]) do
      if(v == nSum) then
          return 1
      end
    end
    return 0
  elseif(nStatus == 0) then
    for _, v in ipairs(tRule.Data["B"]) do
      if(v == nSum) then
          return 1
      end
    end
    return 0
  end
end

Life.Field = function(w,h,sRule)  
  local self  = {}
  local w = w or 0
        w = ((w >= 1) and w) or 1
  local h = h or 0
        h = ((h >= 1) and h) or 1
  local Gen = 0
  local Old = arMalloc2D(w,h) 
  local New = arMalloc2D(w,h)
  local Draw = { ["text"] = DrawConsole }
  local Rule
        
  setmetatable(self,MetaField)
  
  if(type(sRule) ~= "string") then
    Rule = getDefaultRule()
  else
    Rule = {}
    Rule.Name = sRule
    Rule.Data = getRuleBS(sRule)
    if(Rule.Data == nil) then
      LogLine("Field creator: Please redefine your life rule !")
      return nil
    end
  end
  
  function self:getRuleName()
    return Rule.Name
  end

  function self:getRuleData()
    return Rule.Data
  end  
  
  function self:ShiftXY(nX,nY)
    local x   = nX or 0
    local y   = nY or 0
    arShift2D(Old,w,h,x,y)
  end
  
  function self:RollXY(nX,nY)
    local x   = nX or 0
    local y   = nY or 0
    arRoll2D(Old,w,h,x,y)
  end
  
  function self:MirrorXY(x,y)    
    arMirror2D(Old,w,h,x,y)
  end
  
  -- Give birth to a "Shape" within the cell array
  function self:Spawn(Shape,Px,Py)
    local Px = Px or 1
    local Py = Py or 1
        
    Px = Px % w
    Py = Py % h
    if(Rule.Name ~= Shape:getRuleName()) then 
      LogLine("Field:Spawn(Shape,PosX,PosY): Shape: Different kind of life !")
      return nil
    end
    if(Shape == nil) then 
      LogLine("Field:Spawn(Shape,PosX,PosY): Shape: Not present !")
      return nil
    end
    if(getmetatable(Shape) ~= MetaShape) then 
      LogLine("Field:Spawn(Shape,PosX,PosY): Shape: SHAPE obj invalid !")
      return nil
    end
    
    local sw = Shape:getW()
    local sh = Shape:getH()
    local ar = Shape:getArray()
    
    for i=1,sh do
      for j=1,sw do
        local x = Px+j-1
        local y = Py+i-1
        if(x > w) then x = x-w end
        if(x < 1) then x = w+w end
        if(y > h) then y = y-h end
        if(y < 1) then y = h+h end
        Old[y][x] = ar[i][j]
      end
    end
  end

  -- Evelove to the next Generation
  function self:Evolve()
    local ym1,y,yp1,yi=h-1,h,1,h
    while yi > 0 do
      local xm1,x,xp1,xi=w-1,w,1,w
      while xi > 0 do
        local sum = Old[ym1][xm1] + Old[ym1][x] + Old[ym1][xp1] +
                    Old[ y ][xm1]               + Old[ y ][xp1] +
                    Old[yp1][xm1] + Old[yp1][x] + Old[yp1][xp1]
        New[y][x] = getSumStatus(Old[y][x],sum,Rule)
        xm1,x,xp1,xi = x,xp1,xp1+1,xi-1
      end
      ym1,y,yp1,yi = y,yp1,yp1+1,yi-1
    end
    Old, New = New, Old
    Gen = Gen + 1
  end

  function self:RotateR()
    arRotateR(Old,w,h)
    h,w = w,h
  end
  
  function self:RotateL()
    arRotateL(Old,w,h)
    h,w = w,h
  end
  
  function self:RegisterDraw(sKey,fFoo)
    if(type(fFoo) == "function" and type(sKey) == "string") then
      Draw[sKey] = fFoo
    end
  end
  
  -- output the array to screen
  function self:Draw(sMode,tArgs)   
    local Mode = sMode or "text"
    local Arg = tArgs or {}
       
    if(Draw[Mode]) then
      Draw[Mode](self,Arg)
    else
      LogLine("Drawing mode not found !")
    end
  end
  
  function self:getW()
    return w
  end
  
  function self:getH()
    return h
  end
  
  function self:getElemsNum()
    return w * h
  end
    
  function self:toNumber()
    local Pow  = 0
    local Num  = 0
    local Flag = 0
    for i = h,1,-1 do
      for j = w,1,-1 do
        Flag = (Old[i][j] ~= 0) and 1 or 0 
        Num = Num + 2 ^ Pow
        Pow  = Pow + 1
      end
    end
    return Num
  end
  
  function self:toString()
    local Line = ""
    for i = 1,h do
      for j = 1,w do
        Line = Line .. tostring((Old[i][j] ~= 0) and Aliv or Dead)
      end
    end
    return Line
  end
  
  function self:getArray()
    return Old
  end
  
  function self:getGenerations()
    return Gen
  end

  return self
end

-- Creates Shape objects from row data
Life.Shape = function(tInit,sRule)
  if(not tInit) then return false end
  if(not (tInit.w and tInit.h)) then return false end
  if(not (tInit.w > 0 and tInit.h > 0)) then
    LogLine("Shape(Init, Rule): Check Shape init structure !")
    return false
  end
  local self = {}
  local w    = tInit.w
  local h    = tInit.h
  local Data = CopyShape(tInit,w,h)
  local Draw = { ["text"] = DrawConsole }
  local Rule = ""
  
  setmetatable(self,MetaShape)
  
  if(type(sRule) == "string") then
    local Data = getRuleBS(sRule)
    if(Data ~= nil) then
      Rule = sRule
    else
      LogLine("Shape(Init, Rule): Check crator's Rule !")
      return nil
    end
  elseif(type(tInit.Rule) == "table") then
    if(type(tInit.Rule.Name) == "string") then
      local Data = getRuleBS(Rule)
      if(Data ~= nil) then
        Rule = tInit.Rule.Name
      else
        Rule = getDefaultRule().Name
      end
    else
      LogLine("Shape(Init, Rule): Check init Rule !")
      return nil
    end
  else
    Rule = getDefaultRule().Name
  end

  function self:getRuleName(x,y)
    return Rule
  end

  function self:MirrorXY(x,y)
    arMirror2D(Data,w,h,x,y)
  end

  function self:RotateR()
    arRotateR(Data,w,h)
    h,w = w,h
  end
  
  function self:RotateL()
    arRotateL(Data,w,h)
    h,w = w,h
  end
  
  function self:RollXY(nX,nY)
    local x   = nX or 0
    local y   = nY or 0
    arRoll2D(Data,w,h,x,y)
  end
  
  function self:RegisterDraw(sKey,fFoo)
    if(type(fFoo) == "function" and type(sKey) == "string") then
      Draw[sKey] = fFoo
    end
  end
  
  -- output the array to screen
  function self:Draw(sMode,tArgs)   
    local Mode = sMode or "text"
    local Arg = tArgs or {}
    
    if(Draw[Mode]) then
      Draw[Mode](self,Arg)
    else
      LogLine("Drawing mode not found !\n")
    end
  end
  
  function self:getArray()
    return Data
  end
  
  function self:getW()
    return w
  end
  
  function self:getH()
    return h
  end
  
  function self:getElemsNum()
    return w * h
  end
  
  function self:toNumber()
    local Pow  = 0
    local Num  = 0
    local Flag = 0
    for i = h,1,-1 do
      for j = w,1,-1 do
        Flag = (Data[i][j] ~= 0) and 1 or 0 
        Num = Num + 2 ^ Pow
        Pow  = Pow + 1
      end
    end
    return Num
  end
  
  function self:toString()
    local Line = ""
    for i = 1,h do
      for j = 1,w do
        Line = Line .. tostring((Data[i][j] ~= 0) and Aliv or Dead)
      end
    end
    return Line
  end
  
  function self:toStringRle()
    local BaseCh = ""
    local CurCh  = ""
    local Cnt    = 0
    local Line   = ""
    for i = 1,h do
      BaseCh = tostring(((Data[i][1] ~= 0) and "o") or "b")
      Cnt    = 0
      for j = 1,w do
        CurCh = tostring(((Data[i][j] ~= 0) and "o") or "b")
        if(CurCh == BaseCh) then 
          Cnt = Cnt + 1
        else
          if(Cnt > 1) then
            Line  = Line .. Cnt .. BaseCh
          else
            Line  = Line .. BaseCh
          end
          BaseCh = CurCh
          Cnt    = 1
        end
      end
      if(Cnt > 1) then
        Line  = Line .. Cnt .. BaseCh
      else
        Line  = Line .. BaseCh
      end
      if(i ~= h) then
        Line = Line .. "$"
      end
    end
    return Line .. "!"
  end
  
  function self:toStringText(sDelimiter)
    if(sDelimiter ~= Aliv or sDelimiter ~= Dead) then 
      local Line = ""
      local LastAl
      for i = 1,h do
        LastAl = w
        while(Data[i][LastAl] == 0) do
          LastAl = LastAl - 1
        end
        for j = 1,LastAl do
          Line = Line .. tostring(((Data[i][j] ~= 0) and Aliv) or Dead)
        end
        Line = Line .. sDelimiter
      end
      return Line
    end
  end
  function self:getGenerations()
    return nil
  end  
  return self
end
