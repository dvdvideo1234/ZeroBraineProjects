-- Stores a bynch of format strings for various stuff ( wikilib.setFormat )
local wikiFormat = {
  __prj = "https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki",
  __tfm = "type-%s.png",
  __tfc = "%s.png",
  __rty = "ref-%s",
  __rbr = "[%s]: %s",
  __lnk = "[%s](%s)",
  __ins = "!%s",
  __lrs = "[%s][%s]",
  __ref = "[%s]",
  __brk = "(%s)",
  __img = "[image][%s]",
  __ytb = "[![](https://img.youtube.com/vi/%s/%d.jpg)](http://www.youtube.com/watch?v=%s \"\")",
  __loc = "file:///%s",
  __cou = "%s/countries/%s",
  __typ = "%s/types/%s",
  __wds = "E2Helper.Descriptions[\"%s\"] = \"%s\"\n",
  __url = "%s://%s",
  __sss = "[%s%s%s]",
  __hsr = "https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/buttons/%s.png",
  __hmg = "<img src=\"%s\" width=\"%s\" height=\"%s\"/>",
  __bnr = "via.placeholder.com/%dx%d.png/%02x%02x%02x/%02x%02x%02x?text=%s",
  __rid = "ref-%d-%s",
  cub = "%(.+%)", -- Match string in curly brakets
  sqb = "%[.+%]", -- Match string in square brakets
  tsp = "/",
  asp = ",",
  msp = ":",
  esp = "=",
  hsh = "#",
  fnd = "e2function",
  npt = "%)%s-=%s-e2function",
  vpt = "^%D[%w_]*$", -- Pattern to check name available for variable
  fpt = "^%D[%w_]*$" -- Pattern to check name available for function
}

return wikiFormat
