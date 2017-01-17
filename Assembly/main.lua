require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/gmodlib")
require("ZeroBraineProjects/dvdlualib/asmlib")

local stringExplode = string.Explode
local stringSub   =  string.sub
local stringFind  = string.find
local stringFormat = string.format

asmlib.InitBase("track","assembly")

asmlib.SetOpVar("MODE_DATABASE" , "SQL")

asmlib.CreateTable("PIECES",{
  --Timer = asmlib.TimerSetting(gaTimerSet[1]),
  Index = {{1},{4},{1,4}},
  [1] = {"MODEL" , "TEXT"   , "LOW", "QMK"},
  [2] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [3] = {"NAME"  , "TEXT"   ,  nil , "QMK"},
  [4] = {"LINEID", "INTEGER", "FLR",  nil },
  [5] = {"POINT" , "TEXT"   ,  nil ,  nil },
  [6] = {"ORIGIN", "TEXT"   ,  nil ,  nil },
  [7] = {"ANGLE" , "TEXT"   ,  nil ,  nil },
  [8] = {"CLASS" , "TEXT"   ,  nil ,  nil }
},true,true)

local defTable = asmlib.GetOpVar("DEFTABLE_PIECES")
 
asmlib.DefaultType("Test",[[function(m)
    local r = m:gsub("models/bobsters_trains/rails/2ft/",""):gsub("_","/")
    local s = r:find("/"); r = (s and r:sub(1,s-1) or "other");
          r = r:gsub("^%l", string.upper); return r end
          ]])

asmlib.DefaultType("Bobster's two feet rails",[[function(m)
  local r = m:gsub("goldels/bobsters_trains/rails/2ft/",""):gsub("_","/")
  local s = r:find("/"); r = (s and r:sub(1,s-1) or "other");
        r = r:gsub("^%l", string.upper); return r end]])


local conPalette = asmlib.MakeContainer(colors)

local function regPanel(pTree, pFolders, iCall, Typ, pCateg, ptCat)
    local bSuc = true
    
    local pItem  
    if(Typ ~= "" and not pFolders[Typ]) then
      pItem = pTree:AddNode(Typ)
      pFolders[Typ] = pItem
    else
      pItem = pFolders[Typ]
    end
    
    --logTable(pItem,"Start")
    
    if(bSuc) then
      local pCurr = pCateg[Typ]
      if(type(ptCat) == "table" and ptCat[1]) then
        local iCnt = 1;   
        while(ptCat[iCnt]) do
          local sCat = tostring(ptCat[iCnt])
          asmlib.StatusLog(nil, "Ind: <"..sCat..">")
          if(pCurr[sCat]) then
            pCurr, pItem = asmlib.GetDirectoryObj(pCurr, sCat)
            asmlib.StatusLog(nil, "Jump table: <"..sCat..">")
          else
            pCurr, pItem = asmlib.SetDirectoryObj(pItem, pCurr, sCat,"icon16/folder.png",conPalette:Select("tx"))
            asmlib.StatusLog(nil, "Make table: <"..sCat..">")
          end; iCnt = iCnt + 1; 
        end
      elseif(asmlib.IsString(ptCat)) then
        if(not asmlib.IsEmptyString(ptCat)) then
          if(not pCurr[ptCat]) then
            pCurr, pItem = asmlib.SetDirectoryObj(pItem, pCurr, ptCat,"icon16/folder.png",conPalette:Select("tx"))
          else
            pCurr, pItem = asmlib.GetDirectoryObj(pCurr, ptCat)
          end
        end
      end
      if(psNam and psNam ~= "") then Nam = psNam end
    end
    
    
    pItem:SetName(pItem:GetName().."("..tostring(iCall)..")")
end

local Typ  = "Bobster's reails"
local Nam  = "Rail"
local pCateg = {}
local pFolders = {}

if(not pCateg[Typ]) then pCateg[Typ] = {} end
local pTree = asmlib.MakePanel(); pTree:SetName("Tree"); 
local pItem = pTree
local pCurr = pCateg[Typ]
--logTable(pCurr,"pCurr-ST")

regPanel(pTree, pFolders, 0, Typ, pCateg, nil)
regPanel(pTree, pFolders, 1, Typ, pCateg, "")
regPanel(pTree, pFolders, 2, Typ, pCateg, "Categ")
regPanel(pTree, pFolders, 3, Typ, pCateg, "Categ")

regPanel(pTree, pFolders, 41, Typ, pCateg, {"Categ","Test"})
regPanel(pTree, pFolders, 42, Typ, pCateg, {"Categ","Test","Gaga"})
regPanel(pTree, pFolders, 5, Typ, pCateg, {"OneTab"})
regPanel(pTree, pFolders, 6, Typ, pCateg, {"Categ"})
regPanel(pTree, pFolders, 7, Typ, pCateg, "Categ")

regPanel(pTree, pFolders, 92, Typ, pCateg, {"1"})
regPanel(pTree, pFolders, 91, Typ, pCateg, {"1","2"})

regPanel(pTree, pFolders, 93, Typ, pCateg, {"2"})
regPanel(pTree, pFolders, 42, Typ, pCateg, {"Categ","Test","Gaga","hoho"})

logTable(pTree,"pTree")

--logTable(pCurr,"pCurr")

--logTable(pFolders,"Folders")

