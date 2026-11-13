local file = {}

function file.Open(n, m)
  local s, f, e = pcall(io.open, n, m)
  if(not (s and f)) then
    return logStatus("file.Open("..m.."): "..tostring(e))
  end
  local mt = getmetatable(f)
  mt.Write = mt.write
  mt.Close = mt.close
  mt.Flush = mt.flush
  mt.ReadLine = function(f) return f:read("*line") end
  mt.EndOfFile = function(f)
    local p = f:seek() -- Store position
    local t = f:read(); f:seek("set", p)
    return common.getPick(t, false, true)
  end
  mt.Read = function(f)
    return f:read("*all")
  end
  mt.Tell = function(f)
    return f:seek()
  end
  mt.Seek = function(f, n)
    return f:seek("set", n)
  end
  mt.Size = function(f)
    local c = f:seek()
    local s = f:seek("end") 
    f:seek("set", c)
    return s
  end
  return f
end

function file.Exists(n)
  local a,b,c,d = pcall(os.execute, "cd "..n.." >nul 2>&1")
  if(a and b and c == "exit" and d == 0) then return true end
  local s, f = pcall(io.open, n, "rb")
  if(s and f) then f:close(); return true; end
  return false
end

function file.IsDir(n)
  if(type(n) ~= "string") then return false end
  local s, r = pcall(os.execute, "cd /d "..n)
  if(not s) then r = false end
  if(not r) then r = false end
  return r
end

function file.Delete(n)
  local p = common.stringGetFilePath(n)
  local n = common.stringGetFileName(n)
  local a,b,c = os.execute("cd "..p.." && del /f "..n.." >nul 2>&1")
end

function file.Append(n, c)
  local F = file.Open(n, "ab")
  if(not F) then
    return logStatus("file.Append: Nofile: "..tostring(n))
  end
  F:seek("end")
  F:write(tostring(c))
  F:flush()
  F:close()
end

function file.CreateDir(path)
-- Normalize backslashes to forward slashes for consistent parsing
    local norm = path:gsub("[\\/]+", "/")
          norm = norm:gsub("%.%./", "")
          norm = norm:gsub("^[/]+" , "")
          norm = norm:gsub("[/]+$", "")
    
    local accumulated = ""
    
    -- Preserve leading slash for absolute paths
    if norm:sub(1, 1) == "/" then
        accumulated = "/"
    end
    
    for dir in norm:gmatch("[^/]+") do
        if accumulated == "" or accumulated == "/" then
            accumulated = accumulated .. dir
        else
            accumulated = accumulated .. "/" .. dir
        end
        
        -- Check if the directory already exists
        local mode = lfs.attributes(accumulated, "mode")
        if not mode then
            local ok, err = lfs.mkdir(accumulated)
            if not ok then
                return nil, err
            end
        elseif mode ~= "directory" then
            return nil, "Path exists and is not a directory: " .. accumulated
        end
    end
    
    return true
end

function file.Find(sName, sPath, sSort)
  local sSrt, sArg = tostring(sSort or ""), ""
  local sCol = (sSort and sSrt:sub(1,4) or nil)
  local sMod = (sSort and sSrt:sub(5,-1) or nil)
  if(sMod) then sMod = ((sMod == "desc") and "-" or "") end
  if(sCol == "date" or sCol == "name") then
    sArg = " /O:"..sMod..sCol:sub(1,1):upper()
  end; return common.fileFind(sName, sArg)
end

function file.Time(sF)
  return lfs.attributes(sF, "modification") or 0
end

function file.Read( filename, path )

	if ( path == true ) then path = "GAME" end
	if ( path == nil or path == false ) then path = "DATA" end

	local f = file.Open( filename, "rb", path )
	if ( not f ) then return nil end

	local str = f:Read( f:Size() )

	f:Close()

	if ( not str ) then str = "" end
	return str

end

function file.Write( filename, contents )

	local f = file.Open( filename, "wb", "DATA" )
	if ( not f ) then return false end

	f:Write( contents )
	f:Close()

	return true

end

function file.Append( filename, contents )

	local f = file.Open( filename, "ab", "DATA" )
	if ( not f ) then return false end

	f:Write( contents )
	f:Close()

	return true

end

return file
