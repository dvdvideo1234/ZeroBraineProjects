local type = type
local tonumber = tonumber
local tostring = tostring
local setmetatable = setmetatable
local math = math
local string = string

local MetaComplex   = {}
MetaComplex.__type  = "complex"
MetaComplex.__index = MetaComplex

function Complex(nRe,nIm)
  self = {}
  local Re = tonumber(nRe) or 0
  local Im = tonumber(nIm) or 0
 
  setmetatable(self,MetaComplex)
  
  function self:getReal()
    return Re
  end
  
  function self:getImag()
    return Im
  end
  
  function self:setReal(R)
    Re = (tonumber(R) or 0)
  end
  
  function self:setImag(I)
    Im = (tonumber(I) or 0)
  end
  
  function self:Set(R,I)
    local tR = type(R) 
    local tI = type(I)
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      Re = (tonumber(R) or 0)
      Im = (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == MetaComplex and not I) then
      Re = R:getReal()
      Im = R:getImag()
    end
  end
  
  function self:Add(R,I)
    local tR = type(R) 
    local tI = type(I)
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      Re = Re + (tonumber(R) or 0)
      Im = Im + (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == MetaComplex and not I) then
      Re = Re + R:getReal()
      Im = Im + R:getImag()
    end
  end
  
  function self:Sub(R,I)
    local tR = type(R) 
    local tI = type(I)
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      Re = Re - (tonumber(R) or 0)
      Im = Im - (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == MetaComplex and not I) then
      Re = Re - R:getReal()
      Im = Im - R:getImag()
    end
  end
  
  function self:Scale(nNum)
    local Typ = type(nNum) 
    if(Typ == "number" or
       Typ == "string"
    ) then
      local M = (tonumber(Num) or 0)
      Re = Re * M
      Im = Im * M
    end
  end
  
  function self:Mul(R,I)
    local tR = type(R) 
    local tI = type(I)
    local A = Re
    local C = 0
    local D = 0
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      C = (tonumber(R) or 0)
      D = (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == MetaComplex and not I) then
      C = R:getReal()
      D = R:getImag()
    end
    Re = A*C - Im*D
    Im = A*D + Im*C
  end
  
  function self:Div(R,I)
    local tR = type(R) 
    local tI = type(I)
    local A = Re
    local C = 0
    local D = 0
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      C = (tonumber(R) or 0)
      D = (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == MetaComplex and not I) then
      C = R:getReal()
      D = R:getImag()
    end
    Z = (C*C + D*D)
    if(Z ~= 0) then
      Re = (A *C + Im*D) / Z
      Im = (Im*C -  A*D) / Z
    end
  end
  
  function self:Mod(R,I)
    local tR = type(R) 
    local tI = type(I)
    local A = Re
    local C = 0
    local D = 0
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      C = (tonumber(R) or 0)
      D = (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == MetaComplex and not I) then
      C = R:getReal()
      D = R:getImag()
    end
    self:Div(C,D)
    local rei, ref = math.modf(Re)
    local imi, imf = math.modf(Im)
    self:Set(ref,imf)
    self:Mul(C,D)
  end
  
  function self:NegRe()
    Re = -Re
  end
  
  function self:NegIm()
    Im = -Im
  end
  
  function self:Conj()
    Im = -Im
  end
  
  function self:getDup()
    return Complex(Re,Im)
  end
  
  function self:Floor()
    Re = math.floor(Re)
    Im = math.floor(Im)
  end

  function self:getFloor()
    return Complex(math.floor(Re),math.floor(Im))
  end

  function self:Ceil()
    Re = math.ceil(Re)
    Im = math.ceil(Im)
  end

  function self:getCeil()
    return Complex(math.ceil(Re),math.ceil(Im))
  end
  
  function self:toPointXY()
    return {x = Re, y = Im}
  end
  
  function self:getNeg()
    return Complex(-Re,-Im)
  end
  
  function self:getNegRe()
    return Complex(-Re,Im)
  end
  function self:getNegIm()
    return Complex(Re,-Im)
  end
  
  function self:getConj()
    return Complex(Re,-Im)
  end
  
  function self:getNorm2()
    return (Re*Re + Im*Im)
  end  
  
  function self:getNorm()
    return math.sqrt(Re*Re + Im*Im)
  end 
  
  function self:getAngRad()
    return math.atan2(Im,Re)
  end 
  
  function self:getAngDeg()
      return (math.atan2(Im,Re) * 180) / math.pi
  end 
  
  function self:Pow(R,I)
    local tR = type(R) 
    local tI = type(I)
    local nC = 0
    local nD = 0
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      nC = (tonumber(R) or 0)
      nD = (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == MetaComplex and not I) then
      nC = R:getReal()
      nD = R:getImag()
    end
    local Ro = self:getNorm()
    local Th = self:getAngRad()
    local nR = (Ro^nC)*math.exp(-nD*Th)
    local nF = nC*Th + nD*math.log(Ro)
    Re = nR * math.cos(nF)
    Im = nR * math.sin(nF)
  end
  
  function self:getRoots(nNum)
    local T = type(nNum)
    if(T == "number" or
       T == "string"
    ) then
      local Num = tonumber(nNum)
      if(Num) then
        Num = math.floor(Num)
        local tRoots = {}
        local Pi = math.pi
        local R  = self:getNorm()   ^ (1 / Num)
        local Th = self:getAngRad() * (1 / Num)
        local CRe, CIm
        local AngStep = (2*Pi) / Num
        for k = 1, Num do
          CRe = R * math.cos(Th)
          CIm = R * math.sin(Th)
          tRoots[k] = Complex(CRe,CIm)
          Th = Th + AngStep
        end
        return tRoots
      end
      return nil
    end
    return nil
  end 

  return self
