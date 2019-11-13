package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
-- http://w3.impa.br/~diego/software/luasocket/http.html
local https = require("ssl.https")
local tBOM  = {"ef","bb","bf"}

-- https://www.rulit.me/books/tajnata-read-182168-1.html
-- char
local iPT  = 3 -- Pages count. Book total pages to be scanned.
local iLT  = 120 -- Symbols per line. Defines how long a line is
local sID  = "182168" -- Book ID in the database
local sNM  = "tajnata" -- Book name to complete the URL
local fURL = "https://www.rulit.me/books/%s-read-%s-%d.html"
local sPth = "E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/SocketHTTP/%s.txt"
local function concat(oF, sBody)
  local nES, nEE, sO =  nil, nil, ""
  local nSS, nSE = sBody:find("<p>", 1, true)
  while(nSS and nSE) do
    nES, nEE = sBody:find("</p>", nSE+1, true)
    if(nES and nEE) then
      local sData = sBody:sub(nSE+1, nES-1)
      if(not sData:find("%w+=\"%w*\"")) then
        local sL = sBody:sub(nSE+1, nES-1)
        local iL = sL:len()
        while(iL > iLT) do
          local iK = iLT
          local cH = sL:sub(iK, iK)
          while(cH ~= "") do
            if(cH:byte() == 32) then break end
            iK = iK - 1
            cH = sL:sub(iK, iK)
          end
          oF:write(sL:sub(1, iK-1).."\n")
          sL = sL:sub(iK + 1, -1)
          iL = sL:len()
        end
        oF:write(sL.."\n")
      end
      nSS, nSE = sBody:find("<p>",nEE+1, true)
    else break end
  end
end

local oF, sE = io.open(sPth:format(sNM), "wb")
if(oF) then
  for iD = 1, #tBOM do oF:write(string.char(tonumber(tBOM[iD], 16))) end
  for iP = 1, iPT do
    concat(oF, https.request(fURL:format(sNM, sID, iP)))
  end; oF:flush(); oF:close()
else
  print(sE)
end









