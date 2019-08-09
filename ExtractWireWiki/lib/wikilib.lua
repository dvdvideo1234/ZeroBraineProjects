local common = require('common')

local wikilib   = {} -- Reference to the library
local wikiMList = {} -- Stores the ordered list of the APIs
local wikiMatch = {} -- Stores the APIs hashed list information
local wikiType = {
  list = {
    {"a"  , "Angle"        , "[Angle] class"           , "https://en.wikipedia.org/wiki/Euler_angles"},
    {"b"  , "Bone"         , "[Bone] class"            , "https://github.com/wiremod/wire/wiki/Expression-2#Bone"},
    {"c"  , "ComplexNumber", "[Complex] number"        , "https://en.wikipedia.org/wiki/Complex_number"},
    {"e"  , "Entity"       , "[Entity] class"          , "https://en.wikipedia.org/wiki/Entity"},
    {"xm2", "Matrix2"      , "[Matrix] 2x2"            , "https://en.wikipedia.org/wiki/Matrix_(mathematics)"},
    {"m"  , "Matrix"       , "[Matrix] 3x3"            , "https://en.wikipedia.org/wiki/Matrix_(mathematics)"},
    {"xm4", "Matrix4"      , "[Matrix] 4x4"            , "https://en.wikipedia.org/wiki/Matrix_(mathematics)"},
    {"n"  , "Number"       , "[Number]"                , "https://en.wikipedia.org/wiki/Number"},
    {"q"  , "Quaternion"   , "[Quaternion]"            , "https://en.wikipedia.org/wiki/Quaternion"},
    {"r"  , "Array"        , "[Array]"                 , "https://en.wikipedia.org/wiki/Array_data_structure"},
    {"s"  , "String"       , "[String] class"          , "https://en.wikipedia.org/wiki/String_(computer_science)"},
    {"t"  , "Table"        , "[Table]"                 , "https://github.com/wiremod/wire/wiki/Expression-2#Table"},
    {"xv2", "Vector2"      , "[Vector] 2D class"       , "https://en.wikipedia.org/wiki/Euclidean_vector"},
    {"v"  , "Vector"       , "[Vector] 3D class"       , "https://en.wikipedia.org/wiki/Euclidean_vector"},
    {"xv4", "Vector4"      , "[Vactor] 4D class"       , "https://en.wikipedia.org/wiki/4D_vector"},
    {"xrd", "RangerData"   , "[Ranger data] class"     , "https://github.com/wiremod/wire/wiki/Expression-2#BuiltIn_Ranger"},
    {"xwl", "WireLink"     , "[Wire link] class"       , "https://github.com/wiremod/wire/wiki/Expression-2#Wirelink"},
    {"xft", ""             , "[Flash tracer] class"    , "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FTracer"},
    {"xsc", ""             , "[State controller] class", "https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl"},
    {"xxx", ""             , "[Void] data type"        , "https://en.wikipedia.org/wiki/Void_type"}
  },
  idx = {
    ["angle"]      = 1,
    ["bone"]       = 2,
    ["complex"]    = 3,
    ["entity"]     = 4,
    ["matrix2"]    = 5,
    ["matrix"]     = 6,
    ["matrix4"]    = 7, 
    ["number"]     = 8,
    ["quaternion"] = 9,    
    ["array"]      = 10,
    ["string"]     = 11, 
    ["table"]      = 12,
    ["vector2"]    = 13,
    ["vector"]     = 14,
    ["vector4"]    = 15,
    ["ranger"]     = 16,
    ["wirelink"]   = 17,
    ["ftracer"]    = 18,
    ["stcontrol"]  = 19,
    ["void"]       = 20
  }
}

wikiDChunk = {
top = [===[
return function()
local E2Helper = {}; E2Helper.Descriptions = {}

--[[ ******************************************************************************
 This header is automatically injected into the chunk
****************************************************************************** ]]--

]===],
bot = [===[
return DSC  -- The return value is automatically injected into the chunk
end
]===]
}

