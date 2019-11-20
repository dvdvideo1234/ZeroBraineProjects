local common = require("common")

local wikilib   = {} -- Reference to the library
local wikiMList = {} -- Stores the ordered list of the APIs
local wikiMatch = {} -- Stores the APIs hashed list information
local wikiType  = require("wikilib/type")
local wikiFolder = require("wikilib/folder")
local wikiFormat = require("wikilib/format")
local wikiDChunk = require("wikilib/dscchnk")
local wikiEncodeURL = require("wikilib/uenc")
wikilib.common = common

-- Stores the direct API outputs based on function mnemonics ( IFF named correctly xD )
local wikiRefer = { ["is"] = "n",
  __this = {"dump", "res", "set", "upd", "smp", "add", "rem", "no", "new"}
}
-- Pattern for something in brackets including the brakets
local wikiBraketsIN = "%(.-%)"
-- What the instance creator might start with
local wikiMakeOOP = {["new"]=true, ["no"]=true, ["make"]=true, ["create"]=true}
-- https://stackoverflow.com/questions/17978720/invisible-characters-ascii
local wikiSpace = " " -- Space character for drawing table column names
-- A bunch of patterns when matched transform a word into MD quote
local wikiQuote = {["%d"] = true, ["_"]=true, ["%l%u"]=true, ["%u+%u+"]=true}
-- Characters to exclude from the word quoting
local wikiDiver = {[","]=true, [")"]=true, ["("] = true, ["."] = true}
-- Stores the new line abbreviature in MD
local wikiNewLN = "  "

-- Stores the symbol for line divider and the repetition count
local wikiLineDiv = {"-", 120}

local function isQuote(sS)
  local bLet = wikilib.common.stringHasLetter(sS)
  local bUpp = wikilib.common.stringIsUpper(sS)
  return (bLet and bUpp)
end

local function toURL(dir, soc)
  return (wikiFormat.__url:format(tostring(soc or "https"), dir))
end

local function toSSS(...)
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

local function apiSortFinctionParam(a, b)
  if(table.concat(a.par) < table.concat(b.par)) then return true end
  return false
end

local function sortMatch(tM)
  table.sort(tM, apiSortFinctionParam)
end

local function apiGetValue(API, sTab, sKey, vDef)
  local tTab = API[sTab]
  local bTab = wikilib.common.isTable(tTab)
  return (bTab and tTab[sKey] or vDef)
end

function wikilib.setFormat(sK, sS)
  wikiFormat["__"..sK] = sS
end

function wikilib.insYoutubeVideo(sK, iD)
  local nD = tonumber(iD)
  return wikiFormat.__ytb:format(sK, (nD and math.floor(common.getClamp(nD, 0 ,3)) or 0), sK)
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
    wikilib.common.logStatus("wikilib.setDecoderURL: Code mismatch <"..sE.."> !")
    if(bErr) then
      error("wikilib.setDecoderURL: Code mismatch <"..sE.."> !") end
  end
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
    wikilib.common.logStatus("wikilib.getDecodeURL: Code missing <"..sK.."> !")
    if(bErr) then
      error("wikilib.getDecodeURL: Code missing <"..sK.."> !") end
  end
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
    wikilib.common.logStatus("wikilib.getEncodeURL: Code missing <"..sK.."> !")
    if(bErr) then
      error("wikilib.getEncodeURL: Code missing <"..sK.."> !") end
  end
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

function wikilib.replaceToken(sT, tR, bR, bQ)
  local qR = wikilib.common.getPick(bQ, "`", "")
  local sD, sO = tostring(sT or ""), tostring(sT or "")
  if(tR and wikilib.common.isTable(tR)) then
    for k, v in pairs(tR) do
      if(k:sub(1,1) ~= "#") then
        local nF, nB = sD:find(k, 1, true)
        if(nF and nB) then
          nF, nB, sX = (nF-1), (nB+1), (bR and v:format(k) or v)
          local cF, cB = sD:sub(nF,nF), sD:sub(nB,nB)
          if(cF..cB == "``") then
            sO = sD:sub(1,nF-1)..toSSS(cF,k,cB).."("..sX..")"..sD:sub(nB+1,-1)
          elseif(cF..cB == "  ") then
            sO = sD:sub(1,nF)..toSSS(qR,k,qR).."("..sX..")"..sD:sub(nB,-1)
          elseif(cF..cB == " ") then
            sO = sD:sub(1,nF)..toSSS(qR,k,qR).."("..sX..")"..sD:sub(nB,-1)
          elseif(cB == ",") then
            sO = sD:sub(1,nF)..toSSS(qR,k,qR).."("..sX..")"..sD:sub(nB,-1)
          end
        end
      end
    end
  end; return sO
