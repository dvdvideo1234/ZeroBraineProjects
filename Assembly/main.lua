require("ZeroBraineProjects/dvdlualib/asmlib")

function traceback ()
  local level = 1
  while true do
    local info = debug.getinfo(level, "Sl")
    if not info then break end
    if info.what == "C" then   -- is a C function?
      print(level, "C function")
    else   -- a Lua function
      print(string.format("[%s]:%d",
                          info.short_src, info.currentline))
    end
    level = level + 1
  end
end


local stringLen             = string and string.len
local stringSub             = string and string.sub
local stringFind            = string and string.find
local stringGsub            = string and string.gsub
local stringUpper           = string and string.upper
local stringLower           = string and string.lower
local stringFormat          = string and string.format

function addEstim(fFunction, sName)
  return {Function = fFunction, Name = sName, Times = {}, Rolled = {}}
end

function testPerformance(stCard,stEstim,sFile)
  if(sFile) then
    local F = io.open(sFile,"a+")
    if(F) then
      io.output(F)
    end
  end
  local Test = 1
  while(stCard[Test]) do -- All tests
    local tstVal = stCard[Test]
    local fooVal = tstVal[1]
    local fooRes = tstVal[2]
    local tstNam = tstVal[3] or ""
    local tstEst = #stEstim
    io.write("\nTesting case: <"..tostring(tstVal[3])..">")
    io.write("\n   Inp: <"..tostring(tstVal[1])..">")
    io.write("\n   Out: <"..tostring(tstVal[2])..">")
    local Itr = 1 -- Current iteration
    for Itr = 1, stCard.Settings.Count, 1 do -- Repeat each test
      for Est = 1, tstEst  do -- For all functions
        if(not stEstim[Est].Times[tstNam]) then
          stEstim[Est].Times[tstNam] = 0
        end
        if(not stEstim[Est].Rolled[tstNam]) then
          stEstim[Est].Rolled[tstNam] = {}
          stEstim[Est].Rolled[tstNam]["PASS"] = 0
          stEstim[Est].Rolled[tstNam]["FAIL"] = 0
        end
        local Roll = stEstim[Est].Rolled[tstNam]
        local Time, Rez = os.clock()
        for Ind = 1, stCard.Settings.Cycles do -- N Cycles
          Rez = stEstim[Est].Function(fooVal)
          if(Rez == fooRes) then
            Roll["PASS"] = Roll["PASS"] + 1
          else
            Roll["FAIL"] = Roll["FAIL"] + 1
          end
        end
        stEstim[Est].Times[tstNam]  = stEstim[Est].Times[tstNam] + (os.clock() - Time)
      end
    end

    local Min = stEstim[1].Times[tstNam]
    for Est = 1, tstEst do  -- For all functions
      if(stEstim[Est].Times[tstNam] <= Min) then
        Min = stEstim[Est].Times[tstNam]
      end
    end

    for Est = 1, tstEst do  -- For all functions
      local All = (stCard.Settings.Count * stCard.Settings.Cycles)
      local Pas = ((100 *  stEstim[Est].Rolled[tstNam]["PASS"]) / All)
      local Fal = ((100 *  stEstim[Est].Rolled[tstNam]["FAIL"]) / All)
      -- print(Test,Est,stEstim[Est].Rolled[tstNam]["PASS"],All)
      local Tim = stEstim[Est].Times[tstNam]
      local Tip =  (Min ~= 0) and (100 * (Tim / Min)) or 0
      local Nam = "Passed ["..stEstim[Est].Name.."]: "
      local Dat = string.format("%3.3f -> %3.3f (%5.3f)",Pas,Tip,Tim)
      io.write("\n"..Nam..Dat)
    end

    io.write("\n")

    Test = Test + 1
  end
  if(F) then
    F:close()
  end
end


asmlib.SetOpVar("DIRPATH_BAS","E:/Documents/Lua-Projs/Lua/Projects/")
asmlib.SetOpVar("DIRPATH_DSV","TempTest/")


asmlib.SetIndexes("V",1,2,3)
asmlib.SetIndexes("A",1,2,3)
asmlib.SetIndexes("S",4,5,6,7)

asmlib.InitAssembly("track")
asmlib.SetOpVar("MODE_DATABASE","LUA")

asmlib.CreateTable("PIECES",{
  Index = {{1},{4},{1,4}},
  [1] = {"MODEL" , "TEXT"   , "LOW", "QMK"},
  [2] = {"TYPE"  , "TEXT"   ,  nil , "QMK"},
  [3] = {"NAME"  , "TEXT"   ,  nil , "QMK"},
  [4] = {"LINEID", "INTEGER", "FLR",  nil },
  [5] = {"POINT" , "TEXT"   ,  nil ,  nil },
  [6] = {"ORIGIN", "TEXT"   ,  nil ,  nil },
  [7] = {"ANGLE" , "TEXT"   ,  nil ,  nil }
},true,true)

asmlib.DefaultTable("PIECES")
asmlib.DefaultType("StephenTechno's Buildings Cross")
asmlib.SettingsModelToName("SET",{1,3},{"sdwhwy_","_"})
asmlib.InsertRecord({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 1, "", "0, 0, 2.499", ""})
asmlib.InsertRecord({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 2, "", "-1632, 1152, 2.506", "0,90,0"})
asmlib.InsertRecord({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 3, "", "-2304, 1152, 314.494", "0,90,0"})
asmlib.InsertRecord({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 4, "#", "-2976, 1152, 2.507", "0,90,0"})
asmlib.InsertRecord({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 5, "", "-2976.007,-1151.975,2.506", "0,-90,0"})
asmlib.InsertRecord({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 6, "", "-2304,-1152,314.498", "0,-90,0"})
asmlib.InsertRecord({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 7, "", "-1632,-1152,2.499", "0,-90,0"})
asmlib.InsertRecord({"models/buildingspack/roadsdwhighway/1_0roadsdwhwy_ramp_1.mdl", "#", "#", 8, "#", "-4608,0,2.5", "0,180,0"})
-- For crash test
asmlib.InsertRecord({"models/props_kite/metro_station.mdl","#","#",1,"#",123,nil})
print(traceback())
-- End crash test
asmlib.SettingsModelToName("CLR")


CLIENT = false
SERVER = false

sInst = ((SERVER and "SERVER" or nil) or (CLIENT and "CLIENT" or nil) or "NOINST")

print(sInst)










