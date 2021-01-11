return function(sTool, sLimit)
return {
  {"tool."..sTool..".workmode.1"       , "General spawn/snap pieces" },
  {"tool."..sTool..".workmode.2"       , "Active point intersection" },
  {"tool."..sTool..".workmode.3"       , "Curve line segment fitting" },
  {"tool."..sTool..".workmode.4"       , "Surface normal flip over" },
  {"tool."..sTool..".info.1"           , "Spawns pieces on the map or snaps them relative to each other" },
  {"tool."..sTool..".info.2"           , "Connects track sections with dedicated segment designed for that" },
  {"tool."..sTool..".info.3"           , "Creates continuous track layouts passing through given checkpoints" },
  {"tool."..sTool..".info.4"           , "Flips the selected entities list across given origin and normal" },
  {"tool."..sTool..".left.1"           , "Spawn/snap a track piece. Hold SHIFT to stack" },
  {"tool."..sTool..".left.2"           , "Spawn track piece at the intersection point" },
  {"tool."..sTool..".left.3"           , "Spawn segmented track interpolation curve" },
  {"tool."..sTool..".left.4"           , "Spawn flipped over list of tracks selected" },
  {"tool."..sTool..".right.1"          , "Copy track piece model or open frequent pieces frame" },
  {"tool."..sTool..".right.2"          , "tool."..sTool..".right.1" },
  {"tool."..sTool..".right.3"          , "Create node for the segmented curve. Hold SHIFT to update" },
  {"tool."..sTool..".right.4"          , "Register entity in the flip over list. Hold SHIFT to change model" },
  {"tool."..sTool..".right_use.1"      , "Disabled SCROLL. ".."tool."..sTool..".right.1" },
  {"tool."..sTool..".right_use.2"      , "tool."..sTool..".right_use.1" },
  {"tool."..sTool..".right_use.3"      , "Generate node from the nearest track piece active point" },
  {"tool."..sTool..".right_use.4"      , "tool."..sTool..".right_use.1" },
  {"tool."..sTool..".reload.1"         , "Remove a track piece. Hold SHIFT to select an anchor" },
  {"tool."..sTool..".reload.2"         , "Remove a track piece. Hold SHIFT to select relation ray" },
  {"tool."..sTool..".reload.3"         , "Removes a curve interpolation node. Hold SHIFT to clear the stack" },
  {"tool."..sTool..".reload.4"         , "Clear the flip entities selection list. When empty removes piece" },
  {"tool."..sTool..".reload_use.1"     , "Enable database export to open DSV manager" },
  {"tool."..sTool..".reload_use.2"     , "tool."..sTool..".reload_use.1" },
  {"tool."..sTool..".reload_use.3"     , "tool."..sTool..".reload_use.1" },
  {"tool."..sTool..".reload_use.4"     , "tool."..sTool..".reload_use.1" },
  {"tool."..sTool..".desc"             , "Assembles a track for the vehicles to run on" },
  {"tool."..sTool..".name"             , "Track assembly" },
  {"tool."..sTool..".phytype"          , "Select physical properties type of the ones listed here" },
  {"tool."..sTool..".phytype_con"      , "Material type:" },
  {"tool."..sTool..".phytype_def"      , "<Select Surface Material TYPE>" },
  {"tool."..sTool..".phyname"          , "Select physical properties name to use when creating the track as this will affect the surface friction" },
  {"tool."..sTool..".phyname_con"      , "Material name:" },
  {"tool."..sTool..".phyname_def"      , "<Select Surface Material NAME>" },
  {"tool."..sTool..".bgskids"          , "Selection code of comma delimited Bodygroup/Skin ID" },
  {"tool."..sTool..".bgskids_con"      , "Bodygroup/Skin:" },
  {"tool."..sTool..".bgskids_def"      , "Write selection code here. For example 1,0,0,2,1/3" },
  {"tool."..sTool..".mass"             , "How heavy the piece spawned will be" },
  {"tool."..sTool..".mass_con"         , "Piece mass:" },
  {"tool."..sTool..".model"            , "Select a piece to start/continue your track with by expanding a type and clicking on a node" },
  {"tool."..sTool..".model_con"        , "Piece model:" },
  {"tool."..sTool..".activrad"         , "Minimum distance needed to select an active point" },
  {"tool."..sTool..".activrad_con"     , "Active radius:" },
  {"tool."..sTool..".stackcnt"         , "Maximum number of pieces to create while stacking" },
  {"tool."..sTool..".stackcnt_con"     , "Pieces count:" },
  {"tool."..sTool..".angsnap"          , "Snap the first piece spawned at this much degrees" },
  {"tool."..sTool..".angsnap_con"      , "Angular alignment:" },
  {"tool."..sTool..".resetvars"        , "Click to reset the additional values" },
  {"tool."..sTool..".resetvars_con"    , "V Reset variables V" },
  {"tool."..sTool..".nextpic"          , "Additional origin angular pitch offset" },
  {"tool."..sTool..".nextpic_con"      , "Origin pitch:" },
  {"tool."..sTool..".nextyaw"          , "Additional origin angular yaw offset" },
  {"tool."..sTool..".nextyaw_con"      , "Origin yaw:" },
  {"tool."..sTool..".nextrol"          , "Additional origin angular roll offset" },
  {"tool."..sTool..".nextrol_con"      , "Origin roll:" },
  {"tool."..sTool..".nextx"            , "Additional origin linear X offset" },
  {"tool."..sTool..".nextx_con"        , "Offset X:" },
  {"tool."..sTool..".nexty"            , "Additional origin linear Y offset" },
  {"tool."..sTool..".nexty_con"        , "Offset Y:" },
  {"tool."..sTool..".nextz"            , "Additional origin linear Z offset" },
  {"tool."..sTool..".nextz_con"        , "Offset Z:" },
  {"tool."..sTool..".gravity"          , "Controls the gravity on the piece spawned" },
  {"tool."..sTool..".gravity_con"      , "Apply piece gravity" },
  {"tool."..sTool..".weld"             , "Creates welds between pieces or pieces/anchor" },
  {"tool."..sTool..".weld_con"         , "Weld" },
  {"tool."..sTool..".forcelim"         , "Controls how much force is needed to break the weld" },
  {"tool."..sTool..".forcelim_con"     , "Force limit:" },
  {"tool."..sTool..".ignphysgn"        , "Ignores physics gun grab on the piece spawned/snapped/stacked" },
  {"tool."..sTool..".ignphysgn_con"    , "Ignore physics gun" },
  {"tool."..sTool..".nocollide"        , "Creates a no-collide between pieces or pieces/anchor" },
  {"tool."..sTool..".nocollide_con"    , "NoCollide" },
  {"tool."..sTool..".nocollidew"       , "Creates a no-collide between pieces and world" },
  {"tool."..sTool..".nocollidew_con"   , "NoCollide world" },
  {"tool."..sTool..".freeze"           , "Makes the piece spawn in a frozen state" },
  {"tool."..sTool..".freeze_con"       , "Freeze piece" },
  {"tool."..sTool..".igntype"          , "Makes the tool ignore the different piece types on snapping/stacking" },
  {"tool."..sTool..".igntype_con"      , "Ignore track type" },
  {"tool."..sTool..".spnflat"          , "The next piece will be spawned/snapped/stacked horizontally" },
  {"tool."..sTool..".spnflat_con"      , "Spawn horizontally" },
  {"tool."..sTool..".spawncn"          , "Spawns the piece at the center, else spawns relative to the active point chosen" },
  {"tool."..sTool..".spawncn_con"      , "Origin from center" },
  {"tool."..sTool..".surfsnap"         , "Snaps the piece to the surface the player is pointing at" },
  {"tool."..sTool..".surfsnap_con"     , "Snap to trace surface" },
  {"tool."..sTool..".appangfst"        , "Apply the angular offsets only on the first piece" },
  {"tool."..sTool..".appangfst_con"    , "Apply angular on first" },
  {"tool."..sTool..".applinfst"        , "Apply the linear offsets only on the first piece" },
  {"tool."..sTool..".applinfst_con"    , "Apply linear on first" },
  {"tool."..sTool..".adviser"          , "Controls rendering the tool position/angle adviser" },
  {"tool."..sTool..".adviser_con"      , "Draw adviser" },
  {"tool."..sTool..".pntasist"         , "Controls rendering the tool snap point assistant" },
  {"tool."..sTool..".pntasist_con"     , "Draw assistant" },
  {"tool."..sTool..".ghostcnt"         , "Controls rendering the tool ghosted holder pieces count" },
  {"tool."..sTool..".ghostcnt_con"     , "Ghosts count:" },
  {"tool."..sTool..".engunsnap"        , "Controls snapping when the piece is dropped by the player physgun" },
  {"tool."..sTool..".engunsnap_con"    , "Enable physgun snap" },
  {"tool."..sTool..".type"             , "Select the track type to use by expanding the folder" },
  {"tool."..sTool..".type_con"         , "Track type:" },
  {"tool."..sTool..".category"         , "Select the track category to use by expanding the folder" },
  {"tool."..sTool..".category_con"     , "Track category:" },
  {"tool."..sTool..".workmode"         , "Change this option to select a different working mode" },
  {"tool."..sTool..".workmode_con"     , "Work mode:" },
  {"tool."..sTool..".pn_export"        , "Click to export the client database as a file" },
  {"tool."..sTool..".pn_export_lb"     , "Export DB" },
  {"tool."..sTool..".pn_routine"       , "The list of your frequently used track pieces" },
  {"tool."..sTool..".pn_routine_hd"    , "Frequent pieces by:" },
  {"tool."..sTool..".pn_externdb"      , "The external databases available for:" },
  {"tool."..sTool..".pn_externdb_hd"   , "External databases by:" },
  {"tool."..sTool..".pn_externdb_lb"   , "Right click for options:" },
  {"tool."..sTool..".pn_externdb_1"    , "Copy unique prefix" },
  {"tool."..sTool..".pn_externdb_2"    , "Copy DSV folder path" },
  {"tool."..sTool..".pn_externdb_3"    , "Copy table nick" },
  {"tool."..sTool..".pn_externdb_4"    , "Copy table path" },
  {"tool."..sTool..".pn_externdb_5"    , "Copy table time" },
  {"tool."..sTool..".pn_externdb_6"    , "Copy table size" },
  {"tool."..sTool..".pn_externdb_7"    , "Edit table content (Luapad)" },
  {"tool."..sTool..".pn_externdb_8"    , "Delete database entry" },
  {"tool."..sTool..".pn_ext_dsv_lb"    , "External DSV list" },
  {"tool."..sTool..".pn_ext_dsv_hd"    , "External DSV databases list is displayed here" },
  {"tool."..sTool..".pn_ext_dsv_1"     , "Database unique prefix" },
  {"tool."..sTool..".pn_ext_dsv_2"     , "Active" },
  {"tool."..sTool..".pn_display"       , "The model of your track piece is displayed here" },
  {"tool."..sTool..".pn_pattern"       , "Write a pattern here and hit ENTER to preform a search" },
  {"tool."..sTool..".pn_srchcol"       , "Choose which list column you want to preform a search on" },
  {"tool."..sTool..".pn_srchcol_lb"    , "<Search by>" },
  {"tool."..sTool..".pn_srchcol_lb1"   , "Model" },
  {"tool."..sTool..".pn_srchcol_lb2"   , "Type" },
  {"tool."..sTool..".pn_srchcol_lb3"   , "Name" },
  {"tool."..sTool..".pn_srchcol_lb4"   , "End" },
  {"tool."..sTool..".pn_routine_lb"    , "Routine items" },
  {"tool."..sTool..".pn_routine_lb1"   , "Used" },
  {"tool."..sTool..".pn_routine_lb2"   , "End" },
  {"tool."..sTool..".pn_routine_lb3"   , "Type" },
  {"tool."..sTool..".pn_routine_lb4"   , "Name" },
  {"tool."..sTool..".pn_display_lb"    , "Piece display" },
  {"tool."..sTool..".pn_pattern_lb"    , "Write pattern" },
  {"tool."..sTool..".sizeucs"          , "Scale set for the coordinate systems displayed" },
  {"tool."..sTool..".sizeucs_con"      , "Scale UCS:" },
  {"tool."..sTool..".maxstatts"        , "Defines how many stack attempts the script will try before failing" },
  {"tool."..sTool..".maxstatts_con"    , "Stack attempts:" },
  {"tool."..sTool..".incsnpang"        , "Defines the angular incremental step when button sliders are used" },
  {"tool."..sTool..".incsnpang_con"    , "Angular step:" },
  {"tool."..sTool..".incsnplin"        , "Defines the linear incremental step when button sliders are used" },
  {"tool."..sTool..".incsnplin_con"    , "Linear step:" },
  {"tool."..sTool..".enradmenu"        , "When enabled turns on the usage of the workmode radial menu" },
  {"tool."..sTool..".enradmenu_con"    , "Enable radial menu" },
  {"tool."..sTool..".enpntmscr"        , "When enabled turns on the switching active points via mouse scroll" },
  {"tool."..sTool..".enpntmscr_con"    , "Enable point scroll" },
  {"tool."..sTool..".exportdb"         , "When enabled turns on the database export as one large file" },
  {"tool."..sTool..".exportdb_con"     , "Enable database export" },
  {"tool."..sTool..".modedb"           , "Change this to make tool database operate in different storage mode" },
  {"tool."..sTool..".modedb_con"       , "Database mode:" },
  {"tool."..sTool..".devmode"          , "When enabled turns on the developer mode for tracking and debugging" },
  {"tool."..sTool..".devmode_con"      , "Enable developer mode" },
  {"tool."..sTool..".maxtrmarg"        , "Change this to adjust the time between tool traces" },
  {"tool."..sTool..".maxtrmarg_con"    , "Trace margin:" },
  {"tool."..sTool..".maxmenupr"        , "Change this to adjust the number of the decimal places in the menu" },
  {"tool."..sTool..".maxmenupr_con"    , "Decimal places:" },
  {"tool."..sTool..".maxmass"          , "Change this to adjust the maximum mass that can be applied on a piece" },
  {"tool."..sTool..".maxmass_con"      , "Mass limit:" },
  {"tool."..sTool..".maxlinear"        , "Change this to adjust the maximum linear offset on a piece" },
  {"tool."..sTool..".maxlinear_con"    , "Offset limit:" },
  {"tool."..sTool..".maxforce"         , "Change this to adjust the maximum force limit when creating welds" },
  {"tool."..sTool..".maxforce_con"     , "Force limit:" },
  {"tool."..sTool..".maxactrad"        , "Change this to adjust the maximum active radius for obtaining point ID" },
  {"tool."..sTool..".maxactrad_con"    , "Radius limit:" },
  {"tool."..sTool..".maxstcnt"         , "Change this to adjust the maximum pieces to be created in stacking mode" },
  {"tool."..sTool..".maxstcnt_con"     , "Stack limit:" },
  {"tool."..sTool..".enwiremod"        , "When enabled turns on the wiremod expression chip extension" },
  {"tool."..sTool..".enwiremod_con"    , "Enable wire expression" },
  {"tool."..sTool..".enctxmenu"        , "When enabled turns on the tool dedicated context menu for pieces" },
  {"tool."..sTool..".enctxmenu_con"    , "Enable context menu" },
  {"tool."..sTool..".enctxmall"        , "When enabled turns on the tool dedicated context menu for all props" },
  {"tool."..sTool..".enctxmall_con"    , "Enable context menu for all props" },
  {"tool."..sTool..".endsvlock"        , "When enabled turns on the external pluggable DSV databases file lock" },
  {"tool."..sTool..".endsvlock_con"    , "Enable DSV database lock" },
  {"tool."..sTool..".curvefact"        , "Change this to adjust the curving factor tangent coefficient" },
  {"tool."..sTool..".curvefact_con"    , "Curve factor:" },
  {"tool."..sTool..".curvsmple"        , "Change this to adjust the curving interpolation samples" },
  {"tool."..sTool..".curvsmple_con"    , "Curve samples:" },
  {"tool."..sTool..".crvturnlm"        , "Change this to adjust the turn curving sharpness limit for the segment" },
  {"tool."..sTool..".crvturnlm_con"    , "Curvature turn:" },
  {"tool."..sTool..".crvleanlm"        , "Change this to adjust the lean curving sharpness limit for the segment" },
  {"tool."..sTool..".crvleanlm_con"    , "Curvature lean:" },
  {"tool."..sTool..".spawnrate"        , "Change this to adjust the amount of track segments spawned per server tick" },
  {"tool."..sTool..".spawnrate_con"    , "Spawning rate:" },
  {"tool."..sTool..".bnderrmod"        , "Change this to define the behavior when clients are spawning pieces outside of map bounds" },
  {"tool."..sTool..".bnderrmod_off"    , "Allow stack/spawn without restriction" },
  {"tool."..sTool..".bnderrmod_log"    , "Deny stack/spawn the error is logged" },
  {"tool."..sTool..".bnderrmod_hint"   , "Deny stack/spawn hint message is displayed" },
  {"tool."..sTool..".bnderrmod_generic", "Deny stack/spawn generic message is displayed" },
  {"tool."..sTool..".bnderrmod_error"  , "Deny stack/spawn error message is displayed" },
  {"tool."..sTool..".bnderrmod_con"    , "Bounding mode:" },
  {"tool."..sTool..".maxfruse"         , "Change this to adjust the depth of how many frequently used pieces are there" },
  {"tool."..sTool..".maxfruse_con"     , "Frequent pieces:" },
  {"tool."..sTool..".timermode_ap"     , "Click this to apply your changes to the SQL memory manager configuration" },
  {"tool."..sTool..".timermode_ap_con" , "Apply memory settings" },
  {"tool."..sTool..".timermode_md"     , "Change this to adjust the timer algorithm of the SQL memory manager" },
  {"tool."..sTool..".timermode_lf"     , "Change this to adjust the amount of time the record spends in the cache" },
  {"tool."..sTool..".timermode_lf_con" , "Record life:" },
  {"tool."..sTool..".timermode_rd"     , "When enabled wipes the record from the cache by forcing a nil value" },
  {"tool."..sTool..".timermode_rd_con" , "Enable record deletion" },
  {"tool."..sTool..".timermode_ct"     , "When enabled forces the garbage collection to run on record deletion" },
  {"tool."..sTool..".timermode_ct_con" , "Enable garbage collection" },
  {"tool."..sTool..".timermode_mem"    , "Memory manager for SQL table:" },
  {"tool."..sTool..".timermode_cqt"    , "Cache query timer via record request" },
  {"tool."..sTool..".timermode_obj"    , "Object timer attached to cache record" },
  {"tool."..sTool..".logfile"          , "When enabled starts streaming the log into dedicated file" },
  {"tool."..sTool..".logfile_con"      , "Enable logging file" },
  {"tool."..sTool..".logsmax"          , "Change this to adjust the log streaming maximum output lines written" },
  {"tool."..sTool..".logsmax_con"      , "Logging lines:" },
  {"sbox_max"..sLimit                  , "Change this to adjust the things spawned via track assembly tool on the server" },
  {"sbox_max"..sLimit.."_con"          , "Tracks amount:" },
  {"Cleanup_"..sLimit                  , "Assembled track pieces" },
  {"Cleaned_"..sLimit                  , "Cleaned up all track pieces" },
  {"SBoxLimit_"..sLimit                , "You've hit the spawned tracks limit!" }
}
end