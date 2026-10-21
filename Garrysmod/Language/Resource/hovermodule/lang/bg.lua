return function(sTool, sLimit) local tSet = {} -- Bulgarian ( Column "ISO 639-1" 
  ------ CONFIGURE TRANSLATIONS ------ https://en.wikipedia.org/wiki/ISO_639-1
  -- con >> control # def >> default # hd >> header # lb >> label
  tSet["tool."..sTool..".1"        ] = "Администрира левитиращи модули"
  tSet["tool."..sTool..".left"     ] = "Създава/Променя левитиращ модул"
  tSet["tool."..sTool..".right"    ] = "Копира настройки/Въвежда напред"
  tSet["tool."..sTool..".right_use"] = "Копира настройки/Въвежда нагоре"
  tSet["tool."..sTool..".reload"   ] = "Трие левитиращ модул"
  tSet["tool."..sTool..".name"     ] = "Инструмент за левитращи модули"
  tSet["tool."..sTool..".desc"     ] = "Менижира левитиращи модули"
  tSet["tool."..sTool..".0"        ] = "Ляво копче да създадете/конвертирате/промените, дясно да вземете настройките, презаредете за да премахнете"
  tSet["Cleanup_"..sLimit.."s"     ] = "Левитиращи модули"
  tSet["Cleaned_"..sLimit.."s"     ] = "Левитиращите модули са почистени"
  tSet["SBoxLimit_"..sLimit.."s"   ] = "Достигнахте границата на създадените левитиращи модули!" 
return tSet end
