local a = "ASFDFG"

local common = {}

function common.stringIsUpper(sS)
  return (sS:upper() == sS)
end

function common.stringIsLower(sS)
  return (sS:lower() == sS)
end

print(common.stringIsUpper(a))
print(common.stringIsLower(a))