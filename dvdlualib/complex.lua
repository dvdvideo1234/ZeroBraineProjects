local type         = type
local math         = math
local tonumber     = tonumber
local tostring     = tostring
local setmetatable = setmetatable

local metaComplex   = {}
metaComplex.__type  = "Complex"
metaComplex.__index = metaComplex
metaComplex.__bords = {"/|<({[","/|>)}]"}

metaComplex.__tostring = function(Comp)
  local R = tostring(Comp:getReal())
  local I = tostring(Comp:getImag())
  if(R and I) then return "{"..R..","..I.."}" end
  return "N/A"
end

metaComplex.__unm = function(Comp)
  T = type(Comp)
  if(T and T == "table" and getmetatable(Comp) == metaComplex) then
    return Complex(-Comp:getReal(),-Comp:getImag())
  end
end

metaComplex.__add = function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Add(C2)
  return O
end

metaComplex.__sub = function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Sub(C2)
  return O
end

metaComplex.__mul = function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Mul(C2)
  return O
end

metaComplex.__div = function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Div(C2)
  return O
end

metaComplex.__mod =  function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Mod(C2)
  return O
end

metaComplex.__concat = function(A,B)
  local Ta, Tb = type(A), type(B)
  if(Ta == "table" and getmetatable(A) == metaComplex) then
    return "{"..A:getReal()..", "..A:getImag().."}"..tostring(B)
  elseif(Tb == "table" and getmetatable(B) == metaComplex) then
    return tostring(A).."{"..B:getReal()..", "..B:getImag().."}"
  end
  return "N/A"
end

metaComplex.__pow =  function(C1,C2)
  local O = Complex()
  O:Set(C1)
  O:Pow(C2)
  return O
end

metaComplex.__eq =  function(C1,C2)
  local T1, T2 = type(C1), type(C2)
  local R1, R2, I1, I2 = 0, 0, 0, 0
  if(T1 and T1 == "table" and getmetatable(C1) == metaComplex) then
    R1, I1 = C1:getReal(), C1:getImag()
  else
    R1, I1 = (tonumber(C1) or 0), 0
  end
  if(T2 and T2 == "table" and getmetatable(C2) == metaComplex) then
    R2, I2 = C2:getReal(), C2:getImag()
  else
    R2, I2 = (tonumber(C2) or 0), 0
  end
  if(R1 == R2 and I1 == I2) then return true end
  return false
end

metaComplex.__le =  function(C1,C2)
  local T1, T2 = type(C1), type(C2)
  local R1, R2, I1, I2 = 0, 0, 0, 0
  if(T1 and T1 == "table" and getmetatable(C1) == metaComplex) then
    R1, I1 = C1:getReal(), C1:getImag()
  else
    R1, I1 = (tonumber(C1) or 0), 0
  end
  if(T2 and T2 == "table" and getmetatable(C2) == metaComplex) then
    R2, I2 = C2:getReal(), C2:getImag()
  else
    R2, I2 = (tonumber(C2) or 0), 0
  end
  if(R1 <= R2 and I1 <= I2) then return true end
  return false
end

metaComplex.__lt =  function(C1,C2)
  local T1, T2 = type(C1), type(C2)
  local R1, R2, I1, I2 = 0, 0, 0, 0
  if(T1 and T1 == "table" and getmetatable(C1) == metaComplex) then
    R1, I1 = C1:getReal(), C1:getImag()
  else
    R1, I1 = (tonumber(C1) or 0), 0
  end
  if(T2 and T2 == "table" and getmetatable(C2) == metaComplex) then
    R2, I2 = C2:getReal(), C2:getImag()
  else
    R2, I2 = (tonumber(C2) or 0), 0
  end
  if(R1 < R2 and I1 < I2) then return true end
  return false
end

