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
The `StControl` class consists of fast performing controller object-oriented
instance that is designed to be `@persist`and initialized in expression
`first() || dupefinished()`. That way you create the controller instance once
and you can use it as many times as you need, without creating a new one.

### What console variables can be used to setup it
```
wire_expression2_stcontrol_enst > Contains flag that enables status output messages
wire_expression2_stcontrol_dprn > Stores the default status output messages streaming destination
```

### How to create an instance then?
You can create a controller object by calling one of the dedicated creators `newStControl` below 
either with an argument of sampling time to make the sampling time static or without
a parameter to make it take the value dynamically as some other thing may slow down the E2.
Then you must activate the instance `setIsActive(1)` to enable it to calculate the control signal,
apply the current state values `setState` and retrieve the control signal afterwards by calling
`getControl(...)`.

### Do you have an example by any chance?
The internal type of the class is `xsc` and internal expression type `stcontrol`, so to create 
an instance you can take a [look at the example][ref_example].

### Can you show me the methods of the class?
The description of the API is provided in the table below.

|  Instance creator  | Out | Description |
|:-------------------|:---:|:------------|
|`newStControl`(![image][ref-xxx])|![image][ref-xsc]|Creates state controller object with dynamic sampling time|
|`newStControl`(![image][ref-n])|![image][ref-xsc]|Creates state controller object with static sampling time|
|`noStControl`(![image][ref-xxx])|![image][ref-xsc]|Returns state controller invalid object|

