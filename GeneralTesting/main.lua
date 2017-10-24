function foo(a,b,c)
  return a,b,c
end

function bar(a, ...)
  print(a); return ...
end

local x,y,z = bar("aaaa",foo())

print(x,y,z)