end

MetaComplex.__unm = function(Comp)
  T = type(Comp)
  if(T and T == "table" and getmetatable(Comp) == MetaComplex) then
    return Complex(-Comp:getReal(),-Comp:getImag())
  end
end

MetaComplex.__add = function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Add(C2)
  return O
end

MetaComplex.__sub = function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Sub(C2)
  return O
end

MetaComplex.__mul = function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Mul(C2)
  return O
end

MetaComplex.__div = function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Div(C2)
  return O
end

MetaComplex.__mod =  function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Mod(C2)
  return O
end
MetaComplex.__tostring = function(Comp)
  local R = tostring(Comp:getReal())
  local I = tostring(Comp:getImag())
  if(R and I) then
    return "{"..R..","..I.."}"
  end
  return "N/A"
end

MetaComplex.__concat = function(A,B)
  local Ta = type(A)
  local Tb = type(B)
  if(Ta == "table" and getmetatable(A) == MetaComplex) then
    return "{"..A:getReal()..", "..A:getImag().."}"..tostring(B)
  elseif(Tb == "table" and getmetatable(B) == MetaComplex) then
    return tostring(A).."{"..B:getReal()..", "..B:getImag().."}"
  end
  return "N/A"
end

MetaComplex.__pow =  function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Pow(C2)
  return O
end

MetaComplex.__eq =  function(C1,C2)
  local T1 = type(C1) 
  local T2 = type(C2)
  local R1 = 0
  local R2 = 0
  local I1 = 0
  local I2 = 0
  if(T1 and T1 == "table" and getmetatable(C1) == MetaComplex) then
    R1 = C1:getReal()
    I1 = C1:getImag()
  else
    R1 = (tonumber(C1) or 0)
    I1 = 0
  end
  if(T2 and T2 == "table" and getmetatable(C2) == MetaComplex) then
    R2 = C2:getReal()
    I2 = C2:getImag()
  else
    R2 = (tonumber(C2) or 0)
    I2 = 0
  end
  if(R1 == R2 and I1 == I2) then
    return true
  end
  return false
end

MetaComplex.__le =  function(C1,C2)
  local T1 = type(C1) 
  local T2 = type(C2)
  local R1 = 0
  local R2 = 0
  local I1 = 0
  local I2 = 0
  if(T1 and T1 == "table" and getmetatable(C1) == MetaComplex) then
    R1 = C1:getReal()
    I1 = C1:getImag()
  else
    R1 = (tonumber(C1) or 0)
    I1 = 0
  end
  if(T2 and T2 == "table" and getmetatable(C2) == MetaComplex) then
    R2 = C2:getReal()
    I2 = C2:getImag()
  else
    R2 = (tonumber(C2) or 0)
    I2 = 0
  end
  if(R1 <= R2 and I1 <= I2) then
    return true
  end
  return false
