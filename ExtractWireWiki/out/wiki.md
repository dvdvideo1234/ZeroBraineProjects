### What does this extension include?
State controller [OOP class][ref_class_oop] that creates LQ-PID controllers with static or
dynamic [sampling time][ref_samp_time]. They are used generally for every kind of
[automatic control][ref_auto_con] that is needed in Wiremod. Supports a bunch of general
[tuning methods][ref_contr_tune], I studied at [the university][ref_tusofia] and can be
initialized as a [relay][ref_relay], linear or power controller. The error `E` with power
`P` can be zero, positive or negative number. When zero, the output is calculated as [relay][ref_relay],
when equal to `1`, we have the [classic PID controller][ref_pid] when the power
is `2` the error has [quadratic relation][ref_quad_eq] `E^2`, `3`, for [cubic][ref_cubic_eq]
and so on needed for [aero-propeller][ref_aero_sys] systems. Negative powers will be treated as error
[square root][ref_root] ( `1/E^P` when p = `2` ). The user can put even fractional powers `P` to each term. It
has a lot of possibilities. The only limits is your imagination.

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
|--------------------|-----|-------------|
|`newStControl`(![image][ref-xxx])|![image][ref-xsc]|Returns state control object with dynamic sampling time|
|`newStControl`(![image][ref-n])|![image][ref-xsc]|Returns state control object with static sampling time|
|`noStControl`(![image][ref-xxx])|![image][ref-xsc]|Returns invalid state control object|

