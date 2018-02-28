local paths = {}

function paths.regDirectory(sB, sE)
  local bas = ((sB:sub(-1,-1) == "/") and sB or (sB.."/"))
  local ext = tostring(sE or "*.*")
  package.path = package.path..";"..(bas..ext):match("(.-)[^\\/]+$").."?.lua"
  paths.requireRel = require
end

return paths
