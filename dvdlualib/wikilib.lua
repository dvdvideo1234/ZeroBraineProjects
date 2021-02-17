local common = require("common")

local wikilib   = {} -- Reference to the library
local wikiMList = {} -- Stores the ordered list of the APIs
local wikiMatch = {} -- Stores the APIs hashed list information
local wikiRList = {Size = 0, Meta = {}} -- Stores the markdown link
local wikiFlags  = require("dvdlualib/wikilib/flag")
local wikiType   = require("dvdlualib/wikilib/type")
local wikiFolder = require("dvdlualib/wikilib/folder")
local wikiFormat = require("dvdlualib/wikilib/format")
local wikiDChunk = require("dvdlualib/wikilib/dscchnk")
local wikiEncodeURL = require("dvdlualib/wikilib/uenc")
wikilib.common = common

-- Stores the direct API outputs based on function mnemonics ( IFF named correctly xD )
local wikiRefer = { ["is"] = "n",
  __this = {"dump", "res", "set", "upd", "smp", "add", "rem", "no", "new"}
}
-- What to write or output when something is missing
local wikiNotHere = "N/A"
-- Pattern for something in brackets including the brakets
local wikiBraketsIN = "%(.-%)"
-- What the instance creator might start with
local wikiMakeOOP = {["new"]=true, ["no"]=true, ["make"]=true, ["create"]=true}
-- https://stackoverflow.com/questions/17978720/invisible-characters-ascii
local wikiSpace = string.char(0xC2)..string.char(0xA0) -- Space character for (``) quote
-- A bunch of patterns when matched transform a word into MD quote
local wikiQuote = {["%d"] = true, ["_"]=true, ["%l%u"]=true, ["%u+%u+"]=true}
-- Characters to exclude from the word quoting
local wikiDiver = {[","]=true, [")"]=true, ["("] = true, ["."] = true}
-- Stores the new line abbreviature in MD
local wikiNewLN = "  "
-- Stores the symbol for line divider and the repetition count
local wikiLineDiv = {"-", 120}
-- Stores placeholder background and freground image colors
local wikiColorPH = {{0,0,0}, {0,0,0}}
-- Dividers when the script processes a cascade token
local wikiDivTok = {[","]=true, [")"]=true, ["("] = true, ["."] = true, ["/"] = true}
-- This holds break conditions for the loops that my be stuck during execution
local wikiLoopTM = {Cnt = 10}

local function isQuote(sS)
  local bLet = wikilib.common.stringHasLetter(sS)
  local bUpp = wikilib.common.stringIsUpper(sS)
  return (bLet and bUpp)
end

local function toURL(dir, soc)
  return (wikiFormat.__url:format(tostring(soc or "https"), dir))
end

local function toQSQ(...)
  return (wikiFormat.__sss:format(...))
end

local function toType(...)
  return (wikiFormat.__tfm:format(...))
end

local function toWireDSC(...)
  return (wikiFormat.__wds:format(...))
end

local function toCountry(...)
  return (wikiFormat.__tfc:format(...))
end

local function toLocal(...)
  return (wikiFormat.__loc:format(...))
end

local function toImgSrcHTML(...)
  return (wikiFormat.__hsr:format(...))
end

local function toImgHTML(...)
  return (wikiFormat.__hmg:format(...))
end

local function toImgBanner(...)
  return (wikiFormat.__bnr:format(...))
end

local function toLinkURL(...)
  return (wikiFormat.__lnk:format(...))
end

local function toLinkRef(...)
  return (wikiFormat.__rbr:format(...))
end

local function toLinkRefSrc(...)
  return (wikiFormat.__lrs:format(...))
end

local function toRef(...)
  return (wikiFormat.__ref:format(...))
end

local function toRefer(...)
  return (wikiFormat.__rty:format(...))
end

local function toImage(...)
  return (wikiFormat.__img:format(...))
end

local function toInsert(...)
  return (wikiFormat.__ins:format(...))
end

local function toCountryURL(...)
  return (wikiFormat.__cou:format(...))
end

local function toTypeURL(...)
  return (wikiFormat.__typ:format(...))
end

local function toBracket(...)
  return wikiFormat.__brk:format(...)
end

local function toReferID(...)
  return (wikiFormat.__rid:format(...))
end

local function apiSortFinctionParam(a, b)
  return (table.concat(a.par) < table.concat(b.par))
end

local function getFunctionName(vS)
  return "wikilib."..wikilib.common.stringGetFunction(vS, wikiNotHere)
end  

local function sortMatch(tM)
  table.sort(tM, apiSortFinctionParam)
end

local function wikilibError(sM, bE)
  local sF = tostring(debug.getinfo(2).name)
  local sO = "wikilib."..sF..": "..sM
  wikilib.common.logStatus(sO, nil)
  if(bE) then error(sO) end
end

local function apiGetValue(API, sTab, sKey, vDef)
  local tTab = API[sTab]
  local bTab = wikilib.common.isTable(tTab)
  return (bTab and tTab[sKey] or vDef)
end

function wikilib.isFlag(sF, bF)
  local sF = tostring(sF or wikiNotHere); if(sF == wikiNotHere) then
    wikilibError("Flag hash missing !", wikiFlags.erro) end
  local cF = wikiFlags[sF]; if(not wikilib.common.isBool(cF)) then 
    wikilibError("Flag ["..sF.."] type ["..type(cF).."] !", wikiFlags.erro) end
  if(not wikilib.common.isNil(bF)) then
    wikiFlags[sF] = wikilib.common.toBool(bF)
  end; return wikiFlags[sF]
end

function wikilib.newLoopTerm(sKey, vO, vN)
  wikiLoopTM[sKey] = {vN, vO, wikiLoopTM.Cnt}
end

function wikilib.annLoopTerm(sKey)
  wikiLoopTM[sKey] = nil
end

function wikilib.setLoopTerm(sKey, vN)
  if(not sKey) then return end
  local tT = wikiLoopTM[sKey]
  tT[2] = tT[1] -- Pushes down
  tT[1] = vN -- Recieve value
  return tT
end

function wikilib.isLoopTerm(sKey, vN)
  if(not sKey) then return end
  local tT = wikilib.setLoopTerm(sKey, vN)
  local cN, cO, cC = unpack(tT)
  if(cN == cO) then -- No loop change
    cC = cC - 1 -- Decrement thr try
  else -- Reset counter when different
    cC = wikiLoopTM.Cnt -- Reset
  end; tT[3] = cC
  if(cC <= 0) then
    wikilib.annLoopTerm(sKey)
  end; return (cC <= 0)
end

function wikilib.setFormat(sK, sS)
  wikiFormat["__"..sK] = sS
end

function wikilib.insYoutubeVideo(sK, iD)
  local nD = tonumber(iD)
  return wikiFormat.__ytb:format(sK, (nD and math.floor(common.getClamp(nD, 0 ,3)) or 0), sK)
end

function wikilib.insReferID(iD, sNam, sURL)
  return toLinkRef(toReferID(iD, sNam), sURL)
end

function wikilib.insImage(sURL)
  return toInsert(toLinkURL("", sURL))
end

function wikilib.insLocal(sP)
  return toInsert(toLinkURL("", toLocal(sP:gsub("\\","/"))))
end

function wikilib.insCountry(sC)
  return toInsert(toLinkURL("", toCountryURL(wikiFormat.__prj, toCountry(sC))))
end

function wikilib.insRefCountry(sC)
  local sR = toRefer("cou-"..sC); return toInsert(toImage(sR)),
    toLinkRef(sR, toCountryURL(wikiFormat.__prj, toCountry(sC)))
end

