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
SERVER = true

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
  local catTypes = asmlib.GetOpVar("TABLE_CATEGORIES")
  local pTypes, pCateg, pNode = {}, {}
  local coMo = makTab:GetColumnName(1)
  local coTy = makTab:GetColumnName(2)
  local coNm = makTab:GetColumnName(3)
  for iC = 1, qPanel.Size do
    local vRec, bNow = qPanel[iC], true
    local sMod, sTyp, sNam = vRec[coMo], vRec[coTy], vRec[coNm]
    if(asmlib.IsModel(sMod)) then
      if(not (asmlib.IsBlank(sTyp) or pTypes[sTyp])) then
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
        pTypes[sTyp] = pRoot
      end -- Reset the primary tree node pointer
      if(pTypes[sTyp]) then pItem = pTypes[sTyp] else pItem = pTree end
      -- Register the category if definition functional is given
      if(catTypes[sTyp]) then -- There is a category definition
        local bSuc, vCat, vNam = pcall(catTypes[sTyp].Cmp, sMod)
        if(bSuc) then -- When the call is successful in protected mode
          if(vNam and not asmlib.IsBlank(vNam)) then
            sNam = asmlib.GetBeautifyName(vNam)
          end -- Custom name override when the addon requests
          local pCur = pCateg[sTyp]
          if(not asmlib.IsHere(pCur)) then
            pCateg[sTyp] = {}; pCur = pCateg[sTyp] end
          if(asmlib.IsBlank(vCat)) then vCat = nil end
          if(asmlib.IsHere(vCat)) then
            if(not istable(vCat)) then vCat = {vCat} end
            for iD = 1, #vCat do -- Create category tree path
              local sCat = tostring(vCat[iD] or ""):lower():Trim()
              if(asmlib.IsBlank(sCat)) then sCat = "other" end
              sCat = asmlib.GetBeautifyName(sCat) -- Beautify the category
              if(pCur[sCat]) then -- Jump next if already created
                pCur, pItem = asmlib.GetDirectory(pCur, sCat)
              else -- Create a new sub-category for the incoming content
                pCur, pItem = asmlib.SetDirectory(pItem, pCur, sCat)
              end -- Create the last needed node regarding pItem
            end -- When the category has at least one element
          else -- Store the creation information of the ones without category for later
            tableInsert(pCateg[sTyp], {sNam, sMod}); bNow = false
          end -- Is there is any category apply it. When available process it now
        else -- When there is an error in the category execution report it
          asmlib.LogInstance("Category "..asmlib.GetReport(sTyp, sMod).." execution error: "..vCat,sLog)
        end -- Category factory has been executed and sub-folders are created
      end -- Category definition has been processed and nothing more to be done
      -- Register the node associated with the track piece when is intended for later
      if(bNow) then asmlib.SetDirectoryNode(pItem, sNam, sMod) end
      -- SnapReview is ignored because a query must be executed for points count
    else asmlib.LogInstance("Ignoring item "..asmlib.GetReport(sTyp, sNam, sMod),sLog) end
  end
  -- Attach the hanging items to the type root
  for typ, val in pairs(pCateg) do
    for iD = 1, #val do
      local pan = pTypes[typ]
      local nam, mod = unpack(val[iD])
      asmlib.SetDirectoryNode(pan, nam, mod)
      asmlib.LogInstance("Rooting item "..asmlib.GetReport(typ, nam, mod),sLog)
    end
  end -- Process all the items without category defined
  asmlib.LogInstance("Found items #"..qPanel.Size, sLog)