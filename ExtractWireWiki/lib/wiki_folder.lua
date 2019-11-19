local wikiFolder = {}
      wikiFolder.__temp = "/temp"
      wikiFolder.__slsh = {["/"] = true, ["\\"] = true}
      wikiFolder.__read = "*line"
      wikiFolder.__drof = "Directory of "
      wikiFolder.__fdat = "%d%d%-%d%d%-%d%d%d%d%s+%d%d:%d%d"
      wikiFolder.__idir = {".", "..", "<DIR>"}
      wikiFolder.__pdir = {["."] = true, [".."] = true}
      wikiFolder.__fcmd = "cd %s && dir > %s"
      wikiFolder.__ranm = 60 -- Random string file name
      wikiFolder.__syms = { -- https://en.wikipedia.org/wiki/Code_page_437
        {"└", "├", "─", "│", "┌"},
        {"╚", "╠", "═", "║", "╔"},
        {"╙", "╟", "─", "║", "╓"},
        {"╘", "╞", "═", "│", "╒"},
        {"`", "|", "-", "|", "/"},
        {"+", "+", "-", "|", "*"}
      }
      wikiFolder.__drem = "(.*)/"
      wikiFolder.__dept = 3   -- The folder depth offset
      wikiFolder.__ubom = {
        ["UTF8" ] = {0xEF, 0xBB, 0xBF},      -- UTF8
        ["UTF16"] = {0xFE, 0xFF},            -- UTF16
        ["UTF32"] = {0x00, 0x00, 0xFE, 0xFF} -- UTF32
      }
      wikiFolder.__furl = {"",""}
      wikiFolder.__flag = {
        prnt = false, -- (TRUE) Show the parent directory in the tree
        hide = false, -- (TRUE) Show hidden directories
        size = false, -- (TRUE) Show file size
        hash = false, -- (TRUE) So directory hash address
        urls = false, -- (TRUE) Use URLs for the files /wikiFolder.__furl/
        namr = false, -- (TRUE) Use Repo name for the tree name
        ufbr = false, -- (TRUE) Use file bottom references instead of long links
        prep = false, -- (TRUE) Replace key in the link pattern in the replace table. Call formatting   
        qref = false  -- (TRUE) Quote the string in the link reference
      }
      wikiFolder.__refl = {Size = 0}
      wikiFolder.__mems = {"", "k", "m", "t"} -- File zire amout round
      wikiFolder.__memi = 3                   -- File zire amout round ID
      
return wikiFolder
