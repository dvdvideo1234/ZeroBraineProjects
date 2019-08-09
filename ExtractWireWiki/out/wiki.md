|ˑˑInstance.creatorˑˑ|ˑOutˑ|ˑDescriptionˑ|
|--------------------|-----|-------------|
|`newStControl`(![image][ref-xxx])|![image][ref-xsc]|Returns state control object with dynamic sampling time|
|`newStControl`(![image][ref-n])|![image][ref-xsc]|Returns state control object with static sampling time|
|`noStControl`(![image][ref-xxx])|![image][ref-xsc]|Returns invalid state control object|

|ˑˑˑˑˑˑˑˑˑˑˑClass.methodsˑˑˑˑˑˑˑˑˑˑˑ|ˑOutˑ|ˑDescriptionˑ|
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
|![image][ref-xsc]:`getTimeDelta`(![image][ref-xxx])|![image][ref-n]|Returns state control dymamic process time delta|
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
|![image][ref-xsc]:`isInverted`(![image][ref-xxx])|![image][ref-n]|Checks state control inverted feedback flag of the reference and setpoint|
|![image][ref-xsc]:`isManual`(![image][ref-xxx])|![image][ref-n]|Checks state control manual control flag|
|![image][ref-xsc]:`remGain`(![image][ref-xxx])|![image][ref-xsc]|Removes state control proportional term gain, integral term gain and derivative term gain|
|![image][ref-xsc]:`remGainD`(![image][ref-xxx])|![image][ref-xsc]|Removes state control derivative term gain|
|![image][ref-xsc]:`remGainI`(![image][ref-xxx])|![image][ref-xsc]|Removes state control integral term gain|
|![image][ref-xsc]:`remGainID`(![image][ref-xxx])|![image][ref-xsc]|Removes state control integral term gain and derivative term gain|
|![image][ref-xsc]:`remGainP`(![image][ref-xxx])|![image][ref-xsc]|Removes state control proportional term gain|
|![image][ref-xsc]:`remGainPD`(![image][ref-xxx])|![image][ref-xsc]|Removes state control proportional term gain and derivative term gain|
|![image][ref-xsc]:`remGainPI`(![image][ref-xxx])|![image][ref-xsc]|Removes state control proportional term gain and integral term gain|
|![image][ref-xsc]:`remSelf`(![image][ref-xxx])|![image][ref-n]|Removes the state control from the list|
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
|![image][ref-xsc]:`setIsInverted`(![image][ref-n])|![image][ref-xsc]|Updates state control inverted feedback flag of the reference and setpoint|
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
|![image][ref-xsc]:`tuneAH`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Astrom-Hagglund method `(AH)`|
|![image][ref-xsc]:`tuneAutoZN`(![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Ziegler-Nichols auto-oscilation method `(ZN)`|
|![image][ref-xsc]:`tuneAutoZN`(![image][ref-n],![image][ref-n],![image][ref-s])|![image][ref-xsc]|Tunes the state control using the Ziegler-Nichols auto-oscilation method with overshot option `(ZN)`|
|![image][ref-xsc]:`tuneIAE`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the integral absolute error method `(IAE)`|
|![image][ref-xsc]:`tuneISE`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the integral square error method `(ISE)`|
|![image][ref-xsc]:`tuneITAE`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the integral of time-weighted absolute error method `(ITAE)`|
|![image][ref-xsc]:`tuneOverCHRLR`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Chien-Hrones-Reswick method `(CHR)` load rejection `20%` overshot|
|![image][ref-xsc]:`tuneOverCHRSP`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Chien-Hrones-Reswick method `(CHR)` set point track `20%` overshot|
|![image][ref-xsc]:`tuneProcCC`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Choen-Coon method `(CC)`|
|![image][ref-xsc]:`tuneProcCHRLR`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Chien-Hrones-Reswick method `(CHR)` load rejection|
|![image][ref-xsc]:`tuneProcCHRSP`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Chien-Hrones-Reswick method `(CHR)` set point track|
|![image][ref-xsc]:`tuneProcZN`(![image][ref-n],![image][ref-n],![image][ref-n])|![image][ref-xsc]|Tunes the state control using the Ziegler-Nichols plant process method `(ZN)`|

|ˑGeneral.functionsˑˑ|ˑOutˑ|ˑDescriptionˑ|
|--------------------|-----|-------------|
|`maxStControls`(![image][ref-xxx])|![image][ref-n]|Returns the upper state control count|
|`sumStControls`(![image][ref-xxx])|![image][ref-n]|Returns the used state control count|

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

