local function gcd(a,b)
  if(b ~= 0) then return gcd(b,a%b)
  else return a end
end

local function f(n)
  local s = 0
  for d = 1, (n+1) do
    if((n % d) == 0) then s = s + gcd(d, n/d) end
  end
  return s
end

local av = 590525
local an = 25143

local function F(k, vv, vn)
  local v = 0 + vv
  for n = (1+vn), k do
    v = v + f(n)
    print(n, v)
  end; return v
end

print(F(10^3, 0, 0))