function wikilib.insType(sC)
  return toInsert(toLinkURL("", toTypeURL(wikiFormat.__prj, toType(sC))))
end

function wikilib.setInternalType(API)
  local aT = wikiRefer.__this
  for ID = 1, #aT do local key = aT[ID]
    wikiRefer[key] = tostring(apiGetValue(API,"TYPE", "OBJ") or "xxx")
  end
end

function wikilib.addPrefixNameOOP(...)
  local tA = {...}; if(type(tA[1]) == "table") then tA = tA[1] end
  for key, val in ipairs(tA) do
    local sv = wikilib.common.stringTrim(tostring(val or ""))
    if(sv ~= "") then wikiMakeOOP[sv] = true end
  end
end

function wikilib.remPrefixNameOOP(...)
  local tA = {...}; if(type(tA[1]) == "table") then tA = tA[1] end
  for key, val in ipairs(tA) do
    local sv = wikilib.common.stringTrim(tostring(val or ""))
    if(sv ~= "") then wikiMakeOOP[sv] = false end
  end
end

function wikilib.setDecoderURL(vE)
  local sE = tostring(vE or wikiEncodeURL.mod)
  if(wikiEncodeURL.enc[sE]) then wikiEncodeURL.mod = sE else
    wikilibError("Code mismatch <"..sE.."> !", bErr) end
end

function wikilib.urlSymbolize(sURL)
  local sB = tostring(sURL or "")
  local tO = {Size = 0}
  for iD = 1, sB:len() do
    tO.Size = tO.Size + 1
    tO[tO.Size] = sB:sub(iD,iD)
  end; return tO
end

function wikilib.getDecodeURL(sURL)
  local sK = tostring(wikiEncodeURL.mod)
  if(not wikiEncodeURL.enc[sK]) then
    wikilibError("Code missing <"..sK.."> !", bErr) end
  local nB, nE = 0, 0
  local cU = tostring(sURL or ""):rep(1)
  for key, val in pairs(wikiEncodeURL.dec[sK]) do
    local nB, nE = cU:find(key, nB + 1, true)
    if(nB and nE) then
      cU = cU:sub(1, nB-1)..string.char(val)..cU:sub(nE+1, -1)
    end
  end; return cU
end

function wikilib.getEncodeURL(sURL)
  local sK = tostring(wikiEncodeURL.mod)
  if(not wikiEncodeURL.enc[sK]) then
    wikilibError("Code missing <"..sK.."> !", bErr) end
  local cU, sO = tostring(sURL or ""):rep(1), ""
  local tU = wikilib.urlSymbolize(cU)
  for iD = 1, tU.Size do
    local sC = tU[iD]
    local iC = sC:byte()
    if((iC >= 127) or (iC < 32) or (not sC:find("[%./A-Za-z0-9]"))) then
      tU[iD] = wikiEncodeURL.enc[sK][iC]
    end
  end; return table.concat(tU, "")
end

function wikilib.isEncodedURL(sURL)
  return ((tostring(sURL or ""):find("%%[A-Za-z0-9][A-Za-z0-9]")) > 0 and true or false)
end

function wikilib.findTokenCloser(sT, tR, iD)
  local iM, tM = 0, {}
  local mF, mB, mK, mV, mP
  for k, v in pairs(tR) do
    if(k:sub(1,1) ~= "#") then
      local nF, nB = sT:find(k, iD, true)
      if(nF and nB) then
        if(not (mF and mB and mK)) then  
          mF, mB, mK, mV, mP = nF, nB, k, v, false
          iM = iM + 1; tM[iM] = {mF, mB, mK, mV, mP}
        else
          if(nF <= mF and mF >= iD) then
            mF, mB, mK, mV, mP = nF, nB, k, v, false
            iM = iM + 1; tM[iM] = {mF, mB, mK, mV, mP}
          end
        end
      else nF, nB = sT:find(k, iD)
        if(nF and nB) then
          if(not (mF and mB and mK)) then
            mF, mB, mK, mV, mP = nF, nB, k, v, true
            iM = iM + 1; tM[iM] = {mF, mB, mK, mV, mP}
          else
            if(nF <= mF and mF >= iD) then
              mF, mB, mK, mV, mP = nF, nB, k, v, true
              iM = iM + 1; tM[iM] = {mF, mB, mK, mV, mP}
            end
          end
        end
      end
    end
  end

  if(iM > 1) then
    -- Obtain the closest token for replace
    table.sort(tM, function(a, b) return a[1] < b[1] end)
    mF, mK = tM[1][1], 1
    -- Wipe all the tokens from the list being ferther
    while(tM[mK]) do local vM = tM[mK]
      if(vM[1] > mF) then table.remove(tM, mK) else mK = mK + 1 end end
    -- Obtain the record having the longest token found (greedy)
    table.sort(tM, function(a, b)
      local na = (a[2] - a[1] + 1)
      local nb = (b[2] - b[1] + 1)
      return na > nb
    end); mB = tM[1]
    return mB[1], mB[2], mB[3], mB[4], mB[5]
  elseif(iM == 1) then local vM = tM[1]
    return vM[1], vM[2], vM[3], vM[4], vM[5]
  end
  return nil
end

--[[
 * sT > The sting to be tokenized
 * tR > Replace token table
 * tS > Set of parameters for found token
]]
function wikilib.replaceToken(sT, tR, tS)
  local sF = getFunctionName(1)
  local bF = wikilib.isFlag("prep")
  local bQ = wikilib.isFlag("qref")
  local bR = wikilib.isFlag("ufbr")
  local qR = wikilib.common.getPick(bQ, "`", "")
  local sD, sN, iD, dL = tostring(sT or ""), "", 1, 0
  if(tR and wikilib.common.isTable(tR)) then
    local mF, mB, mK, mV, mP = wikilib.findTokenCloser(sD, tR, iD)
    wikilib.newLoopTerm(sF, mF, iD)
    while(mF and mB) do
      if(wikilib.common.isTable(mV)) then
        local tV = {mF, mB, mK, mV, mP} -- Send the parameters to next stage
        local vD, vL = wikilib.replaceToken(sD, mV, tV)
        iD, sD = (mB + vL), vD
      else local nF, nB = (mF-1), (mB+1)
        local sX = (bF and mV:format(mK) or mV)
        local cF, cB = sD:sub(nF,nF), sD:sub(nB,nB)
        local fX = toBracket(sX)
        if(bR) then fX = toRef(wikilib.getTokenReference(mK, mV)) end
        if(cF..cB == "``") then
          sN = sD:sub(1,nF-1)..toQSQ(cF,mK,cB)..fX -- Concatenate the link to the beginning
          sD, iD = sN..sD:sub(nB+1,-1), sN:len() + 1 -- Concatenate the rest and search in there
          if(tS and mF < tS[1] and mB < tS[1]) then -- Check if the string found is on the front
            dL = dL + sX:len() + 4 -- How many symbols are added in the conversion overall
          end -- Update lenght only if the string is in front of the pattern with adjusted length
        elseif(cF..cB == "  " or cF..cB == " ") then
          sN = sD:sub(1,nF)..toQSQ(qR,mK,qR)..fX
          sD, iD = sN..sD:sub(nB,-1), sN:len() + 1
          if(tS and mF < tS[1] and mB < tS[1]) then
            dL = dL + sX:len() + 4 + (2 * qR:len())
          end
        elseif(wikiDivTok[cB] or wikiDivTok[cF]) then
          sN = sD:sub(1,nF)..toQSQ(qR,mK,qR)..fX
          sD, iD = sN..sD:sub(nB,-1), sN:len() + 1
          if(tS and mF < tS[1] and mB < tS[1]) then
            dL = dL + sX:len() + 4 + (2 * qR:len())
          end
        elseif(cF:find("%w+") or cB:find("%w+")) then
          iD = mB -- Skip searcing when token is found within a word
        else
          wikilib.common.logStatus(sF.."("..mK.."): Unmached case "..("<%s|%s>"):format(cF, cB))
        end
      end
      mF, mB, mK, mV, mP = wikilib.findTokenCloser(sD, tR, iD)
      if(wikilib.isLoopTerm(sF, mF)) then
        local sM = sF.."(%s): Terminated <%d|%d> mismatch [%s]!"
        wikilibError(sM:format(mK, mF, mB, sD), true)
      end
    end
  end; return sD, dL
