local com = require("dvdlualib/common")

hF = {["Log"]=true,["LogInstance"]=true,[""]=true}

local sPath = "E:/Documents/Lua-Projs/SVN/TrackAssemblyTool_GIT_master_POA/lua/weapons/gmod_tool/stools/trackassembly.lua"
local F, E = io.open(sPath, "rb")
local tF, iF, iL, bF = {}, 0, 0, true
if(F) then
  local sLine = F:read("*line")
  while(sLine) do iL, bF = (iL + 1), true
    -----------------------
    local fS, fE = sLine:find("function", 1, true)
    if(fS and fE) then
      local bS, bE = sLine:find("(", 1, true)
      if(bS and bE) then
        local sF = sLine:sub(fE+2, bS-1)
        if(sF and not hF[sF]) then
          bF = false
          iF = iF + 1
          tF[iF] = {iL, sF}
          tF.Size = iF
       --   print(iF, tF.Size, sF)
        end
      end
    end
    if(bF and tF.Size) then
      for iD = 1, tF.Size do
        local sF = tF[iD][2]
        local nS, nE = sLine:find(sF,1,true)
        local lS, lE = sLine:find("LogInstance",1,true)
        if(nS and nE and lS and lE and lE <= nS) then
          print("Function <"..tF[iD][2].."> found @ line ["..iL.."]")
        end
      end
    end
    -----------------------
    sLine = F:read("*line")
  end
else print(E) end

-- com.logTable(tF)