-- Stores a bynch of format strings for various stuff ( wikilib.setFormat )
local wikiFormat = {
  __prj = "https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki",
  __tfm = "type-%s.png",
  __tfc = "%s.png",
  __rty = "ref-%s",
  __rbr = "[%s]: %s",
  __lnk = "[%s](%s)",
  __ins = "!%s",
  __ref = "[%s]",
  __img = "[image][%s]",
  __ytb = "[![](http://img.youtube.com/vi/%s/%d.jpg)](http://www.youtube.com/watch?v=%s \"\")",
  __loc = "file:///%s",
  __cou = "%s/countries/%s",
  __typ = "%s/types/%s",
  __wds = "E2Helper.Descriptions[\"%s\"] = \"%s\"\n",
  tsp = "/",
  asp = ",",
  msp = ":",
  esp = "=",
  hsh = "#",
  fnd = "e2function",
  npt = "%)%s-=%s-e2function"
}

-- Stores the direct API outputs based on function mnemonics ( IFF named correctly xD )
local wikiRefer = { ["is"] = "n",
  __this = {"dump", "res", "set", "upd", "smp", "add", "rem", "no", "new"}
}
-- Pattern for something in brackets including the brakets
local wikiBraketsIN = "%(.-%)"
-- What the instance creator might start with
local wikiMakeOOP = {["new"]=true, ["no"]=true, ["set"]=true}
-- https://stackoverflow.com/questions/17978720/invisible-characters-ascii
local wikiSpace = "ˑ" -- Space character for drawing table column names
-- A bunch of patterns when matched transform a word into MD quote
local wikiQuote = {["%d"] = true, ["_"]=true, ["%l%u"]=true}
-- A bunch of functions when matched transform a word into MD quote
local wikiQuFoo = {common.stringIsUpper}
-- Characters to exclude from the word quoting
local wikiDiver = {[","]=true, [")"]=true, ["("] = true}
-- Stores the new line abbreviature in MD
local wikiNewLN = "  "
-- Stores the base folder for all operations
local wikiBaseFolder = ""
-- Stores the symbol for line divider and the repetition count
local wikiLineDiv = {"-", 120}

local function isQuote(sS)
  local bR = false
  for ID = 1, #wikiQuFoo do
    if(wikiQuFoo[ID](sS)) then
      bR = true; break end
  end; return bR
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
  local bTab = common.isTable(tTab)
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

function wikilib.normalDir(sD) local sS = tostring(sD)
  return ((sS:sub(-1,-1) == "/") and sS or (sS.."/"))
end

function wikilib.setBaseFolder(sB)
  wikiBaseFolder = wikilib.normalDir(common.stringTrim(sB:gsub("\\","/"), "/"))
end

