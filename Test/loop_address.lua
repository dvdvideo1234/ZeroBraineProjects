local nVal = 65532
local p = {[1] = nVal}

print(tostring(p))

while true do
  if(p[1] ~= nVal) then print(nVal) end
end

wait();