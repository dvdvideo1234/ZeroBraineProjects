local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE")
      dir.setBase(2)

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
local CPanel = vguiCreate("Panel")
local gsToolNameL = asmlib.GetOpVar("TOOLNAME_NL")

function asmlib.IsModel(m) return true end

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
  local tType, tCats, tRoot = {}, {}, {Size = 0}
  for iC = 1, qPanel.Size do
    local vRec, bNow = qPanel[iC], true
    local sMod, sTyp, sNam = vRec.M, vRec.T, vRec.N
    if(asmlib.IsModel(sMod)) then
      if(not (asmlib.IsBlank(sTyp) or tType[sTyp])) then
        local pRoot = pTree:AddNode(sTyp) -- No type folder made already
              pRoot:SetTooltip(languageGetPhrase("tool."..gsToolNameL..".type"))
              pRoot.Icon:SetImage(asmlib.ToIcon(defTable.Name))
              pRoot.DoClick = function() asmlib.SetExpandNode(pRoot) end
              pRoot.Expander.DoClick = function() asmlib.SetExpandNode(pRoot) end
              pRoot.DoRightClick = function()
                local sID = asmlib.WorkshopID(sTyp)
                if(sID and sID:len() > 0 and inputIsKeyDown(KEY_LSHIFT)) then
                  guiOpenURL(asmlib.GetOpVar("FORM_URLADDON"):format(sID))
                else SetClipboardText(pRoot:GetText()) end
              end
              pRoot:UpdateColours(drmSkin)
        tType[sTyp] = pRoot
      end -- Reset the primary tree node pointer
      if(tType[sTyp]) then pItem = tType[sTyp] else pItem = pTree end
      -- Register the node associated with the track piece when is intended for later
      local pCur = tCats[sTyp]; if(not asmlib.IsHere(pCur)) then
        tCats[sTyp] = {}; pCur = tCats[sTyp] end -- Create category tree path
      if(vRec.C) then -- When category for the track type is available
        for iD = 1, vRec.C.Size do -- Generate the path to the track piece
          local sCat = vRec.C[iD] -- Read the category name
          if(pCur[sCat]) then -- Jump next if already created
            pCur, pItem = asmlib.GetDirectory(pCur, sCat)
          else -- Create a new sub-category for the incoming content
            pCur, pItem = asmlib.SetDirectory(pItem, pCur, sCat)
          end -- Create the last needed node regarding pItem
        end -- When the category has at least one element
      else -- Panel cannot categorize the entry add it to the list
        tRoot.Size = tRoot.Size + 1 -- Increment count to avoid calling #
        tableInsert(tRoot, iC); bNow = false -- Attach row ID to rooted items
      end -- When needs to be processed now just attach it to the tree
      if(bNow) then asmlib.SetDirectoryNode(pItem, sNam, sMod) end
      -- SnapReview is ignored because a query must be executed for points count
    else asmlib.LogInstance("Ignoring item "..asmlib.GetReport(sTyp, sNam, sMod),sLog) end
  end
  -- Attach the hanging items to the type root
  for iR = 1, tRoot.Size do
    local iRox = tRoot[iR]
    local vRec = qPanel[iRox]
    local sMod, sTyp, sNam = vRec.M, vRec.T, vRec.N
    asmlib.SetDirectoryNode(tType[sTyp], sNam, sMod)
    asmlib.LogInstance("Rooting item "..asmlib.GetReport(sTyp, sNam, sMod), sLog)
  end -- Process all the items without category defined
  asmlib.LogInstance("Found items #"..qPanel.Size, sLog)