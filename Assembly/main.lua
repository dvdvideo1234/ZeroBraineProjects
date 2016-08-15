require("ZeroBraineProjects/dvdlualib/asmlib")

asmlib.InitAssembly("track")

asmlib.SetLocalify("BGR","tool.test.name","This is a test")
asmlib.SetLocalify("BGR","tool.test.2","This is a test2")

asmlib.InitLocalify("BGR",print)

function math.Sign(num)
  local num = tonumber(num) or 0
  return (num ~= 0) and (num / math.abs(num)) or 0
end

print(math.Sign(123))
print(math.Sign(-123))
print(math.Sign(0))
print(math.Sign("-5"))