end

function wikilib.updateAPI(API, DSC)
  local tA, tW
  local sO = apiGetValue(API,"TYPE", "OBJ")
  local wD = apiGetValue(API,"FLAG", "wdsc")
  local bR = apiGetValue(API,"FLAG", "prep")
  local bQ = apiGetValue(API,"FLAG", "qref")
  wikilib.addPrefixNameOOP(apiGetValue(API,"TYPE", "DSG"))
  if(wD) then API.POOL.wdsc = {}
    tW = apiGetValue(API,"POOL", "wdsc")
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

    if(wikiMakeOOP[api:gsub(API.NAME..wikiBraketsIN, "")] -- newOOP()
      or api:find(API.NAME..wikiBraketsIN) == 1) then     --    OOP()
      tA = API.POOL[1] -- The function os an class creator
    elseif(api:find(sO..":")) then
      tA = API.POOL[2] -- The finction is calss method
    else -- Some other function not related with the class
      tA = API.POOL[3] -- The functoion is a helper API
    end
    if(API.REPLACE) then local tR = API.REPLACE
      DSC[api] = wikilib.replaceToken(DSC[api], tR, bR, bQ)
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
        cT = "return function() "..(cT or wikiDChunk.top)
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
    elseif(wikilib.common.isFunction(API.DSCHUNK)) then
      local bS, sC = pcall(API.DSCHUNK)
      if(bS) then sC = (cT..sI..sC..sI..cB)
      else wikilib.common.logStatus("wikilib.readDescriptions: API chink unsuccessful: "..type(API.DSCHUNK)) end
    else wikilib.common.logStatus("wikilib.readDescriptions: API chink not supported: "..type(API.DSCHUNK)) end
  else
    local sN = wikilib.common.normFolder(sBas)..common.normFolder(sLua)
          sN = sN.."cl_"..sE2:lower()..".lua"
    local fR = io.open(sN, "rb"); if(not fR) then
      return wikilib.common.logStatus("wikilib.readDescriptions: No file <"..sN..">") end    
    wikilib.common.logStatus("Description: "..sN)
    sC = (cT..sI..fR:read("*all")..sI..cB)
  end
  local fC, oE = load(sC)
  if(fC) then local bS, fC = pcall(fC);
    if(bS) then bS, fC = pcall(fC);
      if(bS) then return fC else
        wikilib.common.logStatus("wikilib.readDescriptions[2]: Compilation chunk:\n")
        wikilib.common.logStatus("--------------------------------------------\n")
        wikilib.common.logStatus(sC)
        wikilib.common.logStatus("--------------------------------------------\n")
        wikilib.common.logStatus("wikilib.readDescriptions[2]: Execution error: "..fC)
      end
    else
      wikilib.common.logStatus("wikilib.readDescriptions[1]: Compilation chunk:\n")
      wikilib.common.logStatus("--------------------------------------------\n")
      wikilib.common.logStatus(sC)
      wikilib.common.logStatus("--------------------------------------------\n")
      wikilib.common.logStatus("wikilib.readDescriptions[1]: Execution error: "..fC)
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
  local bE = apiGetValue(API,"FLAG", "extr") -- Use external wire types
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
  local bVo = apiGetValue(API,"FLAG", "remv")
  if(bVo and sV == sVo) then return "" end
  local bI = apiGetValue(API, "FLAG", "icon")
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
      print("wikilib.readReturnValues", tT[1], tT[2])
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
  local iS, tD, sT = nil, nil
  local sE = wikilib.common.stringTrim(sE2)
  local sM, sA = wikiFormat.msp, wikiFormat.asp
  local bErr = apiGetValue(API, "FLAG", "erro")
  if(sE:sub(1,10) == "e2function") then
    local tInfo, tTyp = {}, API.TYPE; tInfo.row = sE2
    sE = wikilib.common.stringTrim(sE:sub(11, -1)); iS = sE:find("%s", 1)
    local tD = wikilib.convTypeE2Description(API,common.stringTrim(sE:sub(1, iS)))
    if(not tD) then
      wikilib.common.logStatus("wikilib.convApiE2Description: Type missing <"..sT.."> !")
      wikilib.common.logStatus("wikilib.convApiE2Description: API mismatch <"..sE2.."> !")
      if(bErr) then
        error("wikilib.convApiE2Description: Type missing <"..sT.."> !") end
    end; tInfo.ret = tD[1]
    sE = wikilib.common.stringTrim(sE:sub(iS, -1))
    iS = sE:find(sM, 1, true)
    if(iS) then
      local tD = wikilib.convTypeE2Description(API,common.stringTrim(sE:sub(1, iS-1)))
      if(not tD) then
        wikilib.common.logStatus("wikilib.convApiE2Description: Type missing <"..sT.."> !")
        wikilib.common.logStatus("wikilib.convApiE2Description: API mismatch <"..sE2.."> !")
        if(bErr) then
          error("wikilib.convApiE2Description: Type missing <"..sT.."> !") end
      end; tInfo.obj = tD[1]
      sE = wikilib.common.stringTrim(sE:sub(iS+1, -1))
    end
    iS = sE:find("(", 1, true)
    tInfo.foo = wikilib.common.stringTrim(sE:sub(1, iS-1))
    sE = wikilib.common.stringTrim(sE:match(wikiBraketsIN)):sub(2,-2)
    tInfo.par = wikilib.common.stringExplode(sE, sA)
    for ID = 1, #tInfo.par do
      tInfo.par[ID] = wikilib.common.stringTrim(tInfo.par[ID])
      iS = tInfo.par[ID]:find(" ", 1, true)
      if(not iS) then break end
      sT = tInfo.par[ID]:sub(1, iS-1)
      local tD = wikilib.convTypeE2Description(API,sT)
      if(not tD) then
        wikilib.common.logStatus("wikilib.convApiE2Description: Type missing <"..sT.."> !")
        wikilib.common.logStatus("wikilib.convApiE2Description: API mismatch <"..sE2.."> !")
        if(bErr) then
          error("wikilib.convApiE2Description: Type missing <"..sT.."> !") end
      end; tInfo.par[ID] = tD[1]
    end; tInfo.com = tInfo.foo.."("
    if(tInfo.obj) then
      tInfo.com = tInfo.com..tInfo.obj..sM end
    for ID = 1, #tInfo.par do
      tInfo.com = tInfo.com..tInfo.par[ID]
    end; tInfo.com = tInfo.com..")"; return tInfo
  end; return nil
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
    return wikilib.common.logStatus("wikilib.makeReturnValues: No file <"..sN..">") end
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
  local tK = wikiMList; table.sort(tK)
  local sN = tostring(sNam or wikiDChunk.mch)
  for ID = 1, tK.__top do
    if(not DSC[tK[ID]]) then
      wikilib.common.logStatus(sN.."[\""..tK[ID].."\"] = \"\"") end
  end
