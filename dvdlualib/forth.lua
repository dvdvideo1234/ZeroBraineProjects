local string = string
local math   = math
local io     = io

function Log(sStr)
  print(tostring(sStr))
end

------ Refs 
-- http://galileo.phys.virginia.edu/classes/551.jvn.fall01/primer.htm

------ Forth Library

local Forth = {}
--- Default state interpret
Forth.State = true
Forth.File  = ""
Forth.PC    = 1
------------
Forth.MakeStack = function()
  local CurSP = 1
  local self  = {}
  local Data  = {}

  function self:Get()
    local Ind = CurSP-1
    if(Data[Ind]) then
      local Str = Data[Ind]
      Data[Ind] = nil
      CurSP = CurSP - 1
      return Str
    end
    return nil
  end
  function self:Put(Str) 
    if(Str) then
      Data[CurSP] = Str
      CurSP = CurSP + 1
    end
  end
  function self:GetTopInd()
    return CurSP - 1
  end
  function self:CopyGetTopRel(nNum)
    Num = CurSP - nNum - 1
    if( Data[Num] and
        Num <= CurSP and
        Num > 0 
    ) then
      local Str = string.sub(Data[Num],1,-1)
      if(not Str) then return end
      return Str
    end
    return nil
  end
  function self:DelGetTopRel(nNum)
    Num = CurSP - nNum - 1
    if(Data[Num] and
           Num <= CurSP and
           Num > 0 
    ) then
      local Str = string.sub(Data[Num],1,-1)
      if(not Str) then return end
      local Cnt = Num
      while(0) do
        if(not Data[Cnt + 1]) then break end
        Data[Cnt] = Data[Cnt + 1]
        Cnt = Cnt + 1
      end
      Data[Cnt] = nil
      CurSP = CurSP - 1
      return Str
    end
    return nil
  end
  function self:TopIsNumber()
    if(Data[CurSP-1]) then
      if(tonumber(Data[CurSP])) then
        return true
      end
    end
    return false
  end
  function self:DelTop()
    if(Data[CurSP-1]) then
      Data[CurSP-1] = nil
      CurSP = CurSP - 1
    end
    return 
  end
  function self:GetData()
    return Data
  end
  return self
end

------- Doo EEt !
Forth.DataStack = Forth.MakeStack()
Forth.AddrStack = Forth.MakeStack()

Forth.Using = function(sFileName)
  Forth.File = string.gsub(sFileName,"/","\\")
end

Forth.ExplodeLine = function(Line)
  local Data = {}
  local Cnt  = 1
  local Ch   = ""
  local By   = 0
  local Buff = ""
  local io.write = false
  local WCnt = 1
  while(0) do
    Ch = string.sub(Line,Cnt,Cnt)
    if(Ch == "") then break end
    By = string.byte(Ch)
    if(By <= 32) then By = 32 end
    if(By == 32) then
      if(io.write) then 
        Data[WCnt] = Buff
        WCnt = WCnt + 1
        Buff = ""
      end
      io.write = false
    else
      Buff  = Buff .. Ch
      io.write = true
    end
    Cnt = Cnt + 1
  end
  if(Buff ~= "") then
    Data[WCnt] = Buff
  end
  return Data
end

Forth.ListFile = function()
    local F= io.open(Forth.File,"r")
    local Line = ""
    io.input(F)
    while(0) do
      Line = io.read()
      if(not Line) then break end
      print(Line)
    end
    io.close(F)
end

Forth.ListWords = function()
  for k,_ in pairs(Forth.Words) do
    print(k)
  end
end

--------- Words