end

function wikilib.updateAPI(API, DSC)
  local wD = wikilib.isFlag("wdsc")
  local sO, tA, tW = apiGetValue(API,"TYPE", "OBJ")  
  wikilib.addPrefixNameOOP(apiGetValue(API,"TYPE", "DSG"))
  if(wD) then
    API.POOL.WDESCR = {}
    tW = API.POOL.WDESCR
  end
  for api, dsc in pairs(DSC) do
    if(wD) then
      table.insert(tW, toWireDSC(api, dsc))
    end
    if(apiGetValue(API,"FLAG", "quot")) then
      local tD = wikilib.common.stringExplode(dsc, " ")
      for ID = 1, #tD do local sW = tD[ID]
        local cQ = sW:sub(1,1)..sW:sub(-1,-1)
        for k, v in pairs(wikiQuote) do
          if((sW:match(k) and cQ ~= "``") or isQuote(sW)) then
            local sF, sB = sW:sub(1,1), sW:sub(-1,-1)
            if(wikiDiver[sF] or wikiDiver[sB]) then
              local nF, nB = 1, sW:len() -- Strip exclusion characters
              local sF, sB = sW:sub(nF,nF), sW:sub(nB,nB)
              while((wikiDiver[sF] or wikiDiver[sB]) and nF < nB) do
                if(wikiDiver[sF]) then nF = nF + 1 end
                if(wikiDiver[sB]) then nB = nB - 1 end
                sF, sB = sW:sub(nF,nF), sW:sub(nB,nB)
              end
              tD[ID] = sW:sub(1,nF-1).."`"..sW:sub(nF,nB).."`"..sW:sub(nB+1,-1)
            else
              tD[ID] = "`"..sW.."`"
            end
          end
        end
      end; dsc = table.concat(tD, " "); DSC[api] = dsc
    end

    if(wikiMakeOOP[api:gsub(API.NAME..wikiBraketsIN, "")] -- newNAME()
      or api:find(API.NAME..wikiBraketsIN) == 1) then     --    NAME()
      tA = API.POOL[1] -- The function is class creator
    elseif(api:find(sO..":")) then
      tA = API.POOL[2] -- The finction is calss method
    else -- Some other helper function for the class
      tA = API.POOL[3] -- The functoion is a helper API
    end
    if(API.REPLACE) then local tR = API.REPLACE
      DSC[api] = wikilib.replaceToken(DSC[api], tR)
    end
    table.insert(tA, api)
  end
  if(wD) then table.sort(tW)
    for iD = 1, #tW do io.write(tW[iD]) end
    io.write("\n")
    io.write(wikiLineDiv[1]:rep(wikiLineDiv[2]))
    io.write("\n\n")
  end
end

function wikilib.setDescriptionChunk(sT, sB, sD)
  wikiDChunk.top = table.concat({sT,wikiDChunk.inj},"\n")
  wikiDChunk.bot = table.concat({wikiDChunk.inj,sB},"\n")
  wikiDChunk.mch = tostring(sD or "DSC")
end -- The return value is automatically injected into the chunk

function wikilib.readDescriptions(API)
  local sC   = "" -- This stores description chunk
  local sE2  = apiGetValue(API,"FILE", "exts")
  local sBas = apiGetValue(API,"FILE", "base")
  local sLua = apiGetValue(API,"FILE", "slua")
  local cT = apiGetValue(API,"HDESC", "top")
        cT = "return function()\n"..(cT or wikiDChunk.top)
  local cB = apiGetValue(API,"HDESC", "bot")
        cB = (cB or wikiDChunk.bot).." end"
  local cD = apiGetValue(API,"HDESC", "dsc")
        cD = cD or wikiDChunk.dsc
        cD = (cD and tostring(cD) or "")
  local sI = apiGetValue(API,"HDESC", "inj")
        sI = sI or wikiDChunk.inj
        sI = (sI and tostring(sI) or "")
  if(API.DSCHUNK) then wikilib.common.logStatus("Description: API > "..type(API.DSCHUNK))
    if(wikilib.common.isString(API.DSCHUNK)) then
      sC = (cT..sI..API.DSCHUNK..sI..cB)
    elseif(wikilib.common.isFunction(API.DSCHUNK)) then wikilib.common.logStatus("Description: API > "..type(API.DSCHUNK))
      local bS, sC = pcall(API.DSCHUNK)
      if(bS) then sC = (cT..sI..sC..sI..cB)
      else wikilib.common.logStatus("wikilib.readDescriptions: API chink unsuccessful: "..type(API.DSCHUNK)) end
    else wikilib.common.logStatus("wikilib.readDescriptions: API chink not supported: "..type(API.DSCHUNK)) end
  else
    local sN = wikilib.common.normFolder(sBas)..common.normFolder(sLua)
          sN = sN.."cl_"..sE2:lower()..".lua"
    local fR = io.open(sN, "rb"); if(not fR) then
      return wikilib.common.logStatus("wikilib.readDescriptions: No file <"..sN..">") end
    wikilib.common.logStatus("Description: FILE > "..sN)
    sC = (cT..sI..fR:read("*all")..sI..cB)
  end
  local fC, oE = load(sC)
  if(fC) then local bS, fC = pcall(fC)
    if(bS) then bS, fC = pcall(fC)
      if(bS) then
        if(wikilib.common.isDryTable(fC)) then
          wikilib.common.logStatus("wikilib.readDescriptions[3]: Compilation chunk:\n")
          wikilib.common.logStatus("--------------------------------------------\n")
          wikilib.common.logStatus(sC)
          wikilib.common.logStatus("--------------------------------------------\n")
          error("wikilib.readDescriptions[3]: Description empty !")
        elseif(not fC) then
          wikilib.common.logStatus("wikilib.readDescriptions[3]: Compilation chunk:\n")
          wikilib.common.logStatus("--------------------------------------------\n")
          wikilib.common.logStatus(sC)
          wikilib.common.logStatus("--------------------------------------------\n")
          error("wikilib.readDescriptions[3]: Description return value empty !")
        end; return fC
      else
        wikilib.common.logStatus("wikilib.readDescriptions[2]: Compilation chunk:\n")
        wikilib.common.logStatus("--------------------------------------------\n")
        wikilib.common.logStatus(sC)
        wikilib.common.logStatus("--------------------------------------------\n")
        error("wikilib.readDescriptions[2]: Execution error: "..fC)
      end
    else
      wikilib.common.logStatus("wikilib.readDescriptions[1]: Compilation chunk:\n")
      wikilib.common.logStatus("--------------------------------------------\n")
      wikilib.common.logStatus(sC)
      wikilib.common.logStatus("--------------------------------------------\n")
      error("wikilib.readDescriptions[1]: Execution error: "..fC)
    end
  else
    wikilib.common.logStatus("wikilib.readDescriptions: Compilation chunk:\n")
    wikilib.common.logStatus("--------------------------------------------\n")
    wikilib.common.logStatus(sC)
    wikilib.common.logStatus("--------------------------------------------\n")
    error("wikilib.readDescriptions: Compilation error: "..oE)
  end