|           Class methods           | Out | Description |
|:----------------------------------|:---:|:------------|
|![image][ref-xsc]:`dumpItem`(![image][ref-n])|![image][ref-xsc]|Dumps state controller to the chat area by number identifier|
|![image][ref-xsc]:`dumpItem`(![image][ref-s])|![image][ref-xsc]|Dumps state controller to the chat area by string identifier|
|![image][ref-xsc]:`dumpItem`(![image][ref-s],![image][ref-n])|![image][ref-xsc]|Dumps state controller by number identifier in the specified area by first argument|
|![image][ref-xsc]:`dumpItem`(![image][ref-s],![image][ref-s])|![image][ref-xsc]|Dumps state controller by string identifier in the specified area by first argument|
|![image][ref-xsc]:`getBias`(![image][ref-xxx])|![image][ref-n]|Returns state controller output signal bias|
|![image][ref-xsc]:`getControl`(![image][ref-xxx])|![image][ref-n]|Returns state controller automated control output signal value|
|![image][ref-xsc]:`getControlTerm`(![image][ref-xxx])|![image][ref-r]|Returns state controller automated control term signals as vector or array|
|![image][ref-xsc]:`getControlTerm`(![image][ref-xxx])|![image][ref-v]|Returns state controller automated control term signals as vector or array|
|![image][ref-xsc]:`getControlTermD`(![image][ref-xxx])|![image][ref-n]|Returns state controller derivative automated control term signal|
|![image][ref-xsc]:`getControlTermI`(![image][ref-xxx])|![image][ref-n]|Returns state controller integral automated control term signal|
|![image][ref-xsc]:`getControlTermP`(![image][ref-xxx])|![image][ref-n]|Returns state controller proportional automated control term signal|
|![image][ref-xsc]:`getCopy`(![image][ref-xxx])|![image][ref-xsc]|Returns state controller object copy instance|
|![image][ref-xsc]:`getCopy`(![image][ref-n])|![image][ref-xsc]|Returns state controller object copy instance with static sampling time|
|![image][ref-xsc]:`getErrorDelta`(![image][ref-xxx])|![image][ref-n]|Returns state controller process error delta|
|![image][ref-xsc]:`getErrorNow`(![image][ref-xxx])|![image][ref-n]|Returns state controller process current error|
|![image][ref-xsc]:`getErrorPast`(![image][ref-xxx])|![image][ref-n]|Returns state controller process passed error|
|![image][ref-xsc]:`getGain`(![image][ref-xxx])|![image][ref-r]|Returns state controller proportional, integral and derivative term gains|
|![image][ref-xsc]:`getGain`(![image][ref-xxx])|![image][ref-v]|Returns state controller proportional, integral and derivative term gains|
|![image][ref-xsc]:`getGainD`(![image][ref-xxx])|![image][ref-n]|Returns state controller derivative term gain|
|![image][ref-xsc]:`getGainI`(![image][ref-xxx])|![image][ref-n]|Returns state controller integral term gain|
|![image][ref-xsc]:`getGainID`(![image][ref-xxx])|![image][ref-r]|Returns state controller integral and derivative term gain|
|![image][ref-xsc]:`getGainID`(![image][ref-xxx])|![image][ref-xv2]|Returns state controller integral and derivative term gain|
|![image][ref-xsc]:`getGainP`(![image][ref-xxx])|![image][ref-n]|Returns state controller proportional term gain|
|![image][ref-xsc]:`getGainPD`(![image][ref-xxx])|![image][ref-r]|Returns state controller proportional and derivative term gain|
|![image][ref-xsc]:`getGainPD`(![image][ref-xxx])|![image][ref-xv2]|Returns state controller proportional and derivative term gain|
|![image][ref-xsc]:`getGainPI`(![image][ref-xxx])|![image][ref-r]|Returns state controller proportional and integral term gain|
|![image][ref-xsc]:`getGainPI`(![image][ref-xxx])|![image][ref-xv2]|Returns state controller proportional and integral term gain|
|![image][ref-xsc]:`getManual`(![image][ref-xxx])|![image][ref-n]|Returns state controller manual control signal value|
|![image][ref-xsc]:`getPower`(![image][ref-xxx])|![image][ref-r]|Returns state controller proportional, integral and derivative term power|
|![image][ref-xsc]:`getPower`(![image][ref-xxx])|![image][ref-v]|Returns state controller proportional, integral and derivative term power|
|![image][ref-xsc]:`getPowerD`(![image][ref-xxx])|![image][ref-n]|Returns state controller derivative term power|
|![image][ref-xsc]:`getPowerI`(![image][ref-xxx])|![image][ref-n]|Returns state controller integral term power|
|![image][ref-xsc]:`getPowerID`(![image][ref-xxx])|![image][ref-r]|Returns state controller integral and derivative term power|
|![image][ref-xsc]:`getPowerID`(![image][ref-xxx])|![image][ref-xv2]|Returns state controller integral and derivative term power|
|![image][ref-xsc]:`getPowerP`(![image][ref-xxx])|![image][ref-n]|Returns state controller proportional term power|
|![image][ref-xsc]:`getPowerPD`(![image][ref-xxx])|![image][ref-r]|Returns state controller proportional and derivative term power|
|![image][ref-xsc]:`getPowerPD`(![image][ref-xxx])|![image][ref-xv2]|Returns state controller proportional and derivative term power|
|![image][ref-xsc]:`getPowerPI`(![image][ref-xxx])|![image][ref-r]|Returns state controller proportional and integral term power|
|![image][ref-xsc]:`getPowerPI`(![image][ref-xxx])|![image][ref-xv2]|Returns state controller proportional and integral term power|
|![image][ref-xsc]:`getTimeBench`(![image][ref-xxx])|![image][ref-n]|Returns state controller dynamic process benchmark time|
|![image][ref-xsc]:`getTimeDelta`(![image][ref-xxx])|![image][ref-n]|Returns state controller dynamic process time delta|
|![image][ref-xsc]:`getTimeNow`(![image][ref-xxx])|![image][ref-n]|Returns state controller dynamic process current time|
|![image][ref-xsc]:`getTimePast`(![image][ref-xxx])|![image][ref-n]|Returns state controller dynamic process passed time|
|![image][ref-xsc]:`getTimeRatio`(![image][ref-xxx])|![image][ref-n]|Returns state controller dynamic process time ratio|
|![image][ref-xsc]:`getTimeSample`(![image][ref-xxx])|![image][ref-n]|Returns state controller static process time delta|
|![image][ref-xsc]:`getType`(![image][ref-xxx])|![image][ref-s]|Returns state controller control type|
|![image][ref-xsc]:`getWindup`(![image][ref-xxx])|![image][ref-r]|Returns state controller windup lower and upper bound|
|![image][ref-xsc]:`getWindup`(![image][ref-xxx])|![image][ref-xv2]|Returns state controller windup lower and upper bound|
|![image][ref-xsc]:`getWindupMax`(![image][ref-xxx])|![image][ref-n]|Returns state controller windup upper bound|
|![image][ref-xsc]:`getWindupMin`(![image][ref-xxx])|![image][ref-n]|Returns state controller windup lower bound|
|![image][ref-xsc]:`isActive`(![image][ref-xxx])|![image][ref-n]|Checks state controller activated working flag|
|![image][ref-xsc]:`isCombined`(![image][ref-xxx])|![image][ref-n]|Checks state controller combined flag spreading proportional term gain across others|
|![image][ref-xsc]:`isDerivative`(![image][ref-xxx])|![image][ref-n]|Checks state controller derivative enabled flag|
|![image][ref-xsc]:`isIntegral`(![image][ref-xxx])|![image][ref-n]|Checks state controller integral enabled flag|
|![image][ref-xsc]:`isInverted`(![image][ref-xxx])|![image][ref-n]|Checks state controller inverted feedback flag of the reference and set-point|
|![image][ref-xsc]:`isManual`(![image][ref-xxx])|![image][ref-n]|Checks state controller manual control signal flag|
|![image][ref-xsc]:`isZeroCross`(![image][ref-xxx])|![image][ref-n]|Checks state controller integral zero crossing flag|
|![image][ref-xsc]:`remGain`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller proportional, integral and derivative term gains|
|![image][ref-xsc]:`remGainD`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller derivative term gain|
|![image][ref-xsc]:`remGainI`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller integral term gain|
|![image][ref-xsc]:`remGainID`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller integral and derivative term gain|
|![image][ref-xsc]:`remGainP`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller proportional term gain|
|![image][ref-xsc]:`remGainPD`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller proportional and derivative term gain|
|![image][ref-xsc]:`remGainPI`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller proportional and integral term gain|
|![image][ref-xsc]:`remTimeSample`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller static process time delta|
|![image][ref-xsc]:`remWindup`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller windup lower and upper bound|
|![image][ref-xsc]:`remWindupMax`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller windup upper bound|
|![image][ref-xsc]:`remWindupMin`(![image][ref-xxx])|![image][ref-xsc]|Removes state controller windup lower bound|
|![image][ref-xsc]:`resState`(![image][ref-xxx])|![image][ref-xsc]|Resets state controller automated internal parameters|
|![image][ref-xsc]:`setBias`(![image][ref-n])|![image][ref-xsc]|Updates state controller output signal bias|
|![image][ref-xsc]:`setGain`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state controller proportional, integral and derivative term gains|
|![image][ref-xsc]:`setGain`(![image][ref-r])|![image][ref-xsc]|Updates state controller proportional, integral and derivative term gains|
|![image][ref-xsc]:`setGain`(![image][ref-v])|![image][ref-xsc]|Updates state controller proportional, integral and derivative term gains|
|![image][ref-xsc]:`setGainD`(![image][ref-n])|![image][ref-xsc]|Updates state controller derivative term gain|
|![image][ref-xsc]:`setGainI`(![image][ref-n])|![image][ref-xsc]|Updates state controller integral term gain|
|![image][ref-xsc]:`setGainID`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state controller integral and derivative term gain|
|![image][ref-xsc]:`setGainID`(![image][ref-r])|![image][ref-xsc]|Updates state controller integral and derivative term gain|
|![image][ref-xsc]:`setGainID`(![image][ref-xv2])|![image][ref-xsc]|Updates state controller integral and derivative term gain|
|![image][ref-xsc]:`setGainP`(![image][ref-n])|![image][ref-xsc]|Updates state controller proportional term gain|
|![image][ref-xsc]:`setGainPD`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state controller proportional and derivative term gain|
|![image][ref-xsc]:`setGainPD`(![image][ref-r])|![image][ref-xsc]|Updates state controller proportional and derivative term gain|
|![image][ref-xsc]:`setGainPD`(![image][ref-xv2])|![image][ref-xsc]|Updates state controller proportional and derivative term gain|
|![image][ref-xsc]:`setGainPI`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state controller proportional and integral term gain|
|![image][ref-xsc]:`setGainPI`(![image][ref-r])|![image][ref-xsc]|Updates state controller proportional and integral term gain|
|![image][ref-xsc]:`setGainPI`(![image][ref-xv2])|![image][ref-xsc]|Updates state controller proportional and integral term gain|
|![image][ref-xsc]:`setIsActive`(![image][ref-n])|![image][ref-xsc]|Updates state controller activated working flag|
|![image][ref-xsc]:`setIsCombined`(![image][ref-n])|![image][ref-xsc]|Updates state controller combined flag spreading proportional term gain across others|
|![image][ref-xsc]:`setIsDerivative`(![image][ref-n])|![image][ref-xsc]|Updates state controller derivative enabled flag|
|![image][ref-xsc]:`setIsIntegral`(![image][ref-n])|![image][ref-xsc]|Updates state controller integral enabled flag|
|![image][ref-xsc]:`setIsInverted`(![image][ref-n])|![image][ref-xsc]|Updates state controller inverted feedback flag of the reference and set-point|
|![image][ref-xsc]:`setIsManual`(![image][ref-n])|![image][ref-xsc]|Updates state controller manual control signal flag|
|![image][ref-xsc]:`setIsZeroCross`(![image][ref-n])|![image][ref-xsc]|Updates state controller integral zero crossing flag|
|![image][ref-xsc]:`setManual`(![image][ref-n])|![image][ref-xsc]|Updates state controller manual control signal value|
|![image][ref-xsc]:`setPower`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state controller proportional, integral and derivative term power|
|![image][ref-xsc]:`setPower`(![image][ref-r])|![image][ref-xsc]|Updates state controller proportional, integral and derivative term power|
|![image][ref-xsc]:`setPower`(![image][ref-v])|![image][ref-xsc]|Updates state controller proportional, integral and derivative term power|
|![image][ref-xsc]:`setPowerD`(![image][ref-n])|![image][ref-xsc]|Updates state controller derivative term power|
|![image][ref-xsc]:`setPowerI`(![image][ref-n])|![image][ref-xsc]|Updates state controller integral term power|
|![image][ref-xsc]:`setPowerID`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state controller integral and derivative term power|
|![image][ref-xsc]:`setPowerID`(![image][ref-r])|![image][ref-xsc]|Updates state controller integral and derivative term power|
|![image][ref-xsc]:`setPowerID`(![image][ref-xv2])|![image][ref-xsc]|Updates state controller integral and derivative term power|
|![image][ref-xsc]:`setPowerP`(![image][ref-n])|![image][ref-xsc]|Updates state controller proportional term power|
|![image][ref-xsc]:`setPowerPD`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state controller proportional and derivative term power|
|![image][ref-xsc]:`setPowerPD`(![image][ref-r])|![image][ref-xsc]|Updates state controller proportional and derivative term power|
|![image][ref-xsc]:`setPowerPD`(![image][ref-xv2])|![image][ref-xsc]|Updates state controller proportional and derivative term power|
|![image][ref-xsc]:`setPowerPI`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state controller proportional and integral term power|
|![image][ref-xsc]:`setPowerPI`(![image][ref-r])|![image][ref-xsc]|Updates state controller proportional and integral term power|
|![image][ref-xsc]:`setPowerPI`(![image][ref-xv2])|![image][ref-xsc]|Updates state controller proportional and integral term power|
|![image][ref-xsc]:`setState`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state controller automated internal parameters|
|![image][ref-xsc]:`setTimeSample`(![image][ref-n])|![image][ref-xsc]|Updates state controller static process time delta|
|![image][ref-xsc]:`setWindup`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state controller windup lower and upper bound|
|![image][ref-xsc]:`setWindup`(![image][ref-r])|![image][ref-xsc]|Updates state controller windup lower and upper bound|
|![image][ref-xsc]:`setWindup`(![image][ref-xv2])|![image][ref-xsc]|Updates state controller windup lower and upper bound|
|![image][ref-xsc]:`setWindupMax`(![image][ref-n])|![image][ref-xsc]|Updates state controller windup upper bound|
|![image][ref-xsc]:`setWindupMin`(![image][ref-n])|![image][ref-xsc]|Updates state controller windup lower bound|
|![image][ref-xsc]:`tuneAH`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`AH`) Astrom-Hagglund|
|![image][ref-xsc]:`tuneAutoZN`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`ZN`) [`Ziegler-Nichols auto-oscillation`](https://raw.githubusercontent.com/dvdvideo1234/ControlSystemsE2/master/data/pictures/ZN_tunning.png)|
|![image][ref-xsc]:`tuneAutoZN`(![image][ref-n],![image][ref-n],![image][ref-s])|![image][ref-xsc]|Tunes the state controller using the method (`ZN`) [`Ziegler-Nichols auto-oscillation`](https://raw.githubusercontent.com/dvdvideo1234/ControlSystemsE2/master/data/pictures/ZN_tunning.png) extended by type: `classic`, `pessen`, `sovers`, `novers`|
|![image][ref-xsc]:`tuneIAE`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`IAE`) Integral absolute error|
|![image][ref-xsc]:`tuneISE`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`ISE`) Integral square error|
|![image][ref-xsc]:`tuneITAE`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`ITAE`) Integral of time-weighted absolute error|
|![image][ref-xsc]:`tuneOverCHRLR`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`CHR`) Chien-Hrones-Reswick load rejection `20%` overshot|
|![image][ref-xsc]:`tuneOverCHRSP`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`CHR`) Chien-Hrones-Reswick set point track `20%` overshot|
|![image][ref-xsc]:`tuneProcCC`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`CC`) [`Choen-Coon`](https://raw.githubusercontent.com/dvdvideo1234/ControlSystemsE2/master/data/pictures/CC_tuning.png)|
|![image][ref-xsc]:`tuneProcCHRLR`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`CHR`) Chien-Hrones-Reswick load rejection|
|![image][ref-xsc]:`tuneProcCHRSP`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`CHR`) Chien-Hrones-Reswick set point track|
|![image][ref-xsc]:`tuneProcZN`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state controller using the method (`ZNM`) Ziegler-Nichols plant process|

