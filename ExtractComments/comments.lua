[1] -- Initialize the global variable of the library
[5] -- Server controlled flags for console variables
[7] -- Independently controlled flags for console variables
[10] -- Library internal variables for limits and realtime tweaks
[38] -- Golden ratio used for panels
[39] -- Tool name for internal use
[40] -- Format to convert icons
[41] -- Not available as string
[42] -- Category name in the entities tab
[43] -- Reduce debug function calls
[44] -- Decimals beam round for visibility check
[45] -- Width coefficient used to calculate power
[46] -- Maximum value for valid coloring
[47] -- Color vectors and alpha comparison tolerance
[48] -- Nudge amount for origin vectors back-tracing
[49] -- Minimum width to be considered visible
[50] -- Collinearity and dot product margin check
[51] -- Lowest bounds of laser power
[52] -- Entity refract coefficient for back trace origins
[53] -- Beam back trace width when refracting
[54] -- World vectors to be correctly converted to local
[55] -- The distance to trace for finding water surface
[56] -- Cone slope length for cone section search
[57] -- User notification configuration type
[58] -- Utilized to print vector in proper manner
[59] -- General angular limits for having min/max
[60] -- External forced beam max bounces. Resets on every beam
[61] -- External forced beam length used in the current request
[62] -- External forced entity source for the beam update
[63] -- External forced beam color used in the current request
[64] -- The default key in a collection point to take when not found
[65] -- The all key in a collection point to return the all in set
[66] -- Zero angle used across all sources
[67] -- Zero vector used across all sources
[68] -- Global forward vector used across all sources
[69] -- Global right vector used across all sources. Positive is at the left
[70] -- Global up vector used across all sources
[71] -- Store reference to the world to skip the call in realtime
[72] -- Trace hit normal displacement
[82] -- Translates color from index/key to key/index
[84] -- Red
[85] -- Green
[86] -- Blue
[87] -- Alpha
[92] -- Classes existing in the hash part are laser-enabled entities `LaserLib.ClearOrder(self)`
[93] -- Classes are stored in notation `[ent:GetClass()] = true` and used in `LaserLib.IsUnit(ent)`
[94] -- This is present for hot reload. You must register yours separately
[95] -- This is present for hot reload. You must register yours separately
[96] -- This is present for hot reload. You must register yours separately
[97] -- This is present for hot reload. You must register yours separately
[98] -- This is present for hot reload. You must register yours separately
[99] -- This is present for hot reload. You must register yours separately
[100] -- This is present for hot reload. You must register yours separately
[101] -- This is present for hot reload. You must register yours separately
[102] -- This is present for hot reload. You must register yours separately
[103] -- This is present for hot reload. You must register yours separately
[104] -- This is present for hot reload. You must register yours separately
[105] -- This is present for hot reload. You must register yours separately
[106] -- [1] Actual class passed to `ents.Create` and used to actually create the proper scripted entity
[107] -- [2] Extension for folder name indices. Which filder are entity specific files located
[108] -- [3] Extension for variable name indices. Populate this when model control variable is different
[109] -- Laser entity class `PriarySource`
[110] -- Laser crystal class `EveryBeam`
[111] -- Laser reflectors class `DoBeam`
[112] -- Laser beam splitter `EveryBeam`
[113] -- Laser beam divider `DoBeam`
[114] -- Laser beam sensor `EveryBeam`
[115] -- Laser beam divide `DoBeam`
[116] -- Laser beam splitter multy `EveryBeam`
[117] -- Laser beam portal  `DoBeam`
[118] -- Laser beam parallel `DoBeam`
[119] -- Laser beam filter `DoBeam`
[122] -- Model used by the entities menu
[123] -- Laser model is changed via laser tool. Variable is not needed.
[124] -- Portal cube: models/props/reflection_cube.mdl
[128] -- Portal catcher: models/props/laser_catcher_center.mdl
[131] -- Portal: Well... Portals being entities
[137] -- Laser material is changed with the model
[173] -- Reflection descriptor
[174] -- Cube maps textures
[175] -- Has reflect in the name
[176] -- Regular mirror surface
[177] -- Chrome stuff reflect
[178] -- All shiny reflective stuff
[179] -- All general white paint
[180] -- All shiny metal reflect
[181] -- Used for prop updates and checks
[183] -- User for general class control
[184] -- [1] : Surface reflection index for the material specified
[185] -- [2] : Which index is the materil found at when it is searched in array part
[186] -- Disable empty materials
[187] -- Disable empty world materials
[188] -- Disable empty prop materials
[196] -- Materials that are overriden and directly hash searched
[207] -- White room in gm_construct
[208] -- There is no perfect mirror
[219] -- https://en.wikipedia.org/wiki/List_of_refractive_indices
[220] -- Air enumerator index
[221] -- Glass enumerator index
[222] -- Water enumerator index
[223] -- Used for prop updates and checks
[225] -- User for general class control
[226] -- [1] : Medium refraction index for the material specified
[227] -- [2] : Medium refraction rating when the beam goes trough reduces its power
[228] -- [3] : Which index is the materil found at when it is searched in array part
[229] -- Disable empty materials
[230] -- Disable empty world materials
[231] -- Disable empty prop materials
[232] -- Air refraction index
[233] -- Ordinary glass
[234] -- Water refraction index
[235] -- Materials that are overriden and directly hash searched
[236] -- Closer to air (pixelated)
[237] -- Non pure glass 2
[238] -- Ordinary glass
[239] -- Water refraction index
[240] -- Water with some impurites
[241] -- Water refraction index
[242] -- Ordinary glass
[243] -- Transperent no perfect air
[244] -- Ordinary glass
[245] -- Glass with some impurites
[246] -- Non pure glass 1
[247] -- Amber refraction index
[248] -- Dycamically changing slass
[249] -- Glass with decent impurites
[250] -- White glass
[251] -- Resembles no perfect glass
[252] -- Bit darker glass
[253] -- Dark glass
[254] -- Dark glass
[255] -- Dark glass other
[256] -- Dark glass other
[257] -- Blue temper glass
[271] -- Mee's Seamless-Portals. Disable detour
[293] -- Callbacks for console variables
[312] --[[
[313]  * Performs CAP dedicated traces. Will return result
[314]  * only when CAP hits its dedicated entities
[315]  * origin > Trace origin as world position vector
[316]  * direct > Trace direction as world aim vector
[317]  * length > Trace length in source units
[318]  * filter > Trace filter as standard config
[319]  * https://github.com/RafaelDeJongh/cap/blob/master/lua/stargate/shared/tracelines.lua
[320] ]]
[328] -- Use proper length even if missing
[332] -- If CAP specific entity is hit return and override the trace
[333] -- Otherwise use the reglar trace for refraction control
[336] --[[
[337]  * Performs general traces according to the parameters passed
[338]  * origin > Trace origin as world position vector
[339]  * direct > Trace direction as world aim vector
[340]  * length > Trace length in source units
[341]  * filter > Trace filter as standard config
[342]  * mask   > Trace mask as standard config
[343]  * colgrp > Trace collision group as standard config
[344]  * iworld > Trace ignore world as standard config
[345]  * width  > When larger than zero will run a hull trace instead
[346]  * result > Trace output destination table as standard config
[347] ]]
[354] -- Use proper length even if missing
[368] -- Default trace mask
[373] -- Default world ignore
[378] -- Default collision group
[428] --[[
[429]  * Clears an array table from specified index
[430]  * arr > Array to be cleared
[431]  * idx > Start clear index (not mandatory)
[432] ]]
[440] --[[
[441]  * Extracts table values from 2D set specified key
[442]  * tab > Reference to a table of row tables
[443]  * key > The key to be extracted (not mandatory)
[444] ]]
[448] -- Allocate
[450] -- Populate values
[451] -- Key-value pairs
[454] --[[
[455]  * Validates entity or physics object
[456]  * arg > Entity or physics object
[457] ]]
[465] --[[
[466]  * This setups the beam kill crediting
[467]  * Updates the kill credit player for specific entity
[468]  * To obtain the creator player use `ent:GetCreator()`
[469]  * https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/entity.lua#L69
[470] ]]
[474] -- Used for PPs and wire
[475] -- Used in sandbox on spawn
[478] -- https://wiki.facepunch.com/gmod/Enums/NOTIFY
[514] -- Origin
[516] -- Direction
[518] -- Return the converted transform
[521] --[[
[522]  * Applies the final posutional and angular offsets to the laser spawned
[523]  * Adjusts the custom model angle and calculates the touch position
[524]  * base  > The laser entity to preform the operation for
[525]  * trace > The trace that player is aiming for
[526]  * tran  > Transform information setup array
[527] ]]
[536] --[[
[537]  * Reads entity class name from the list
[538]  * idx (int) > When provided checks settings
[539] ]]
[542] -- Pick elemrnt
[543] -- No info
[545] -- Return whatever found
[548] --[[
[549]  * Check when the entity is laser library unit
[550] ]]
[557] --[[
[558]  * Defines when the entity can produce output beam
[559] ]]
[566] --[[
[567]  * Defines when the entity has primary laser settings
[568] ]]
[575] --[[
[576]  * Defines when the entity is actual beam source
[577] ]]
[584] --[[
[585]  * Allocates etity data tables and adds entity to `LaserLib.IsPrimary`
[586]  * ent > Entity to register as primary laser source
[587]  * nov > Enable initializing empty value
[588] ]]
[625] --[[
[626]  * Clears etity internal order info for the editable wrapper
[627]  * Registers the entity to the units list on CLIENT/SERVER
[628]  * ent > Entity to register as primary laser source
[629] ]]
[636] --[[
[637]  * Retrieves entity order settings for the given key
[638]  * ent > Entity to register as primary laser source
[639] ]]
[680] -- Server can go out now
[709] -- Server can go out now
[710] -- Ray assist disabled
[717] -- Aim laser beam at the reciever entity
[732] -- Move reciever entity on the laser beam
[737] -- Draw a position on the screen
[763] -- Draw a position on the screen
[790] --[[
[791]  * Creates ordered sequence set for use with
[792]  * The `Type` key is last and not mandaory
[793]  * It is used for materials found with indexing match
[794]  * https://wiki.facepunch.com/gmod/table.sort
[795] ]]
[802] -- Check database
[803] -- Entry is not present
[806] -- Insert
[808] -- Store info and return sequential table
[809] -- Entry is added to the squential list
[813] --[[
[814]  * Extracts information for a given sorted row
[815]  * Returns the information as a string
[816] ]]
[818] -- Temporary storage
[824] --[[
[825]  * Automatically adjusts the materil size
[826]  * Materials button will apways be square
[827] ]]
[840] --[[
[841]  * Clears the materil selector from eny content
[842]  * This is used for sorting and filtering
[843] ]]
[846] -- Clear all entries from the list
[849] -- Remove all rermaining image panels
[855] --[[
[856]  * Changes the selected materil paint over function
[857]  * When other one is clicked reverts the last change
[858] ]]
[861] -- Remove the current overlay
[865] -- Add the overlay to this button
[871] --[[
[872]  * Triggers save request for the material select
[873]  * scroll bar and reads it on the next panel open
[874]  * Animates the slider to the last remembered poistion
[875] ]]
[891] --[[
[892]  * Preforms material selection panel update for the requested entries
[893]  * Clears the content and remembers the last panel view state
[894]  * Called recursively when sorting or filtering is requested
[895] ]]
[899] -- Update material selection content
[901] -- Read the controls table and craete index
[903] -- Update material panel with ordered values
[906] -- Drawing is enabled
[924] -- Attach sub-menu to the menu items
[929] -- Sort sort by the entry key
[942] -- Sort sort by the absorbtion rate
[955] -- Sorted members by the medium refraction index
[970] -- When the variable value is the same as the key
[977] -- Update material panel scroll bar
[981] --[[
[982]  * Used to debug and set random stuff  in an interval
[983]  * Good for perventing spam of printing traces for example
[984] ]]
[988] -- Update time
[1012] --[[
[1013]  * Creates welds between laser and base
[1014]  * Applies and controls surface weld flag
[1015]  * weld  > Surface weld flag
[1016]  * laser > Laser entity to be welded
[1017]  * trace > Trace enity to be welded or world
[1018] ]]
[1029] -- Remove the weld with the laser
[1033] -- Otherwise falls trough the ground
[1036] -- Remove the NC with the laser
[1038] -- Skip no-collide when world is anchor
[1039] -- Do not call this for the world
[1042] --[[
[1043]  * Returns the yaw angle for the spawn function
[1044]  * ply > Player to calculate the angle for
[1045]  * Returns the calculated yaw result angle
[1046] ]]
[1053] --[[
[1054]  * Reflects a beam from a surface with material override
[1055]  * direct > The incident direction vector
[1056]  * normal > Surface normal vector trace.HitNormal ( normalized )
[1057]  * Return the refracted ray and beam status
[1058]   [1] > The refracted ray direction vector
[1059] ]]
[1061] -- Always normalized
[1067] --[[
[1068]  * Calculates the refract interface border angle
[1069]  * between two mediuims. Returns angles in range
[1070]  * from (-pi/2) to (pi/2)
[1071]  * source > Source refraction index
[1072]  * destin > Destination refraction index
[1073]  * bdegr  > Return the result in degrees
[1074] ]]
[1076] -- Calculate ratio
[1078] -- Calculate sine argument
[1080] -- The medium border angle
[1083] --[[
[1084]  * https://en.wikipedia.org/wiki/Refraction
[1085]  * Refracts a beam across two mediums by returning the refracted vector
[1086]  * direct > The incident direction vector
[1087]  * normal > Surface normal vector trace.HitNormal ( normalized )
[1088]  * source > Refraction index of the source medium
[1089]  * destin > Refraction index of the destination medium
[1090]  * Return the refracted ray and beam status
[1091]   [1] > The refracted ray direction vector
[1092]   [2] > Will the beam traverse to the next medium
[1093]   [3] > Mediums have the same refractive index
[1094] ]]
[1096] -- Read normalized copy os incident
[1097] -- Continue out medium
[1098] -- Always normalized. Call copy-constructor
[1099] -- Sine: |i||n|sin(i^n)
[1101] -- Apply Snell's law
[1102] -- Valid angle available
[1105] -- Make refraction
[1106] -- Reflect from medum interface boundary
[1111] --[[
[1112]  * Updates render bounds vector by calling min/max
[1113]  * base > Vector to be updated
[1114]  * vec  > Vector the base must be updated with
[1115]  * func > The cinction to be called. Either max or min
[1116] ]]
[1123] --[[
[1124]  * Makes the width visible when different than zero
[1125]  * width > The value to apply beam transformation
[1126] ]]
[1133] --[[
[1134]  * Calculates the laser trigger power
[1135]  * width  > Laser beam width
[1136]  * damage > Laser beam damage
[1137] ]]
[1142] --[[
[1143]  * Returns true whenever the width is still visible
[1144]  * width  > Value to chack beam visiblility
[1145]  * damage > Complete the power damage formula
[1146] ]]
[1153] -- https://developer.valvesoftware.com/wiki/Env_entity_dissolver
[1159] -- Try to index
[1161] -- Return indexed OK
[1172] --[[
[1173]  Translates indeces to color keys for RGB
[1174]  Genrally used to split colors into separate beams
[1175]  * idx > Index of the beam being split to components
[1176]  * mr  > Red component of the picked color channel
[1177]          Can also be a color object then `mb` is missed
[1178]  * mg  > Green component of the picked color channel
[1179]          Can also be a flag for new color if mr is object
[1180]  * mb  > Blue component of the picked color channel
[1181] ]]
[1184] -- Index component
[1185] -- Key color component
[1190] -- Split red   [1]
[1191] -- Split green [2]
[1192] -- Split blue  [3]
[1193] -- Return the picked component
[1215] --[[
[1216]  * Checks when the entity has interactive material
[1217]  * Cashes the request issued for index material
[1218]  * mat > Direct material to check for. Missing uses `ent`
[1219]  * set > The dedicated parameeters setting to check
[1220]  * Returns: Material entry from the given set
[1221] ]]
[1225] -- Pointer to the local surface material
[1226] -- Read the first entry from table
[1228] -- Check for overriding with default
[1230] -- Check for element overrides
[1232] -- Check for emement category
[1234] -- Cache the material
[1235] -- Cache rhe material found
[1236] -- Compare the entry
[1237] -- Read and compare the next entry
[1238] -- Undefined material
[1239] -- Return nothing when not found
[1242] --[[
[1243]  * Searches for a material in the definition set
[1244]  * When material is not passed returns the default
[1245]  * When material is passed indexes and returns it
[1246] ]]
[1250] -- Index the row
[1261] --[[
[1262]  * Calculates the local beam origin offset
[1263]  * according to the base entity and direction provided
[1264]  * base   > Base entity to calculate the vector for
[1265]  * direct > Local direction vector according to `base`
[1266]  * Returns the local entity origin offcet vector
[1267]  * obcen  > Beam origin as a local offset vector
[1268]  * kmulv  > Width relative to the given local direction
[1269] ]]
[1279] --[[
[1280]  * Calculates the beam direction according to the
[1281]  * angle provided as a regular number. Rotates around Y
[1282]  * base  > Base entity to calculate the direction for
[1283]  * angle > Amount to rotate the entity angle in degrees
[1284] ]]
[1295] --[[
[1296]  * Projects the OBB onto the ray defined by position and direction
[1297]  * base  > Base entity to calculate the snapping for
[1298]  * hitp  > The position of the surface to snap the laser on
[1299]  * norm  > World normal direction vector defining the snap plane
[1300]  * angle > The model offset beam angling parameterization
[1301] ]]
[1313] --[[
[1314]  * Generates a custom local angle for lasers
[1315]  * Defines value bases on a domainat direction
[1316]  * base   > Entity to calculate for
[1317]  * direct > Local direction for beam align
[1318] ]]
[1323] -- Wipe ID
[1324] -- Pick up min/max projection lengths
[1325] -- Read primal direction vector
[1327] -- Calculate margin
[1338] -- Forward is max projection up is min projection
[1339] -- Primary forward (orthogonal)
[1340] -- Primary up (orthogonal)
[1341] -- Transfer and apply angle pitch
[1342] -- Cache angle
[1365] -- Create a server-side damage information class
[1367] -- https://wiki.facepunch.com/gmod/Global.DamageInfo
[1376] -- https://developer.valvesoftware.com/wiki/Env_entity_dissolver
[1395] -- Force relative to mass center
[1397] -- Keep force separate from damage inflicting
[1399] -- This is the way laser can be used as forcer
[1400] -- Do not apply force on laser units
[1406] -- Take damage doesn't work on player inside a vehicle.
[1409] -- We must kill the driver!
[1415] -- We stop here because we hit a shield!
[1426] -- We need to kill the player first to get his ragdoll.
[1428] -- Thanks to Nevec for the player ragdoll idea, allowing us to dissolve him the cleanest way.
[1491] -- Setup the laser kill crediting
[1494] -- These do not change when laser is updated
[1503] -- Retrieve the string of the base class
[1505] -- Setup kill icon for the base laser
[1507] -- Setup the same kill icon across other units
[1513] --[[
[1514]  * Caculates the beam posidion and direction when entity is a portal
[1515]  * This assumes that the neam enters th +X and exits at +X
[1516]  * This will lead to correct beam representation across portal Y axis
[1517]  * base    > Base entity actime as a portal entrance
[1518]  * exit    > Exit entity actime as a portal beam output location
[1519]  * origin  > Hit location vector placed on the furst entity surface
[1520]  * direct  > Direction that the beam goes inside the first entity
[1521]  * forigin > Origin custom modifier function. Negates X, Y by default
[1522]  * fdirect > Direction custom modifier function. Negates X, Y by default
[1523]  * Returns the output beam ray position and direction
[1524] ]]
[1543] --[[
[1544]  * Projects beam direction onto portal forward and retrieeves
[1545]  * portal beam margin visuas to be displayed correctly in
[1546]  * render target surface. Returns incorrect results when
[1547]  * portal position is not located on the render target surface
[1548]  * entity > The portal entity to calculate margin for
[1549]  * origin > Hit location vector placed on the furst entity surface
[1550]  * direct > Direction that the beam goes inside the first entity
[1551]  * normal > Surface normal vector. Usually portal:GetForward()
[1552]  * Returns the output beam ray margin transition
[1553] ]]
[1554] --[[
[1555]     local pos, dir = trace.HitPos, beam.VrDirect
[1556]     local eps, mav = ent:GetPos(), Vector(dir)
[1557]     local fwd, wvc = ent:GetForward(), Vector(pos); wvc:Sub(eps)
[1558] -- Project entrance vector
[1558]     local mar = math.abs(wvc:Dot(fwd)) -- Project entrance vector
[1559]     local vsm = mar / math.cos(math.asin(fwd:Cross(dir):Length()))
[1560]     vsm = 2 * vsm; mav:Set(dir); mav:Mul(vsm); mav:Add(pos)
[1561] ]]
[1566] -- Project entrance vector
[1572] --[[
[1573]  * Makes the laser trace loop use pre-defined bounces cout
[1574]  * When this is not given the loop will use MBOUNCES
[1575]  * bounce > The amount of bounces the loop will have
[1576] ]]
[1578] -- Initial value
[1584] --[[
[1585]  * Makes the laser trace loop use pre-defined length
[1586]  * This is done so the next unit will know the
[1587]  * actual length when SIMO entities are used
[1588]  * length > The actual external length for SIMO
[1589] ]]
[1597] --[[
[1598]  * Updates the beam source according to the current entity
[1599]  * entity > Reference to the current entity
[1600]  * former > Reference to the source from last split
[1601] ]]
[1603] -- Initial value
[1607] -- Source is found
[1608] -- No source is found
[1611] --[[
[1612]  * Updates the beam source according to the current entity
[1613]  * entity > Reference to the current entity
[1614]  * former > Reference to the source from last split
[1615] ]]
[1617] -- Initial value
[1619] -- Localize max
[1621] -- Color object
[1626] -- Must utilize numbers
[1631] -- We have input parameter
[1632] -- We do not have input parameter
[1635] --[[
[1636]  * This implements beam OOP with all its specifics
[1637] ]]
[1638] -- Object metatable for class methods
[1639] -- Store class type here
[1640] -- If not found in self search here
[1641] -- Temprary calculation origin vector
[1642] -- Temprary calculation direct vector
[1643] -- General air info
[1644] -- General water info
[1647] -- Water surface plane position
[1648] -- Water surface plane normal ( used also for trigger )
[1649] -- Water surface plane temporary direction vector
[1650] -- The value of the temporary dot product margin
[1651] -- Fast water texture hash matching
[1655] -- Initial start beam length
[1656] -- Length is not available exit now
[1657] -- Copy direction and normalize when present
[1659] -- Create local copy for origin not to modify it
[1660] -- Contains information for the mediums being traversed
[1661] -- Create empty vertices array for the client
[1662] -- This will apply the external configuration during the beam creation
[1663] -- Max bounces for the laser loop being applied
[1664] -- External count
[1665] -- Internal caount from the convar
[1666] -- Beam start color
[1667] -- Original source
[1668] -- Original length
[1669] -- Source beam medium
[1670] -- Destination beam medium
[1671] -- Medium memory
[1672] -- Initial current beam damage
[1673] -- Initial current beam width
[1674] -- Initial current beam force
[1675] -- Diameter trace-back dimensions of the entity
[1676] -- Full length for traces not being bound by hit events
[1677] -- Make sure beam is zero width during the initial trace hit
[1678] -- Library is still tracing the beam and calculating nodes
[1679] -- Start tracing the beam inside a medium boundary
[1680] -- Trace filter was updated by actor and must be cleared
[1681] -- Ignore world flag to make it hit the other side
[1682] -- The beam is refracting inside and entity or world solid
[1683] -- Trace mask. When not provided negative one is used
[1684] -- Collision group. Missing then COLLISION_GROUP_NONE
[1685] -- Amount of bounces to control the infinite loop
[1686] -- Range of the length. Just like wire ranger
[1687] -- The actual beam lengths substracted after iterations
[1691] --[[
[1692]  * Checks when water base medium is not activated
[1693] ]]
[1699] --[[
[1700]  * Clears the water surface normal
[1701] ]]
[1704] -- Coding effective API
[1707] --[[
[1708]  * Issues a finish command to the traced laser beam
[1709] ]]
[1711] -- We are neither hitting something nor still tracing or hit dedicated entity
[1712] -- Refresh medium pass trough information
[1713] -- Coding effective API
[1716] --[[
[1717]  * Cecks the condition for the beam loop to terminate
[1718]  * Returns boolean when the beam must continue
[1719] ]]
[1726] --[[
[1727]  * Cecks whenever the beam runs the first iteration
[1728]  * Returns boolean when the beam runs the first iteration
[1729] ]]
[1734] --[[
[1735]  * Issues a finish command to the traced laser beam
[1736]  * trace > Trace structure of the current iteration
[1737] ]]
[1739] -- Make sure to exit not to do performance hit
[1741] -- Coding effective API
[1744] --[[
[1745]  * Nudges and adjusts the temporary vector
[1746]  * using the direction and origin with a margin
[1747]  * Returns the adjusted temporary
[1748]  * margn > Marging to adjust the temporary with
[1749] ]]
[1756] --[[
[1757]  * Checks whenever the given position is located
[1758]  * above or below the water plane defined in `__water`
[1759]  * pos > World-space position to be checked
[1760] ]]
[1770] --[[
[1771]  * Checks for memory refraction start-refract
[1772]  * from the last medum stored in memory and
[1773]  * ignores the beam start entity. Checks when
[1774]  * the given position is inside the beam source
[1775] ]]
[1785] --[[
[1786]  * Changes the source medium. Source is the medium that
[1787]  * surrounds all objects and acts line their environment
[1788]  * origin > Beam exit position
[1789]  * direct > Beam exit direction
[1790] ]]
[1793] -- Apply medium info
[1794] -- Apply medium key
[1796] -- Apply medium info
[1797] -- Apply medium key
[1799] -- Coding effective API
[1802] --[[
[1803]  * Changes the source medium. Source is the medium that
[1804]  * surrounds all objects and acts line their environment
[1805]  * origin > Beam exit position
[1806]  * direct > Beam exit direction
[1807] ]]
[1810] -- Apply medium info
[1811] -- Apply medium key
[1813] -- Apply medium info
[1814] -- Apply medium key
[1816] -- Coding effective API
[1819] --[[
[1820]  * Changes the source medium. Source is the medium that
[1821]  * surrounds all objects and acts line their environment
[1822]  * origin > Beam exit position
[1823]  * direct > Beam exit direction
[1824] ]]
[1827] -- Apply medium info
[1828] -- Apply medium key
[1830] -- Apply medium info
[1831] -- Apply medium key
[1836] -- Coding effective API
[1839] --[[
[1840]  * Intersects line (start, end) with a plane (position, normal)
[1841]  * This can be called then beam goes out of the water
[1842]  * To straight caluculate the intersection pont
[1843]  * this will ensure no overhead traces will be needed.
[1844]  * pos > Plane position as vector in 3D space
[1845]  * nor > Plane normal as world direction vector
[1846]  * org > Ray start origin position (trace.HitPos)
[1847]  * dir > Ray direction world vector (trace.Normal)
[1848] ]]
[1856] -- Water-air intersextion point
[1859] --[[
[1860]  * Clears configuration parameters for trace medium
[1861]  * origin > Beam exit position
[1862]  * direct > Beam exit direction
[1863] ]]
[1865] -- Appy origin and direction when beam exits the medium
[1868] -- Lower the refraction flag ( Not full internal reflection )
[1870] -- Use zero width beam traces
[1871] -- Revert ignoring world
[1872] -- Has to stop refracting
[1873] -- Restore the filter and hit world for tracing something else
[1874] -- We prepare to hit something else anyway
[1875] -- We are changing mediums and refraction is complete
[1876] -- Coding effective API
[1879] --[[
[1880]  * Updates the hit texture if the trace contents
[1881]  * index > Texture index relative to gtREFRACT[ID]
[1882]  * trace > Trace structure of the current iteration
[1883] ]]
[1892] -- Coding effective API
[1895] --[[
[1896]  * Account for the trace width cube half diagonal
[1897]  * trace  > Trace result to be modified
[1898]  * length > Actual iteration beam length
[1899] ]]
[1901] -- Check if the trace is available
[1902] -- Trace must hit something
[1903] -- Library must be refracting
[1904] -- Beam width is available
[1905] -- Beam width is present
[1908] -- At this point we know exacly how long will the trace be
[1909] -- In this case the value of node regster length is calculated
[1910] -- Acctual beam requested length
[1911] -- Length fraction
[1912] -- Length fraction LS
[1917] --[[
[1918]  * Beam traverses from medium [1] to medium [2]
[1919]  * origin > The node position to be registered
[1920]  * nbulen > Update the length according to the new node
[1921]  *          Positive number when provided else internal length
[1922]  *          Pass true boolean to update the node with distance
[1923]  * bedraw > Enable draw beam node on the CLIENT
[1924]  *          Use this for portals when skip gap is needed
[1925]  *   info > Trace data points row for a given node ID
[1926]  *    [1] > Node locaton in 3D space position (vector)
[1927]  *    [2] > Node beam current width automatic (number)
[1928]  *    [3] > Node beam current damage automatic (number)
[1929]  *    [4] > Node beam current force automatic (number)
[1930]  *    [5] > Whenever to draw or not beam line (boolean)
[1931]  *    [6] > Color updated by various filters (boolean)
[1932] ]]
[1934] -- Local reference to stack
[1939] -- Substract the path trough the medium
[1940] -- Direct length
[1941] -- Read the node stack size
[1942] -- Length is not provided
[1944] -- Relative to previous
[1946] -- Use the nodes and make sure previos exists
[1947] -- Register the new node to the stack
[1949] -- Coding effective API
[1952] --[[
[1953]  * Setups the beam power ratio when requested for the last
[1954]  * node on the stack. Applies power ratio and calculates
[1955]  * whenever the total beam is absorbed to be stopped
[1956]  * Returns node reference indexed internally and current power
[1957]  * rate   > The ratio to apply on the last node
[1958] ]]
[1962] -- There is sanity with adjusting the stuff
[1966] -- Update the parameters used for drawing the beam trace
[1967] -- Adjusts visuals for width
[1968] -- Adjusts visuals for damage
[1969] -- Adjusts visuals for force
[1970] -- Check out power rating so the trace absorbed everything
[1972] -- Absorbs remaining light
[1973] -- It is indexed anyway then return it to the caller
[1976] --[[
[1977]  * Checks whenever the last node location
[1978]  * belongs on the laser beam. Adjusts if not
[1979] ]]
[1982] -- Set of nodes
[1983] -- Read stack size
[1984] -- Exit
[1985] -- Index temporary
[1992] --[[
[1993]  * Prepares the laser beam structure for entity refraction
[1994]  * origin  > New beam origin location vector
[1995]  * direct  > New beam ray direction vector
[1996]  * target  > New entity target being switched
[1997]  * refract > Refraction descriptor entry
[1998]  * key     > Refraction descriptor key
[1999] ]]
[2001] -- Register desination medium and raise calculate refraction flag
[2003] -- First element is always structure
[2004] -- Second element is always the index found
[2005] -- Otherwise refract contains the whole thing
[2006] -- Get the trace tready to check the other side and point and register the location
[2013] -- Must trace only this entity otherwise invalid
[2015] -- We are interested only in the refraction entity
[2016] -- Raise the bounce off refract flag
[2017] -- Increase the beam width for back track
[2018] -- Scale and again to make it hit
[2019] -- Coding effective API
[2022] --[[
[2023]  * https://wiki.facepunch.com/gmod/Enums/MAT
[2024]  * https://wiki.facepunch.com/gmod/Entity:GetMaterialType
[2025]  * Retrieves material override for a trace or use the default
[2026]  * Toggles material original selecton when not available
[2027]  * When flag is disabled uses the material type for checking
[2028]  * The value must be available for client and server sides
[2029]  * trace > Reference to trace result structure
[2030]  * Returns: Material extracted from the entity on server and client
[2031] ]]
[2036] -- Use trace material type
[2038] -- Material lookup
[2039] -- **studio**, **displacement**, **empty**
[2044] -- Entity may not have override
[2045] -- Empty then use the material type
[2046] -- No override is available use original
[2047] -- Just grab the first material
[2048] -- Gmod can not simply decide which material is hit
[2049] -- Use trace material type
[2051] -- Material lookup
[2052] -- **studio**, **displacement**, **empty**
[2053] -- Physobj has a single surfacetype related to model
[2059] --[[
[2060]  * Samples the medium ahead in given direction
[2061]  * This aims to hit a solids of the map or entities
[2062]  * On success will return the refraction surface entry
[2063]  * origin > Refraction medium boundary origin
[2064]  * direct > Refraction medium boundary surface direct
[2065]  * trace  > Trace structure to store the result
[2066] ]]
[2070] -- Nothing traces
[2071] -- Has prop air gap
[2075] --[[
[2076]  * Prepares the beam for the next general trace
[2077]  * This makes the hit-back entity from the other side
[2078]  * origin > Refraction medium boundary origin
[2079]  * direct > Refraction medium boundary surface direct
[2080] ]]
[2087] -- Coding effective API
[2090] --[[
[2091]  * Requests a beam reflection
[2092]  * reflect > Reflection info structure
[2093]  * trace   > The current trace result
[2094] ]]
[2100] -- Coding effective API
[2103] --[[
[2104]  * Returns the trace entity valid flag and class
[2105]  * Updates the actor exit flag when found
[2106]  * target > The entity being the target
[2107] ]]
[2109] -- If filter was a special actor and the clear flag is enabled
[2110] -- Make sure to reset the filter if needed to enter actor again
[2111] -- Custom filter clear has been requested
[2112] -- Reset the filter to hit something else
[2113] -- Lower the flag so it does not enter
[2114] -- Filter is present and we have request to clear the value
[2115] -- Validate trace target and extract its class if available
[2116] -- Validate target
[2120] --[[
[2121]  * Performs library dedicated beam trace. Runs a
[2122]  * CAP trace. when fails runs a general trace
[2123]  * result > Trace output destination table as standard config
[2124] ]]
[2127] -- CAP trace is not needed wen we are refracting
[2129] -- Return CAP currently hit
[2130] -- When the trace is not specific CAP entity continue
[2131] -- Otherwise use the standard trace
[2136] --[[
[2137]  * Handles refraction of water to air
[2138]  * Redirects the beam from water to air at the boundary
[2139]  * point when water flag is triggered and hit position is
[2140]  * outside the water surface.
[2141] ]]
[2143] -- When beam started inside the water and hit ouside the water
[2144] -- Local reference indexing water
[2147] -- Registering the node cannot be done with direct substraction
[2153] -- Set water normal flag to zero
[2154] -- Switch to air medium
[2155] -- Redirect and reset laser beam
[2156] -- Redirect the beam in case of going out reset medium
[2157] -- Redirect only reset laser beam
[2158] -- Apply power ratio when requested
[2160] -- Coding effective API
[2163] --[[
[2164]  * Configures and activates the water refraction surface
[2165]  * The beam may sart in the water or hit it and switch
[2166]  * reftype > Indication that this is found in the water
[2167]  * trace   > Trace result structure output being used
[2168] ]]
[2178] -- Refract type is not water so reset the configuration
[2179] -- Clear the water normal vector
[2180] -- Water refraction configuration is done
[2181] -- Refract type not water then setup
[2183] -- Memorize the plane position
[2184] -- Memorize the plane normal
[2185] -- Refract type is not water so reset the configuration
[2186] -- Clear the water normal vector
[2187] -- Water refraction configuration is done
[2188] -- Coding effective API
[2191] --[[
[2192]  * Setups the clags for world and water refraction
[2193] ]]
[2196] -- First element is always structure
[2197] -- Second element is always the index found
[2198] -- Otherwise refract contains the whole thing
[2199] -- Substact traced lenght from total length because we have hit something
[2201] -- Remaining in refract mode
[2202] -- Separate control for water and non-water
[2203] -- There is no water plane registered
[2204] -- Beam is inside another non water solid
[2205] -- World transparen objects do not need world ignore
[2206] -- Beam did not traverse into water
[2207] -- Increase the beam width for back track
[2208] -- Apply world-only filter for refraction exit the location
[2209] -- Fumction that filters hit world only
[2210] -- Filter solids so they can be hit inside water medium
[2211] -- Beam is inside water. Do not force refract
[2212] -- Water refraction does not need world ignore
[2213] -- Aim to hit solid props within the water
[2214] -- Clear the personal filter so we can hit models in the water
[2215] -- We also must pass the primary iteration entity for custom beam offsets
[2216] -- When beam starts inside the a laser prop with custom offsets must skip it
[2223] --[[
[2224]  * Checks when another medium is present on exit
[2225]  * When present tranfers the beam to the new medium
[2226]  * origin > Origin position to be checked ( not mandatory )
[2227]  * direct > Ray direction vector override ( not mandatory )
[2228]  * normal > Normal vector of the refraction surface
[2229]  * target > Entity being the current beam target
[2230]  * trace  > Trace structure to temporary store the result
[2231] ]]
[2237] -- Refract the hell out of this requested beam with enity destination
[2241] -- Force start-refract
[2242] -- The beam did not traverse mediums
[2245] -- Get the trace ready to check the other side and register the location
[2246] -- The beam did not traverse mediums
[2248] -- Apply power ratio when requested
[2251] --[[
[2252]  * This does some logic on the start entity
[2253]  * Preforms some logick to calculate the filter
[2254]  * entity > Entity we intend the start the beam from
[2255] ]]
[2258] -- Populated customly depending on the API
[2259] -- Recursive
[2260] -- Reset entity hit report index
[2261] -- We need to reset the top index hit reports count
[2262] -- Make sure the initial laser source is skipped
[2267] -- Switch the filter according to the waepon the player is holding
[2272] --[[
[2273]  * Returns the beam current active source entity
[2274] ]]
[2279] --[[
[2280]  * Returns the beam current active length
[2281] ]]
[2286] --[[
[2287]  * Reads draw color from the beam object when needed
[2288] ]]
[2293] -- No forced colors are present use source
[2294] -- Return object
[2295] -- Numbers
[2298] --[[
[2299]  * Cashes the currently used beam color when needed
[2300] ]]
[2317] --[[
[2318]  * This does post-update fnd regiasters beam sources
[2319]  * Preforms some logick to calculate the filter
[2320]  * trace > Trace result after the last iteration
[2321] ]]
[2324] -- Calculates the range as beam distanc traveled
[2327] -- Update hit report of the source
[2329] -- Update the current beam source hit report
[2330] -- What we just hit
[2331] -- Register us to the target sources table
[2332] -- Recursive
[2333] -- Update reports
[2334] -- We need to apply the top index hit reports count
[2336] -- Register the beam initial entity to target sources
[2337] -- Register target in sources
[2338] -- Coding effective API
[2341] --[[
[2342]  * This traps the beam by following the trace
[2343]  * You can mark trace view points as visible
[2344]  * sours > Override for laser unit entity `self`
[2345]  * imatr > Reference to a beam materil object
[2346]  * color > Color structure reference for RGBA
[2347] ]]
[2351] -- Check node avalability
[2355] -- Update rendering boundaries
[2360] -- Extend render bounds with player hit position
[2363] -- Extend render bounds with the first node
[2366] -- Adjust the render bounds with world-space coordinates
[2367] -- World space is faster
[2368] -- Material must be cached and pdated with left click setup
[2372] -- Draw the beam sequentially being faster
[2376] -- Read origin
[2377] -- Start width
[2378] -- Make sure the coordinates are conveted to world ones
[2381] -- When we need to draw the beam with rendering library
[2382] -- Change color
[2385] -- Draw the actual beam texture
[2386] -- Adjust the render bounds with world-space coordinates
[2390] --[[
[2391]  * This is actually faster than stuffing all the beams
[2392]  * information for every laser in a dedicated table and
[2393]  * draw the table elements one by one at once.
[2394]  * sours > Entity keping the beam effects internals
[2395]  * trace > Trace result recieved from the beam
[2396]  * endrw > Draw enabled flag from beam sources
[2397] ]]
[2403] -- Drawing effects is enabled
[2406] -- Allocate effect class
[2415] -- Draw particle effects
[2436] --[[
[2437]  * Function handler for calculating SISO actor routines
[2438]  * These are specific handlers for specific classes
[2439]  * having single input beam and single output beam
[2440]  * trace > Reference to trace result structure
[2441]  * beam  > Reference to laser beam class
[2442] ]]
[2445] -- Assume that beam stops traversing
[2449] -- We need to go somewhere
[2451] -- Leave networking to CAP. Invalid target. Stop
[2453] -- Library effect flag
[2454] -- Enter effect
[2455] -- Exit effect
[2456] -- Stargate ( CAP ) requires little nudge in the origin vector
[2458] -- Otherwise the trace will get stick and will hit again
[2461] -- CAP networking is correct. Continue
[2464] -- Assume that beam stops traversing
[2468] -- No output ID chosen
[2469] -- Validate output entity
[2470] -- No output ID. Missing ent
[2471] -- Read current normal
[2472] -- When the model is flat
[2500] -- Output model is validated. Continue
[2503] -- Assume that beam stops traversing
[2505] -- No linked pair
[2506] -- Retrieve open pair
[2508] -- Assume that output portal will have the same surface offset
[2509] -- No linked pair
[2520] -- Output portal is validated. Continue
[2523] -- Assume that beam stops traversing
[2524] -- Retrieve class trace entity
[2528] -- Beam hits correct surface. Continue
[2530] -- May absorb
[2532] -- Makes beam pass the dimmer
[2533] -- We are not portal update position
[2534] -- We are not portal enable drawing
[2564] -- Output portal is validated. Continue
[2567] -- Assume that beam stops traversing
[2568] -- Retrieve class trace entity
[2584] -- Assume that beam stops traversing
[2589] -- Read current nore stack
[2590] -- Extract nodes stack size
[2596] -- Color tolerance
[2603] -- Block the given texture
[2611] -- Block similar beams
[2618] -- Makes beam pass the dimmer
[2619] -- We are not portal update position
[2620] -- We are not portal enable drawing
[2621] -- Beam hits correct surface. Continue
[2622] -- The beam did not fell victim to direct draw filtering
[2629] -- Color needs to be changed for the current node
[2656] -- Last beam color being used
[2657] -- Remove from the output beams with such color and material
[2658] -- Length not used in visuals
[2663] -- Makes beam pass the dimmer
[2664] -- We are not portal update position
[2665] -- We are not portal enable drawing
[2666] -- Beam hits correct surface. Continue
[2671] -- Assume that beam stops traversing
[2672] -- Retrieve class trace entity
[2676] -- Beam hits correct surface. Continue
[2678] -- May absorb
[2681] -- Makes beam pass the parallel
[2682] -- We are not portal update node
[2683] -- We are not portal enable drawing
[2693] --[[
[2694]  * Traces a laser beam from the entity provided
[2695]  * entity > Entity origin of the beam ( laser )
[2696]  * origin > Inititial ray world position vector
[2697]  * direct > Inititial ray world direction vector
[2698]  * length > Total beam length to be traced
[2699]  * width  > Beam starting width from the origin
[2700]  * damage > The amout of damage the beam does
[2701]  * force  > The amout of force the beam does
[2702]  * usrfle > Use surface material reflecting efficiency
[2703]  * usrfre > Use surface material refracting efficiency
[2704]  * noverm > Enable interactions with no material override
[2705] ]]
[2707] -- Parameter validation check. Allocate only when these conditions are present
[2708] -- Source entity must be valid
[2709] -- Create a laser beam object and validate the current ray spawn parameters
[2710] -- Create beam class
[2711] -- Beam parameters are mismatched and traverse is not run
[2712] -- Temporary values that are considered local and do not need to be accessed by hit reports
[2713] -- Stores whenever the trace is valid entity or not
[2714] -- This stores the current extracted material as string
[2715] -- This stores the calss of the current trace entity
[2716] -- Configure and target and shared trace reference
[2717] -- Reports dedicated values that are being used by other entities and processses
[2718] -- Beam reflection ratio flag. Reduce beam power when reflecting
[2719] -- Beam refraction ratio flag. Reduce beam power when refracting
[2720] -- Beam no override material flag. Try to extract original material
[2721] -- Beam recursion depth for units that use it
[2722] -- Beam hit report index. Use one if not provided
[2728] -- Run the trace using the defined conditianl parameters
[2731] -- Initial start so the beam separate from the laser
[2736] -- Beam starts inside map solid and source must be changed
[2746] -- Water to air specifics
[2747] -- Update the trace reference with the new beam
[2752] -- Check current target for being a valid specific actor
[2754] -- Actor flag and specific filter are now reset when present
[2755] -- Ignore registering zero length traces
[2756] -- Target is valis and it is a actor
[2759] -- The trace entity target is not special actor case
[2762] -- The trace has hit invalid entity or world
[2764] -- Use the feft-solid value
[2765] -- Calculate nudge origin
[2766] -- Register the node at the location the laser lefts the glass
[2771] -- Start in world entity
[2773] -- Trace distance lenght is zero so enable refraction
[2774] -- Do not alter the beam direction
[2775] -- Do not put a node when beam does not traverse
[2776] -- When we are still tracing and hit something that is not specific unit
[2778] -- Register a hit so reduce bounces count
[2781] -- Well the beam is still tracing
[2782] -- Produce next ray
[2783] -- Decide whenever to go out of the entity according to the hit location
[2786] -- Water general flag is present
[2789] -- Check if point is in or out of the water
[2791] -- Update the source accordingly
[2792] -- Nagate the normal so it must point inwards before refraction
[2794] -- Make sure to pick the correct refract exit medium for current node
[2796] -- Refract the hell out of this requested beam with enity destination
[2799] -- When the beam gets out of the medium
[2801] -- Check for zero when water only
[2803] -- Reset the normal. We are out of the water now
[2805] -- Get the trace ready to check the other side and register the location
[2807] -- Apply power ratio when requested
[2810] -- Put special cases here
[2814] -- Trigger for units without action cunction
[2815] -- When the entity is unit but does not have actor function
[2816] -- Otherwise bust continue medium change. Reduce loops when hit dedicted units
[2818] -- Still tracing the beam
[2820] -- Just call reflection and get done with it..
[2821] -- Call reflection method
[2824] -- Needs to be refracted
[2825] -- When we have refraction entry and are still tracing the beam
[2826] -- When refraction entry is available do the thing
[2827] -- Substact traced lenght from total length
[2829] -- Calculated refraction ray. Reflect when not possible
[2830] -- Refraction entity direction and reflection
[2831] -- Call refraction cases and prepare to trace-back
[2832] -- Bounces were decremented so move it up
[2834] -- Primary node starts inside solid
[2835] -- When two props are stuck save the middle boundary and traverse
[2836] -- When the traverse mediums is differerent and node is not inside a laser
[2840] -- Do not waste game ticks to refract the same refraction ratio
[2841] -- When there is no medium refractive index traverse change
[2842] -- Keep the last beam direction
[2843] -- Finish start-refraction for current iteration
[2844] -- Marking the fraction being zero and refracting from the last entity
[2845] -- Make sure to disable the flag agian
[2846] -- Otherwise do a normal water-entity-air refraction
[2850] -- We have to change mediums
[2852] -- Redirect the beam with the reflected ray
[2855] -- Apply power ratio when requested
[2857] -- We cannot be able to refract as the requested beam is missing
[2859] -- We are neither reflecting nor refracting and have hit a wall
[2860] -- All triggers are processed
[2863] -- Comes from air then hits and refracts in water or starts in water
[2867] -- Important thing is to consider what is the shape of the world entity
[2868] -- We can eather memorize the normal vector which will fail for different shapes
[2869] -- We can eather set the trace length insanely long will fail windows close to the gound
[2870] -- Another trace is made here to account for these probles above
[2871] -- Well the beam is still tracing
[2872] -- Produce next ray
[2873] -- Make sure that outer trace will always hit
[2876] -- Margin multiplier for trace back to find correct surface normal
[2877] -- This is the only way to get the proper surface normal vector
[2880] -- Store hit position and normal in beam temporary
[2882] -- Reverse direction of the normal to point inside transperent
[2884] -- Do the refraction according to medium boundary
[2888] -- When the beam gets out of the medium
[2891] -- Memorizing will help when beam traverses from world to no-collided entity
[2893] -- Get the trace ready to check the other side and register the location
[2897] -- The beam ends inside a solid transperent medium
[2901] -- Apply power ratio when requested
[2907] -- Trigger for units without action cunction
[2908] -- When the entity is unit but does not have actor function
[2909] -- Otherwise bust continue medium change. Reduce loops when hit dedicted units
[2911] -- Still tracing the beam
[2914] -- Call reflection method
[2917] -- Needs to be refracted
[2918] -- When we have refraction entry and are still tracing the beam
[2919] -- When refraction entry is available do the thing
[2920] -- Calculated refraction ray. Reflect when not possible
[2921] -- Laser is within the map water submerged
[2923] -- Keep the same direction and initial origin
[2924] -- Lower the flag so no preformance hit is present
[2925] -- Beam comes from the air and hits the water. Store water plane and refract
[2926] -- Get the trace tready to check the other side and point and register the location
[2931] -- Need to make the traversed destination the new source
[2933] -- Apply power ratio when requested
[2935] -- We cannot be able to refract as the requested entry is missing
[2937] -- All triggers when reflecting and refracting are processed
[2938] -- Not traversing and have hit a wall
[2940] -- We are neither hit a valid entity nor a map water
[2942] -- Refresh medium pass trough information
[2943] -- Trace did not hit anything to be bounced off from
[2945] -- Clear the water trigger refraction flag
[2947] -- The beam ends inside transperent entity
[2949] -- Update the sources and trigger the hit reports
[2951] -- Return what did the beam hit and stuff
[2982] -- https://github.com/Facepunch/garrysmod/tree/master/garrysmod/resource/localization/en
[3049] -- Portal
[3063] -- Portal 2
[3069] -- HL2
[3086] -- DoD
[3090] -- HL2 EP2
[3094] -- Counter-Strike Source
[3098] -- Left 4 Dead
[3103] -- Team Fortress 2
[3107] -- Make these model available only if the player has Wire
[3116] -- Automatic model array population. Add models in the list above
[3135] -- http://www.famfamfam.com/lab/icons/silk/preview.php
