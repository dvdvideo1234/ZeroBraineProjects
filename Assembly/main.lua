require("ZeroBraineProjects/dvdlualib/asmlib")

asmlib.InitAssembly("track")



function math.Sign(num)
  local num = tonumber(num) or 0
  return (num ~= 0) and (num / math.abs(num)) or 0
end


asmlib.SetAction("TEST",function(a,b) 
  local td = asmlib.GetActionData("TEST").t
  return a + b + td
end ,{t = 5})

s = asmlib.GetActionCode("TEST")

print(s(2,3))