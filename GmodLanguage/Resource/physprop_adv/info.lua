local info = {}

info.tool = "physprop_adv" -- Tool name
info.limit = "asmtracks" -- Spawn limit convar name
info.sors = "%s/"..info.tool.."/lang/%s.lua"
info.dest = "%s/"..info.tool.."/resource/localization/%s/"..info.tool..".properties"
info.lang = {"en", "bg", "fr", "ru", "ja"} -- Available naguages
info.match = { -- The amount of matches to try
  {"\"..stool..\"", info.tool},
  {"\"..slimit..\"", info.limit},
  {"\"..slimit", info.limit}
} -- Automatic array size
info.lang.size = #info.lang
info.match.size = #info.match

return info