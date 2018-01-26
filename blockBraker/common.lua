local common = {}

local function logStatus(anyMsg, ...)
  io.write(tostring(anyMsg).."\n"); return ...
end

function common.stringImplode(tList,sDel)
  local ID, Str = 1, ""
  local Del = tostring(sDel or "")
  while(tList and tList[ID]) do
    Str = Str..tList[ID]; ID = ID + 1
    if(tList[ID] and sDel ~= "") then Str = Str..Del end
  end; return Str
end

function common.stringExplode(sStr,sDel)
  local List, Ch, Idx, ID, dL = {""}, "", 1, 1, (sDel:len()-1)
  while(Ch) do
    Ch = sStr:sub(Idx,Idx+dL)
    if    (Ch ==  "" ) then return List
    elseif(Ch == sDel) then ID = ID + 1; List[ID], Idx = "", (Idx + dL)
    else List[ID] = List[ID]..Ch:sub(1,1) end; Idx = Idx + 1
  end; return List
end

function common.stringTrim(sStr)
  return sStr:gsub("^%s+", ""):gsub("%s+$", "")
end

function common.fgetLine(pF)
  if(not pF) then return logStatus("fgetString: No file", ""), true end
  local sCh, sLn = "X", "" -- Use a value to start cycle with
  while(sCh) do sCh = pF:read(1); if(not sCh) then break end
    if(sCh == "\n") then return common.stringTrim(sLn), false else sLn = sLn..sCh end
  end; return common.stringTrim(sLn), true -- EOF has been reached. Return the last data
end

function common.getSign(anyVal)
  local nVal = (tonumber(anyVal) or 0)
  return ((nVal > 0 and 1) or (nVal < 0 and -1) or 0)
end

function common.getType(o)
  local mt = getmetatable(o)
  if(mt and mt.__type) then
    return tostring(mt.__type)
  end; return type(o)
end

-- Defines what should return /false/ when converted to a boolean
local __tobool = {
  [0]       = true,
  ["0"]     = true,
  ["false"] = true,
  [false]   = true
}

-- http://lua-users.org/lists/lua-l/2005-11/msg00207.html
function common.getBool(anyVal)
  if(not anyVal) then return false end
  if(__tobool[anyVal]) then return false end
  return true
end

return common