end

function wikilib.printTypeReference(API, bExt)
  local tT, sL = wikiType.list, apiGetValue(API,"TYPE", "LNK")
  local bE = wikilib.isFlag("extr") -- Use external wire types
  for ID = 1, #tT do local iDx = (bE and 2 or 1)
    if(tT[ID][iDx] ~= "") then
      local ref, typ = toRefer(tT[ID][1]), toType(tT[ID][iDx])
      io.write(toLinkRef(ref, sL:format(typ)).."\n")
    end
  end; io.write("\n")
end

function wikilib.printRow(tT)
  io.write("|"..table.concat(tT, "|").."|\n")
end

function wikilib.printLinkReferences(API)
  local tRef = API.REFLN
  if(common.isTable(tRef)) then
    for k, v in ipairs(tRef) do
      io.write(toLinkRef(tostring(v[1] or ""), tostring(v[2] or "")).."\n")
    end
  end
end

--[[
  sT > Text to process
  bP > Enable pictures
  bD > Dicable and return empry string
]]--
function wikilib.concatType(API, sT)
  local sV = tostring(sT)
  local sS, sA = wikiFormat.tsp, wikiFormat.asp
  if(sV:sub(1,1) == sS) then sV = sV:sub(2,-1) end
  local sVo = wikilib.convTypeE2Description(API, "void")[1]
  local bVo = wikilib.isFlag("remv")
  if(bVo and sV == sVo) then return "" end
  local bI = wikilib.isFlag("icon")
  if(bI) then
    local sL = apiGetValue(API,"TYPE", "LNK")
    local exp = wikilib.common.stringExplode(sV, sS)
    for iN = 1, #exp do
      if(bVo and exp[iN] == sVo) then exp[iN] = ""
      else
        exp[iN] = toInsert(toImage(toRefer(exp[iN])))
      end
    end
    return table.concat(exp, sA)
  else
    return sV:gsub(sS, sA)
  end
end

function wikilib.readReturnValues(API)
  local sBas = apiGetValue(API,"FILE", "base")
  local sPth = apiGetValue(API,"FILE", "path")
  local sE2  = apiGetValue(API,"FILE", "exts")
  local sN = wikilib.common.normFolder(sBas)..common.normFolder(sPth)
        sN = sN..sE2:lower().."_rt.txt"
  local fR = io.open(sN, "r"); if(not fR) then
    return wikilib.common.logStatus("wikilib.readReturnValues: No file <"..sN..">") end
  local sL = fR:read("*line")
  while(sL ~= nil) do
    local sT = wikilib.common.stringTrim(sL)
    if(sL ~= "") then
      local tT = wikilib.common.stringExplode(sT, ":")
      tT[1] = wikilib.common.stringTrim(tostring(tT[1]))
      tT[2] = wikilib.common.stringTrim(tostring(tT[2]))
      wikiMatch[tT[1]] = tT[2]
    end
    sL = fR:read("*line")
  end
end

function wikilib.convTypeE2Description(API, sT)
  return wikiType.list[wikiType.idx[sT]]
end

-- e2function stcontrol stcontrol:setPower(number nP, number nI, number nD)
function wikilib.convApiE2Description(API, sE2)
  local iS, tD, sT, sR = nil, nil
  local sE = wikilib.common.stringTrim(sE2)
  local sM, sA = wikiFormat.msp, wikiFormat.asp
  local pF, pV = wikiFormat.fpt, wikiFormat.vpt
  local bErr = wikilib.isFlag("erro")
  local bNfr = wikilib.isFlag("nxtp")
  if(sE:sub(1,10) == "e2function") then
    local tInfo, tTyp = {}, API.TYPE; tInfo.row = sE2
    sE = wikilib.common.stringTrim(sE:sub(11, -1)); iS = sE:find("%s", 1)
    sR = common.stringTrim(sE:sub(1, iS))
    -- Remove the header and extract function return type
    local tD = wikilib.convTypeE2Description(API, sR)
    if(not tD) then
      wikilib.common.logStatus("wikilib.convApiE2Description: Return line <"..sE2.."> !")
      wikilibError("Return type missing <"..sE2.."> !", bErr)
    end; tInfo.ret = tD[1]
    sE = wikilib.common.stringTrim(sE:sub(iS, -1)); iS = sE:find(sM, 1, true)  
    if(iS) then -- Is this function a object method
      local sT = common.stringTrim(sE:sub(1, iS-1))
      local tD = wikilib.convTypeE2Description(API, sT)
      if(not tD) then
        wikilib.common.logStatus("wikilib.convApiE2Description: API mismatch <"..sE2.."> !")
        wikilibError("Type missing <"..sT.."> !", bErr)
      end; tInfo.obj = tD[1]
      sE = wikilib.common.stringTrim(sE:sub(iS+1, -1))
    end
    local nS, nE = sE:find(wikiBraketsIN)
    if(nS and nE) then
      tInfo.foo = wikilib.common.stringTrim(sE:sub(1, nS - 1))
      if(not tInfo.foo:find(pF)) then
        wikilib.common.logStatus("wikilib.convApiE2Description: API mismatch <"..sE2.."> !")
        wikilibError("Function name invalid <"..tInfo.foo.."> !", bErr)
      end -- Extract the function name and chech for valid name
      tInfo.par = wikilib.common.stringExplode(sE:sub(nS + 1, nE - 1), sA)
      local sT, sP, nN = "", tInfo.par[1], #tInfo.par
      if(wikilib.common.isDryString(sP)) then
        tInfo.par[1] = "void"; sP = tInfo.par[1]
      end -- Extract the function parameters
      for iD = 1, nN do
        sP = wikilib.common.stringTrim(tInfo.par[iD])
        if(sP ~= "void") then -- No parameter functions
          local nS, nE = sP:find("%s+")
          if(nS and nE) then
            sT = sP:sub(1, nS - 1)
            sP = sP:sub(nE + 1, -1)
          else -- Thre is only a parameter name with no type
            if(bNfr) then -- Type defaults to number when enabled
              sT = "number"
            else -- Generate error otherwise
              wikilib.common.logStatus("wikilib.convApiE2Description: Force number flag `nxtp = true` !")
              wikilibError("Type auto-correct <"..sE2.."> !", bErr)
            end
          end
          if(not sP:find(pV)) then -- Parameter name is crappy
            wikilib.common.logStatus("wikilib.convApiE2Description: API mismatch <"..sE2.."> !")
            wikilibError("Parameter name invalid <"..sP.."> !", bErr)
          end
          local tD = wikilib.convTypeE2Description(API, sT)
          if(not tD) then -- Then the type exists in the table and it is valid
            wikilib.common.logStatus("wikilib.convApiE2Description: API Parameter mismatch <"..sE2.."> !")
            wikilibError("Parameter type missing <"..sT.."> !", bErr)
          end
          tInfo.par[iD] = tD[1] -- Extract the wiremod internal data type
        else -- If the first parameter is void stop checking the others
          tInfo.par[iD] = "" -- The void type is not inserted in description
          if(nN > 1) then
            wikilib.common.logStatus("wikilib.convApiE2Description: API Parameter mismatch <"..sE2.."> !")
            wikilibError("Non single void <"..sT.."> !", bErr)
          end
        end
      end
    else -- In case of the parameters have unbalanced bracket
      wikilibError("Brackets mssing <"..sE2.."> !", bErr)
    end    
    tInfo.com = tInfo.foo.."("
    if(tInfo.obj) then
      tInfo.com = tInfo.com..tInfo.obj..sM end
    for iD = 1, #tInfo.par do
      tInfo.com = tInfo.com..tInfo.par[iD]
    end; tInfo.com = tInfo.com..")"; return tInfo
  end; return nil -- Return nothing when the line does not define E2 function
