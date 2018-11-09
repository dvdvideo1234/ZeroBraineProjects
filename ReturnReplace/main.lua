local common = require("../dvdlualib/common")

local sPath = "E:/Documents/Lua-Projs/SVN/TrackAssemblyTool_GIT_master_POA/lua/weapons/gmod_tool/stools/trackassembly.lua"
local iCnt = 0
local I = io.open(sPath, "rb")
local O = io.open("ReturnReplace/out_asmlib.lua", "wb")
if(I and O) then
  local sLine = I:read("*line")
  while(sLine) do iCnt = iCnt + 1
    local nfS, nfE = sLine:find("StatusLog", 1, true)
    if(nfS and nfE) then local suBeg = sLine:sub(1, nfS-1)
      local nrS, nrE =  sLine:find("return asmlib.StatusLog", 1, true)
      local nbS = sLine:find("(", nfE, true)
      local nbE = sLine:len()-sLine:reverse():find(")",1,true)+1
      local sBra = sLine:sub(nbS, nbE) -- String withing the brackets included (true,ASDF)
      local nCo = sBra:find(",",1,true)
      local sRet = sBra:sub(2,nCo-1)
            sBra = "("..sBra:sub(nCo+1,-1) -- (ASDF)
      local sEnd = ((common.stringTrim(sLine):sub(-3,-1) == "end") and " end" or "")
      print("\n"..iCnt, sLine)
      if(not (nrS and nrE)) then break end
      local sOut = sLine:sub(1,nrS-1).."asmlib.LogInstance"..sBra.."; return "..sRet..sEnd
      print(iCnt, sOut)
      O:write(sOut.."\n")
    else
      O:write(sLine.."\n")
    end
    sLine = I:read("*line")
  end
  O:write()
  I:close(); O:flush(); O:close()
end