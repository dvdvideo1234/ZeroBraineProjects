local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/Programs/LuaIDE")
      drpath.addBase("C:/Programs/ZeroBraineIDE").setBase(2)
local testexec = require("testexec")

local exp = "math_Ease_InOut"

local function loop(str)
  local i, out = 1, ""
  local char = str:sub(i,i)
  while char and (char >= "a" and char <= "z" or
                  char >= "A" and char <= "Z" or
                  char >= "0" and char <= "9" or char == "_") do
    out = out..char
    i = i + 1
    char = str:sub(i,i)
  end
  return out
end

local function patt(str)
  local out = str:match("[a-zA-Z0-9_]+")

  return out
end

local function nbyte(str)
  local i, out = 1, ""
  local char = str:sub(i,i)
  while char do
    local b = char:byte()
    if(not b) then break end
    if not (b >= 48 and b <= 57 or
            b >= 65 and b <= 90 or
            b >= 97 and b <= 122 or b == 95) then
      break
    end
    out = out..char
    i = i + 1
    char = str:sub(i,i)
  end
  return out
end



t = testexec.New()
t:setCase(loop, "loop")
t:setCase(patt, "pattern")
t:setCase(nbyte, "nbyte")
t:setProgress(1, 0.1)
t:setCount(1000, 1000)
--t:setCard("cat", {1,2,3,4}, "1|2|3|4")
t:setCard("library", {exp}, exp)
t:runMeasure()