function wikilib.updateAPI(API, DSC)
  for iD = 1, #API.POOL do
    local val = API.POOL[iD]
    if(val.cols) then
      for iK = 1, #val.cols do
        val.cols[iK] = val.cols[iK]:gsub(" ", wikiSpace)
      end
    end
  end
  local tA, tW
  local sO = apiGetValue(API,"TYPE", "OBJ")
  local qR = apiGetValue(API,"FLAG", "qref") and "`" or ""
  local bR = apiGetValue(API,"FLAG", "prep")
  local wD = apiGetValue(API,"FLAG", "wdsc")
  if(wD) then API.POOL.wdsc = {}
    tW = apiGetValue(API,"POOL", "wdsc")
  end
  for api, dsc in pairs(DSC) do
    if(wD) then 
      table.insert(tW, toWireDSC(api, dsc))
    end
    if(apiGetValue(API,"FLAG", "quot")) then
      local tD = common.stringExplode(dsc, " ")
      for ID = 1, #tD do local sW = tD[ID]
        for k, v in pairs(wikiQuote) do
          if(sW:match(k)) then
            local sF, sB = sW:sub(1,1), sW:sub(-1,-1)
            if(wikiDiver[sF]) then
              tD[ID] = sF.."`"..sW:sub(2,-1).."`"
            elseif(wikiDiver[sB]) then
              tD[ID] = "`"..sW:sub(1,-2).."`"..sB
            else
              tD[ID] = "`"..sW.."`"
            end
          elseif(isQuote(sW)) then
            tD[ID] = "`"..sW.."`"
          end
        end
      end; dsc = table.concat(tD, " "); DSC[api] = dsc
    end

    if(wikiMakeOOP[api:gsub(API.NAME..wikiBraketsIN, "")]) then
      tA = API.POOL[1] 
    elseif(api:find(sO..":")) then
      tA = API.POOL[2]
    else
      tA = API.POOL[3]
    end
    if(API.REPLACE) then local tR = API.REPLACE
      for k, v in pairs(tR) do local sD = DSC[api]
        if(k:sub(1,1) ~= "#") then
          local nF, nB = sD:find(k, 1, true)
          if(nF and nB) then
            nF, nB, sX = (nF-1), (nB+1), (bR and v:format(k) or v)
            local cF, cB = sD:sub(nF,nF), sD:sub(nB,nB)
            if(cF..cB == "``") then
              DSC[api] = sD:sub(1,nF-1)..("[%s%s%s]"):format(qR,k,qR).."("..sX..")"..sD:sub(nB+1,-1)
            elseif(cF..cB == "  ") then
              DSC[api] = sD:sub(1,nF)..("[%s%s%s]"):format(qR,k,qR).."("..sX..")"..sD:sub(nB,-1)
            elseif(cF..cB == " ") then
              DSC[api] = sD:sub(1,nF)..("[%s%s%s]"):format(qR,k,qR).."("..sX..")"..sD:sub(nB,-1)
            elseif(cB == ",") then
              DSC[api] = sD:sub(1,nF)..("[%s%s%s]"):format(qR,k,qR).."("..sX..")"..sD:sub(nB,-1)
            end
          end
        end
      end
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

function wikilib.readDescriptions(API)
  local sE2  = apiGetValue(API,"FILE", "exts")
  local sBas = apiGetValue(API,"FILE", "base")
  local sLua = apiGetValue(API,"FILE", "slua")
  local sN = wikilib.normalDir(sBas)..wikilib.normalDir(sLua)
        sN = sN.."cl_"..sE2:lower()..".lua"
  local cT, cB = wikiDChunk.top, wikiDChunk.bot
  local fR = io.open(sN, "rb"); if(not fR) then
    return common.logStatus("wikilib.readDescriptions: No file <"..sN..">") end
  local sC = cT..fR:read("*all")..cB
  local fC, oE = load(sC); if(fC) then
    local bS, fC = pcall(fC); if(bS) then return fC() else
      common.logStatus("wikilib.readDescriptions: Execution error: "..fC) end
  else
    common.logStatus("wikilib.readDescriptions: Compilation chunk:\n")
    common.logStatus("--------------------------------------------\n")
    common.logStatus(sC)
    common.logStatus("--------------------------------------------\n")
    error("wikilib.readDescriptions: Compilation error: "..oE)
  end
end

function wikilib.printTypeReference(API, bExt)
  local tT, sL = wikiType.list, apiGetValue(API,"TYPE", "LNK")
  local bE = apiGetValue(API,"FLAG", "extr") -- Use external wire types
  for ID = 1, #tT do local iDx = (bE and 2 or 1)
    io.write(toLinkRef(toRefer(tT[ID][1]), sL:format(toType(tT[ID][iDx]))).."\n")
  end; io.write("\n")
end

