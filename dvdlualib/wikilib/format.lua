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
  __img = "[image][%s]",
  __ytb = "[![](https://img.youtube.com/vi/%s/%d.jpg)](http://www.youtube.com/watch?v=%s \"\")",
  __loc = "file:///%s",
  __cou = "%s/countries/%s",
  __typ = "%s/types/%s",
  __wds = "E2Helper.Descriptions[\"%s\"] = \"%s\"\n",
  __url = "%s://%s",
  __sss = "[%s%s%s]",
  tsp = "/",
  asp = ",",
  msp = ":",
  esp = "=",
  hsh = "#",
  fnd = "e2function",
  npt = "%)%s-=%s-e2function"
}

return wikiFormat