[ref-a]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-a.png
[ref-b]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-b.png
[ref-c]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-c.png
[ref-e]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-e.png
[ref-xm2]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xm2.png
[ref-m]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-m.png
[ref-xm4]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xm4.png
[ref-n]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-n.png
[ref-q]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-q.png
[ref-r]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-r.png
[ref-s]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-s.png
[ref-t]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-t.png
[ref-xv2]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xv2.png
[ref-v]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-v.png
[ref-xv4]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xv4.png
[ref-xrd]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xrd.png
[ref-xwl]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xwl.png
[ref-xft]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xft.png
[ref-xsc]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xsc.png
[ref-xxx]: https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/type-xxx.png

[ref_example]: https://github.com/dvdvideo1234/ControlSystemsE2/blob/master/data/Expression2/e2_code_test_stcontrol.txt
[ref_tusofia]: https://tu-sofia.bg/
[ref_exponent]: https://en.wikipedia.org/wiki/Exponentiation
[ref_relay]: https://en.wikipedia.org/wiki/Relay
[ref_realnum]: https://en.wikipedia.org/wiki/Real_number
[ref_pid]: https://en.wikipedia.org/wiki/PID_controller
[ref_aero_sys]: https://en.wikipedia.org/wiki/Propeller_(aeronautics)
[ref_quad_eq]: https://en.wikipedia.org/wiki/Quadratic_equation
[ref_class_oop]: https://en.wikipedia.org/wiki/Class_(computer_programming)
[ref_fa_tu]: https://tu-sofia.bg/department/preview/13?dep_id=4
[ref_samp_time]: https://en.wikipedia.org/wiki/Sampling_(signal_processing)
[ref_auto_con]: https://en.wikipedia.org/wiki/Automation
[ref_contr_tune]: https://en.wikipedia.org/wiki/PID_controller#Loop_tuning
[ref_cubic_eq]: https://en.wikipedia.org/wiki/Cubic_equation
[ref_root]: https://en.wikipedia.org/wiki/Square_root
