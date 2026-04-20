--[[
 * The purpose of this Lua file is to add your track pack pieces to the
 * track assembly tool, so they can appear in the tool selection menu.
 * Why the name starts with /z/ you may ask. When Gmod loads the game
 * it goes trough all the Lua addons alphabetically.
 * That means your file name ( The file you are reading right now )
 * must be greater alphabetically than /trackasmlib/, so the API of the
 * module can be loaded before you can use it like seen below.
]]--

-- Local reference to the module.
local asmlib = trackasmlib; if(not asmlib) then -- Module present
  ErrorNoHaltWithStack("TOOL: Track assembly tool module fail!\n"); return end

--[[
 * This is your addon name. It is mandatory and it must be string.
 * It is used by TA in order to classify the content you are creating
 * It must NOT be an empty string nil or any other type regarding
 * The value will be automatically pattern converted to a index prefix
]]
local myAddon = "SligWolf's Suspension Train"

-- Log messages identifier. Leave DSV here or change it if you like
local mySource = "DSV"

--[[
 * Change this if you want to use different in-game type
 * You can also use multiple types myType1, myType2,
 * myType3, ... myType/n when your addon contains
 * multiple model packs.
]]--
local myType = myAddon -- The type your addon resides in the tool with

-- This is used for addon relation prefix. Fingers away from it
local myPrefix = myAddon:gsub("[^%w]","_") -- Addon prefix

-- This is the script path. It tells TA who wants to add these models
-- Do not touch this also, it is used for debugging
local myScript = tostring(debug.getinfo(1).source or "N/A")
      myScript = "@"..myScript:gsub("^%W+", ""):gsub("\\","/")
      mySource = tostring(mySource or ""):gsub("^%W+", "")
      mySource = (asmlib.IsBlank(mySource) and "DSV" or mySource)

-- Store a reference to disable symbol
local gsMissDB = asmlib.GetOpVar("MISS_NOSQL")
local gsDirDSV = asmlib.GetOpVar("DIRPATH_DSV")
local gsToolPF = asmlib.GetOpVar("TOOLNAME_PU")
local gsSymOff = asmlib.GetOpVar("OPSYM_DISABLE")

-- This is the path to your DSV
local myDsv = asmlib.GetLibraryPath(gsDirDSV, myPrefix, gsToolPF.."PIECES")

--[[
 * This flag is used when the track pieces list needs to be processed.
 * It generally represents the locking file persistence flag. It is
 * bound to finding a "PIECES" DSV external database for the prefix
 * of your addon. You can use it for boolean value deciding whenever
 * or not to run certain events. For example you can stop exporting
 * your local database every time Gmod loads, but then the user will
 * skip the available updates of your addon until he/she deletes the DSVs.
]]--
local myFlag = file.Exists(myDsv, "DATA")

--[[
 * This function defines what happens when there is an error present
 * Usually you can tell Gmod that you want it to generate an error
 * and throw the message to the log also. In this case you will not
 * have to change the function name in lots of places
 * when you need it to do something else.
--]]
local function ThrowError(vMesg)
  local sMesg = (myScript.." > ("..myAddon.."): "..tostring(vMesg)) -- Convert to string
  if(asmlib) then asmlib.LogInstance(sMesg, mySource) end -- Update the tool logs
  ErrorNoHaltWithStack(sMesg.."\n") -- Produce an error without breaking the stack
end

--[[
 * This logic statement is needed for reporting the error
 * in the console if the process fails.
 *
 @ bSuccess = trackasmlib.SynchronizeDSV(sTable, tData, bRepl, sPref, sDelim)
 * sTable > The table you want to sync
 * tData  > A data table like the one described above
 * bRepl  > If set to /true/, makes the API replace the repeating models with
            these of your addon. This is nice when you are constantly updating your track packs
            If set to /false/ keeps the current model in the
            database and ignores yours if they are the same file.
 * sPref  > An export file custom prefix. For synchronizing it must be related to your addon
 * sDelim > The delimiter used by the server/client ( default is a tab symbol )
 *
 @ bSuccess = trackasmlib.TranslateDSV(sTable, sPref, sDelim)
 * sTable > The table you want to translate to Lua script
 * sPref  > An export file custom prefix. For synchronizing it must be related to your addon
 * sDelim > The delimiter used by the server/client ( default is a tab symbol )
]]--
local function DoSynchronize(sName, tData, bRepl)
  local sRep = asmlib.GetReport(myPrefix, sName) -- Generate report if error is present
  if(not asmlib.IsEmpty(tData)) then -- Something to be processed. Do stuff when the table is not empty
    asmlib.LogInstance("Synchronization START "..sRep, mySource) -- Signal start synchronization
    if(not asmlib.SynchronizeDSV(sName, tData, bRepl, myPrefix)) then -- Attempt to synchronize
      ThrowError("Failed to synchronize content") -- Raise error when fails to sync tracks data
    else -- Successful. You are saving me from all the work for manually generating these
      asmlib.LogInstance("Translation START "..sRep, mySource) -- Signal start translation
      if(not asmlib.TranslateDSV(sName, myPrefix)) then -- Attempt to translate the DSV to Lua source
        ThrowError("Failed to translate content") end -- Raise error when fails
      asmlib.LogInstance("Translation OK "..sRep, mySource) -- Translation is successful
    end -- Now we have Lua inserts and DSV. Otherwise sent empty table and print status in logs
  else asmlib.LogInstance("Synchronization EMPTY "..sRep, mySource) end -- Nothing to be done
end