end

function wikilib.isValidMatch(tM)
  if(tM.__nam:sub(1,3) ~= "set") then return true end
  local tL = {}; for ID = 1, tM.__top do local vM = tM[ID]
    if(not tL[vM.com]) then tL[vM.com] = {} end
    table.insert(tL[vM.com], ID)
  end
  for api, val in pairs(tL) do
    local all = #val; if(all  > 1) then
      return wikilib.common.logStatus("wikilib.isValidMatch: API <"..api.."> doubled", false)
    end
  end; return true
end

function wikilib.makeReturnValues(API)
  local sE2  = apiGetValue(API,"FILE", "exts")
  local sBas = apiGetValue(API,"FILE", "base")
  local sLua = apiGetValue(API,"FILE", "slua")
  local sN = wikilib.common.normFolder(sBas)..common.normFolder(sLua)
  local sM, sE = wikiFormat.msp, wikiFormat.esp
        sN = sN..sE2:lower()..".lua"
  local fR = io.open(sN, "r"); if(not fR) then
    wikilibError("No file <"..sN..">!", true) end
  local sL, tF, tK, sA, bA, bE = fR:read("*line"), wikiMatch, wikiMList, "", false, false
  local mP, mH, mF = wikiFormat.npt, wikiFormat.hsh, wikiFormat.fnd
  while(sL ~= nil) do
    local fL = wikilib.common.stringTrim(sL)
    local eL = fL:find(mP)
    local mL = fL:gsub(mP, mH)
    if(fL:find(mF) and not bA) then sA, bA = "", true end
    if(bA) then sA = sA.." "..fL
      if(mL:find(")")) then sA = wikilib.common.stringTrim(sA)
        local tE = wikilib.common.stringExplode(sA, sE)
        local sP, sO = wikilib.common.stringTrim(tE[1]), nil
        if(tE[2]) then sO = wikilib.common.stringTrim(tE[2]) end
        local tL = wikilib.common.stringExplode(sP, " ")
        local typ, foo = tL[2], tL[3]
        local mth = (foo:find(sM) or  0)
        local brk = (foo:find("%(") or -1)
              foo = foo:sub(mth+1, brk-1)
        local tP = tF[foo]; if(not tP) then
          tF[foo] = {__top = 0, __key = {}, __nam = foo}; tP = tF[foo] end
        tP.__top = tP.__top + 1        
        local tInfo = wikilib.convApiE2Description(API, sP)
        tP.__key[tInfo.com] = tP.__top; tP[tP.__top] = tInfo
        if(sO) then tP.__equ = wikilib.convApiE2Description(API, sO) end
        if(not tK.__top) then tK.__top = 0 end
        tK.__top = tK.__top + 1; tK[tK.__top] = tInfo.com
        -- Register API and and write to the memory
        sA, bA = "", false
      end
    end; sL = fR:read("*line")
  end; return tF
end

function wikilib.printMatchedAPI(API, DSC, sNam)
  local tK, bF = wikiMList, false; table.sort(tK)
  local sD = apiGetValue(API, "HDESC", "dsc")
  local sN = tostring(sNam or (sD or wikiDChunk.mch))
  local bErr = wikilib.isFlag("erro")
  for ID = 1, tK.__top do
    if(not DSC[tK[ID]]) then bF = true
      wikilib.common.logStatus(sN.."[\""..tK[ID].."\"] = \"\"") end
  end
  if(bF) then wikilibError("No file <"..sN..">!", bErr) end
end

function wikilib.printTypeTable(API)
  local tT = wikiType.list
  wikilib.printRow({"Icon", "Internal", "External", "Description"})
  wikilib.printRow({":---:", ":---:", ":---:", "---"})
  local sQ = wikilib.isFlag("qref") and "`" or ""
  local bQ = wikilib.isFlag("quot")
  for ID = 1, #tT do local sL = tT[ID][5]
    local sI = wikilib.common.stringTrim(tT[ID][1])
    local sP = toInsert(toImage(toRefer(sI)))
          sI = (bQ and "`"..sI.."`" or sI)
    local sD = wikilib.common.stringTrim(tT[ID][3])
    local sT = wikilib.common.stringTrim(tT[ID][4])
          sT = (bQ and "`"..sT.."`" or sT)
    if(sL and not wikilib.common.isDryString(sL)) then
      sL = wikilib.common.stringTrim(sL)
      local sR = sD:match("%[.+%]"); if(sR) then
        sR = sR:gsub("%[", "%%%["):gsub("%]", "%%%]")
        sD = sD:gsub(sR, sR:gsub("%[", "%["..sQ):gsub("%]", sQ.."%]").."%("..sL.."%)")
      end
    end
    wikilib.printRow({sP, sI, sT, sD})
  end; io.write("\n")
end

function wikilib.printDescriptionTable(API, DSC, iN)
  local bMsp = wikilib.isFlag("mosp")
  local bIco = wikilib.isFlag("icon")
  local bErr = wikilib.isFlag("erro")
  local sObj = apiGetValue(API, "TYPE", "OBJ")
  local tPool = apiGetValue(API, "POOL", iN); if(not tPool) then return end
  local nC, tC, tH = #tPool.cols, {}, {}
  for ID = 1, nC do local scol = tPool.cols[ID]
    local csiz, clen = tPool.size[ID], scol:len(); if(csiz < clen) then
      wikilibError("Header overflow <"..scol.."> ["..csiz.." < "..clen.."] !", bErr) end
    local ccat = ((csiz - clen) / 2)
    local fcat, bcat = math.floor(ccat), math.ceil(ccat)
    local algn = tPool.algn; algn = (algn and algn[ID] or nil)
    tH[ID] = ("-"):rep(common.getClamp((csiz or clen), 3))
    if(algn) then
      if    (algn:sub(1,1) == "<") then tH[ID] = ":"..tH[ID]:sub(2,-1)
      elseif(algn:sub(1,1) == ">") then tH[ID] = tH[ID]:sub(1,-2)..":"
      elseif(algn:sub(1,1) == "|") then tH[ID] = ":"..tH[ID]:sub(2,-2)..":"
      else wikilibError("Alignment invalid <"..algn.."> !", bErr) end
    end
    tC[ID] = wikiSpace:rep(fcat)..scol:gsub("%s+",wikiSpace)..wikiSpace:rep(bcat)
  end; table.sort(tPool); tPool.data = {}
  wikilib.printRow(tC); wikilib.printRow(tH)
  local sM = wikiFormat.msp
  local sS, sA = wikiFormat.tsp, wikiFormat.asp
  local sV = wikilib.convTypeE2Description(API,"void")[1]
  for i, n in ipairs(tPool) do
    local arg, vars, obj = n:match(wikiBraketsIN), "", ""
    if(arg) then arg = arg:sub(2,-2)
      local tsk = wikilib.common.stringExplode(arg, sM)
      if(not arg:find(sM)) then
        tsk[2], tsk[1] = tsk[1], sV end
      if(tsk[2] == "") then tsk[2] = sV end
      tsk[1], tsk[2] = wikilib.common.stringTrim(tsk[1]), wikilib.common.stringTrim(tsk[2])
      local k, len = 1, tsk[2]:len(); obj = sS..tsk[1]
      while(k <= len) do local sbc = tsk[2]:sub(k,k)
        if(sbc == "x") then -- Wiremod type is three letters
          sbc = tsk[2]:sub(k, k+2); k = (k + 2) -- The end of the current type
        end; k = (k + 1)
        vars = vars..sS..sbc
      end
    end
    local iM = 0
    for rmk, rmv in pairs(wikiMatch) do
      if(n:find(rmk.."%(") and rmv.__top > 0) then iM = iM + 1
        if(not wikilib.isValidMatch(rmv)) then
          wikilibError("Duplicated function <"..rmv.__nam.."> !", bErr) end
        local ret = ""; sortMatch(rmv)
        for ID = 1, rmv.__top do local api = rmv[ID]; ret = api.ret
          if(not DSC[api.com]) then
            wikilib.common.logStatus("wikilib.printDescriptionTable: API missing <"..api.row.."> !")
            wikilibError("Description missing <"..api.com.."> !", bErr)
          end

          if(n == api.com) then
            if(ret == "") then local cap = rmk:find("%L", 1)
              if(n:find(API.NAME)) then
                ret = sS..sObj
              elseif(cap and wikiRefer[n:sub(1,cap-1)]) then
                ret = sS..wikiRefer[n:sub(1,cap-1)]
              else ret = sS..sV end
            end

            local sR = n:gsub(wikiBraketsIN, ""); if(bMsp) then sR = "`"..sR.."`" end

            if(obj:find(sV)) then
              wikilib.printRow({sR.."("..wikilib.concatType(API, vars)
                    ..")", wikilib.concatType(API, ret), DSC[n]})
            else
              wikilib.printRow({wikilib.concatType(API, obj)..sM..sR.."("
                      ..wikilib.concatType(API, vars)..")", wikilib.concatType(API, ret), DSC[n]})
            end
          end
        end
      end
    end; if(iM == 0) then wikilibError("Description mismatch <"..n.."> !", bErr) end
  end
  io.write("\n")