end

function wikilib.printTypeTable(API)
  local tT = wikiType.list
  wikilib.printRow({"Icon", "Description"})
  wikilib.printRow({"---", "---"})
  local sQ = apiGetValue(API, "FLAG", "qref") and "`" or ""
  for ID = 1, #tT do local sL = tT[ID][4]
    local sI = wikilib.common.stringTrim(tT[ID][1])
    local sD = wikilib.common.stringTrim(tT[ID][3])
    if(sL and not wikilib.common.isDryString(sL)) then
      sL = wikilib.common.stringTrim(sL)
      local sR = sD:match("%[.+%]"); if(sR) then
        sR = sR:gsub("%[", "%%%["):gsub("%]", "%%%]")
        sD = sD:gsub(sR, sR:gsub("%[", "%["..sQ):gsub("%]", sQ.."%]").."%("..sL.."%)")
      end
    end
    wikilib.printRow({toInsert(toImage(toRefer(sI))), sD})
  end; io.write("\n")
end

function wikilib.printDescriptionTable(API, DSC, iN)
  local bMsp = apiGetValue(API, "FLAG", "mosp")
  local bIco = apiGetValue(API, "FLAG", "icon")
  local bErr = apiGetValue(API, "FLAG", "erro")
  local sObj = apiGetValue(API, "TYPE", "OBJ")
  local tPool = apiGetValue(API, "POOL", iN); if(not tPool) then return end
  local nC, tC, tH = #tPool.cols, {}, {}
  for ID = 1, nC do local scol = tPool.cols[ID]
    local csiz, clen = tPool.size[ID], scol:len()
    if(csiz < clen) then
      wikilib.common.logStatus("wikilib.printDescriptionTable: Header overflow <"..scol.."> ["..csiz.." < "..clen.."] !")
      wikilib.common.logStatus("wikilib.printDescriptionTable: Header mismatch <"..scol.."> ["..csiz.." < "..clen.."] !")
      if(bErr) then
        error("wikilib.printDescriptionTable: Header overflow <"..scol.."> ["..csiz.." < "..clen.."] !") end
    end
    local ccat = ((csiz - clen) / 2)
    local fcat, bcat = math.floor(ccat), math.ceil(ccat)
    tH[ID] = ("-"):rep(common.getClamp((csiz or clen), 3))
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
        if(not wikilib.isValidMatch(rmv)) then if(bErr) then
          error("wikilib.printDescriptionTable: Duplicated function <"..rmv.__nam.."> !") end
        end

        local ret = ""; sortMatch(rmv)

        for ID = 1, rmv.__top do local api = rmv[ID]; ret = api.ret
          if(not DSC[api.com]) then
            wikilib.common.logStatus("wikilib.printDescriptionTable: Description missing <"..api.row.."> !")
            wikilib.common.logStatus("wikilib.printDescriptionTable: API missing <"..api.com.."> !")
            if(bErr) then
              error("wikilib.printDescriptionTable: Description missing <"..api.com.."> !") end
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
    end; if(iM == 0) then
      wikilib.common.logStatus("wikilib.printDescriptionTable: Description mismatch <"..n.."> !")
      if(bErr) then error("wikilib.printDescriptionTable: Description mismatch <"..n.."> !") end
    end
  end
  io.write("\n")