function wikilib.printRow(tT)
  io.write("|"..table.concat(tT, "|").."|\n")
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
    local exp = common.stringExplode(sV, sS)
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
  local sN = wikilib.normalDir(sBas)..wikilib.normalDir(sPth)
        sN = sN..sE2:lower().."_rt.txt"
  local fR = io.open(sN, "r"); if(not fR) then
    return common.logStatus("wikilib.readReturnValues: No file <"..sN..">") end
  local sL = fR:read("*line")
  while(sL ~= nil) do
    local sT = common.stringTrim(sL)
    if(sL ~= "") then
      local tT = common.stringExplode(sT, ":")
      tT[1] = common.stringTrim(tostring(tT[1]))
      tT[2] = common.stringTrim(tostring(tT[2]))
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
  local sE = common.stringTrim(sE2)
  local sM, sA = wikiFormat.msp, wikiFormat.asp
  if(sE:sub(1,10) == "e2function") then
    local tInfo, tTyp = {}, API.TYPE; tInfo.row = sE2
    sE = common.stringTrim(sE:sub(11, -1))
    iS = sE:find("%s", 1)
    tInfo.ret = wikilib.convTypeE2Description(API,common.stringTrim(sE:sub(1, iS)))[1]
    sE = common.stringTrim(sE:sub(iS, -1))
    iS = sE:find(sM, 1, true)
    if(iS) then
      tInfo.obj = wikilib.convTypeE2Description(API,common.stringTrim(sE:sub(1, iS-1)))[1]
      sE   = common.stringTrim(sE:sub(iS+1, -1))     
    end
    iS = sE:find("(", 1, true)
    tInfo.foo = common.stringTrim(sE:sub(1, iS-1))
    sE = common.stringTrim(sE:match(wikiBraketsIN)):sub(2,-2)
    tInfo.par = common.stringExplode(sE, sA)
    for ID = 1, #tInfo.par do
      tInfo.par[ID] = common.stringTrim(tInfo.par[ID])
      iS = tInfo.par[ID]:find(" ", 1, true)
      if(not iS) then break end
      tInfo.par[ID] = wikilib.convTypeE2Description(API,tInfo.par[ID]:sub(1, iS-1))[1]
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
      return common.logStatus("wikilib.isValidMatch: API <"..api.."> doubled", false)
    end
  end; return true
end

function wikilib.makeReturnValues(API)
  local sE2  = apiGetValue(API,"FILE", "exts")
  local sBas = apiGetValue(API,"FILE", "base")
  local sLua = apiGetValue(API,"FILE", "slua")
  local sN = wikilib.normalDir(sBas)..wikilib.normalDir(sLua)
  local sM, sE = wikiFormat.msp, wikiFormat.esp
        sN = sN..sE2:lower()..".lua"
  local fR = io.open(sN, "r"); if(not fR) then
    return common.logStatus("wikilib.makeReturnValues: No file <"..sN..">") end
  local sL, tF, tK, sA, bA, bE = fR:read("*line"), wikiMatch, wikiMList, "", false, false
  local mP, mH, mF = wikiFormat.npt, wikiFormat.hsh, wikiFormat.fnd
  while(sL ~= nil) do
    local fL = common.stringTrim(sL)
    local eL = fL:find(mP)
    local mL = fL:gsub(mP, mH)
    if(fL:find(mF) and not bA) then sA, bA = "", true end
    if(bA) then sA = sA.." "..fL
      if(mL:find(")")) then sA = common.stringTrim(sA)
        local tE = common.stringExplode(sA, sE)
        local sP, sO = common.stringTrim(tE[1]), nil
        if(tE[2]) then sO = common.stringTrim(tE[2]) end
        local tL = common.stringExplode(sP, " ")
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
  local sN = tostring(sNam or "DSC")
  for ID = 1, tK.__top do
    if(not DSC[tK[ID]]) then
      common.logStatus(sN.."[\""..tK[ID].."\"] = \"\"") end
  end
end

