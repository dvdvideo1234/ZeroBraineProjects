require("ZeroBraineProjects/dvdlualib/asmlib")

asmlib.InitAssembly("track")



function math.Sign(num)
  local num = tonumber(num) or 0
  return (num ~= 0) and (num / math.abs(num)) or 0
end

asmlib.SetAction("mul",function(db, a, b, c) print(c); return (a * b) + db.Base; end, {Base = 7})

print("Rez: ",asmlib.CallAction("mul",14,2,3))