end

function wikilib.folderReplaceURL(sF, ...)
  local sF, sU = wikilib.common.normFolder(tostring(sF or "")), ""
  local tA = {...} if(tA and wikilib.common.isTable(tA[1])) then tA = tA[1] end
  for key, val in ipairs(tA) do
    sU = sU..common.normFolder(tostring(val or ""))
  end
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
  else local iD, sS = 1, tostring(vS); while(tM[iD]) do
    if(tM[iD] == vS) then iM = iD; return iD end end
    wikilib.common.logStatus("wikilib.folderRoundSize: Mismatch <"..vS.."> !")
    if(bErr) then error("wikilib.folderRoundSize: Mismatch <"..vS.."> !") end
  end
end

function wikilib.folderFlag(sF, bF)
  local tF, sF = wikiFolder.__flag, tostring(sF)
  if(tF[sF] ~= nil) then tF[sF] = (bF and bF or false)
  else wikilib.common.logStatus("wikilib.folderFlag: Mismatch <"..sF.."> !")
    if(bErr) then error("wikilib.folderFlag: Mismatch <"..sF.."> !") end
  end
end

function wikilib.writeBOM(sF, vE)
  local sC, lE = tostring(sF or ""), wikilib.common.toBool(lE)
  local tU = wikiFolder.__ubom[sC]; if(not tU) then
    return error("wikilib.writeBOM: Missed ("..tostring(lE)..") <"..sC..">") end
  if(not lE) then for iD = 1, #tU,  1 do io.write(string.char(tU[iD])) end
  else for iD = #tU, 1, -1 do io.write(string.char(tU[iD])) end end
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
  local sU = wikiFolder.__furl
  local sR = wikilib.common.randomGetString(wikiFolder.__ranm)
  local vT, tF = tostring(iT).."_"..sR, wikiFolder.__flag
  local nT = wikiFolder.__temp..vT..".txt"
  os.execute(wikiFolder.__fcmd:format(sP, nT))
  local fD, oE = io.open(nT, "rb"); if(not fD) then
    wikilib.common.logStatus("wikilib.folderReadStructure: Open error <"..nT..">", nil)
    error("wikilib.folderReadStructure: Open error: "..oE)
  end
  local tT, iD, sL = {hash = {iT, sR}}, 0, fD:read(wikiFolder.__read)
    while(sL) do sL = wikilib.common.stringTrim(sL)
    if(sL:sub(1, 13) == wikiFolder.__drof) then
      tT.base = sL:sub(14, -1):gsub("\\","/")
      if(sU[1] ~= "" and sU[2] ~= "") then
        local uS, uE = sP:find(sU[1], 1, true)
        if(uS and uE) then tT.link = sU[2]..sP:sub(uE+1, -1) end
      end
    elseif(sL:sub(1, 17):match(wikiFolder.__fdat)) then
      local sS = wikilib.common.stringTrim(sL:sub(18, 36))
      local sN = wikilib.common.stringTrim(sL:sub(37, -1))
      if(sS == wikiFolder.__idir[3] and wikiFolder.__pdir[sN]) then
        if(tF.prnt and iT > 1) then
          if(not tT.cont) then tT.cont = {} end; iD = iD + 1
          tT.cont[iD] = {size = sS, name = sN}
        end
      elseif(sN:sub(1,1) == ".") then
        if(tF.hide) then
          if(not tT.cont) then tT.cont = {} end; iD = iD + 1
          tT.cont[iD] = {size = sS, name = sN}
        end
      else
        if(not tT.cont) then tT.cont = {} end; iD = iD + 1
        tT.cont[iD] = {size = sS, name = sN}
        local tP = tT.cont[iD]
        if(not tP.root and tP.size == wikiFolder.__idir[3]) then
          tP.root = wikilib.folderReadStructure(sP.."/"..tP.name, iT)
        end
      end
    end
    sL = fD:read(wikiFolder.__read)
  end; fD:close(); os.remove(nT) return tT