--[[
 * Register the addon to the auto-load prefix list when the
 * PIECES file is missing. The auto-load list is located in
 * (/garrysmod/data/trackassembly/set/trackasmlib_dsv.txt)
 * a.k.a the DATA folder of Garry's mod.
 *
 * @bSuccess = trackasmlib.RegisterDSV(sProg, sPref, sDelim)
 * sProg  > The program which registered the DSV
 * sPref  > The external data prefix to be added ( default instance prefix )
 * sDelim > The delimiter to be used for processing ( default tab )
 * bSkip  > Skip addition for the DSV prefix if exists ( default `false` )
]]--
local function DoRegister(bSkip)
  local sRep = asmlib.GetReport(myPrefix, bSkip) -- Generate report if error is present
  asmlib.LogInstance("Registration START "..sRep, mySource)
  if(bSkip) then -- Your DSV must be registered only once when loading for the first time
    asmlib.LogInstance("Registration SKIP "..sRep, mySource)
  else -- If the locking file is not located that means this is the first run of your script
    if(not asmlib.RegisterDSV(myScript, myPrefix)) then -- Register the DSV prefix and check for error
      ThrowError("Failed to register content") -- Throw the error if fails
    end -- Third argument is the delimiter. The default tab is used
    asmlib.LogInstance("Registration OK "..sRep, mySource)
  end
end

--[[
 * This logic statement is needed for reporting the error in the console if the
 * process fails.
 *
 @ bSuccess = trackasmlib.ExportCategory(nInd, tData, sPref)
 * nInd   > The index equal indent format to be stored with ( generally = 3 )
 * tData  > The category functional definition you want to use to divide your stuff with
 * sPref  > An export file custom prefix. For synchronizing
 *          it must be related to your addon ( default is instance prefix )
]]--
local function DoCategory(tCatg)
  local sRep = asmlib.GetReport(myPrefix, bSkip) -- Generate report if error is present
  asmlib.LogInstance("Category export START "..sRep, mySource)
  if(CLIENT) then -- Category handling is client side only
    if(not asmlib.IsEmpty(tCatg)) then
      if(not asmlib.ExportCategory(3, tCatg, myPrefix)) then
        ThrowError("Failed to synchronize category")
      end; asmlib.LogInstance("Category export OK "..sRep, mySource)
    else asmlib.LogInstance("Category export SKIP "..sRep, mySource) end
  else asmlib.LogInstance("Category export SERVER "..sRep, mySource) end
end

-- Tell TA what custom script we just called don't touch it
asmlib.LogInstance(">>> "..myScript.." ("..tostring(myFlag).."): {"..myAddon..", "..myPrefix.."}", mySource)

-- Register the addon to the workshop ID list
asmlib.WorkshopID(myAddon, "3297918081")

-- Register the addon to the plugable DSV list
local bS, vO = pcall(DoRegister, myFlag)
if(not bS) then ThrowError("Registration error: "..vO) end

--[[
 * This is used if you want to make internal categories for your addon
 * You must make a function as a string under the hash of your addon
 * The function must take only one argument and that is the model
 * For every sub-category of your track pieces, you must return a table
 * with that much elements or return a /nil/ value to add the piece to
 * the root of your branch. You can also return a second value if you
 * want to override the track piece name. If you need to use categories
 * for multiple track types, just put their hashes in the table below
 * and make every track point to its dedicated category handler.
]]--
local myCategory = {
  [myType] = {Txt = [[
    function(m) local s, c; s = _G.SligWolf_Addons; c = s and s.CallFunctionOnAddon("wpsuspensiontrain", "TrackAssamblerCategory", m); return c; end
  ]]}
}

-- Register the addon category to the plugable DSV list
local bS, vO = pcall(DoCategory, myCategory)
if(not bS) then ThrowError("Category error: "..vO) end

