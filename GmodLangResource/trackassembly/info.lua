local info = {}

info.tool = "trackassembly"
info.limit = "asmtracks"
info.sors = "C:/Users/ddobromirov/Documents/Lua-Projs/SVN/TrackAssemblyTool_GIT/lua/trackassembly/lang/%s.lua"
info.dest = "%s/"..info.tool.."/resource/localization/%s/"..info.tool..".properties"
info.lang = {"en", "bg", "fr", "ru", "ja"}; info.lang.size = #info.lang
info.match = {
  {"\"%.%..*tool.*%.%.\"", info.tool},
  {"\"%.%..*lim.*%.%.\"", info.limit},
  {"\"%.%..*lim%S+", info.limit}
}; info.match.size = #info.match

return info