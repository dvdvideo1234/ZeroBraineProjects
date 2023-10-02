local drpath = require("directories")
      drpath.addPath("myprograms",
                     "ZeroBraineProjects",
                     "CorporateProjects",
                     -- When not located in general directory search in projects
                     "ZeroBraineProjects/dvdlualib",
                     "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE").setBase(1)

--[[
Data = {}
Data["linedefined"] = 0
Data["currentline"] = 11
Data["func"] = function: 0x00897e50
Data["isvararg"] = true
Data["namewhat"] = ""
Data["lastlinedefined"] = 15
Data["source"] = "@D:\Programs\LuaIDE\ZeroBraineProjects\BinaryMapToXML\main.lua"
Data["nups"] = 0
Data["what"] = "main"
Data["nparams"] = 0
Data["short_src"] = "...ograms\LuaIDE\ZeroBraineProjects\BinaryMapToXML\main.lua"
]]
local com = require("common")
local fmt = "  <field name=\"%s\" type=\"%s\"/>\n"
local dbg = debug.getinfo(1)
local c = dbg.source:gsub("\\", "/"):gsub("@", ""):gsub("%w+%.lua", "")
local i = assert(io.open(c.."in.txt", "r"))
local o = assert(io.open(c.."out.xml", "w"))
      o:write("<?xml version=\"1.0\" encoding=\"ANSI\" ?>\n")
      o:write("<fields>\n")
local r, s, t, nm, ty = i:read("*line"), 0
while(r) do
  r = r:gsub("%s+", " ")
  r = com.stringTrim(r, "\n")
  r = com.stringTrim(r, "\r")
  t = com.stringExplode(r, " ")
  nm, ty = t[#t-1], t[#t]
  o:write(fmt:format(nm, ty))
  r = i:read("*line")
end
o:write("</fields>\n")
o:flush()
i:close()
o:close()
