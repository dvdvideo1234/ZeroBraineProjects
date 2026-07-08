local P = "Notify"
local F = assert(io.open("ExtractMatch/text.txt", "r"))
local O = assert(io.open("ExtractMatch/resu.txt", "w"))
local L, C = F:read("*line"), 1
while(L) do
  local N = L:find(P)
  if(N) then
    O:write(L:sub(N, -1))
    O:write("\n")
  end
  L = F:read("*line")
  C = C + 1
end
F:close()
O:flush()
O:close()