|           Class methods           | Out | Description |
|-----------------------------------|-----|-------------|
|![image][ref-xsc]:`dumpItem`(![image][ref-n])|![image][ref-xsc]|Dumps state control to the chat area by number identifier|
|![image][ref-xsc]:`dumpItem`(![image][ref-s])|![image][ref-xsc]|Dumps state control to the chat area by string identifier|
|![image][ref-xsc]:`dumpItem`(![image][ref-s],![image][ref-n])|![image][ref-xsc]|Dumps state control by number identifier in the specified area by first argument|
|![image][ref-xsc]:`dumpItem`(![image][ref-s],![image][ref-s])|![image][ref-xsc]|Dumps state control by string identifier in the specified area by first argument|
|![image][ref-xsc]:`getBias`(![image][ref-xxx])|![image][ref-n]|Returns state control control bias|
|![image][ref-xsc]:`getControl`(![image][ref-xxx])|![image][ref-n]|Returns state control automated control signal signal|
|![image][ref-xsc]:`getControlTerm`(![image][ref-xxx])|![image][ref-r]|Returns state control automated control term signal|
|![image][ref-xsc]:`getControlTerm`(![image][ref-xxx])|![image][ref-v]|Returns state control automated control term signal|
|![image][ref-xsc]:`getControlTermD`(![image][ref-xxx])|![image][ref-n]|Returns state control derivative automated control term signal|
|![image][ref-xsc]:`getControlTermI`(![image][ref-xxx])|![image][ref-n]|Returns state control integral automated control term signal|
|![image][ref-xsc]:`getControlTermP`(![image][ref-xxx])|![image][ref-n]|Returns state control proportional automated control term signal|
|![image][ref-xsc]:`getCopy`(![image][ref-xxx])|![image][ref-xsc]|Returns state control object copy instance|
|![image][ref-xsc]:`getCopy`(![image][ref-n])|![image][ref-xsc]|Returns state control object copy instance with static sampling time|
|![image][ref-xsc]:`getErrorDelta`(![image][ref-xxx])|![image][ref-n]|Returns state control process error delta|
|![image][ref-xsc]:`getErrorNow`(![image][ref-xxx])|![image][ref-n]|Returns state control process current error|
|![image][ref-xsc]:`getErrorOld`(![image][ref-xxx])|![image][ref-n]|Returns state control process passed error|
|![image][ref-xsc]:`getGain`(![image][ref-xxx])|![image][ref-r]|Returns state control proportional term gain, integral term gain and derivative term gain|
|![image][ref-xsc]:`getGain`(![image][ref-xxx])|![image][ref-v]|Returns state control proportional term gain, integral term gain and derivative term gain|
|![image][ref-xsc]:`getGainD`(![image][ref-xxx])|![image][ref-n]|Returns state control derivative term gain|
|![image][ref-xsc]:`getGainI`(![image][ref-xxx])|![image][ref-n]|Returns state control integral term gain|
|![image][ref-xsc]:`getGainID`(![image][ref-xxx])|![image][ref-r]|Returns state control integral term gain and derivative term gain|
|![image][ref-xsc]:`getGainID`(![image][ref-xxx])|![image][ref-xv2]|Returns state control integral term gain and derivative term gain|
|![image][ref-xsc]:`getGainP`(![image][ref-xxx])|![image][ref-n]|Returns state control proportional term gain|
|![image][ref-xsc]:`getGainPD`(![image][ref-xxx])|![image][ref-r]|Returns state control proportional term gain and derivative term gain|
|![image][ref-xsc]:`getGainPD`(![image][ref-xxx])|![image][ref-xv2]|Returns state control proportional term gain and derivative term gain|
|![image][ref-xsc]:`getGainPI`(![image][ref-xxx])|![image][ref-r]|Returns state control proportional term gain and integral term gain|
|![image][ref-xsc]:`getGainPI`(![image][ref-xxx])|![image][ref-xv2]|Returns state control proportional term gain and integral term gain|
|![image][ref-xsc]:`getManual`(![image][ref-xxx])|![image][ref-n]|Returns state control manual control signal value|
|![image][ref-xsc]:`getPower`(![image][ref-xxx])|![image][ref-r]|Returns state control proportional term power, integral term power and derivative term power|
|![image][ref-xsc]:`getPower`(![image][ref-xxx])|![image][ref-v]|Returns state control proportional term power, integral term power and derivative term power|
|![image][ref-xsc]:`getPowerD`(![image][ref-xxx])|![image][ref-n]|Returns state control derivative term power|
|![image][ref-xsc]:`getPowerI`(![image][ref-xxx])|![image][ref-n]|Returns state control integral term power|
|![image][ref-xsc]:`getPowerID`(![image][ref-xxx])|![image][ref-r]|Returns state control integral term power and derivative term power|
|![image][ref-xsc]:`getPowerID`(![image][ref-xxx])|![image][ref-xv2]|Returns state control integral term power and derivative term power|
|![image][ref-xsc]:`getPowerP`(![image][ref-xxx])|![image][ref-n]|Returns state control proportional term power|
|![image][ref-xsc]:`getPowerPD`(![image][ref-xxx])|![image][ref-r]|Returns state control proportional term power and derivative term power|
|![image][ref-xsc]:`getPowerPD`(![image][ref-xxx])|![image][ref-xv2]|Returns state control proportional term power and derivative term power|
|![image][ref-xsc]:`getPowerPI`(![image][ref-xxx])|![image][ref-r]|Returns state control proportional term power and integral term power|
|![image][ref-xsc]:`getPowerPI`(![image][ref-xxx])|![image][ref-xv2]|Returns state control proportional term power and integral term power|
|![image][ref-xsc]:`getTimeBench`(![image][ref-xxx])|![image][ref-n]|Returns state control process benchmark time|
|![image][ref-xsc]:`getTimeDelta`(![image][ref-xxx])|![image][ref-n]|Returns state control dynamic process time delta|
|![image][ref-xsc]:`getTimeNow`(![image][ref-xxx])|![image][ref-n]|Returns state control process current time|
|![image][ref-xsc]:`getTimeOld`(![image][ref-xxx])|![image][ref-n]|Returns state control process passed time|
|![image][ref-xsc]:`getTimeRatio`(![image][ref-xxx])|![image][ref-n]|Returns state control process time ratio|
|![image][ref-xsc]:`getTimeSample`(![image][ref-xxx])|![image][ref-n]|Returns state control static process time delta|
|![image][ref-xsc]:`getType`(![image][ref-xxx])|![image][ref-s]|Returns state control control type|
|![image][ref-xsc]:`getWindup`(![image][ref-xxx])|![image][ref-r]|Returns state control windup lower bound and windup upper bound|
|![image][ref-xsc]:`getWindup`(![image][ref-xxx])|![image][ref-xv2]|Returns state control windup lower bound and windup upper bound|
|![image][ref-xsc]:`getWindupD`(![image][ref-xxx])|![image][ref-n]|Returns state control windup lower bound|
|![image][ref-xsc]:`getWindupU`(![image][ref-xxx])|![image][ref-n]|Returns state control windup upper bound|
|![image][ref-xsc]:`isActive`(![image][ref-xxx])|![image][ref-n]|Checks state control activated working flag|
|![image][ref-xsc]:`isCombined`(![image][ref-xxx])|![image][ref-n]|Checks state control combined flag spreading proportional term gain across others|
|![image][ref-xsc]:`isIntegrating`(![image][ref-xxx])|![image][ref-n]|Checks integral enabled flag|
|![image][ref-xsc]:`isInverted`(![image][ref-xxx])|![image][ref-n]|Checks state control inverted feedback flag of the reference and set-point|
|![image][ref-xsc]:`isManual`(![image][ref-xxx])|![image][ref-n]|Checks state control manual control flag|
|![image][ref-xsc]:`remGain`(![image][ref-xxx])|![image][ref-xsc]|Removes state control proportional term gain, integral term gain and derivative term gain|
|![image][ref-xsc]:`remGainD`(![image][ref-xxx])|![image][ref-xsc]|Removes state control derivative term gain|
|![image][ref-xsc]:`remGainI`(![image][ref-xxx])|![image][ref-xsc]|Removes state control integral term gain|
|![image][ref-xsc]:`remGainID`(![image][ref-xxx])|![image][ref-xsc]|Removes state control integral term gain and derivative term gain|
|![image][ref-xsc]:`remGainP`(![image][ref-xxx])|![image][ref-xsc]|Removes state control proportional term gain|
|![image][ref-xsc]:`remGainPD`(![image][ref-xxx])|![image][ref-xsc]|Removes state control proportional term gain and derivative term gain|
|![image][ref-xsc]:`remGainPI`(![image][ref-xxx])|![image][ref-xsc]|Removes state control proportional term gain and integral term gain|
|![image][ref-xsc]:`remTimeSample`(![image][ref-xxx])|![image][ref-xsc]|Removes state control static process time delta|
|![image][ref-xsc]:`remWindup`(![image][ref-xxx])|![image][ref-xsc]|Removes state control windup lower bound and windup upper bound|
|![image][ref-xsc]:`remWindupD`(![image][ref-xxx])|![image][ref-xsc]|Removes state control windup lower bound|
|![image][ref-xsc]:`remWindupU`(![image][ref-xxx])|![image][ref-xsc]|Removes state control windup upper bound|
|![image][ref-xsc]:`resState`(![image][ref-xxx])|![image][ref-xsc]|Resets state control automated internal parameters|
|![image][ref-xsc]:`setBias`(![image][ref-n])|![image][ref-xsc]|Updates state control control bias|
|![image][ref-xsc]:`setGain`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state control proportional term gain, integral term gain and derivative term gain|
|![image][ref-xsc]:`setGain`(![image][ref-r])|![image][ref-xsc]|Updates state control proportional term gain, integral term gain and derivative term gain|
|![image][ref-xsc]:`setGain`(![image][ref-v])|![image][ref-xsc]|Updates state control proportional term gain, integral term gain and derivative term gain|
|![image][ref-xsc]:`setGainD`(![image][ref-n])|![image][ref-xsc]|Updates state control derivative term gain|
|![image][ref-xsc]:`setGainI`(![image][ref-n])|![image][ref-xsc]|Updates state control integral term gain|
|![image][ref-xsc]:`setGainID`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state control integral term gain and derivative term gain|
|![image][ref-xsc]:`setGainID`(![image][ref-r])|![image][ref-xsc]|Updates state control integral term gain and derivative term gain|
|![image][ref-xsc]:`setGainID`(![image][ref-xv2])|![image][ref-xsc]|Updates state control derivative term gain and derivative term gain|
|![image][ref-xsc]:`setGainP`(![image][ref-n])|![image][ref-xsc]|Updates state control proportional term gain|
|![image][ref-xsc]:`setGainPD`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state control proportional term gain and derivative term gain|
|![image][ref-xsc]:`setGainPD`(![image][ref-r])|![image][ref-xsc]|Updates state control proportional term gain and derivative term gain|
|![image][ref-xsc]:`setGainPD`(![image][ref-xv2])|![image][ref-xsc]|Updates state control proportional term gain and derivative term gain|
|![image][ref-xsc]:`setGainPI`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state control proportional term gain and integral term gain|
|![image][ref-xsc]:`setGainPI`(![image][ref-r])|![image][ref-xsc]|Updates state control proportional term gain and integral term gain|
|![image][ref-xsc]:`setGainPI`(![image][ref-xv2])|![image][ref-xsc]|Updates state control proportional term gain and integral term gain|
|![image][ref-xsc]:`setIsActive`(![image][ref-n])|![image][ref-xsc]|Updates state control activated working flag|
|![image][ref-xsc]:`setIsCombined`(![image][ref-n])|![image][ref-xsc]|Updates combined flag spreading proportional term gain across others|
|![image][ref-xsc]:`setIsIntegrating`(![image][ref-n])|![image][ref-xsc]|Updates integral enabled flag|
|![image][ref-xsc]:`setIsInverted`(![image][ref-n])|![image][ref-xsc]|Updates state control inverted feedback flag of the reference and set-point|
|![image][ref-xsc]:`setIsManual`(![image][ref-n])|![image][ref-xsc]|Updates state control manual control signal value|
|![image][ref-xsc]:`setManual`(![image][ref-n])|![image][ref-xsc]|Updates state control manual control value|
|![image][ref-xsc]:`setPower`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state control proportional term power, integral term power and derivative term power|
|![image][ref-xsc]:`setPower`(![image][ref-r])|![image][ref-xsc]|Updates state control proportional term power, integral term power and derivative term power|
|![image][ref-xsc]:`setPower`(![image][ref-v])|![image][ref-xsc]|Updates state control proportional term power, integral term power and derivative term power|
|![image][ref-xsc]:`setPowerD`(![image][ref-n])|![image][ref-xsc]|Updates state control derivative term power|
|![image][ref-xsc]:`setPowerI`(![image][ref-n])|![image][ref-xsc]|Updates state control integral term power|
|![image][ref-xsc]:`setPowerID`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state control integral term power and derivative term power|
|![image][ref-xsc]:`setPowerID`(![image][ref-r])|![image][ref-xsc]|Updates state control integral term power and derivative term power|
|![image][ref-xsc]:`setPowerID`(![image][ref-xv2])|![image][ref-xsc]|Updates state control derivative term power and derivative term power|
|![image][ref-xsc]:`setPowerP`(![image][ref-n])|![image][ref-xsc]|Updates state control proportional term power|
|![image][ref-xsc]:`setPowerPD`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state control proportional term power and derivative term power|
|![image][ref-xsc]:`setPowerPD`(![image][ref-r])|![image][ref-xsc]|Updates state control proportional term power and derivative term power|
|![image][ref-xsc]:`setPowerPD`(![image][ref-xv2])|![image][ref-xsc]|Updates state control proportional term power and derivative term power|
|![image][ref-xsc]:`setPowerPI`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state control proportional term power and integral term power|
|![image][ref-xsc]:`setPowerPI`(![image][ref-r])|![image][ref-xsc]|Updates state control proportional term power and integral term power|
|![image][ref-xsc]:`setPowerPI`(![image][ref-xv2])|![image][ref-xsc]|Updates state control proportional term power and integral term power|
|![image][ref-xsc]:`setState`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Works state control automated internal parameters|
|![image][ref-xsc]:`setTimeSample`(![image][ref-n])|![image][ref-xsc]|Updates state control static process time delta|
|![image][ref-xsc]:`setWindup`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Updates state control windup lower bound and windup upper bound|
|![image][ref-xsc]:`setWindup`(![image][ref-r])|![image][ref-xsc]|Updates state control windup lower bound and windup upper bound|
|![image][ref-xsc]:`setWindup`(![image][ref-xv2])|![image][ref-xsc]|Updates state control windup lower bound and windup upper bound|
|![image][ref-xsc]:`setWindupD`(![image][ref-n])|![image][ref-xsc]|Updates state control windup lower bound|
|![image][ref-xsc]:`setWindupU`(![image][ref-n])|![image][ref-xsc]|Updates state control windup upper bound|
|![image][ref-xsc]:`tuneAH`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Astrom-Hagglund method (`AH`)|
|![image][ref-xsc]:`tuneAutoZN`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Ziegler-Nichols auto-oscillation method (`ZN`)|
|![image][ref-xsc]:`tuneAutoZN`(![image][ref-n],![image][ref-n],![image][ref-s])|![image][ref-xsc]|Tunes the state control using the Ziegler-Nichols auto-oscillation method with overshot option (`ZN`)|
|![image][ref-xsc]:`tuneIAE`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the integral absolute error method (`IAE`)|
|![image][ref-xsc]:`tuneISE`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the integral square error method (`ISE`)|
|![image][ref-xsc]:`tuneITAE`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the integral of time-weighted absolute error method (`ITAE`)|
|![image][ref-xsc]:`tuneOverCHRLR`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Chien-Hrones-Reswick method (`CHR`) load rejection `20%` overshot|
|![image][ref-xsc]:`tuneOverCHRSP`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Chien-Hrones-Reswick method (`CHR`) set point track `20%` overshot|
|![image][ref-xsc]:`tuneProcCC`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Choen-Coon method (`CC`)|
|![image][ref-xsc]:`tuneProcCHRLR`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Chien-Hrones-Reswick method (`CHR`) load rejection|
|![image][ref-xsc]:`tuneProcCHRSP`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Chien-Hrones-Reswick method (`CHR`) set point track|
|![image][ref-xsc]:`tuneProcZN`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Ziegler-Nichols plant process method (`ZN`)|

