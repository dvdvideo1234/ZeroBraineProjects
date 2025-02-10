local par = {
  -- Key patterns being ignored when searching dor dupes
  dup_all = { en = true, all = true,-- Enable or disable the ignore
    "left%.%d", "right_use%.%d",
    "reload%.%d", "right%.%d", "reload_use%.%d"
  }, -- Forlder prefixes for data source
  dup_any = { en = true, any = false, -- Enable or disable the ignore
    "pn_contextm_"
  }, -- Forlder prefixes for data source
  mrg_emp = false, -- Show empty old values as key difference
  prf_ext = ".properties",
  prf_src = {"TrackAssemblyTool_GIT", "trackassembly"},
  prm_lng = "en",    -- English is primary gmod language
  cnt_len = 2,       -- How many symbols to display dupes count
  key_len = 60       -- How many symbols to display keys
}

return par
