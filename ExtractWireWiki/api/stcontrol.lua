local fImg = "https://raw.githubusercontent.com/dvdvideo1234/ControlSystemsE2/master/data/pictures/%s.png"

local API = {
  NAME = "StControl",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols links []
    qref = true,  -- (TRUE) Quote the string in the link reference
    wdsc = false,  -- (TRUE) Outputs the direct wire-based description in the markdown overhead
    mosp = true   -- (TRUE) Enables monospace font for the function names
  },
  POOL = {
    {name="MAKE",cols={"Instance creator", "Out", "Description"},size={20,5,13},algn={"<","|","<"}},
    {name="APPLY",cols={"Class methods", "Out", "Description"},size={35,5,13},algn={"<","|","<"}},
    {name="SETUP",cols={"General functions", "Out", "Description"},size={20,5,13},algn={"<","|","<"}}
  },
  FILE = {
    exts = "stcontrol",
    base = "E:/Documents/Lua-Projs/SVN/ControlSystemsE2",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
    cvar = "wire_expression2_stcontrol",
    repo = "github.com/dvdvideo1234/ControlSystemsE2",
    blob = "blob/master",
  },
  TYPE = {
    OBJ = "xsc",
    FRM = "type-%s.png",
    LNK = "https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/%s"
  },
  REPLACE = {
    ["MASK"] = "https://wiki.garrysmod.com/page/Enums/MASK",
    ["COLLISION_GROUP"] = "https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP",
    ["Material_surface_properties"] = "https://developer.valvesoftware.com/wiki/Material_surface_properties",
    ["Choen-Coon"] = fImg:format("CC_tuning"),
    ["%s+%(`*ZN`*%)%s+"] = {
      ["Ziegler-Nichols"] = fImg:format("ZN_tunning"),
      ["auto oscillation"] = fImg:format("auto_Tu")
    },
    ["%s+%(`*IAE`*%)%s+"]  = {["Integral absolute error"] = fImg:format("IAE_tuning")},
    ["%s+%(`*ISE`*%)%s+"]  = {["Integral square error"] = fImg:format("IAE_tuning")},
    ["%s+%(`*ITAE`*%)%s+"] = {["Integral of time-weighted absolute error"] = fImg:format("IAE_tuning")},
    ["%(`*CHR`*%).+set%s+point%s+track"] = {["Chien-Hrones-Reswick"] = fImg:format("CHR_tunning_sp")},
    ["%(`*CHR`*%).+load%s+rejection"]    = {["Chien-Hrones-Reswick"] = fImg:format("CHR_tunning_dr")},
    ["%s+%(`*TL`*%)%s+"] = {
      ["Tyreus-Luyben"] = fImg:format("TL_tunning"),
      ["auto oscillation"] = fImg:format("auto_Tu")
    },
    ["%s+%(`*ZNM`*%)%s+"] = {
      ["plant process"] = fImg:format("proc_curve"),
      ["Ziegler-Nichols"] = fImg:format("ZN_proc_tunning")
    }
  },
  HDESC = {
    bot = "return E2Helper.Descriptions",
    dsc = "E2Helper.Descriptions"
  },
  REFLN = {
    {"ref_example", "https://github.com/dvdvideo1234/ControlSystemsE2/blob/master/data/Expression2/e2_code_test_stcontrol.txt"},
    {"ref_tusofia", "https://tu-sofia.bg/"},
    {"ref_exponent", "https://en.wikipedia.org/wiki/Exponentiation"},
    {"ref_relay", "https://en.wikipedia.org/wiki/Relay"},
    {"ref_realnum", "https://en.wikipedia.org/wiki/Real_number"},
    {"ref_pid", "https://en.wikipedia.org/wiki/PID_controller"},
    {"ref_aero_sys", "https://en.wikipedia.org/wiki/Propeller_(aeronautics)"},
    {"ref_quad_eq", "https://en.wikipedia.org/wiki/Quadratic_equation"},
    {"ref_class_oop","https://en.wikipedia.org/wiki/Class_(computer_programming)"},
    {"ref_fa_tu"  , "https://tu-sofia.bg/department/preview/13?dep_id=4"},
    {"ref_samp_time", "https://en.wikipedia.org/wiki/Sampling_(signal_processing)"},
    {"ref_auto_con", "https://en.wikipedia.org/wiki/Automation"},
    {"ref_contr_tune","https://en.wikipedia.org/wiki/PID_controller#Loop_tuning"},
    {"ref_cubic_eq", "https://en.wikipedia.org/wiki/Cubic_equation"},
    {"ref_root", "https://en.wikipedia.org/wiki/Square_root"}
  }
}

