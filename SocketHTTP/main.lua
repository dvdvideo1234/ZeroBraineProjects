package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require("common")
-- http://notebook.kulchenko.com/programming/https-ssl-calls-with-lua-and-luasec
local https = require("ssl.https")

local tBOM =
{
  ["UTF-8"] = {"ef","bb","bf"}
}

local fURL = "https://www.rulit.me/books/%s-%s-%s-%d.html"
local sPth = "E:/Documents/Lua-Projs/ZeroBraineIDE/ZeroBraineProjects/SocketHTTP/%s.txt"

-- https://www.rulit.me/books/tajnata-read-182168-1.html
local tList =
{
  {Name = "tajnata", Mode= "read", ID = "182168", Size = 3, Wrap = 120}
}

local function concat(oF, sBody, iWrp)
  local nES, nEE, sO =  nil, nil, ""
  local nSS, nSE = sBody:find("<p>", 1, true)
  while(nSS and nSE) do
    nES, nEE = sBody:find("</p>", nSE+1, true)
    if(nES and nEE) then
      local sData = sBody:sub(nSE+1, nES-1)
      if(not sData:find("%w+=\"%w*\"")) then
        local sL = sBody:sub(nSE+1, nES-1)
        local iL = sL:len()
        while(iL > iWrp) do
          local iK = iWrp
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

for iB = 1, #tList do local vList = tList[iB]
  local oF, sE = io.open(sPth:format(tostring(vList.Name or "default")), "wb")
  if(oF) then
    for iP = 1, tonumber(vList.Size or 1) do
      local vN = tostring(vList.Name or "default")
      local vM = tostring(vList.Mode or "read")
      local vD = tostring(vList.ID or "0")
      local vW = (tonumber(vList.Wrap) or 80)
      local body, code, headers, status = https.request(fURL:format(vN, vM, vD, iP))
      local tStat = common.stringExplode(status, " ")
      if(tStat[2]:find("2%d%d$") and tStat[3] == "OK") then
        if(iP == 1) then local sHead = headers["content-type"]
          if(sHead) then local tHead = common.stringExplode(sHead, " ")
            for iC = 1, #tHead do local vHead = tHead[iC]
              local iB, iE = vHead:find("charset%s*=%s*")
              if(iB and iE) then
                vHead = vHead:gsub("charset%s*=%s*", "")
                vHead = common.stringTrim(vHead, ";")
                local vBOM = tBOM[vHead]; if(not vBOM) then
                  error("Character encoding sequence missing! ["..vHead.."]") end
                common.logStatus("Encoding: "..vHead)
                for iD = 1, #vBOM do oF:write(string.char(tonumber(vBOM[iD], 16))) end
              end
            end
          else error("Character encoding set not found! ["..sHead.."]") end
        end -- common.logTable({code, headers, status}, "STATUS")
        concat(oF, body, vW)
      end
    end; oF:flush(); oF:close()
  else
    print(sE)
  end
end