function wikilib.printTypeTable(API)
  local tT = wikiType.list
  wikilib.printRow({"Icon", "Description"})
  wikilib.printRow({"---", "---"})
  local sQ = apiGetValue(API, "FLAG", "qref") and "`" or ""
  for ID = 1, #tT do local sL = tT[ID][4]
    local sI = common.stringTrim(tT[ID][1])
    local sD = common.stringTrim(tT[ID][3])
    if(sL and not common.isDryString(sL)) then
      sL = common.stringTrim(sL)
      local sR = sD:match("%[.+%]"); if(sR) then
        sR = sR:gsub("%[", "%%%["):gsub("%]", "%%%]")
        sD = sD:gsub(sR, sR:gsub("%[", "%["..sQ):gsub("%]", sQ.."%]").."%("..sL.."%)")
      end
    end
    wikilib.printRow({toInsert(toImage(toRefer(sI))), sD})
  end; io.write("\n")
end

function wikilib.printDescriptionTable(API, DSC, iN)
  local tPool = API.POOL[iN]; if(not tPool) then return end   
  local nC, tC, tH = #tPool.cols, {}, {}
  for ID = 1, nC do
    local cat = ((tPool.size[ID] - tPool.cols[ID]:len()) / 2)
    tH[ID] = ("-"):rep(common.getClamp((tPool.size[ID] or tPool.cols[ID]:len()), 3))
    tC[ID] = wikiSpace:rep(math.floor(cat))..tPool.cols[ID]..wikiSpace:rep(math.ceil(cat))
  end; table.sort(tPool); tPool.data = {}
  wikilib.printRow(tC); wikilib.printRow(tH)
  local sM = wikiFormat.msp
  local bMsp = apiGetValue(API, "FLAG", "mosp")
  local bIco = apiGetValue(API, "FLAG", "icon")
  local bErr = apiGetValue(API, "FLAG", "erro")
  local sObj = apiGetValue(API, "TYPE", "OBJ")
  local sS, sA = wikiFormat.tsp, wikiFormat.asp
  local sV = wikilib.convTypeE2Description(API,"void")[1]
  for i, n in ipairs(tPool) do
    local arg, vars, obj = n:match("%(.-%)"), "", ""
    if(arg) then arg = arg:sub(2,-2)
      local tsk = common.stringExplode(arg, sM)
      if(not arg:find(sM)) then
        tsk[2], tsk[1] = tsk[1], sV end
      if(tsk[2] == "") then tsk[2] = sV end
      tsk[1], tsk[2] = common.stringTrim(tsk[1]), common.stringTrim(tsk[2])
      local k, len = 1, tsk[2]:len(); obj = sS..tsk[1]
      while(k <= len) do local sbc = tsk[2]:sub(k,k)
        if(sbc == "x") then
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
            common.logStatus("wikilib.printDescriptionTable: Description missing <"..api.row.."> !")
            common.logStatus("wikilib.printDescriptionTable: API missing <"..api.com.."> !")
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
            
            local sR = n:gsub("%(.-%)", ""); if(bMsp) then sR = "`"..sR.."`" end
            
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
      common.logStatus("wikilib.printDescriptionTable: Description mismatch <"..n.."> !")
      if(bErr) then error("wikilib.printDescriptionTable: Description mismatch <"..n.."> !") end
    end  
  end
  io.write("\n")
end

