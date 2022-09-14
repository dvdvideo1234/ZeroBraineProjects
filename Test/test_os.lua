function directories.osChange(sB, bP, bR)
  local sB = directories.getNorm(sB)
  local sOS = metaDirectories.sNmOS
  local sSP = metaDirectories.tSupr[sOS]
  if(metaDirectories.sNmOS == "windows") then
    local sC = "cd "..(bR and "/d " or "")..sB..(bP and sSP or "")
    local bS, sE, nE = os.execute(sC)
    if(not bS) then error("Error: ".. sC) end
    return bS, sE, nE
  elseif(metaDirectories.sNmOS == "linux") then
    local sC = "cd "..sB..(bP and sSP or "")
    local bS, sE, nE = os.execute(sC)
    if(not bS) then error("Error: ".. sC) end
    return bS, sE, nE
  else
    error("Unsupported: "..sOS)
  end
end

function directories.osNew(sB, sN, bP)
  local sB = directories.getNorm(sB)
  local sOS = metaDirectories.sNmOS
  local sSP = metaDirectories.tSupr[sOS]
  if(metaDirectories.sNmOS == "windows") then
    local sC = "mkdir "..sB.."/"..sN..(bP and sSP or "")
    local bS, sE, nE, sE = os.execute(sC)
    print(bS, sE, nE, sE)
    if(not bS) then error("Error: ".. sC) end
    return bS, sE, nE
  elseif(metaDirectories.sNmOS == "linux") then
    local sC = "mkdir "..sB.."/"..sN..(bP and sSP or "")
    local bS, sE, nE = os.execute(sC)
    if(not bS) then error("Error: ".. sC) end
    return bS, sE, nE
  else
    error("Unsupported: "..sOS)
  end
end
