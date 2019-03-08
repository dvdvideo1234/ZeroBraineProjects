local function foo1(a) return a + 1 end
local function foo2(a) return a + foo1(a) end
local function foo3(a) 
  error("asdasd")
  return a + foo2(a)
end
local function foo4(a) return a + foo3(a) end
print(foo4(1))