local wikiFolder = {}
      wikiFolder.__temp = "temp/"
      wikiFolder.__slsh = {["/"] = true, ["\\"] = true}
      wikiFolder.__read = "*line"
      wikiFolder.__drof = "Directory of "
      wikiFolder.__fdat = "%d%d%-%d%d%-%d%d%d%d%s+%d%d:%d%d"
      wikiFolder.__idir = {".", "..", "<DIR>"}
      wikiFolder.__pdir = {["."] = true, [".."] = true}
      wikiFolder.__fcmd = "cd %s && dir > %s"
      wikiFolder.__ranm = 60 -- Random string file name
      wikiFolder.__syms = { -- https://en.wikipedia.org/wiki/Code_page_437
        {"└", "├", "─", "│", "┌"},
        {"╚", "╠", "═", "║", "╔"},
        {"╙", "╟", "─", "║", "╓"},
        {"╘", "╞", "═", "│", "╒"},
        {"`", "|", "-", "|", "/"},
        {"+", "+", "-", "|", "*"}
      }
      wikiFolder.__drem = "(.*)/"
      wikiFolder.__dept = 3   -- The folder depth offset
      wikiFolder.__ubom = {
        ["UTF8" ] = {0xEF, 0xBB, 0xBF},      -- UTF8
        ["UTF16"] = {0xFE, 0xFF},            -- UTF16
        ["UTF32"] = {0x00, 0x00, 0xFE, 0xFF} -- UTF32
      }
      wikiFolder.__furl = {"",""}
      wikiFolder.__flag = {
        prnt = false, -- Show the parent directory in the tree
        hide = false, -- Show hidden directories
        size = false, -- Show file size
        hash = false, -- So directory hash address
        urls = false  -- Use URLs for the files /wikiFolder.__furl/
      }
      wikiFolder.__mems = {"", "k", "m", "t"} -- File zire amout round
      wikiFolder.__memi = 3                   -- File zire amout round ID

function wikilib.folderReplaceURL(sF, sU)
  local sF = wikilib.normalDir(tostring(sF or ""):gsub("\\","/"))
  local sU = wikilib.normalDir(tostring(sU or ""):gsub("\\","/")):gsub("%s","%%20")
  wikiFolder.__furl = {sF, sU}; return wikiFolder.__furl
end

function wikilib.folderSet(sT)
  wikiFolder.__temp = wikilib.normalDir(sT)
end