function Complex(nRe,nIm)
  self = {}
  local Re = tonumber(nRe) or 0
  local Im = tonumber(nIm) or 0

  setmetatable(self,metaComplex)

  function self:NegRe()     Re = -Re end
  function self:NegIm()     Im = -Im end
  function self:Conj()      Im = -Im end
  function self:setReal(R)  Re = (tonumber(R) or 0) end
  function self:setImag(I)  Im = (tonumber(I) or 0) end
  function self:Floor()     Re = math.floor(Re); Im = math.floor(Im); end
  function self:Ceil()      Re = math.ceil(Re); Im = math.ceil(Im); end
  function self:Print(N,E)  io.write(tostring(N).."{"..tostring(Re)..","..tostring(Im).."}"..tostring(E)) end
  function self:getReal()   return Re end
  function self:getImag()   return Im end
  function self:getDup()    return Complex(Re,Im) end
  function self:getFloor()  return Complex(math.floor(Re),math.floor(Im)) end
  function self:getCeil()   return Complex(math.ceil(Re),math.ceil(Im)) end
  function self:toPointXY() return {x = Re, y = Im} end
  function self:getNeg()    return Complex(-Re,-Im) end
  function self:getNegRe()  return Complex(-Re, Im) end
  function self:getNegIm()  return Complex( Re,-Im) end
  function self:getConj()   return Complex( Re,-Im) end
  function self:getNorm2()  return (Re*Re + Im*Im) end
  function self:getNorm()   return math.sqrt(Re*Re + Im*Im) end
  function self:getAngRad() return math.atan2(Im,Re) end
  function self:getAngDeg() return (math.atan2(Im,Re) * 180) / math.pi end

  function self:Set(R,I)
    local tR, tI = type(R), type(I)
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      Re, Im = (tonumber(R) or 0), (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == metaComplex and not I) then
      Re, Im = R:getReal(), R:getImag()
    end
  end

  function self:Add(R,I)
    local tR, tI = type(R), type(I)
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      Re, Im = (Re + (tonumber(R) or 0)), (Im + (tonumber(I) or 0))
    elseif(tR == "table" and getmetatable(R) == metaComplex and not I) then
      Re, Im = (Re + R:getReal()), (Im + R:getImag())
    end
  end

  function self:Sub(R,I)
    local tR, tI = type(R), type(I)
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      Re, Im = (Re - (tonumber(R) or 0)), (Im - (tonumber(I) or 0))
    elseif(tR == "table" and getmetatable(R) == metaComplex and not I) then
      Re, Im = (Re - R:getReal()), (Im - R:getImag())
    end
  end

  function self:Scale(nNum)
    local Typ = type(nNum)
    if(Typ == "number" or Typ == "string" ) then
      local M = (tonumber(Num) or 0)
      Re, Im = (Re * M), (Im * M)
    end
  end

  function self:Mul(R,I)
    local tR, tI = type(R), type(I)
    local A, C, D = Re, 0, 0
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      C, D = (tonumber(R) or 0), (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == metaComplex and not I) then
      C, D = R:getReal(), R:getImag()
    end
    Re = A*C - Im*D; Im = A*D + Im*C
  end

  function self:Div(R,I)
    local tR, tI = type(R), type(I)
    local A, C, D = Re, 0, 0
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      C, D = (tonumber(R) or 0), (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == metaComplex and not I) then
      C, D = R:getReal(), R:getImag()
    end
    Z = (C*C + D*D)
    if(Z ~= 0) then Re = (A *C + Im*D) / Z; Im = (Im*C -  A*D) / Z end
  end

  function self:Mod(R,I)
    local tR, tI = type(R), type(I)
    local A, C, D = Re, 0, 0
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      C, D = (tonumber(R) or 0), (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == metaComplex and not I) then
      C, D = R:getReal(), R:getImag()
    end
    self:Div(C,D)
    local rei, ref = math.modf(Re)
    local imi, imf = math.modf(Im)
    self:Set(ref,imf)
    self:Mul(C,D)
  end

  function self:Pow(R,I)
    local tR, tI = type(R), type(I)
    local nC, nD = 0, 0
    if( (tR == "number" or tR == "string") and
       ((tI == "number" or tI == "string") or not I)
    ) then
      nC, nD = (tonumber(R) or 0), (tonumber(I) or 0)
    elseif(tR == "table" and getmetatable(R) == metaComplex and not I) then
      nC, nD = R:getReal(), R:getImag()
    end
    local Ro = self:getNorm()
    local Th = self:getAngRad()
    local nR = (Ro ^ nC) * math.exp(-nD * Th)
    local nF =  nC * Th  + nD * math.log(Ro)
    Re = nR * math.cos(nF)
    Im = nR * math.sin(nF)
  end

  function self:getRoots(nNum)
    local T = type(nNum)
    if(T == "number" or T == "string") then
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