local tConvar = {
  {"enst", "Contains flag that enables status output messages"},
  {"dprn", "Stores the default status output messages streaming destination"}
}

local function getConvar()
  local sC, iC = "", 1
  while(tConvar[iC]) do
    local tC = tConvar[iC]
    sC = sC..API.FILE.cvar.."_"
           ..("%-4s"):format(tostring(tC[1] or "x"))
           .." > "..tostring(tC[2] or "").."\n"
    iC = iC + 1
  end; return sC
end

API.HDESC.top = [===[
local E2Helper = {Descriptions = {}}
local language = {}
function language.Add() return nil end
]===]

API.DSCHUNK = [===[

local DSC = E2Helper.Descriptions

local sObjNm = "state controller"

local tActon = {"Creates", "Dumps", "Returns", "Checks", "Removes", "Resets", Processes, "Updates", "Tunes"}
local fGnRet = "%s "..sObjNm.." %s"
local fRtMak = "%s "..sObjNm.." object with %s sampling time"
local fDump1 = "%s "..sObjNm.." to the chat area by %s identifier"
local fDump2 = "%s "..sObjNm.." by %s identifier in the specified area by first argument"
local fCTerm = "%s "..sObjNm.." %s automated control term signal"
local fError = "%s "..sObjNm.." process %s %s"
local fRtAll = "%s "..sObjNm.." proportional, integral and derivative term %s"
local fRtCpy = "%s "..sObjNm.." object copy %s"
local fRtTrm = "%s "..sObjNm.." automated control term %s"
local fRtEl1 = "%s "..sObjNm.." %s term %s"
local fRtEl2 = "%s "..sObjNm.." %s and %s term %s"
local fRtPDy = "%s "..sObjNm.." dynamic process %s"
local fRtPSt = "%s "..sObjNm.." static process %s"
local fInPar = "%s "..sObjNm.." automated internal parameters"
local fTuneM = "%s "..sObjNm.." using the method %s"

DSC["dumpItem(xsc:n)"]        = fDump1:format(tActon[2], "number")
DSC["dumpItem(xsc:s)"]        = fDump1:format(tActon[2], "string")
DSC["dumpItem(xsc:sn)"]       = fDump2:format(tActon[2], "number")
DSC["dumpItem(xsc:ss)"]       = fDump2:format(tActon[2], "string")
DSC["getBias(xsc:)"]          = fGnRet:format(tActon[3], "output signal bias")
DSC["getControl(xsc:)"]       = fGnRet:format(tActon[3], "automated control output signal value")
DSC["getControlTerm(xsc:)"]   = fRtTrm:format(tActon[3], "signals as vector or array")
DSC["getControlTermD(xsc:)"]  = fCTerm:format(tActon[3], "derivative")
DSC["getControlTermI(xsc:)"]  = fCTerm:format(tActon[3], "integral")
DSC["getControlTermP(xsc:)"]  = fCTerm:format(tActon[3], "proportional")
DSC["getCopy(xsc:)"]          = fRtCpy:format(tActon[3], "instance")
DSC["getCopy(xsc:n)"]         = fRtCpy:format(tActon[3], "instance with static sampling time")
DSC["getErrorDelta(xsc:)"]    = fError:format(tActon[3], "error", "delta")
DSC["getErrorNow(xsc:)"]      = fError:format(tActon[3], "current", "error")
DSC["getErrorPast(xsc:)"]     = fError:format(tActon[3], "passed", "error")
DSC["getGain(xsc:)"]          = fRtAll:format(tActon[3], "gains")
DSC["getGainD(xsc:)"]         = fRtEl1:format(tActon[3], "derivative", "gain")
DSC["getGainI(xsc:)"]         = fRtEl1:format(tActon[3], "integral", "gain")
DSC["getGainID(xsc:)"]        = fRtEl2:format(tActon[3], "integral", "derivative", "gain")
DSC["getGainP(xsc:)"]         = fRtEl1:format(tActon[3], "proportional", "gain")
DSC["getGainPD(xsc:)"]        = fRtEl2:format(tActon[3], "proportional", "derivative", "gain")
DSC["getGainPI(xsc:)"]        = fRtEl2:format(tActon[3], "proportional", "integral", "gain")
DSC["getManual(xsc:)"]        = fGnRet:format(tActon[3], "manual control signal value")
DSC["getPower(xsc:)"]         = fRtAll:format(tActon[3], "power")
DSC["getPowerD(xsc:)"]        = fRtEl1:format(tActon[3], "derivative", "power")
DSC["getPowerI(xsc:)"]        = fRtEl1:format(tActon[3], "integral", "power")
DSC["getPowerID(xsc:)"]       = fRtEl2:format(tActon[3], "integral", "derivative", "power")
DSC["getPowerP(xsc:)"]        = fRtEl1:format(tActon[3], "proportional", "power")
DSC["getPowerPD(xsc:)"]       = fRtEl2:format(tActon[3], "proportional", "derivative", "power")
DSC["getPowerPI(xsc:)"]       = fRtEl2:format(tActon[3], "proportional", "integral", "power")
DSC["getTimeBench(xsc:)"]     = fRtPDy:format(tActon[3], "benchmark time")
DSC["getTimeDelta(xsc:)"]     = fRtPDy:format(tActon[3], "time delta")
DSC["getTimeNow(xsc:)"]       = fRtPDy:format(tActon[3], "current time")
DSC["getTimePast(xsc:)"]      = fRtPDy:format(tActon[3], "passed time")
DSC["getTimeRatio(xsc:)"]     = fRtPDy:format(tActon[3], "time ratio") 
DSC["getTimeSample(xsc:)"]    = fRtPSt:format(tActon[3], "time delta")
DSC["getType(xsc:)"]          = fGnRet:format(tActon[3], "control type")
DSC["getWindup(xsc:)"]        = fGnRet:format(tActon[3], "windup lower and upper bound")
DSC["getWindupMax(xsc:)"]     = fGnRet:format(tActon[3], "windup upper bound")
DSC["getWindupMin(xsc:)"]     = fGnRet:format(tActon[3], "windup lower bound")
DSC["isActive(xsc:)"]         = fGnRet:format(tActon[4], "activated working flag")
DSC["isCombined(xsc:)"]       = fGnRet:format(tActon[4], "combined flag spreading proportional term gain across others")
DSC["isDerivative(xsc:)"]     = fGnRet:format(tActon[4], "derivative enabled flag")
DSC["isIntegral(xsc:)"]       = fGnRet:format(tActon[4], "integral enabled flag")
DSC["isInverted(xsc:)"]       = fGnRet:format(tActon[4], "inverted feedback flag of the reference and set-point")
DSC["isManual(xsc:)"]         = fGnRet:format(tActon[4], "manual control signal flag")
DSC["isZeroCross(xsc:)"]      = fGnRet:format(tActon[4], "integral zero crossing flag")
DSC["newStControl()"]         = fRtMak:format(tActon[1], "dynamic")
DSC["newStControl(n)"]        = fRtMak:format(tActon[1], "static")
DSC["noStControl()"]          = fGnRet:format(tActon[3], "invalid object")
DSC["remGain(xsc:)"]          = fRtAll:format(tActon[5], "gains")
DSC["remGainD(xsc:)"]         = fRtEl1:format(tActon[5], "derivative", "gain")
DSC["remGainI(xsc:)"]         = fRtEl1:format(tActon[5], "integral", "gain")
DSC["remGainID(xsc:)"]        = fRtEl2:format(tActon[5], "integral", "derivative", "gains")
DSC["remGainP(xsc:)"]         = fRtEl1:format(tActon[5], "proportional", "gain")
DSC["remGainPD(xsc:)"]        = fRtEl2:format(tActon[5], "proportional", "derivative", "gains")
DSC["remGainPI(xsc:)"]        = fRtEl2:format(tActon[5], "proportional", "integral", "gains")
DSC["remTimeSample(xsc:)"]    = fRtPSt:format(tActon[5], "time delta")
DSC["remWindup(xsc:)"]        = fGnRet:format(tActon[5], "windup lower and upper bound")
DSC["remWindupMax(xsc:)"]     = fGnRet:format(tActon[5], "windup upper bound")
DSC["remWindupMin(xsc:)"]     = fGnRet:format(tActon[5], "windup lower bound")
DSC["resState(xsc:)"]         = fInPar:format(tActon[6])
DSC["setBias(xsc:n)"]         = fGnRet:format(tActon[8], "output signal bias")
DSC["setGain(xsc:nnn)"]       = fRtAll:format(tActon[8], "gains")
DSC["setGain(xsc:r)"]         = DSC["setGain(xsc:nnn)"]
DSC["setGain(xsc:v)"]         = DSC["setGain(xsc:nnn)"]
DSC["setGainD(xsc:n)"]        = fRtEl1:format(tActon[8], "derivative", "gain")
DSC["setGainI(xsc:n)"]        = fRtEl1:format(tActon[8], "integral", "gain")
DSC["setGainID(xsc:nn)"]      = fRtEl2:format(tActon[8], "integral", "derivative", "gains")
DSC["setGainID(xsc:r)"]       = DSC["setGainID(xsc:nn)"]
DSC["setGainID(xsc:xv2)"]     = DSC["setGainID(xsc:nn)"]
DSC["setGainP(xsc:n)"]        = fRtEl1:format(tActon[8], "proportional", "gain")
DSC["setGainPD(xsc:nn)"]      = fRtEl2:format(tActon[8], "proportional", "derivative", "gains")
DSC["setGainPD(xsc:r)"]       = DSC["setGainPD(xsc:nn)"]
DSC["setGainPD(xsc:xv2)"]     = DSC["setGainPD(xsc:nn)"]
DSC["setGainPI(xsc:nn)"]      = fRtEl2:format(tActon[8], "proportional", "integral", "gains")
DSC["setGainPI(xsc:r)"]       = DSC["setGainPI(xsc:nn)"]
DSC["setGainPI(xsc:xv2)"]     = DSC["setGainPI(xsc:nn)"]
DSC["setIsActive(xsc:n)"]     = fGnRet:format(tActon[8], "activated working flag")
DSC["setIsCombined(xsc:n)"]   = fGnRet:format(tActon[8], "combined flag spreading proportional term gain across others")
DSC["setIsDerivative(xsc:n)"] = fGnRet:format(tActon[8], "derivative enabled flag")
DSC["setIsIntegral(xsc:n)"]   = fGnRet:format(tActon[8], "integral enabled flag")
DSC["setIsInverted(xsc:n)"]   = fGnRet:format(tActon[8], "inverted feedback flag of the reference and set-point")
DSC["setIsManual(xsc:n)"]     = fGnRet:format(tActon[8], "manual control signal flag")
DSC["setIsZeroCross(xsc:n)"]  = fGnRet:format(tActon[8], "integral zero crossing flag")
DSC["setManual(xsc:n)"]       = fGnRet:format(tActon[8], "manual control signal value")
DSC["setPower(xsc:nnn)"]      = fRtAll:format(tActon[8], "powers")
DSC["setPower(xsc:r)"]        = DSC["setPower(xsc:nnn)"]
DSC["setPower(xsc:v)"]        = DSC["setPower(xsc:nnn)"]
DSC["setPowerD(xsc:n)"]       = fRtEl1:format(tActon[8], "derivative", "power")
DSC["setPowerI(xsc:n)"]       = fRtEl1:format(tActon[8], "integral", "power")
DSC["setPowerID(xsc:nn)"]     = fRtEl2:format(tActon[8], "integral", "derivative", "powers")
DSC["setPowerID(xsc:r)"]      = DSC["setPowerID(xsc:nn)"]
DSC["setPowerID(xsc:xv2)"]    = DSC["setPowerID(xsc:nn)"]
DSC["setPowerP(xsc:n)"]       = fRtEl1:format(tActon[8], "proportional", "power")
DSC["setPowerPD(xsc:nn)"]     = fRtEl2:format(tActon[8], "proportional", "derivative", "powers")
DSC["setPowerPD(xsc:r)"]      = DSC["setPowerPD(xsc:nn)"]
DSC["setPowerPD(xsc:xv2)"]    = DSC["setPowerPD(xsc:nn)"]
DSC["setPowerPI(xsc:nn)"]     = fRtEl2:format(tActon[8], "proportional", "integral", "powers")
DSC["setPowerPI(xsc:r)"]      = DSC["setPowerPI(xsc:nn)"]
DSC["setPowerPI(xsc:xv2)"]    = DSC["setPowerPI(xsc:nn)"]
DSC["setState(xsc:nn)"]       = fInPar:format(tActon[8])
DSC["setTimeSample(xsc:n)"]   = fRtPSt:format(tActon[8], "time delta")
DSC["setWindup(xsc:nn)"]      = fGnRet:format(tActon[8], "windup lower and upper bound")
DSC["setWindup(xsc:r)"]       = DSC["setWindup(xsc:nn)"]
DSC["setWindup(xsc:xv2)"]     = DSC["setWindup(xsc:nn)"]
DSC["setWindupMax(xsc:n)"]    = fGnRet:format(tActon[8], "windup upper bound")
DSC["setWindupMin(xsc:n)"]    = fGnRet:format(tActon[8], "windup lower bound")
DSC["tuneProcAH(xsc:nnn)"]    = fTuneM:format(tActon[9], "(AH) Astrom-Hagglund")
DSC["tuneAutoZN(xsc:nn)"]     = fTuneM:format(tActon[9], "(ZN) Ziegler-Nichols auto oscillation")
DSC["tuneAutoZN(xsc:nns)"]    = fTuneM:format(tActon[9], "(ZN) Ziegler-Nichols auto oscillation extended by type: `classic`, `pessen`, `sovers`, `novers`")
DSC["tuneIAE(xsc:nnn)"]       = fTuneM:format(tActon[9], "(IAE) Integral absolute error")
DSC["tuneISE(xsc:nnn)"]       = fTuneM:format(tActon[9], "(ISE) Integral square error")
DSC["tuneITAE(xsc:nnn)"]      = fTuneM:format(tActon[9], "(ITAE) Integral of time-weighted absolute error")
DSC["tuneOverCHRLR(xsc:nnn)"] = fTuneM:format(tActon[9], "(CHR) Chien-Hrones-Reswick load rejection 20% overshot")
DSC["tuneOverCHRSP(xsc:nnn)"] = fTuneM:format(tActon[9], "(CHR) Chien-Hrones-Reswick set point track 20% overshot")
DSC["tuneProcCC(xsc:nnn)"]    = fTuneM:format(tActon[9], "(CC) Choen-Coon")
DSC["tuneProcCHRLR(xsc:nnn)"] = fTuneM:format(tActon[9], "(CHR) Chien-Hrones-Reswick load rejection")
DSC["tuneProcCHRSP(xsc:nnn)"] = fTuneM:format(tActon[9], "(CHR) Chien-Hrones-Reswick set point track")
DSC["tuneProcZN(xsc:nnnn)"]   = fTuneM:format(tActon[9], "(ZNM) Ziegler-Nichols plant process")
DSC["tuneAutoTL(xsc:nn)"]     = fTuneM:format(tActon[9], "(TL) Tyreus-Luyben auto oscillation")

]===]