end

function wikilib.setPlaceHolderColor(bR, bG, bB, tR, tG, tB)
  if(wikilib.common.isTable(bR)) then
    for iD = 1, 3 do wikiColorPH[1][iD] = (tonumber(bR[iD]) or 0) end
    if(wikilib.common.isTable(bG)) then
      for iD = 1, 3 do wikiColorPH[2][iD] = (tonumber(bG[iD]) or 0) end
    else
      wikiColorPH[2][1] = (tonumber(bG) or 0)
      wikiColorPH[2][2] = (tonumber(bB) or 0)
      wikiColorPH[2][3] = (tonumber(tR) or 0)
    end
  else
    wikiColorPH[1][1] = (tonumber(bR) or 0)
    wikiColorPH[1][2] = (tonumber(bG) or 0)
    wikiColorPH[1][3] = (tonumber(bB) or 0)
    if(wikilib.common.isTable(tR)) then
      for iD = 1, 3 do wikiColorPH[2][iD] = (tonumber(tR[iD]) or 0) end
    else
      wikiColorPH[2][1] = (tonumber(tR) or 0)
      wikiColorPH[2][2] = (tonumber(tG) or 0)
      wikiColorPH[2][3] = (tonumber(tB) or 0)
    end
  end
end

-- https://placeholder.com/#How_To_Use_Our_Placeholders
function wikilib.getBanner(vT, vW, vH)
  local sT = tostring(vT or "")
        sT = (wikilib.common.isDryString(sT) and "+" or sT)
  local nW = wikilib.common.getClamp(tonumber(vW) or 1 , 1)
  local nH = wikilib.common.getClamp(tonumber(vH) or nW, 1)
  local bR, bG, bB = unpack(wikiColorPH[1])
  local tR, tG, tB = unpack(wikiColorPH[2])
  return toURL(toImgBanner(nW, nH, bR, bG, bB, tR, tG, tB, wikilib.getEncodeURL(sT)))
end

function wikilib.parseKeyCombination(sS, vT, nW, nH)
  local sTF, sTB, sO, iD = "", "", "", 1
  local sW = tostring(nW and common.getClamp(tonumber(nW) or 0, 0) or "")
  local sH = tostring(nH and common.getClamp(tonumber(nH) or 0, 0) or "")
  if(common.isString(vT)) then
    sTF, sTB = vT, vT
  elseif(common.isTable(vT)) then
    sTF, sTB = vT[1], vT[2]
  else wikilibError("Token invalid <"..tostring(vT).."> !", bErr) end
  local bO, eO = sS:find(sTF, iD, true) -- Open token
  local bC, eC = sS:find(sTB, iD, true) -- Close token
  while(bO and eO and bC and eC) do
    sO = sO..sS:sub(iD, bO - 1)
    local tT = common.stringExplode(sS:sub(eO + 1, bC - 1),"+")
    for iK = 1, #tT do local vS = common.stringTrim(tT[iK])
      vS = toImgHTML(toImgSrcHTML(vS:lower()), sW, sH)
      tT[iK] = vS
    end
    sO = sO..table.concat(tT, "+")
    iD = eC + 1
    bO, eO = sS:find(sTF, iD, true)
    bC, eC = sS:find(sTB, iD, true)
  end
  return sO..sS:sub(iD, -1)
end


function wikilib.folderReplaceURL(sF, ...)
  local tA, sU = {...}, ""
  local sF = wikilib.common.normFolder(tostring(sF or ""))
  if(wikilib.common.isTable(tA[1])) then tA = tA[1] end
  for iD = 1, #tA do sU = sU..common.normFolder(tostring(tA[iD] or "")) end
  wikiFolder.__furl = {sF, sU}; return wikiFolder.__furl
end

function wikilib.folderSetTemp(sT)
  wikiFolder.__temp = wikilib.common.normFolder(sT)
end

