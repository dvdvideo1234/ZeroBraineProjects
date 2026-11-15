-- GMod `file` library running on the real disk. Only dependency: LuaFileSystem.
-- Open/Exists/IsDir/Size/Time/Find/Delete/CreateDir/Rename are engine functions in
-- GMod, so they are implemented here. Read/Write/Append are the public
-- garrysmod/lua/includes/extensions/file.lua, verbatim (`!` -> `not`, `||` -> `or`).
-- The gamePath argument ("DATA", "GAME", ...) is ignored: paths are used as given.

local lfs = require("lfs")

file = file or {}

-- Give io file handles the GMod File methods (once, on the shared metatable).
do
  local mt = getmetatable(io.stdout)
  local m = (type(mt.__index) == "table") and mt.__index or mt -- 5.1: mt itself, 5.2+: __index table

  m.Write = m.write
  m.Close = m.close
  m.Flush = m.flush
  m.Tell  = function(f) return f:seek() end
  m.Seek  = function(f, n) f:seek("set", n) end
  m.Read  = function(f, n) return f:read(n or "*a") end -- read(0) at EOF gives nil, hence the check in file.Read

  m.Size = function(f)
    local c = f:seek()
    local s = f:seek("end")
    f:seek("set", c)
    return s
  end

  m.EndOfFile = function(f) return f:read(0) == nil end

  m.ReadLine = function(f) -- keeps the trailing newline, "" at end of file
    local p = f:seek()
    local l = f:read("*l")
    if not l then return "" end
    if f:seek() - p > #l then l = l .. "\n" end
    return l
  end
end

function file.Open(name, mode, path)
  return (io.open(name, mode))
end

function file.Exists(name, path)
  return lfs.attributes(name, "mode") ~= nil
end

function file.IsDir(name, path)
  return lfs.attributes(name, "mode") == "directory"
end

function file.Size(name, path)
  local a = lfs.attributes(name)
  if not a then return -1 end
  return (a.mode == "directory") and 0 or a.size
end

function file.Time(name, path)
  return lfs.attributes(name, "modification") or 0
end

function file.Delete(name, path)
  if lfs.attributes(name, "mode") ~= "file" then return false end
  return os.remove(name) ~= nil
end

function file.Rename(from, to)
  return os.rename(from, to) ~= nil
end

function file.CreateDir(name)
  local norm = name:gsub("\\", "/")
  local acc = (norm:sub(1, 1) == "/") and "/" or ""
  for dir in norm:gmatch("[^/]+") do
    acc = (acc == "" or acc == "/") and (acc .. dir) or (acc .. "/" .. dir)
    local mode = lfs.attributes(acc, "mode")
    if not mode then
      if not lfs.mkdir(acc) then return end
    elseif mode ~= "directory" then
      return
    end
  end
end

-- Returns files, folders. Wildcards * and ? in the last path component.
-- sorting: "nameasc" (default), "namedesc", "dateasc", "datedesc"
function file.Find(name, path, sorting)
  local dir, pat = name:match("^(.*[/\\])([^/\\]*)$")
  if not dir then dir, pat = "./", name end

  pat = pat:lower():gsub("[%^%$%(%)%%%.%[%]%+%-]", "%%%0")
  pat = pat:gsub("%*", ".*")
  pat = "^" .. pat:gsub("%?", ".") .. "$"

  local files, folders = {}, {}
  local ok, iter, state, init = pcall(lfs.dir, dir)
  if not ok then return files, folders end

  for entry in iter, state, init do
    if entry ~= "." and entry ~= ".." and entry:lower():match(pat) then
      local a = lfs.attributes(dir .. entry)
      if a then
        local list = (a.mode == "directory") and folders or files
        list[#list + 1] = { n = entry, t = a.modification }
      end
    end
  end

  local s = tostring(sorting or "nameasc"):lower()
  local byDate, desc = (s:sub(1, 4) == "date"), (s:sub(-4) == "desc")
  local function cmp(a, b)
    if byDate and a.t ~= b.t then
      if desc then return a.t > b.t else return a.t < b.t end
    end
    if desc and not byDate then return a.n:lower() > b.n:lower() end
    return a.n:lower() < b.n:lower()
  end

  for _, list in ipairs({ files, folders }) do
    table.sort(list, cmp)
    for i, e in ipairs(list) do list[i] = e.n end
  end
  return files, folders
end

--------------------------------------------------------------------------------
-- garrysmod/lua/includes/extensions/file.lua
--------------------------------------------------------------------------------

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