API.TEXT = function() return([===[
### What does this extension include?
State controller [OOP class][ref_class_oop] that creates LQ-PID controllers with static or
dynamic [sampling time][ref_samp_time]. They are used generally for every kind of
[automatic control][ref_auto_con] that is needed in Wiremod. Supports a bunch of general
[tuning methods][ref_contr_tune], I studied at [the university][ref_tusofia] and can be
initialized as a [relay][ref_relay], linear or power controller. The error `E` with power
`P` can be [any real number][ref_realnum]. When zero, the output is calculated as [relay][ref_relay],
when equal to `1`, we have the [classic PID controller][ref_pid] when the power
is `2` the error has [quadratic relation][ref_quad_eq] `E^2`, `3`, for [cubic][ref_cubic_eq] `E^3`
and so on needed for [aero-propeller][ref_aero_sys] systems. Negative powers will be treated as error
[square root][ref_root] `E^(-2) = 1/E^2`. The user can apply even fractional powers `P` on each term.
The [fractional powers][ref_exponent] can be treated as the numerator is taken as the power and the
denominator as a root. However, there is no difference in which operation will be applied first
as you have `E^(2/5) = sqr5(E^2) = sqr5(E)^2`. It has a lot of possibilities. The only limits is your imagination.

### What is this thing designed for?
The `%s` class consists of fast performing controller object-oriented
instance that is designed to be `@persist`and initialized in expression
`first() || dupefinished()`. That way you create the controller instance once
and you can use it as many times as you need, without creating a new one.

### What console variables can be used to setup it
```
]===]..getConvar()..[===[
```

### How to create an instance then?
You can create a controller object by calling one of the dedicated creators `new%s` below 
either with an argument of sampling time to make the sampling time static or without
a parameter to make it take the value dynamically as some other thing may slow down the E2.
Then you must activate the instance `setIsActive(1)` to enable it to calculate the control signal,
apply the current state values `setState` and retrieve the control signal afterwards by calling
`getControl(...)`.

### Do you have an example by any chance?
The internal type of the class is `%s` and internal expression type `%s`, so to create 
an instance you can take a [look at the example][ref_example].

### Can you show me the methods of the class?
The description of the API is provided in the table below.
]===]):format(API.NAME,API.NAME,API.TYPE.OBJ,API.FILE.exts)
end

return API
