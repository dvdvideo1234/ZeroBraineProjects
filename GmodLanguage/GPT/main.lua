local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local common = require("common")
local https = require("ssl.https")
local sBase = "GmodLanguage/GPT"

local body, code, headers, status = https.request("https://chatgpt.com/?q=Help+me+pick+an+outfit+that+will+look+good+on+camera")

local f = assert(io.open(sBase.."/body.html", "w"))

f:write(body)
f:flush()
f:close()

print(code, status)

common.logTable(headers, "headers")

