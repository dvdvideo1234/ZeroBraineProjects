require("ZeroBraineProjects/dvdlualib/common")
local treeintdb = require("ZeroBraineProjects/dvdlualib/treeintdb")

local DB = treeintdb.make();
local ID = treeintdb.toIndex(16909066)
Print(ID)
      DB:Insert(16909066,16909066,"A test")
      DB:Insert(16909066,16909071,"A test-1")
      
  Print(DB:getData())
  
  Print(DB:Select(16909066,16909060))