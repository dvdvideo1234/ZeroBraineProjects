function StatusLog(vRet,vErr)
  local tInfo, sDbg = debug.getinfo(2), ""
  sDbg = sDbg.." "..(tInfo.linedefined and "["..tInfo.linedefined.."]" or "X")
  sDbg = sDbg..(tInfo.name and tInfo.name or "Main")
  sDbg = sDbg..(tInfo.currentline and ("["..tInfo.currentline.."]") or "X")
  sDbg = sDbg.."@"..(tInfo.source and (tInfo.source:gsub("^%W", "")) or "N")
  print("Debug: "..sDbg)
  return vRet
end

local function add(a,b)
  if(not a) then return StatusLog(nil, "Missing argument A") end
  if(not b) then
    return StatusLog(nil, "Missing argument B") 
  end
  return (a + b)
end

print(add(1,   1)) --- Prints: "2" Normal  OK
print(add(1, nil)) --- Errors: [11]add[14] KO
-- print(add(nil, 1)) --- Errors: [0]Main[21] KO


