local com = require("dvdlualib/common")
local gmd = require("dvdlualib/gmodlib")

local getTime = os.time

local function toPID(t)
  return table.concat(t.mType, "-").."["..t.ID.."]"
end

local gtSet = {
  TYP = {"stcontrol", "xsc"},
  VAR = "wire_expression2_",
  ID  = {__top = 0, __all = 0}, -- TOP > ID of the last taken. ALL > Total objects
  FPW = "(%s%s%s)", -- The general type format for the control power setup
  PID = {"P", "I", "D"}, -- The names of each term. This is used for indexing and checking
  MIS = {"Xx", "X", "Nr"}
}; gtSet.VAR = gtSet.VAR..gtSet.TYP[1]

local varMaxTotal = CreateConVar(gtSet.VAR.."_max" , 20, gnServContr, "E2 StControl maximum count")


local function remValue(tSrc, aKey)
  tSrc[aKey] = nil; collectgarbage();
end

local function newItem(nTo)
  local nTop, nAll = gtSet.ID.__top, gtSet.ID.__all
  if(nAll >= varMaxTotal:GetInt()) then 
    return logError("newItem: Count reached ["..nAll.."]", nil) end
  local oStCon = {}; oStCon.mnTo = tonumber(nTo) -- Place to store the object
  if(oStCon.mnTo and oStCon.mnTo <= 0) then -- Fixed sampling time delta check
    return logError("newItem: Delta mismatch ["..tostring(oStCon.mnTo).."]", nil) end
  local sT = gtSet.FPW:format(gtSet.MIS[3], gtSet.MIS[3], gtSet.MIS[3])
  oStCon.mTimN = getTime(); oStCon.mTimO = oStCon.mTimN; -- Reset clock
  oStCon.mErrO, oStCon.mErrN, oStCon.mType = 0, 0, {sT,gtSet.MIS[2]:rep(3)} -- Error state values
  oStCon.mvCon, oStCon.mTimB, oStCon.meInt = 0, 0, true -- Control value and integral enabled
  oStCon.mBias, oStCon.mSatD, oStCon.mSatU = 0, nil, nil -- Saturation limits and settings
  oStCon.mvP, oStCon.mvI, oStCon.mvD = 0, 0, 0 -- Term values
  oStCon.mkP, oStCon.mkI, oStCon.mkD = 0, 0, 0 -- P, I and D term gains
  oStCon.mpP, oStCon.mpI, oStCon.mpD = 1, 1, 1 -- Raise the error to power of that much
  oStCon.mbCmb, oStCon.mbInv, oStCon.mbOn, oStCon.mbMan = false, false, false, false
  oStCon.mvMan = 0 -- Configure manual mode and store indexing
  nTop = (nTop + 1); oStCon.ID = nTop; gtSet.ID[nTop] = oStCon;
  nAll = (nAll + 1); gtSet.ID.__top, gtSet.ID.__all = nTop, nAll
  
  
  function oStCon:remove()
    this = oStCon
    if(not this) then return 0 end
    local nTop, nAll = gtSet.ID.__top, gtSet.ID.__all
    if(this.ID == nTop) then nTop = (nTop - 1)
      while(not gtSet.ID[nTop]) do nTop = (nTop - 1) end end
    nAll = (nAll - 1); remValue(gtSet.ID, this.ID)
    gtSet.ID.__top, gtSet.ID.__all = nTop, nAll; return 1
  end
  
  
  collectgarbage(); return oStCon
end


local aaa = {["table"]=toPID}


local a = newItem()
local b = newItem()
local c = newItem()
local d = newItem()
local e = newItem()
com.logTable(gtSet, "ID")

