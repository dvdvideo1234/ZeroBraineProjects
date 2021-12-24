local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

local testexec = require("testexec")

local ENT = {foo = nil}

local function moo(foo)
  local s, e = pcall(foo)
  if(not s) then error(e) end
end

local function set(ent, foo)
  ent.foo = foo
end

local function f1()
  if(not ENT.foo) then
    ENT.foo = function()
      for i = 1, 100 do
        ENT[i] = "test"
      end
    end
  end
  moo(ENT.foo)
end

local function f2()
  if(not ENT.foo) then
    set(ENT, function()
      for i = 1, 100 do
        ENT[i] = "test"
      end
    end)
  end
  moo(ENT.foo)
end

local function f3()
  moo(function()
    for i = 1, 100 do
      ENT[i] = "test"
    end
  end)
end

local stEstim = {
  testexec.Case(f1, "cached-call"),
  testexec.Case(f2, "set-method"),
  testexec.Case(f3, "current-use")
}

local stCard = {
  {nil, nil , "Speed", 1000, 1000, .2}
}

 testexec.Run(stCard,stEstim,0.1)