Forth.Words = {
  ["."] = function()
    if(Forth.DataStack and Forth.State) then
      Stuff = Forth.DataStack:Get()
      if(Stuff) then print(tostring(Stuff)) end
    end
  end,
  ["DUP"] = function()
    if(Forth.DataStack and Forth.State) then
      Stuff = Forth.DataStack:Get()
      if(Stuff) then
        Forth.DataStack:Put(Stuff)
        Forth.DataStack:Put(Stuff)
      end
    end
  end,
  ["+"] = function()
    if(Forth.DataStack and Forth.State) then
      A = Forth.DataStack:Get()
      B = Forth.DataStack:Get()
      if(A and B) then
        local nA = tonumber(A)
        local nB = tonumber(B)
        if(nA and nB) then
          local Rez = B + A
          Forth.DataStack:Put(tostring(Rez))
        else
          Forth.DataStack:Put(B..A)
        end
      end
    end
  end,
  ["-"] = function()
    if(Forth.DataStack and Forth.State) then
      A = Forth.DataStack:Get()
      B = Forth.DataStack:Get()
      Log(A)
      Log(B)
      if(A and B) then
        local nA = tonumber(A)
        local nB = tonumber(B)
        if(nA and nB) then
          local Rez = B - A
          Forth.DataStack:Put(tostring(Rez))
        elseif(nA) then
          local End = string.len(B) - nA
          if(End > 0) then
            local Rez = string.sub(B,1,End)
            Forth.DataStack:Put(Rez)
          end
        else
          Forth.DataStack:Put(string.gsub(B,A,""))
        end
      end
    end
  end,
  ["*"] = function()
    if(Forth.DataStack and Forth.State) then
      A = Forth.DataStack:Get()
      B = Forth.DataStack:Get()
      if(A and B) then
        nA = tonumber(A)
        nB = tonumber(B)
        if(nA and nB) then
          Forth.DataStack:Put(B * A)
        elseif(nA and nA > 0) then
          Forth.DataStack:Put(string.rep(B,nA))
        end
      end
    end
  end,
  ["/"] = function()
    if(Forth.DataStack and Forth.State) then
      A = Forth.DataStack:Get()
      B = Forth.DataStack:Get()
      if(A and B) then
        nA = tonumber(A)
        nB = tonumber(B)
        if(nA and nB) then
          Forth.DataStack:Put(B / A)
        elseif(nA and nA > 0) then
          nA = math.floor(nA)
          local Koef = math.floor(string.len(B) / nA)
          Forth.DataStack:Put(string.sub(B,1,Koef*nA))
        end
      end
    end
  end,
  ["MOD"] = function()
    if(Forth.DataStack and Forth.State) then
      A = Forth.DataStack:Get()
      B = Forth.DataStack:Get()
      if(A and B) then
        nA = tonumber(A)
        nB = tonumber(B)
        if(nA and nB) then
          Forth.DataStack:Put(B % A)
        elseif(nA and nA > 0) then
          local End = math.floor(string.len(B))
          local Sta = End - (End % nA) + 1
          Forth.DataStack:Put(string.sub(B,Sta,End))
        end
      end
    end
  end,
  ["DROP"] = function()
    if(Forth.DataStack and Forth.State) then
      Forth.DataStack:DelTop()
    end
  end,
  ["SWAP"] = function()
    if(Forth.DataStack and Forth.State) then
      local A = Forth.DataStack:Get()
      local B = Forth.DataStack:Get()
      Forth.DataStack:Put(A)
      Forth.DataStack:Put(B)
    end
  end,
  ["EMIT"] = function()
    if(Forth.DataStack and Forth.State) then
      local A = tonumber(Forth.DataStack:Get())
      if(A) then
        A = math.floor(A)
        if(A <= 32) then A = 32 end
        print(string.char(A))
      end
    end
  end,
  ["ROT"] = function()
    if(Forth.DataStack and Forth.State) then
      local A = Forth.DataStack:Get()
      local B = Forth.DataStack:Get()
      local C = Forth.DataStack:Get()
      Forth.DataStack:Put(B)
      Forth.DataStack:Put(A)
      Forth.DataStack:Put(C)
    end
  end,
  ["OVER"] = function()
    if(Forth.DataStack and Forth.State) then
      local A = Forth.DataStack:Get()
      local B = Forth.DataStack:Get()
      Forth.DataStack:Put(B)
      Forth.DataStack:Put(A)
      Forth.DataStack:Put(B)
    end
  end,
  ["TUCK"] = function()
    if(Forth.DataStack and Forth.State) then
      local A = Forth.DataStack:Get()
      local B = Forth.DataStack:Get()
      Forth.DataStack:Put(A)
      Forth.DataStack:Put(B)
      Forth.DataStack:Put(A)
    end
  end,
  ["PICK"] = function()
    if(Forth.DataStack and Forth.State) then
      local A = tonumber(Forth.DataStack:Get())
      if(A) then
        A = math.floor(A)
        local B = Forth.DataStack:CopyGetTopRel(A)
        Forth.DataStack:Put(B)
      end
    end
  end,
  ["ROLL"] = function()  
    if(Forth.DataStack and Forth.State) then
      local A = tonumber(Forth.DataStack:Get())
      if(A) then
        A = math.floor(A)
        local B = Forth.DataStack:DelGetTopRel(A)
        Forth.DataStack:Put(B)
      end
    end
  end,
  ["="] = function()  
    if(Forth.DataStack and Forth.State) then
      local A = Forth.DataStack:Get()
      local B = Forth.DataStack:Get()
      if(A and B) then
        Forth.DataStack:Put(B)
        if(A == B) then
          Forth.DataStack:Put("-1")
        else
          Forth.DataStack:Put("0")
        end
      end
    end
  end,
  ["IF"] = function()  
    if(Forth.DataStack and Forth.State) then
      local State
      local  A = Forth.DataStack:Get()
      Forth.AddrStack:Put({"IF",Forth.PC})
      if(A == "" or A == "0") then
        --- False
      else 
        --- True
        Forth.PC = Forth.PC + 1
      end
    end
  end,
  ["ELSE"] = function()  
    if(Forth.DataStack and Forth.State) then

    end
  end,
  ["END"] = function()  
    if(Forth.DataStack and Forth.State) then

    end
  end,
  ["FOR"] = function()  
    if(Forth.DataStack and Forth.State) then

    end
  end,
  ["WHILE"] = function()  
    if(Forth.DataStack and Forth.State) then

    end
  end,
  ["S."] = function()  
    if(Forth.DataStack and Forth.State) then
      local Data = Forth.DataStack:GetData()
      local Len  = Forth.DataStack:GetTopInd()
      print("S = {")
      while(Data[Len]) do
        print("  ["..Len.."] = "..Data[Len])
        Len = Len - 1
      end
      print("}")
    end
  end,
  ["WORDS"] = function()  
    if(Forth.Words and Forth.State) then
      Forth.ListWords()
    end
  end,
}