end

local function folderLinkItem(tR, vC, bB)
  local sR, tU = tR.link, wikiFolder.__furl
  local sO, tF = vC.name, wikiFolder.__flag
  if(tF.urls) then
    local cD = wikiFolder.__idir
    local sN = wikilib.common.normFolder(sR)
    local sU = wikilib.getEncodeURL(sN)
    local sB = (bB and "" or wikilib.getEncodeURL(sO))
    local sR = tostring(sR and toURL(sU) or tU[2])
          sR = (bB and sR:sub(1,-2) or sR)
    if(tF.ufbr) then local vP = sR..sB
      local tR = wikiFolder.__refl
            tR.Size = tR.Size + 1
      local sL = wikilib.common.stringGetFileName(vP)
      local vR = "ref-"..tR.Size.."-"..sL
      tR[tR.Size] = toLinkRef(vR, vP)
      sO = toLinkRefSrc("`"..sO.."`", vR)
      if(vC.name == cD[1]) then
        tR[tR.Size] = tR[tR.Size]:sub(1,-3)
      elseif(vC.name == cD[2]) then
        local vR = wikilib.common.stringTrim(sR, "/")
              vR = wikilib.common.stringGetFileName(vR)
        local nB, nE = tR[tR.Size]:find(vR.."/"..sB, 1, true)
        if(nB and nE) then
          tR[tR.Size] = tR[tR.Size]:sub(1, nB-2)
        end
      end
    else
      sO = toLinkURL("`"..sO.."`", sR..sB)  
      if(vC.name == cD[1]) then
        sO = sO:gsub("/%"..cD[1].."%)$",")")
      elseif(vC.name == cD[2]) then
        sO = sO:gsub("/%.%.%)",""):match("(.*[/\\])"):sub(1,-2)..")"
      end
    end
  end; return sO
