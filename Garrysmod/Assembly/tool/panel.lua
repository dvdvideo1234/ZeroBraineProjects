local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE")
      dir.setBase(1)

CLIENT = true
SERVER = false

require("gmodlib")
require("trackasmlib")
local common = require("common")
local asmlib = trackasmlib

local stringExplode = string.Explode
local stringSub   =  string.sub
local stringFind  = string.find
local stringFormat = string.format
local vguiCreate  = vgui.Create
local languageGetPhrase = language.GetPhrase
local tableInsert = table.insert

CreateConVar("gmod_language")
require("Assembly/autorun/config")

local drmSkin = 0
local CPanel = vguiCreate("DPanel")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")

function asmlib.IsModel(m) return true end
local mt = getmetatable(vguiCreate("DTree"))

  local qPanel = asmlib.CacheQueryPanel(devmode); if(not qPanel) then
    asmlib.LogInstance("Panel population empty",sLog); return end
  local makTab = asmlib.GetBuilderNick("PIECES"); if(not asmlib.IsHere(makTab)) then
    asmlib.LogInstance("Missing builder table",sLog); return end
  local pTree  = vguiCreate("DTree", CPanel); if(not pTree) then
    asmlib.LogInstance("Database tree empty",sLog); return end
  pTree:Dock(TOP) -- Initialize to fill left and right bounds
  pTree:SetTall(400) -- Make it quite large
  pTree:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".model"))
  pTree:SetIndentSize(0) -- All track types are closed
  pTree:UpdateColours(drmSkin) -- Apply current skin
  CPanel:AddItem(pTree) -- Register it to the panel
  local defTable = makTab:GetDefinition()
  local tType, tRoot = {}, {Size = 0}
  for iC = 1, qPanel.Size do
    local vRec, bNow = qPanel[iC], true
    local sMod, sTyp, sNam = vRec.M, vRec.T, vRec.N
    if(asmlib.IsModel(sMod)) then
      if(not (asmlib.IsBlank(sTyp) or tType[sTyp])) then
        local pRoot = pTree:AddNode(sTyp) -- No type folder made already
              pRoot:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".type"))
              pRoot.Icon:SetImage(asmlib.ToIcon(defTable.Name))
              pRoot.DoClick = function() asmlib.SetNodeExpand(pRoot) end
              pRoot.Expander.DoClick = function() asmlib.SetNodeExpand(pRoot) end
              pRoot.DoRightClick = function() asmlib.OpenNodeMenu(pRoot) end
              pRoot:UpdateColours(drmSkin)
        tType[sTyp] = {Base = pRoot, Node = {}}
      end -- Reset the primary tree node pointer
      if(tType[sTyp]) then pItem = tType[sTyp].Base else pItem = pTree end
      -- Register the node associated with the track piece when is intended for later
      if(vRec.C and vRec.C.Size > 0) then -- When category for the track type is available
        local tNode = tType[sTyp].Node -- Index the contend for the track type
        for iD = 1, vRec.C.Size do -- Generate the path to the track piece
          local sCat = vRec.C[iD] -- Read the category name
          local tCat = tNode[sCat] -- Index the internal sub-category
          if(tCat) then -- Jump next if already created
            pItem = tCat.Base -- Assume that the category is allocated
            tNode = tCat.Node -- Jump to the next set of base nodes
          else -- Create a new sub-category for the incoming content
            tNode[sCat] = {}; tCat = tNode[sCat] -- Create node info
            pItem = asmlib.SetNodeDirectory(pItem, sCat) -- Create category
            tCat.Base = pItem; tCat.Node = {} -- Allocate node info
            tNode = tCat.Node -- Jump to the allocated set of base nodes
          end -- Create the last needed node regarding pItem
        end -- When the category has at least one element
      else -- Panel cannot categorize the entry add it to the list
        tRoot.Size = tRoot.Size + 1 -- Increment count to avoid calling #
        tableInsert(tRoot, iC); bNow = false -- Attach row ID to rooted items
      end -- When needs to be processed now just attach it to the tree
      if(bNow) then asmlib.SetNodeContent(pItem, sNam, sMod) end
      -- SnapReview is ignored because a query must be executed for points count
    else asmlib.LogInstance("Ignoring item "..asmlib.GetReport(sTyp, sNam, sMod),sLog) end
  end
  -- Attach the hanging items to the type root
  for iR = 1, tRoot.Size do
    local iRox = tRoot[iR]
    local vRec = qPanel[iRox]
    local sMod, sTyp, sNam = vRec.M, vRec.T, vRec.N
    asmlib.SetNodeContent(tType[sTyp].Base, sNam, sMod)
    asmlib.LogInstance("Rooting item "..asmlib.GetReport(sTyp, sNam, sMod), sLog)
  end -- Process all the items without category defined
  asmlib.LogInstance("Found items #"..qPanel.Size, sLog)
  
  common.logTable(tType, "tType", nil, {[mt] = function(v) return "VGUI:"..tostring(v.__type) end})
  