--[[
 * Create a table and populate it as shown below
 * In the square brackets goes your MODEL,
 * and then for every active point, you must have one array of
 * strings, where the elements match the following data settings.
 * You can use the disable event /#/ to make TA auto-fill
 * the value provided and you can also add multiple track types myType[1-n].
 * If you need to use piece origin/angle with model attachment, you must use
 * the attachment extraction event /!/. The model attachment format is
 * /!<attachment_name>/ and it depends what attachment name you gave it when you
 * created the model. If you need TA to extract the origin/angle from an attachment named
 * /test/ for example, you just need to put the string /!test/ in the origin/angle column for that model.
 * {MODEL, TYPE, NAME, LINEID, POINT, ORIGIN, ANGLE, CLASS}
 * MODEL  > This string contains the path to your /*.mdl/ file. It is mandatory and
 *          taken in pairs with LINEID, it forms the unique identifier of every record.
 *          When used in /DSV/ mode ( like seen below ) it is used as a hash index.
 * TYPE   > This string is the name of the type your stuff will reside in the panel.
 *          Disabling this, makes it use the value of the /DEFAULT_TYPE/ variable.
 *          If it is empty uses the string /TYPE/, so make sure you fill this.
 * NAME   > This is the name of your track piece. Put /#/ here to be auto-generated from
 *          the model ( from the last slash to the file extension ).
 * LINEID > This is the ID of the point that can be selected for building. They must be
 *          sequential and mandatory. If provided, the ID must the same as the row index under
 *          a given model key. Disabling this, makes it use the index of the current line.
 *          Use that to swap the active points around by only moving the desired row up or down.
 *          For the example table definition below, the line ID in the database will be the same.
 * POINT  > This is the location vector that TA searches and selects the related ORIGIN for.
 *          An empty string is treated as taking the ORIGIN when assuming player traces can hit the origin
 *          Disabling via /#/ makes it take the ORIGIN. Used to disable a point but keep original data
 *          You can also fill it with attachment event /!/ followed by your attachment name.
 * ORIGIN > This is the origin relative to which the next track piece position is calculated
 *          An empty string is treated as {0,0,0}. Disabling via /#/ also makes it use {0,0,0}
 *          You can also fill it with attachment event /!/ followed by your attachment name. It's mandatory
 * ANGLE  > This is the angle relative to which the forward and up vectors are calculated.
 *          An empty string is treated as {0,0,0}. Disabling via /#/ also makes it use {0,0,0}
 *          You can also fill it with attachment event /!/ followed by your attachment name. It's mandatory
 * CLASS  > This string is populated up when your entity class is not /prop_physics/ but something else
 *          used by ents.Create of the gmod ents API library. Keep this empty if your stuff is a normal prop.
 *          Disabling via /#/ makes it take the NULL value. In this case the model is spawned as a prop
]]--
local myPieces = {
  ["models/sligwolf/wpsuspensiontrain/stations/station_blank.mdl"] = {
    {myType, "Blank", gsSymOff, gsMissDB, "!station01", "!station01", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform01", "!smallplatform01", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform02", "!smallplatform02", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform03", "!smallplatform03", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform04", "!smallplatform04", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform05", "!smallplatform05", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform06", "!smallplatform06", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform07", "!smallplatform07", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform08", "!smallplatform08", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform09", "!smallplatform09", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform10", "!smallplatform10", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform11", "!smallplatform11", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform12", "!smallplatform12", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform13", "!smallplatform13", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform14", "!smallplatform14", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform15", "!smallplatform15", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform16", "!smallplatform16", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform17", "!smallplatform17", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform18", "!smallplatform18", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform19", "!smallplatform19", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform20", "!smallplatform20", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform21", "!smallplatform21", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform22", "!smallplatform22", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform23", "!smallplatform23", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform24", "!smallplatform24", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform25", "!smallplatform25", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform26", "!smallplatform26", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform27", "!smallplatform27", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform28", "!smallplatform28", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform01", "!bigplatform01", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform02", "!bigplatform02", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform03", "!bigplatform03", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform04", "!bigplatform04", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform05", "!bigplatform05", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform06", "!bigplatform06", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform07", "!bigplatform07", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform07a", "!bigplatform07a", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform08", "!bigplatform08", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform09", "!bigplatform09", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform10", "!bigplatform10", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform11", "!bigplatform11", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform12", "!bigplatform12", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform13", "!bigplatform13", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform13a", "!bigplatform13a", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform14", "!bigplatform14", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform15", "!bigplatform15", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform16", "!bigplatform16", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform17", "!bigplatform17", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform18", "!bigplatform18", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform19", "!bigplatform19", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform20", "!bigplatform20", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform20a", "!bigplatform20a", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform21", "!bigplatform21", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform22", "!bigplatform22", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform23", "!bigplatform23", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform24", "!bigplatform24", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform25", "!bigplatform25", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform26", "!bigplatform26", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform26a", "!bigplatform26a", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stations/station_blank_half.mdl"] = {
    {myType, "Blank", gsSymOff, gsMissDB, "!station01", "!station01", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!station02", "!station02", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform15", "!smallplatform15", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform16", "!smallplatform16", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform17", "!smallplatform17", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform18", "!smallplatform18", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform19", "!smallplatform19", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform20", "!smallplatform20", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform21", "!smallplatform21", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform22", "!smallplatform22", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform23", "!smallplatform23", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform24", "!smallplatform24", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform25", "!smallplatform25", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform26", "!smallplatform26", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform27", "!smallplatform27", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!smallplatform28", "!smallplatform28", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform14", "!bigplatform14", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform15", "!bigplatform15", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform16", "!bigplatform16", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform17", "!bigplatform17", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform18", "!bigplatform18", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform19", "!bigplatform19", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform20", "!bigplatform20", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform20a", "!bigplatform20a", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform21", "!bigplatform21", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform22", "!bigplatform22", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform23", "!bigplatform23", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform24", "!bigplatform24", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform25", "!bigplatform25", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform26", "!bigplatform26", gsMissDB},
    {myType, "Blank", gsSymOff, gsMissDB, "!bigplatform26a", "!bigplatform26a", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/bufferstop_64.mdl"] = {
    {myType, "Buffer Stop (64)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/curve_1024_22p5.mdl"] = {
    {myType, "Curve (1024 - 22.5°)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Curve (1024 - 22.5°)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/curve_1024_45.mdl"] = {
    {myType, "Curve (1024 - 45°)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Curve (1024 - 45°)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/curve_1024_90.mdl"] = {
    {myType, "Curve (1024 - 90°)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Curve (1024 - 90°)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/curve_2048_22p5.mdl"] = {
    {myType, "Curve (2048 - 22.5°)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Curve (2048 - 22.5°)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/curve_2048_45.mdl"] = {
    {myType, "Curve (2048 - 45°)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Curve (2048 - 45°)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/curve_2048_90.mdl"] = {
    {myType, "Curve (2048 - 90°)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Curve (2048 - 90°)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/handrails/handrail_platform_192.mdl"] = {
    {myType, "Handrail (192)", gsSymOff, gsMissDB, "!handrail01", "!handrail01", gsMissDB},
    {myType, "Handrail (192)", gsSymOff, gsMissDB, "!handrail02", "!handrail02", gsMissDB},
    {myType, "Handrail (192)", gsSymOff, gsMissDB, "!handrail03", "!handrail03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/handrails/handrail_platform_288.mdl"] = {
    {myType, "Handrail (288)", gsSymOff, gsMissDB, "!handrail01", "!handrail01", gsMissDB},
    {myType, "Handrail (288)", gsSymOff, gsMissDB, "!handrail02", "!handrail02", gsMissDB},
    {myType, "Handrail (288)", gsSymOff, gsMissDB, "!handrail03", "!handrail03", gsMissDB},
    {myType, "Handrail (288)", gsSymOff, gsMissDB, "!handrail04", "!handrail04", gsMissDB},
    {myType, "Handrail (288)", gsSymOff, gsMissDB, "!handrail05", "!handrail05", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/handrails/handrail_platform_384.mdl"] = {
    {myType, "Handrail (384)", gsSymOff, gsMissDB, "!handrail01", "!handrail01", gsMissDB},
    {myType, "Handrail (384)", gsSymOff, gsMissDB, "!handrail02", "!handrail02", gsMissDB},
    {myType, "Handrail (384)", gsSymOff, gsMissDB, "!handrail03", "!handrail03", gsMissDB},
    {myType, "Handrail (384)", gsSymOff, gsMissDB, "!handrail04", "!handrail04", gsMissDB},
    {myType, "Handrail (384)", gsSymOff, gsMissDB, "!handrail05", "!handrail05", gsMissDB},
    {myType, "Handrail (384)", gsSymOff, gsMissDB, "!handrail06", "!handrail06", gsMissDB},
    {myType, "Handrail (384)", gsSymOff, gsMissDB, "!handrail07", "!handrail07", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/handrails/handrail_platform_48.mdl"] = {
    {myType, "Handrail (48)", gsSymOff, gsMissDB, "!handrail01", "!handrail01", gsMissDB},
    {myType, "Handrail (48)", gsSymOff, gsMissDB, "!handrail02", "!handrail02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/handrails/handrail_platform_96.mdl"] = {
    {myType, "Handrail (96)", gsSymOff, gsMissDB, "!handrail01", "!handrail01", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/handrails/handrail_platform_48x48.mdl"] = {
    {myType, "Handrail L-Shape (48 x 48)", gsSymOff, gsMissDB, "!handrail01", "!handrail01", gsMissDB},
    {myType, "Handrail L-Shape (48 x 48)", gsSymOff, gsMissDB, "!handrail02", "!handrail02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/handrails/handrail_platform_96x96.mdl"] = {
    {myType, "Handrail L-Shape (96 x 96)", gsSymOff, gsMissDB, "!handrail01", "!handrail01", gsMissDB},
    {myType, "Handrail L-Shape (96 x 96)", gsSymOff, gsMissDB, "!handrail02", "!handrail02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holder_barmen_1024x448.mdl"] = {
    {myType, "Holder (1024 x 448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holder (1024 x 448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holder (1024 x 448)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holder_barmenwinkel_1024x448.mdl"] = {
    {myType, "Holder (1024 x 448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holder (1024 x 448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holder (1024 x 448)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holder_vohwinkel_1024x448.mdl"] = {
    {myType, "Holder (1024 x 448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holder (1024 x 448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holder (1024 x 448)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holder_barmenwinkel_512x448.mdl"] = {
    {myType, "Holder (512 x 448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holder (512 x 448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holder (512 x 448)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holder_vohwinkel_512x448.mdl"] = {
    {myType, "Holder (512 x 448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holder (512 x 448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holder (512 x 448)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holder_barmen_768x448.mdl"] = {
    {myType, "Holder (768 x 448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holder (768 x 448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holder (768 x 448)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbeam_barmen_128x384.mdl"] = {
    {myType, "Holderbeam (128 x 384)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbeam (128 x 384)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbeam_vohwinkel_192.mdl"] = {
    {myType, "Holderbeam (192)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbeam (192)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbeam_barmen_256x384.mdl"] = {
    {myType, "Holderbeam (256 x 384)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbeam (256 x 384)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbeam_vohwinkel_288.mdl"] = {
    {myType, "Holderbeam (288)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbeam (288)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbeam_varresbeck_384.mdl"] = {
    {myType, "Holderbeam (384)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbeam (384)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbeam_vohwinkel_384.mdl"] = {
    {myType, "Holderbeam (384)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbeam (384)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbeam_vohwinkel_48.mdl"] = {
    {myType, "Holderbeam (48)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbeam (48)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbeam_vohwinkel_96.mdl"] = {
    {myType, "Holderbeam (96)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbeam (96)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbeam_varresbeck_female_end_448.mdl"] = {
    {myType, "Holderbeam - Female (448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbeam - Female (448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbeam_varresbeck_male_end_448.mdl"] = {
    {myType, "Holderbeam - Male (448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbeam - Male (448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderbow_vohwinkel_64x64.mdl"] = {
    {myType, "Holderbow (64 x 64)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderbow (64 x 64)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderconnector_female_64.mdl"] = {
    {myType, "Holderconnector - Female (64)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderconnector - Female (64)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderconnector - Female (64)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderconnector_male_64.mdl"] = {
    {myType, "Holderconnector - Male (64)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderconnector - Male (64)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderconnector - Male (64)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderladder_192.mdl"] = {
    {myType, "Holderladder (192)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderladder (192)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderladder (192)", gsSymOff, gsMissDB, "!holder01a", "!holder01a", gsMissDB},
    {myType, "Holderladder (192)", gsSymOff, gsMissDB, "!holder01b", "!holder01b", gsMissDB},
    {myType, "Holderladder (192)", gsSymOff, gsMissDB, "!holder01c", "!holder01c", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderladder_288.mdl"] = {
    {myType, "Holderladder (288)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderladder (288)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderladder (288)", gsSymOff, gsMissDB, "!holder01a", "!holder01a", gsMissDB},
    {myType, "Holderladder (288)", gsSymOff, gsMissDB, "!holder01b", "!holder01b", gsMissDB},
    {myType, "Holderladder (288)", gsSymOff, gsMissDB, "!holder01c", "!holder01c", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderladder_384.mdl"] = {
    {myType, "Holderladder (384)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderladder (384)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderladder (384)", gsSymOff, gsMissDB, "!holder01a", "!holder01a", gsMissDB},
    {myType, "Holderladder (384)", gsSymOff, gsMissDB, "!holder01b", "!holder01b", gsMissDB},
    {myType, "Holderladder (384)", gsSymOff, gsMissDB, "!holder01c", "!holder01c", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderladder_48.mdl"] = {
    {myType, "Holderladder (48)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderladder (48)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderladder (48)", gsSymOff, gsMissDB, "!holder01a", "!holder01a", gsMissDB},
    {myType, "Holderladder (48)", gsSymOff, gsMissDB, "!holder01b", "!holder01b", gsMissDB},
    {myType, "Holderladder (48)", gsSymOff, gsMissDB, "!holder01c", "!holder01c", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderladder_96.mdl"] = {
    {myType, "Holderladder (96)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderladder (96)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderladder (96)", gsSymOff, gsMissDB, "!holder01a", "!holder01a", gsMissDB},
    {myType, "Holderladder (96)", gsSymOff, gsMissDB, "!holder01b", "!holder01b", gsMissDB},
    {myType, "Holderladder (96)", gsSymOff, gsMissDB, "!holder01c", "!holder01c", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderleg_barmenwinkel_160x448.mdl"] = {
    {myType, "Holderleg (160 x 448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderleg (160 x 448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderleg (160 x 448)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderleg_vohwinkel_160x448.mdl"] = {
    {myType, "Holderleg (160 x 448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderleg (160 x 448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderleg (160 x 448)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderleg_barmen_192x448.mdl"] = {
    {myType, "Holderleg (192 x 448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderleg (192 x 448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderleg (192 x 448)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holderleg_barmen_320x448.mdl"] = {
    {myType, "Holderleg (320 x 448)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Holderleg (320 x 448)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Holderleg (320 x 448)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stations/station_industrial.mdl"] = {
    {myType, "Industrial", gsSymOff, gsMissDB, "!station01", "!station01", gsMissDB},
    {myType, "Industrial", gsSymOff, gsMissDB, "!station02", "!station02", gsMissDB},
    {myType, "Industrial", gsSymOff, gsMissDB, "!station03", "!station03", gsMissDB},
    {myType, "Industrial", gsSymOff, gsMissDB, "!station04", "!station04", gsMissDB},
    {myType, "Industrial", gsSymOff, gsMissDB, "!station05", "!station05", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/holders/holdermain_192x80.mdl"] = {
    {myType, "Mainpiece (192 x 80)", gsSymOff, gsMissDB, "!holder01", "!holder01", gsMissDB},
    {myType, "Mainpiece (192 x 80)", gsSymOff, gsMissDB, "!holder02", "!holder02", gsMissDB},
    {myType, "Mainpiece (192 x 80)", gsSymOff, gsMissDB, "!holder03", "!holder03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_1_96x96.mdl"] = {
    {myType, "Platform 1A (96 x 96)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 1A (96 x 96)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB},
    {myType, "Platform 1A (96 x 96)", gsSymOff, gsMissDB, "!platform03", "!platform03", gsMissDB},
    {myType, "Platform 1A (96 x 96)", gsSymOff, gsMissDB, "!platform04", "!platform04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_1a_96x96.mdl"] = {
    {myType, "Platform 1B (96 x 96)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 1B (96 x 96)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB},
    {myType, "Platform 1B (96 x 96)", gsSymOff, gsMissDB, "!platform03", "!platform03", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_1b_96x96.mdl"] = {
    {myType, "Platform 1C (96 x 96)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 1C (96 x 96)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_1c_96x96.mdl"] = {
    {myType, "Platform 1D (96 x 96)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 1D (96 x 96)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_2_96x192.mdl"] = {
    {myType, "Platform 2A (96 x 192)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 2A (96 x 192)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB},
    {myType, "Platform 2A (96 x 192)", gsSymOff, gsMissDB, "!platform03", "!platform03", gsMissDB},
    {myType, "Platform 2A (96 x 192)", gsSymOff, gsMissDB, "!platform04", "!platform04", gsMissDB},
    {myType, "Platform 2A (96 x 192)", gsSymOff, gsMissDB, "!platform05", "!platform05", gsMissDB},
    {myType, "Platform 2A (96 x 192)", gsSymOff, gsMissDB, "!platform06", "!platform06", gsMissDB},
    {myType, "Platform 2A (96 x 192)", gsSymOff, gsMissDB, "!platform07", "!platform07", gsMissDB},
    {myType, "Platform 2A (96 x 192)", gsSymOff, gsMissDB, "!platform08", "!platform08", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_2a_96x192.mdl"] = {
    {myType, "Platform 2B (96 x 192)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 2B (96 x 192)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB},
    {myType, "Platform 2B (96 x 192)", gsSymOff, gsMissDB, "!platform03", "!platform03", gsMissDB},
    {myType, "Platform 2B (96 x 192)", gsSymOff, gsMissDB, "!platform04", "!platform04", gsMissDB},
    {myType, "Platform 2B (96 x 192)", gsSymOff, gsMissDB, "!platform05", "!platform05", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_2b_96x192.mdl"] = {
    {myType, "Platform 2C (96 x 192)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 2C (96 x 192)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB},
    {myType, "Platform 2C (96 x 192)", gsSymOff, gsMissDB, "!platform03", "!platform03", gsMissDB},
    {myType, "Platform 2C (96 x 192)", gsSymOff, gsMissDB, "!platform04", "!platform04", gsMissDB},
    {myType, "Platform 2C (96 x 192)", gsSymOff, gsMissDB, "!platform05", "!platform05", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_2c_96x192.mdl"] = {
    {myType, "Platform 2D (96 x 192)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 2D (96 x 192)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_2d_96x192.mdl"] = {
    {myType, "Platform 2E (96 x 192)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 2E (96 x 192)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB},
    {myType, "Platform 2E (96 x 192)", gsSymOff, gsMissDB, "!platform03", "!platform03", gsMissDB},
    {myType, "Platform 2E (96 x 192)", gsSymOff, gsMissDB, "!platform04", "!platform04", gsMissDB},
    {myType, "Platform 2E (96 x 192)", gsSymOff, gsMissDB, "!platform05", "!platform05", gsMissDB},
    {myType, "Platform 2E (96 x 192)", gsSymOff, gsMissDB, "!platform06", "!platform06", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_3_192x192.mdl"] = {
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform03", "!platform03", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform04", "!platform04", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform05", "!platform05", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform06", "!platform06", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform07", "!platform07", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform08", "!platform08", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform09", "!platform09", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform10", "!platform10", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform11", "!platform11", gsMissDB},
    {myType, "Platform 3A (192 x 192)", gsSymOff, gsMissDB, "!platform12", "!platform12", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_3a_192x192.mdl"] = {
    {myType, "Platform 3B (192 x 192)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 3B (192 x 192)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB},
    {myType, "Platform 3B (192 x 192)", gsSymOff, gsMissDB, "!platform03", "!platform03", gsMissDB},
    {myType, "Platform 3B (192 x 192)", gsSymOff, gsMissDB, "!platform04", "!platform04", gsMissDB},
    {myType, "Platform 3B (192 x 192)", gsSymOff, gsMissDB, "!platform05", "!platform05", gsMissDB},
    {myType, "Platform 3B (192 x 192)", gsSymOff, gsMissDB, "!platform06", "!platform06", gsMissDB},
    {myType, "Platform 3B (192 x 192)", gsSymOff, gsMissDB, "!platform07", "!platform07", gsMissDB},
    {myType, "Platform 3B (192 x 192)", gsSymOff, gsMissDB, "!platform08", "!platform08", gsMissDB},
    {myType, "Platform 3B (192 x 192)", gsSymOff, gsMissDB, "!platform09", "!platform09", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_3b_192x192.mdl"] = {
    {myType, "Platform 3C (192 x 192)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 3C (192 x 192)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB},
    {myType, "Platform 3C (192 x 192)", gsSymOff, gsMissDB, "!platform03", "!platform03", gsMissDB},
    {myType, "Platform 3C (192 x 192)", gsSymOff, gsMissDB, "!platform04", "!platform04", gsMissDB},
    {myType, "Platform 3C (192 x 192)", gsSymOff, gsMissDB, "!platform05", "!platform05", gsMissDB},
    {myType, "Platform 3C (192 x 192)", gsSymOff, gsMissDB, "!platform06", "!platform06", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/platforms/station_platform_3c_192x192.mdl"] = {
    {myType, "Platform 3D (192 x 192)", gsSymOff, gsMissDB, "!platform01", "!platform01", gsMissDB},
    {myType, "Platform 3D (192 x 192)", gsSymOff, gsMissDB, "!platform02", "!platform02", gsMissDB},
    {myType, "Platform 3D (192 x 192)", gsSymOff, gsMissDB, "!platform03", "!platform03", gsMissDB},
    {myType, "Platform 3D (192 x 192)", gsSymOff, gsMissDB, "!platform04", "!platform04", gsMissDB},
    {myType, "Platform 3D (192 x 192)", gsSymOff, gsMissDB, "!platform05", "!platform05", gsMissDB},
    {myType, "Platform 3D (192 x 192)", gsSymOff, gsMissDB, "!platform06", "!platform06", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stations/station_1a.mdl"] = {
    {myType, "Prebuild A", gsSymOff, gsMissDB, "!station01", "!station01", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stations/station_1a_half.mdl"] = {
    {myType, "Prebuild A", gsSymOff, gsMissDB, "!station01", "!station01", gsMissDB},
    {myType, "Prebuild A", gsSymOff, gsMissDB, "!station02", "!station02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stations/station_1b.mdl"] = {
    {myType, "Prebuild B", gsSymOff, gsMissDB, "!station01", "!station01", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stations/station_1b_half.mdl"] = {
    {myType, "Prebuild B", gsSymOff, gsMissDB, "!station01", "!station01", gsMissDB},
    {myType, "Prebuild B", gsSymOff, gsMissDB, "!station02", "!station02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/rerailer_2048.mdl"] = {
    {myType, "Rerailer (2048)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Rerailer (2048)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB},
    {myType, "Rerailer (2048)", gsSymOff, gsMissDB, "!station", "!station", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/slope_4096x480_8.mdl"] = {
    {myType, "Slope (4096 x 480 - 8°)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Slope (4096 x 480 - 8°)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB},
    {myType, "Slope (4096 x 480 - 8°)", gsSymOff, gsMissDB, "!middle", "!middle", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/slope_half_down_2048_8.mdl"] = {
    {myType, "Slope Down (2048 - 8°)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Slope Down (2048 - 8°)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/slope_half_up_2048_8.mdl"] = {
    {myType, "Slope Up (2048 - 8°)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Slope Up (2048 - 8°)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/handrails/handrail_stairs_192.mdl"] = {
    {myType, "Stairhandrail (192)", gsSymOff, gsMissDB, "!handrail01", "!handrail01", gsMissDB},
    {myType, "Stairhandrail (192)", gsSymOff, gsMissDB, "!handrail02", "!handrail02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/handrails/handrail_stairs_48.mdl"] = {
    {myType, "Stairhandrail (48)", gsSymOff, gsMissDB, "!handrail01", "!handrail01", gsMissDB},
    {myType, "Stairhandrail (48)", gsSymOff, gsMissDB, "!handrail02", "!handrail02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/handrails/handrail_stairs_96.mdl"] = {
    {myType, "Stairhandrail (96)", gsSymOff, gsMissDB, "!handrail01", "!handrail01", gsMissDB},
    {myType, "Stairhandrail (96)", gsSymOff, gsMissDB, "!handrail02", "!handrail02", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_3_wide_192x192x96.mdl"] = {
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_3a_wide_192x192x96.mdl"] = {
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_3b_wide_192x192x96.mdl"] = {
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_3c_wide_192x192x96.mdl"] = {
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs L (192 x 192 x 96)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_3_192x96x96.mdl"] = {
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_3a_192x96x96.mdl"] = {
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_3b_192x96x96.mdl"] = {
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_3c_192x96x96.mdl"] = {
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs L (192 x 96 x 96)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_2_wide_96x192x48.mdl"] = {
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_2a_wide_96x192x48.mdl"] = {
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_2b_wide_96x192x48.mdl"] = {
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_2c_wide_96x192x48.mdl"] = {
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs M (96 x 192 x 48)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_2_96x96x48.mdl"] = {
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_2a_96x96x48.mdl"] = {
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_2b_96x96x48.mdl"] = {
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_2c_96x96x48.mdl"] = {
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs M (96 x 96 x 48)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_1_wide_48x192x28.mdl"] = {
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_1a_wide_48x192x28.mdl"] = {
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_1b_wide_48x192x28.mdl"] = {
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_1c_wide_48x192x28.mdl"] = {
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs S (48 x 192 x 24)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_1_48x96x28.mdl"] = {
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_1a_48x96x28.mdl"] = {
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_1b_48x96x28.mdl"] = {
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/stairs/station_stairs_1c_48x96x28.mdl"] = {
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs01", "!stairs01", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs02", "!stairs02", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs03", "!stairs03", gsMissDB},
    {myType, "Stairs S (48 x 96 x 24)", gsSymOff, gsMissDB, "!stairs04", "!stairs04", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/straight_1024.mdl"] = {
    {myType, "Straight (1024)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Straight (1024)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/straight_128.mdl"] = {
    {myType, "Straight (128)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Straight (128)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/straight_144_full_gauge.mdl"] = {
    {myType, "Straight (144 - Full Gauge)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Straight (144 - Full Gauge)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/straight_16.mdl"] = {
    {myType, "Straight (16)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Straight (16)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/straight_2048.mdl"] = {
    {myType, "Straight (2048)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Straight (2048)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB},
    {myType, "Straight (2048)", gsSymOff, gsMissDB, "!station", "!station", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/straight_256.mdl"] = {
    {myType, "Straight (256)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Straight (256)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/straight_32.mdl"] = {
    {myType, "Straight (32)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Straight (32)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/straight_512.mdl"] = {
    {myType, "Straight (512)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Straight (512)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/straight_64.mdl"] = {
    {myType, "Straight (64)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Straight (64)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/straight_72_half_gauge.mdl"] = {
    {myType, "Straight (72 - Half Gauge)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "Straight (72 - Half Gauge)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/crossing_t_1904.mdl"] = {
    {myType, "T Crossing (1904, 2048 - 144)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "T Crossing (1904, 2048 - 144)", gsSymOff, gsMissDB, "!left", "!left", gsMissDB},
    {myType, "T Crossing (1904, 2048 - 144)", gsSymOff, gsMissDB, "!right", "!right", gsMissDB},
    {myType, "T Crossing (1904, 2048 - 144)", gsSymOff, gsMissDB, "!station", "!station", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/turningloop_1024.mdl"] = {
    {myType, "TurningLoop (1024)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "TurningLoop (1024)", gsSymOff, gsMissDB, "!up_holder", "!up_holder", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/turningloop_2048.mdl"] = {
    {myType, "TurningLoop (2048)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "TurningLoop (2048)", gsSymOff, gsMissDB, "!left_holder", "!left_holder", gsMissDB},
    {myType, "TurningLoop (2048)", gsSymOff, gsMissDB, "!up_holder", "!up_holder", gsMissDB},
    {myType, "TurningLoop (2048)", gsSymOff, gsMissDB, "!right_holder", "!right_holder", gsMissDB}
  },
  ["models/sligwolf/wpsuspensiontrain/turntable/turntable_ring_2way_1536.mdl"] = {
    {myType, "Turntable 2 Way (1536)", gsSymOff, gsMissDB, "!front", "!front", "sligwolf_wpsuspensiontrain_turntable_2way"},
    {myType, "Turntable 2 Way (1536)", gsSymOff, gsMissDB, "!back", "!back", "sligwolf_wpsuspensiontrain_turntable_2way"}
  },
  ["models/sligwolf/wpsuspensiontrain/turntable/turntable_ring_4way_1536.mdl"] = {
    {myType, "Turntable 4 Way (1536)", gsSymOff, gsMissDB, "!front", "!front", "sligwolf_wpsuspensiontrain_turntable_4way"},
    {myType, "Turntable 4 Way (1536)", gsSymOff, gsMissDB, "!back", "!back", "sligwolf_wpsuspensiontrain_turntable_4way"},
    {myType, "Turntable 4 Way (1536)", gsSymOff, gsMissDB, "!front2", "!front2", "sligwolf_wpsuspensiontrain_turntable_4way"},
    {myType, "Turntable 4 Way (1536)", gsSymOff, gsMissDB, "!back2", "!back2", "sligwolf_wpsuspensiontrain_turntable_4way"}
  },
  ["models/sligwolf/wpsuspensiontrain/turntable/turntable_ring_8way_1536.mdl"] = {
    {myType, "Turntable 8 Way (1536)", gsSymOff, gsMissDB, "!front", "!front", "sligwolf_wpsuspensiontrain_turntable_8way"},
    {myType, "Turntable 8 Way (1536)", gsSymOff, gsMissDB, "!back", "!back", "sligwolf_wpsuspensiontrain_turntable_8way"},
    {myType, "Turntable 8 Way (1536)", gsSymOff, gsMissDB, "!front2", "!front2", "sligwolf_wpsuspensiontrain_turntable_8way"},
    {myType, "Turntable 8 Way (1536)", gsSymOff, gsMissDB, "!back2", "!back2", "sligwolf_wpsuspensiontrain_turntable_8way"},
    {myType, "Turntable 8 Way (1536)", gsSymOff, gsMissDB, "!front3", "!front3", "sligwolf_wpsuspensiontrain_turntable_8way"},
    {myType, "Turntable 8 Way (1536)", gsSymOff, gsMissDB, "!back3", "!back3", "sligwolf_wpsuspensiontrain_turntable_8way"},
    {myType, "Turntable 8 Way (1536)", gsSymOff, gsMissDB, "!front4", "!front4", "sligwolf_wpsuspensiontrain_turntable_8way"},
    {myType, "Turntable 8 Way (1536)", gsSymOff, gsMissDB, "!back4", "!back4", "sligwolf_wpsuspensiontrain_turntable_8way"}
  },
  ["models/sligwolf/wpsuspensiontrain/rails/crossing_x_1904.mdl"] = {
    {myType, "X Crossing (1904, 2048 - 144)", gsSymOff, gsMissDB, "!front", "!front", gsMissDB},
    {myType, "X Crossing (1904, 2048 - 144)", gsSymOff, gsMissDB, "!left", "!left", gsMissDB},
    {myType, "X Crossing (1904, 2048 - 144)", gsSymOff, gsMissDB, "!right", "!right", gsMissDB},
    {myType, "X Crossing (1904, 2048 - 144)", gsSymOff, gsMissDB, "!back", "!back", gsMissDB}
  }
}

-- Register the addon PIECES to the plugable DSV list
local bS, vO = pcall(DoSynchronize, "PIECES", myPieces, true)
if(not bS) then ThrowError("PIECES error: "..vO) end

--[[
 * Create a table and populate it as shown below
 * In the square brackets goes your MODELBASE,
 * and then for every active point, you must have one array of
 * strings and numbers, where the elements match the following data settings.
 * {MODELBASE, MODELADD, ENTCLASS, LINEID, POSOFF, ANGOFF, MOVETYPE, PHYSINIT, DRSHADOW, PHMOTION, PHYSLEEP, SETSOLID}
 * MODELBASE > This string contains the path to your base /*.mdl/ file the additions will be attached to.
 *             It is mandatory and taken in pairs with LINEID, it forms the unique identifier of every record.
 *             When used in /DSV/ mode ( like seen below ) it is used as a hash index.
 * MODELADD  > This is the /*.mdl/ path of the addition entity. It is mandatory and cannot be disabled.
 * ENTCLASS  > This is the class of the addition entity. When disabled or missing it defaults to a normal prop.
 * LINEID    > This is the ID of the point that can be selected for building. They must be
 *             sequential and mandatory. If provided, the ID must the same as the row index under
 *             a given model key. Disabling this, makes it use the index of the current line.
 *             Use that to swap the active points around by only moving the desired row up or down.
 *             For the example table definition below, the line ID in the database will be the same.
 * POSOFF    > This is the local position vector offset that TA uses to place the addition relative to MODELBASE.
 *             A NULL, empty, disabled or not available string is treated as taking {0,0,0}.
 * ANGOFF    > This is the local angle offset that TA uses to place the addition.
 *             A NULL, empty, disabled or not available string is treated as taking {0,0,0}.
 * MOVETYPE  > This internally calls /Entity:SetMoveType/ if the database parameter is zero or greater.
 * PHYSINIT  > This internally calls /Entity:PhysicsInit/ if the database parameter is zero or greater.
 * DRSHADOW  > This internally calls /Entity:DrawShadow/ if the database parameter is not zero.
 *             The call evaluates to /true/ for positive numbers and /false/ for negative.
 *             When the parameter is equal to zero skips the call of /Entity:DrawShadow/
 * PHMOTION  > This internally calls /PhysObj:EnableMotion/ if the database parameter is not zero on the validated physics object.
 *             The call evaluates to /true/ for positive numbers and /false/ for negative.
 *             When the parameter is equal to zero skips the call of /Entity:EnableMotion/
 * PHYSLEEP  > This internally calls /PhysObj:Sleep/ if the database parameter is grater than zero on the validated physics object.
 *             When the parameter is equal or less than zero skips the call of /Entity:Sleep/
 * SETSOLID  > This internally calls /Entity:SetSolid/ if the database parameter is zero or greater.
]]--
local myAdditions = {}

-- Register the addon ADDITIONS to the plugable DSV list
local bS, vO = pcall(DoSynchronize, "ADDITIONS", myAdditions, true)
if(not bS) then ThrowError("ADDITIONS error: "..vO) end

--[[
 * Create a table and populate it as shown below
 * In the square brackets goes your TYPE,
 * and then for every active point, you must have one array of
 * strings and numbers, where the elements match the following data settings.
 * {TYPE, LINEID, NAME}
 * TYPE   > This is the category under your physical properties are stored internally.
 *          It is mandatory and taken in pairs with LINEID, it forms the unique identifier of every record.
 *          When used in /DSV/ mode ( like seen below ) it is used as a hash index.
 * LINEID > This is the ID of the point that can be selected for building. They must be
 *          sequential and mandatory. If provided, the ID must the same as the row index under
 *          a given model key. Disabling this, makes it use the index of the current line.
 *          Use that to swap the active points around by only moving the desired row up or down.
 *          For the example table definition below, the line ID in the database will be the same.
 * NAME   > This stores the name of the physical property. It must an actual physical property.
]]--
local myPhysproperties = {}

-- Register the addon PHYSPROPERTIES to the plugable DSV list
local bS, vO = pcall(DoSynchronize, "PHYSPROPERTIES", myPhysproperties, true)
if(not bS) then ThrowError("PHYSPROPERTIES error: "..vO) end

asmlib.LogInstance("<<< "..myScript, mySource)