Forth.DoString = function(Line)
    local Data
    local Word = ""
    local IsDefinition = false
    local CurrDef
    local CountWDef = 1
    local CurrDefItem
    if(Line) then
      Data = Forth.ExplodeLine(Line)
      while(0) do
        if(not Data[Forth.PC]) then break end
        Word = Data[Forth.PC]
        
        if(not IsDefinition
               and Word == ":" 
        ) then
          Forth.PC = Forth.PC + 1
          Word = Data[Forth.PC]
          print("Declare >"..Word.."<")
          IsDefinition = true
          Forth.Words[Word] = {}
          CurrDef = Forth.Words[Word]
          if(IsDefinition) then
            print("Add "..Word.." to Words ")
          end     
        elseif(IsDefinition and CurrDef) then
          if(Word == ";") then
            IsDefinition = false
            CountWDef = 1
            print("End declaration")
          end
          if(IsDefinition) then
            print("Include: "..Word)
            CurrDef[CountWDef] = Word
            CountWDef = CountWDef + 1
          end          
        elseif(not IsDefinition
           and Word
           and (tonumber(Word) or
                not Forth.Words[Word])
        ) then print("Put Value: "..Word)
          Forth.DataStack:Put(Word)
        elseif(not IsDefinition
               and Forth.Words[Word]
               and type(Forth.Words[Word]) == "function" 
        ) then print("Call Core >"..Word.."<")
          Forth.Words[Word]()
        elseif( not IsDefinition
                and type(Forth.Words[Word]) == "table"
        ) then print("Call Declarated: >"..Word.."<")
          local DefTable = Forth.Words[Word]
          local DefIter  = 1
          while(0) do
            CurrDefItem = DefTable[DefIter]
            if(not CurrDefItem) then break end
            if(Forth.Words[CurrDefItem]) then
              print("Call: >"..tostring(CurrDefItem).."<")
              Forth.Words[CurrDefItem]()
            else
              print("Put: >"..tostring(CurrDefItem).."<")
              Forth.DataStack:Put(CurrDefItem)
            end
            DefIter = DefIter + 1
          end
        end
        Forth.PC = Forth.PC + 1    
      end
    end
  print("\nOK")
end