|Icon|Description|
|---|---|
|![image][ref-a]|[`Angle`](https://en.wikipedia.org/wiki/Euler_angles) class|
|![image][ref-b]|[`Bone`](https://github.com/wiremod/wire/wiki/Expression-2#Bone) class|
|![image][ref-c]|[`Complex`](https://en.wikipedia.org/wiki/Complex_number) number|
|![image][ref-e]|[`Entity`](https://en.wikipedia.org/wiki/Entity) class|
|![image][ref-xm2]|[`Matrix`](https://en.wikipedia.org/wiki/Matrix_(mathematics)) 2x2|
|![image][ref-m]|[`Matrix`](https://en.wikipedia.org/wiki/Matrix_(mathematics)) 3x3|
|![image][ref-xm4]|[`Matrix`](https://en.wikipedia.org/wiki/Matrix_(mathematics)) 4x4|
|![image][ref-n]|[`Number`](https://en.wikipedia.org/wiki/Number)|
|![image][ref-q]|[`Quaternion`](https://en.wikipedia.org/wiki/Quaternion)|
|![image][ref-r]|[`Array`](https://en.wikipedia.org/wiki/Array_data_structure)|
|![image][ref-s]|[`String`](https://en.wikipedia.org/wiki/String_(computer_science)) class|
|![image][ref-t]|[`Table`](https://github.com/wiremod/wire/wiki/Expression-2#Table)|
|![image][ref-xv2]|[`Vector`](https://en.wikipedia.org/wiki/Euclidean_vector) 2D class|
|![image][ref-v]|[`Vector`](https://en.wikipedia.org/wiki/Euclidean_vector) 3D class|
|![image][ref-xv4]|[`Vactor`](https://en.wikipedia.org/wiki/4D_vector) 4D class|
|![image][ref-xrd]|[`Ranger data`](https://github.com/wiremod/wire/wiki/Expression-2#BuiltIn_Ranger) class|
|![image][ref-xwl]|[`Wire link`](https://github.com/wiremod/wire/wiki/Expression-2#Wirelink) class|
|![image][ref-xft]|[`Flash tracer`](https://github.com/dvdvideo1234/ControlSystemsE2/wiki/FTracer) class|
|![image][ref-xsc]|[`State controller`](https://github.com/dvdvideo1234/ControlSystemsE2/wiki/StControl) class|
|![image][ref-xxx]|[`Void`](https://en.wikipedia.org/wiki/Void_type) data type|

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
[ref_relay]: https://en.wikipedia.org/wiki/Relay
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