end

--[[
 * This prints out the recursive tree
 * tP > Structure to print
 * vA > The type of graph symbols to use
 * vR > Previous iretaration graph recursion depth ( omited )
 * sR > Previous iretaration graph recursion destination ( omited )
 * tD > API description list the thing is done for ( omited )
 * sG > The repo tree is generated for ( omited )
 * tQ > Word to link creation table
]]
function wikilib.folderDrawTree(tP, vA, vR, sR, tD, sG, tQ)
  local tS, tR = wikiFolder.__syms, wikiFolder.__refl
  local sG = wikilib.common.getPick(common.isString(sG), sG, nil)
  local tD = wikilib.common.getPick(common.isTable(tD), tD, nil)
  local iA = wikilib.common.getClamp(tonumber(vA) or 1, 1, #tS)
  local sR, tF = tostring(sR or ""), wikiFolder.__flag
  local iR = wikilib.common.getClamp(tonumber(vR) or 0, 0)
  local nS, nE = tP.base:find(wikiFolder.__drem); tS = tS[iA]
  local iI, tC = wikiFolder.__dept, wikilib.common.sortTable(tP.cont, {"name"}, true)
  if(iR == 0) then
    local sN = tP.base:sub(nE+1, -1)
    local sB = tostring(tS[5] or "/")
    if(tF.namr and sG) then
      local sT = wikilib.common.stringTrim(sG, "/")
      local sM = sT:match("/%w+$")
      if(not wikilib.common.isNil(sM)) then sN = sM:sub(2,-1)
        local sN = folderLinkItem({link=sG}, {name=sN}, tF.namr)
        io.write("`"..sB..sR.."`"..sN..wikiNewLN); io.write("\n")
      else
        io.write("`"..sB..sR.."`"..sN..wikiNewLN); io.write("\n")
      end
    else
      io.write("`"..sB..sR.."`"..sN..wikiNewLN); io.write("\n")
    end
  end
  for iD = 1, tC.__top do local vC, sL = tP.cont[tC[iD].__key], ""
    if(vC.root) then local dC = wikiSpace
      local sX = (tC[iD+1] and tS[2] or tS[1])..tS[3]:rep(iI)
      local sD = (tC[iD+1] and tS[4] or dC)..dC:rep(iI)
      local sS = (tF.hash and (" ["..vC.root.hash[1].."]"..vC.root.hash[2]) or "")
      if(tD and tD[vC.name]) then
        sL = (" --> "..wikilib.replaceToken(tD[vC.name], tQ, tF.prep, tF.qref)) end
      io.write("`"..sR..sX.."`"..folderLinkItem(tP, vC)..sS..sL..wikiNewLN); io.write("\n")
      wikilib.folderDrawTree(vC.root, iA, iR+1, sR..sD, tD, sG, tQ)
    else
      if(tD and tD[vC.name]) then
        sL = (" --> "..wikilib.replaceToken(tD[vC.name], tQ, tF.prep, tF.qref)) end
      local sS = ((tF.size and vC.size ~= wikiFolder.__idir[3]) and wikilib.fileSize(vC.size) or "")
      local sX = (tC[iD+1] and tS[2] or tS[1])..tS[3]:rep(iI)
      io.write("`"..sR..sX.."`"..folderLinkItem(tP, vC)..sS..sL..wikiNewLN); io.write("\n")
    end
  end
end

function wikilib.folderDrawTreeRef()
  local tR = wikiFolder.__refl
  if(tR.Size and tR.Size > 0) then io.write("\n\n")
    for iD = 1, tR.Size do io.write(tR[iD]); io.write("\n") end
  end
end

wikilib.folderSetTemp(os.getenv("TEMP"))

return wikilib