local paths = {}

function paths.regDir(sB, sE)
  local bas = ((sB:sub(-1,-1) == "/") and sB or (sB.."/"))
  local ext = tostring(sE or ""):gsub("%*",""):gsub("%.","")
  if(ext == "") then io.write("paths.regDir: Missing extension") return end
  local pad = (bas.."*."..ext):match("(.-)[^\\/]+$").."?."..ext
  package.path = package.path..";"..pad
  io.write("paths.regDir: Added <"..pad..">")
end

return paths
