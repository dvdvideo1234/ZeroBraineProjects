package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

local common = require('common')

local treelib = {}
      treelib.__base = "E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/ExtractWireWiki/"
      treelib.__temp = "temp/tree/"
      treelib.__slsh = {["/"] = true, ["\\"] = true}
      treelib.__read = "*line"
      treelib.__drof = "Directory of "
      treelib.__fdat = "%d%d%-%d%d%-%d%d%d%d%s+%d%d:%d%d"
      treelib.__prnt = false -- Extract the parent directory in the tree
      treelib.__hide = false -- Extract hiddend directories
      treelib.__idir = "<DIR>"
      treelib.__pdir = {["."] = true, [".."] = true}
      treelib.__fcmd = "cd %s && dir > %s"
      treelib.__ranm = 60 -- Random string file name
      treelib.__syms = {{"└", "├", "─"}}
      
function treelib.readPath(sP, iV)
  local iT = (tonumber(iV) or 0) + 1
  local sR = common.randomGetString(treelib.__ranm)
  local vT = tostring(iT).."_"..sR
  local nT = treelib.__base..treelib.__temp..vT..".txt"
  os.execute(treelib.__fcmd:format(sP, nT))
  local fD = io.open(nT, "rb"); if(not fD) then
    return common.logStatus("treelib.readPath: Open error <"..fD..">", nil) end
  local tT, iD, sL = {hash = {iT, sR}}, 0, fD:read(treelib.__read)
    while(sL) do sL = common.stringTrim(sL)
    if(sL:sub(1, 13) == treelib.__drof) then
      tT.base = sL:sub(14, -1):gsub("\\","/")
    elseif(sL:sub(1, 17):match(treelib.__fdat)) then
      local sS = common.stringTrim(sL:sub(18, 36))
      local sN = common.stringTrim(sL:sub(37, -1))
      if(sS == treelib.__idir and treelib.__pdir[sN]) then
        if(treelib.__prnt) then
          if(not tT.cont) then tT.cont = {} end; iD = iD + 1
          tT.cont[iD] = {size = sS, name = sN}
        end
      elseif(sN:sub(1,1) == ".") then
        if(treelib.__hide) then
          if(not tT.cont) then tT.cont = {} end; iD = iD + 1
          tT.cont[iD] = {size = sS, name = sN}
        end
      else
        if(not tT.cont) then tT.cont = {} end; iD = iD + 1
        tT.cont[iD] = {size = sS, name = sN}
        local tP = tT.cont[iD]
        if(not tP.root and tP.size == treelib.__idir) then
          tP.root = treelib.readPath(sP.."/"..tP.name, iT)
        end
      end
    end
    sL = fD:read(treelib.__read)
  end; fD:close(); os.remove(nT) return tT
end

function treelib.drawPath(tP, iI)
  io.write(tP.base); io.write("\n")
  local tC, tS = tP.cont, treelib.__syms[1]
  for iD = 1, #tC do
    sX = (tC[iD+1] and tS[2] or tS[1])
    io.write(sX); io.write("\n")
  end
  io.write("\n")
end

return treelib
