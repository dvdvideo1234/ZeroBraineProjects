package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
local socket = require("socket")
local mime   = require("mime")
socket.url   = require("socket.url")
socket.http  = require("socket.http") -- http://w3.impa.br/~diego/software/luasocket/http.html
local https = require("ssl.https")

-- https://www.rulit.me/books/tajnata-read-182168-1.html

local sID  = "182168"
local sPT  = 3
local fURL = "https://www.rulit.me/books/tajnata-read-%s-%d.html"

local function concat(oF, sBody)
  local sO, iD = "", 1
  local nSS, nSE = sBody:find("<p>", 1, true)
  local nES, nEE = nil, nil
  while(nSS and nSE) do
    nES, nEE = sBody:find("</p>", nSE+1, true)
    if(nES and nEE) then
      local sData = sBody:sub(nSE+1, nES-1)
      if(not sData:find("%w+=\"%w*\"")) then
        oF:write(sBody:sub(nSE+1, nES-1).."\n")
      end
      nSS, nSE = sBody:find("<p>",nEE+1, true)
    else
      break
    end
  end
end

local oF, sE = io.open("parse.txt", "wb")
if(oF) then
  for iP = 1, sPT do
    local body, statusCode, headers, statusText = https.request(fURL:format(sID, iP))
    concat(oF, body)
  end
else
  print(sE)
end