local function StrValidateComplex(sStr)
  local Str = sStr:gsub("%s","") -- Remove hollows
  local S, E = 1, Str:len()
  while(S < E) do
    local CS = Str:sub(S,S)
    local CE = Str:sub(E,E)
    local FS = metaComplex.__bords[1]:find(CS,1,true)
    local FE = metaComplex.__bords[2]:find(CE,1,true)
    if((not FS) and FE) then return logStatus(nil,"StrValidateComplex: Unbalanced end #"..CS..CE.."#") end
    if((not FE) and FS) then return logStatus(nil,"StrValidateComplex: Unbalanced beg #"..CS..CE.."#") end
    if(FS and FE and FS > 0 and FE > 0) then
      if(FS == FE) then S = S + 1; E = E - 1
      else return logStatus(nil,"StrValidateComplex: Bracket mismatch #"..CS..CE.."#") end
    elseif(not (FS and FE)) then break end;
  end; return Str, S, E
end

local function Str2Complex(sStr, nS, nE, sDel)
  local Del = tostring(sDel or ","):sub(1,1)
  local S, E, D = nS, nE, sStr:find(Del)
  if((not D) or (D < S) or (D > E)) then
    return Complex(tonumber(sStr:sub(S,E)) or 0, 0) end
  return Complex(tonumber(sStr:sub(S,D-1)) or 0, tonumber(sStr:sub(D+1,E)) or 0)
end

local function StrI2Complex(sStr, nS, nE, nI)
  if(nI == 0) then return logStatus(nil,"StrI2Complex: Complex not in plain format [a+ib] or [a+bi]") end
  local M = nI - 1 -- There will be no delimiter symbols here
  local C = sStr:sub(M,M)
  if(nI == nE) then  -- (-0.7-2.9i) Skip symbols til +/- is reached
    while(C ~= "+" and C ~= "-") do
      M = M - 1; C = sStr:sub(M,M)
    end; return Complex(tonumber(sStr:sub(nS,M-1)), tonumber(sStr:sub(M,nE-1)))
  else -- (-0.7-i2.9)
    return Complex(tonumber(sStr:sub(nS,M-1)), tonumber(C..sStr:sub(nI+1,nE)))
  end
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
        V1 = tTab["X"]    or V1
        V1 = tTab["x"]    or V1
  local V2 = tTab[2]
        V2 = tTab["Imag"] or V2
        V2 = tTab["imag"] or V2
        V2 = tTab["Im"]   or V2
        V2 = tTab["im"]   or V2
        V2 = tTab["I"]    or V2
        V2 = tTab["i"]    or V2
        V2 = tTab["Y"]    or V2
        V2 = tTab["y"]    or V2
  if(V1 or V2) then
    V2 = tonumber(V2) or 0
    V1 = tonumber(V1) or 0
    return Complex(V1,V2)
  end
  return logStatus(nil,"StrI2Complex: Table format not supported")
end

function ToComplex(In,Del)
  local tIn = type(In)
  if(tIn ==  "table") then return Tab2Complex(In) end
  if(tIn == "number") then return Complex(In,0) end
  if(tIn ==    "nil") then return Complex(0,0) end
  if(tIn == "string") then
    local Str, S, E = StrValidateComplex(In)
    if(not (Str and S and E)) then return logStatus(nil,"ToComplex: Failed to vlalidate <"..tostring(In)..">") end
        Str = Str:sub(S ,E); E = E-S+1; S = 1
    local I = Str:find("i",S)
          I = Str:find("I",S) or I
          I = Str:find("j",S) or I
          I = Str:find("J",S) or I
    if(I and (I > 0)) then return StrI2Complex(Str, S, E, I)
    else return Str2Complex(Str, S, E, Del) end
  end
  return logStatus(nil,"ToComplex: Type <"..Tin.."> not supported")
end
