require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/asmlib")

asmlib.SetIndexes("V","x","y","z")
asmlib.SetIndexes("A","p","y","r")
asmlib.InitBase("track","assembly")


asmlib.SettingsLogs("skip")
asmlib.SettingsLogs("only")

logTable(asmlib.GetOpVar("LOG_SKIP"))
logTable(asmlib.GetOpVar("LOG_ONLY"))


