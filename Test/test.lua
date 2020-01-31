package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

local com = require("common")
local gmd = require("dvdlualib/gmodlib")
local symOff =  "#"
local iD = 2
local iCnt = 1
local tRec = {
  {"//"}
}

 local tRow, vID, nID, sID = tRec[iCnt] -- Read the processed row reference
 
      vID = tRow[iD-1]; nID, sID = tonumber(vID), tostring(vID)
      nID = (nID or (sID:sub(1,1) == symOff and iCnt or 0)); tRow[iD-1] = nID
      
com.logTable(tRow)