function wikilib.folderRoundSize(vS)
  local tM, iM = wikiFolder.__mems, wikiFolder.__memi
  if(tonumber(vS)) then
    iM = wikilib.common.getClamp(math.floor(tonumber(nS) or 1), 1, #tM)
    return iM -- Return the parameter used
  else
    local bE = wikilib.isFlag("erro")
    local iD, sS = 1, tostring(vS); while(tM[iD]) do
    if(tM[iD] == vS) then iM = iD; return iD end end
    wikilibError("Mismatch <"..vS.."> !", bE)
  end
end

function wikilib.writeBOM(sF, vE)
  local sC, lE = tostring(sF or ""), wikilib.common.toBool(lE)
  local tU = wikiFolder.__ubom[sC]; if(not tU) then
    wikilibError("Missed ("..tostring(lE)..") <"..sC..">", tF.erro) end
  if(not lE) then
    for iD = 1, #tU,  1 do io.write(string.char(tU[iD])) end
  else
    for iD = #tU, 1, -1 do io.write(string.char(tU[iD])) end
  end
  return true
end

function wikilib.fileSize(sS)
  local tM, sO = wikiFolder.__mems, ""
  local iM, sM = wikiFolder.__memi, #tM
  local tE = wikilib.common.stringExplode(sS, " ")
  wikilib.common.tableArrReverse(tE)
  for iD = 1, sM do tE[iD] = (tonumber(tE[iD]) or 0) end
  if(tE[iM] ~= 0) then
    for iD = sM, iM, -1 do
      if(tE[iD] ~= 0) then sO = sO..tostring(tE[iD]) end end
    return " ["..sO..tM[iM].."B]"
  else
    while(iM > 0 and tE[iM] == 0) do iM = iM - 1
      if(iM < 1) then return (" [0B]") end end
    return (" ["..tE[iM]..tM[iM].."B]")
  end
end

function wikilib.folderReadStructure(sP, iV)
  local iT = (tonumber(iV) or 0) + 1
  local tU, bC = wikiFolder.__furl, false
  local sR = wikilib.common.randomGetString(wikiFolder.__ranm)
  local erro = wikilib.isFlag("erro") 
  local prnt = wikilib.isFlag("prnt")
  local hide = wikilib.isFlag("hide")
  local vT = (tostring(iT or "").."_"..sR)
  local nT = wikiFolder.__temp..vT..".txt"
  local tD = wikiFolder.__fdat -- Content descriptor
  local sC = wikiFolder.__fcmd:format(sP, nT)
  local nR = os.execute(sC); if(not nR) then
    wikilibError("Exec error ["..sC.."]", erro) end
  local fD, oE = io.open(nT, "rb"); if(not fD) then
    wikilibError("Open error ["..nT.."]", erro) end
  local tT, iD, sL = {hash = {iT, sR}}, 0, fD:read(wikiFolder.__read)
  while(sL) do sT = wikilib.common.stringTrim(sL)
    if(sL:match(wikiFolder.__snum)) then
      if(wikilib.common.isNil(iV)) then
        local nS, nE = sL:find(wikiFolder.__snum)
        tT.snum = wikilib.common.stringTrim(sL:sub(nE + 1, -1))
      end   
    elseif(sL:find(wikiFolder.__drof)) then
      tT.base = sL:gsub("\\","/"):gsub(wikiFolder.__drof,"")
      tT.base = wikilib.common.stringTrim(tT.base)
      if(tU[1] ~= "" and tU[2] ~= "") then
        local uS, uE = sP:find(tU[1], 1, true)
        if(uS and uE) then tT.link = tU[2]..sP:sub(uE+1, -1) end
      end
    elseif(sL:sub(1,1) ~= " " and sL:match(tD[1])) then bC = true
      local nS = sL:find(tD[1])
      if(not wikilib.common.isNil(nS)) then
        local nE = (nS + tD[2] - 1) -- The directory and size information end
        local sS = wikilib.common.stringTrim(sL:sub(nS, nE))
        if(sS ~= "<DIR>" and sS:sub(1,1):find("%d") and sS:sub(-1,-1):find("%d")) then -- sS
          sS = wikilib.common.stringTrim(sS:gsub("%D+", " "))
        end -- Make sure to normalize the byte separators for the file size
        local sN = wikilib.common.stringTrim(sL:sub(nE, -1))
        if(sS == wikiFolder.__idir[3] and wikiFolder.__pdir[sN]) then
          if(prnt and iT > 1) then -- Parent/current directory
            if(not tT.cont) then tT.cont = {} end; iD = iD + 1
            tT.cont[iD] = {size = sS, name = sN}
          end
        elseif(sN:sub(1,1) == "." and not wikiFolder.__pdir[sN]) then
          if(hide) then -- Hidden file or folder
            if(not tT.cont) then tT.cont = {} end; iD = iD + 1
            tT.cont[iD] = {size = sS, name = sN}
          end
        else -- Everything else
          if(not tT.cont) then tT.cont = {} end; iD = iD + 1
          tT.cont[iD] = {size = sS, name = sN}
          local tP = tT.cont[iD]
          if(not tP.root and tP.size == wikiFolder.__idir[3]) then
            tP.root = wikilib.folderReadStructure(sP.."/"..tP.name, iT)
          end
        end
      else
        wikilibError("Descriptor mismatch ["..iT.."]["..sL.."]["..sP.."]", erro)
      end
    end
    sL = fD:read(wikiFolder.__read)
  end; fD:close(); os.remove(nT)
  if(not bC) then
    wikilibError("Content missing ["..iT.."]["..sP.."]", erro) end
  return tT
end

local function folderLinkItem(tR, vC, bB)
  local sR, sO, tU = tR.link, vC.name, wikiFolder.__furl
  local urls = wikilib.isFlag("urls")  
  local ufbr = wikilib.isFlag("ufbr")
  local unqr = wikilib.isFlag("unqr")  
  if(urls) then
    local sN = wikilib.common.normFolder(sR)
    local sU = wikilib.getEncodeURL(sN)
    local sB = (bB and "" or wikilib.getEncodeURL(sO))   
    local sR = tostring(sR and toURL(sU) or toURL(tU[2]))
          sR = (bB and sR:sub(1,-2) or sR)
    local tD, vP = wikiFolder.__idir, sR..sB
    if(ufbr) then
      local sL = wikilib.common.stringGetFileName(vP)
      local vR = wikilib.getTokenReference(sL, vP, unqr)      
      sO = toLinkRefSrc("`"..sO.."`", vR)
      if(vC.name == tD[1]) then
        wikiRList[wikiRList.Size] = wikiRList[wikiRList.Size]:sub(1,-3)
      elseif(vC.name == tD[2]) then
        local vR = wikilib.common.stringTrim(sR, "/")
              vR = wikilib.common.stringGetFileName(vR)
        local nB, nE = wikiRList[wikiRList.Size]:find(vR.."/"..sB, 1, true)
        if(nB and nE) then
          wikiRList[wikiRList.Size] = wikiRList[wikiRList.Size]:sub(1, nB-2)
        end
      end
    else
      sO = toLinkURL("`"..sO.."`", vP)
      if(vC.name == tD[1]) then
        sO = sO:gsub("/%"..tD[1].."%)$",")")
      elseif(vC.name == tD[2]) then
        sO = sO:gsub("/%.%.%)",""):match("(.*[/\\])"):sub(1,-2)..")"
      end
    end
  end; return sO
end

--[[
 * Updates the tree print settings to the correct format
 * tSet > Description list the thing is done for
 * tPth > Descriptor of the path stricure
 * Returns boolean success
]]
function wikilib.folderSettings(tSet, tPth)
  if(wikilib.common.isTable(tSet)) then
    local tDsc = wikilib.common.getPick(wikilib.common.isTable(tSet.Desc)
      and not wikilib.common.isDryTable(tSet.Desc), tSet.Desc, nil)
    local tWln = wikilib.common.getPick(wikilib.common.isTable(tSet.Swap)
      and not wikilib.common.isDryTable(tSet.Swap), tSet.Swap, nil)
    local tSkp = wikilib.common.getPick(wikilib.common.isTable(tSet.Skip)
      and not wikilib.common.isDryTable(tSet.Skip), tSet.Skip, nil)
    local tOny = wikilib.common.getPick(wikilib.common.isTable(tSet.Only)
      and not wikilib.common.isDryTable(tSet.Only), tSet.Only, nil)
    wikilib.common.tableClear(tSet)
    tSet.Base = tPth.base
    tSet.Desc = tDsc
    tSet.Swap = tWln
    if(tSkp) then
      tSet.Skip = tSkp; tSet.Skip.__top = #tSet.Skip end
    if(tOny) then  
      tSet.Only = tOny; tSet.Only.__top = #tSet.Only end
    return true
  end; return false
end

--[[
 * Updates the tree path abd removes the filtered nodes 
 * tPth > Folder structure to process
 * tO   > Table of only ones entries ( patterns )
 * tS   > Table of skipped entries ( patterns )
 * Returns boolean success
]]
local function folderOnlySkip(tPth, tSet)
  local tCon = tPth.cont
  local tSor = wikilib.common.sortTable(tCon, {"name"}, true), 1
  if(tSet) then
    local iD, tS, tO = 1, tSet.Skip, tSet.Only
    while(iD <= tSor.__top) do
      local vCon, bRem = tCon[iD], false
      if(not vCon.root) then
        local sP = wikilib.common.normFolder(tPth.base)
              sP = sP..vCon.name
        local nS, nE = sP:find(tSet.Base, 1, true)
              sP = sP:sub(nE + 1, -1)
        if(wikilib.common.isTable(tO) and not
           wikilib.common.isDryTable(tO)) then
          for iO = 1, tO.__top do -- Check only. Not found
            if(not sP:find(tO[iO])) then -- Not within only
              table.remove(tPth.cont, iD)
              table.remove(tSor     , iD)
              tSor.__top = tSor.__top - 1
              bRem = true
            end
          end
        end
        if(wikilib.common.isTable(tS) and not
           wikilib.common.isDryTable(tS)) then
          for iS = 1, tS.__top do -- Check only. Not found
            if(sP:find(tS[iS])) then -- Delete skipped
              table.remove(tPth.cont, iD)
              table.remove(tSor     , iD)
              tSor.__top = tSor.__top - 1
              bRem = true
            end
          end
        end
      end
      
      if(not bRem) then iD = iD + 1 end
    end
    tSor = wikilib.common.sortTable(tPth.cont, {"name"}, true)
  end
  
  -- common.logTable(tPth.cont, "CONT")
  -- common.logTable(tSor, "SORT")
  
  
  return tSor
end

--[[
 * This prints out the recursive tree
 * tPth > Structure to print
 * tSym > Syms set to use for drawing by a given ID
 * sGen > The repository tree is generated for ( not mandatory )
 * tSet > API description list the thing is done for ( not mandatory ) )
 * vR   > Previous iteration graph recursion depth ( omitted )
 * sR   > Previous iteration graph recursion destination ( omitted )
]]
local function folderDrawTreeRecurse(tPth, tSym, sGen, tSet, vR, sR)
  local erro = wikilib.isFlag("erro")
  local hash = wikilib.isFlag("hash")
  local size = wikilib.isFlag("size")
  if(not wikilib.common.isTable(tPth)) then
    wikilibError("Structure invalid {"..type(tPth).."}["..tostring(tPth).."]", erro)
  else
    if(not wikilib.common.isTable(tPth.cont)) then
      wikilibError("Structure content invalid {"..type(tPth.cont).."}["..tostring(tPth.cont).."]", erro)
    end
  end
  local sG = wikilib.common.getPick(common.isString(sGen), sGen, nil)
  local sR, iI = tostring(sR or ""), wikiFolder.__dept
  local iR = wikilib.common.getClamp(tonumber(vR) or 0, 0)
  local tSor = folderOnlySkip(tPth, tSet); if(not tSor) then
    wikilibError("Sort invalid {"..type(tPth.cont).."}["..tostring(tPth.cont).."]", erro) end   
  for iD = 1, tSor.__top do local vC, sL = tPth.cont[tSor[iD].__key], ""
    if(vC.root) then local dC = wikiSpace
      local sX = (tSor[iD+1] and tSym[2] or tSym[1])..tSym[3]:rep(iI)
      local sD = (tSor[iD+1] and tSym[4] or dC)..dC:rep(iI)
      local sS = (hash and (" ["..vC.root.hash[1].."]"..vC.root.hash[2]) or "")
      if(tSet.Desc and tSet.Desc[vC.name]) then
        sL = (" --> "..wikilib.replaceToken(tSet.Desc[vC.name], tSet.Swap)) end
      io.write("`"..sR..sX.."`"..folderLinkItem(tPth, vC)..sS..sL..wikiNewLN); io.write("\n")
      folderDrawTreeRecurse(vC.root, tSym, sG, tSet, iR+1, sR..sD)
    else
      if(tSet.Desc and tSet.Desc[vC.name]) then
        sL = (" --> "..wikilib.replaceToken(tSet.Desc[vC.name], tSet.Swap)) end
      local sS = ((size and vC.size ~= wikiFolder.__idir[3]) and wikilib.fileSize(vC.size) or "")
      local sX = (tSor[iD+1] and tSym[2] or tSym[1])..tSym[3]:rep(iI)
      io.write("`"..sR..sX.."`"..folderLinkItem(tPth, vC)..sS..sL..wikiNewLN); io.write("\n")
    end
  end