end

MetaComplex.__lt =  function(C1,C2)
  local T1 = type(C1) 
  local T2 = type(C2)
  local R1 = 0
  local R2 = 0
  local I1 = 0
  local I2 = 0
  if(T1 and T1 == "table" and getmetatable(C1) == MetaComplex) then
      R1 = C1:getReal()
      I1 = C1:getImag()
  else
    R1 = (tonumber(C1) or 0)
    I1 = 0
  end
  if(T2 and T2 == "table" and getmetatable(C2) == MetaComplex) then
    R2 = C2:getReal()
    I2 = C2:getImag()
  else
    R2 = (tonumber(C2) or 0)
    I2 = 0
  end
  if(R1 < R2 and I1 < I2) then
    return true
  end
  return false
end

local function Str2Complex(strS)
  if(not strS) then return nil end
  local S = 1
  local E = string.len(strS)
  local C = string.find(strS,",")
  if((not C) or (C < S) or (C > E)) then return nil end
  while(S < E) do
    local CS = string.sub(strS,S,S)
    local CE = string.sub(strS,E,E)
    if(CS ~= "{" and CE ~= "}") then break end;
    if(CS == "{") then S = S + 1 end
    if(CE == "}") then E = E - 1 end
  end
  return Complex(tonumber(string.sub(strS,S,C-1)) or 0,
                 tonumber(string.sub(strS,C+1,E)) or 0)
end

local function StrI2Complex(strS)
  if(not strS) then return nil end
  local L  = string.len(strS)
  local Im, Re
  local S = 1
  local M = 1
  local I = 1
  I = string.find(strS,'i',S)
  I = string.find(strS,'I',S) or I
  I = string.find(strS,'j',S) or I
  I = string.find(strS,'J',S) or I
  if(not I) then return nil end
  Ch = string.sub(strS,I-1,I-1)
  if(I == L) then
    L = L - 1
    Ch = string.sub(strS,1,1)
    if(Ch == "+") then
      S = S + 1
    end
    M = string.find(strS,"+",S)
    if(not M) then
      M = string.find(strS,"-",S+1)
      if(not M) then return nil end
    end
    Re = tonumber(string.sub(strS,S,M-1)) or 0
    Im = tonumber(string.sub(strS,M,  L)) or 0
    return Complex(Re,Im)
  elseif(Ch == "+") then
    Re = tonumber(string.sub(strS,1,I-2)) or 0
    Im = tonumber(string.sub(strS,I+1,L)) or 0
    return Complex(Re,Im)
  elseif(Ch == "-") then
    Re = tonumber(string.sub(strS,1,I-2)) or 0
    Im = tonumber(string.sub(strS,I+1,L)) or 0
    Im = -Im
    return Complex(Re,Im)
  else return nil end
end


local function Tab2Complex(tTab)
  if(not tTab) then return nil end
  local V1 = tTab[1]
        V1 = tTab["Real"] or V1
        V1 = tTab["real"] or V1
        V1 = tTab["Re"]   or V1
        V1 = tTab["re"]   or V1
        V1 = tTab["R"]    or V1
        V1 = tTab["r"]    or V1
        V1 = tTab["x"]    or V1
  local V2 = tTab[2]
        V2 = tTab["Imag"] or V2
        V2 = tTab["imag"] or V2
        V2 = tTab["Im"]   or V2
        V2 = tTab["im"]   or V2
        V2 = tTab["I"]    or V2
        V2 = tTab["i"]    or V2
        V2 = tTab["y"]    or V2
  if(V1 or V2) then
    V2 = tonumber(V2) or 0
    V1 = tonumber(V1) or 0
    return Complex(V1,V2)
  end
  return nil
end

function ToComplex(In)
  local C
  local Tin = type(In)
  if(Tin == "table")  then return Tab2Complex(In) end
  if(Tin == "number") then return Complex(In,0)  end
  if(Tin == "nil")    then return Complex(In,0)  end
  if(Tin == "string") then
    local C = Str2Complex(In)
    if(C) then return C end
    return StrI2Complex(In)
  end
  return nil
end
