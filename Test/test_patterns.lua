local l = "asmlib.SetOpVar(\"TOOL_VERSION\",\"6.564\")"
local p1 = "asmlib.SetOpVar%s*%(%s*\"TOOL_VERSION\"%s*,%s*\"%d+%.%d+\"%s*%)"
local p2 = "%s*%d+%s*%.%s*%d+%s*"
print(l, l:find(p2))

local function printNum(n)
  print(tostring(n):sub(1,1):rep(20))
end

local function fixPath(sP)
  local bP = (sP:sub(-1,-1) == "/")
  return (bP and sP or (sP.."/"))
end

print(fixPath("asdf//"))