end

local function folderRemoveBLOB(sU)
  local sM, nL = wikilib.common.stringTrim(sU, "/"), 0
  local nS, nE = sM:find("/master$"); nL = sM:len()
  if(nS and nE and nS > 0 and nE == nL) then sM = sM:sub(1, nS - 1) end
  nS, nE = sM:find("/blob$"); nL = sM:len()
  if(nS and nE and nS > 0 and nE == nL) then sM = sM:sub(1, nS - 1) end
  return sM, sM:len()
end

function wikilib.folderDrawTree(tPth, vIdx, sGen, tSet)
  local namr = wikilib.isFlag("namr")
  local tS, sR = wikiFolder.__syms, tostring(sR or "")
  local iA = wikilib.common.getClamp(tonumber(vIdx) or 1, 1, #tS); tS = tS[iA]
  local sG = wikilib.common.getPick(common.isString(sGen), sGen, nil)
  local nS, nE = tPth.base:find(wikiFolder.__drem)
  local vR = wikilib.common.getClamp(tonumber(vR) or 0, 0)
  if(not wikilib.folderSettings(tSet, tPth)) then
    wikilibError("Settings invalid {"..type(tPth.cont).."}["..tostring(tPth.cont).."]", true) end
  local sN = tPth.base:sub(nE + 1, -1)
  local sB = tostring(tS[5] or "/")
  if(namr and sG) then
    local tU = wikiFolder.__furl
    local sT = wikilib.common.stringTrim(sG, "/")
    local sM = wikilib.common.stringGetFileName(sT)
    if(not wikilib.common.isDryString(sM)) then
      if(tU[2] ~= "") then local nL = 0
        sM = folderRemoveBLOB(tU[2])
        sN = wikilib.common.stringGetFileName(sM)
        sM = folderLinkItem({link=sM}, {name=sN}, namr)
        io.write("`"..sB..sR.."`"..sM..wikiNewLN); io.write("\n")
      else
        sM = folderLinkItem({link=sG}, {name=sM}, namr)
        io.write("`"..sB..sR.."`"..sM..wikiNewLN); io.write("\n")
      end
    else
      io.write("`"..sB..sR.."`"..sN..wikiNewLN); io.write("\n")
    end
  else
    io.write("`"..sB..sR.."`"..sN..wikiNewLN); io.write("\n")
  end
  folderDrawTreeRecurse(tPth, tS, sGen, tSet, vR, sR)
  io.write("\n")
end

--[[
 * Registers a token to be converted to reference link
 * vT > The token to be processed
 * vU > URL to be regstered for this token
 * bN > Always allocate new slot for the token
]]
function wikilib.getTokenReference(vT, vU, bN)
  local sT, sU, iD = tostring(vT), tostring(vU)
  if(bN) then
    wikiRList.Size = wikiRList.Size + 1
    iD = wikiRList.Size
  else
    if(not wikiRList.Meta[sT]) then
      wikiRList.Size = wikiRList.Size + 1
      wikiRList.Meta[sT] = {
        Idx = wikiRList.Size,
        URL = sU  -- Store URL
      }
    else
      local tT = wikiRList.Meta[sT]
      if(tT.URL ~= sU and not bN) then
        wikilib.common.logStatus("< "..tT.URL , nil)
        wikilib.common.logStatus("> "..sU     , nil)
        wikilibError("Token ["..sT.."] present with different URL!", true)
      end
    end
    iD = wikiRList.Meta[sT].Idx
  end
  local sR = toReferID(iD, vT)
  if(not wikiRList[iD]) then
    wikiRList[iD] = toLinkRef(sR, sU)    
  end
  return sR
end

function wikilib.printTokenReferences()
  if(wikiRList.Size and wikiRList.Size > 0) then
    for iD = 1, wikiRList.Size do
      io.write(wikiRList[iD]); io.write("\n")  
    end -- Write all the link references
  end
end

wikilib.folderSetTemp(os.getenv("TEMP"))

return wikilib