function wikilib.folderRoundSize(vS)
  local tM, iM = wikiFolder.__mems, wikiFolder.__memi
  if(tonumber(vS)) then
    iM = common.getClamp(math.floor(tonumber(nS) or 1), 1, #tM)
    return iM -- Return the parameter used
  else local iD, sS = 1, tostring(vS); while(tM[iD]) do
    if(tM[iD] == vS) then iM = iD; return iD end end
    common.logStatus("wikilib.folderRoundSize: Mismatch <"..vS.."> !")
    if(bErr) then error("wikilib.folderRoundSize: Mismatch <"..vS.."> !") end
  end
end

function wikilib.folderFlag(sF, bF)
  local tF = wikiFolder.__flag
  local sF = tostring(sF)
  if(tF[sF] ~= nil) then tF[sF] = (bF and bF or false)
  else common.logStatus("wikilib.folderFlag: Mismatch <"..sF.."> !")
    if(bErr) then error("wikilib.folderFlag: Mismatch <"..sF.."> !") end
  end
end

function wikilib.writeBOM(sF, vE)
  local sC, lE = tostring(sF or ""), common.toBool(lE)
  local tU = wikiFolder.__ubom[sC]; if(not tU) then
    return error("wikilib.writeBOM: Missed ("..tostring(lE)..") <"..sC..">") end
  if(not lE) then for iD = 1, #tU,  1 do io.write(string.char(tU[iD])) end
  else for iD = #tU, 1, -1 do io.write(string.char(tU[iD])) end end
  return true
end

function wikilib.fileSize(sS)
  local tM, sO = wikiFolder.__mems, ""
  local iM, sM = wikiFolder.__memi, #tM
  local tE = common.stringExplode(sS, " ")
  common.tableArrReverse(tE)
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
  local sR = common.randomGetString(wikiFolder.__ranm)
  local vT, tF = tostring(iT).."_"..sR, wikiFolder.__flag
  local nT = wikiFolder.__temp..vT..".txt"
  os.execute(wikiFolder.__fcmd:format(sP, nT))
  local fD, oE = io.open(nT, "rb"); if(not fD) then
    common.logStatus("wikilib.folderReadStructure: Open error <"..nT..">", nil)
    error("wikilib.folderReadStructure: Open error: "..oE)
  end
  local tT, iD, sL = {hash = {iT, sR}}, 0, fD:read(wikiFolder.__read)
    while(sL) do sL = common.stringTrim(sL)
    if(sL:sub(1, 13) == wikiFolder.__drof) then
      tT.base = sL:sub(14, -1):gsub("\\","/")
      if(sU[1] ~= "" and sU[2] ~= "") then
        local uS, uE = sP:find(sU[1], 1, true)
        if(uS and uE) then tT.link = sU[2]..sP:sub(uE+1, -1) end
      end
    elseif(sL:sub(1, 17):match(wikiFolder.__fdat)) then
      local sS = common.stringTrim(sL:sub(18, 36))
      local sN = common.stringTrim(sL:sub(37, -1))
      if(sS == wikiFolder.__idir[3] and wikiFolder.__pdir[sN]) then
        if(tF.prnt) then
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

local function folderLinkItem(tR, vC)
  local sO = vC.name
  if(wikiFolder.__flag.urls) then
    local cD = wikiFolder.__idir
    local tU, sR = wikiFolder.__furl, tR.link
    sR = (sR and wikilib.normalDir(sR) or tU[2])  
    sO = toLinkURL("`"..sO.."`", sR..vC.name:gsub("%s","%%20"))     
    if(vC.name == cD[1]) then sO = sO:gsub("/%"..cD[1].."%)$",")")
  elseif(vC.name == cD[2]) then
    sO = sO:gsub("/%.%.%)",""):match("(.*[/\\])"):sub(1,-2)..")"; end
  end; return sO
end

--[[
 * This proints out the recursive tree
 * tP > Structure to print
 * vA > The type of graph symbols to use
 * vR > Previous iretaration graph recursion depth ( omited )
 * sR > Previous iretaration graph recursion destination ( omited )
 * tD
]]
function wikilib.folderDrawTree(tP, vA, vR, sR, tD)
  local tS = wikiFolder.__syms
  local tD = common.getPick(common.isTable(tD), tD, nil)
  local iA = common.getClamp(tonumber(vA) or 1, 1, #tS)
  local sR, tF = tostring(sR or ""), wikiFolder.__flag
  local iR = common.getClamp(tonumber(vR) or 0, 0)
  local nS, nE = tP.base:find(wikiFolder.__drem); tS = tS[iA]
  local iI, tC = wikiFolder.__dept, common.sortTable(tP.cont, {"name"}, true)
  if(iR == 0) then local sB = tostring(tS[5] or "/")
    io.write("`"..sB..sR.."`"..tP.base:sub(nE+1, -1)..wikiNewLN); io.write("\n") end
  for iD = 1, tC.__top do local vC = tP.cont[tC[iD].__key]
    if(vC.root) then local dC = wikiSpace
      local sX = (tC[iD+1] and tS[2] or tS[1])..tS[3]:rep(iI)
      local sD = (tC[iD+1] and tS[4] or dC)..dC:rep(iI)
      local sS = (tF.hash and (" ["..vC.root.hash[1].."]"..vC.root.hash[2]) or "")
      local sL = ((tD and tD[vC.name]) and (" --> "..tostring(tD[vC.name] or "")) or "")
      io.write("`"..sR..sX.."`"..folderLinkItem(tP, vC)..sS..sL..wikiNewLN); io.write("\n")
      wikilib.folderDrawTree(vC.root, iA, iR+1, sR..sD, tD)
    else
      local sL = ((tD and tD[vC.name]) and (" --> "..tostring(tD[vC.name] or "")) or "")
      local sS = ((tF.size and vC.size ~= wikiFolder.__idir[3]) and wikilib.fileSize(vC.size) or "")
      local sX = (tC[iD+1] and tS[2] or tS[1])..tS[3]:rep(iI)
      io.write("`"..sR..sX.."`"..folderLinkItem(tP, vC)..sS..sL..wikiNewLN); io.write("\n")
    end
  end
end


wikilib.common = common

return wikilib
