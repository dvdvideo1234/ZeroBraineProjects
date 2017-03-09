
module("dummy")

function Foo(S)
  return S:gsub("_a",string.upper)
end