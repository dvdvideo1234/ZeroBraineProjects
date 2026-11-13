derma = derma or {}

function Derma_Hook(...)
  print("DermaHook", ...)
end

-- derma.DefineControl(name, desc, tbl, base) -> same as Register
function derma.DefineControl(name, desc, tbl, base)
    print("derma.DefineControl", name, base, desc)
    return vgui.Register(name, tbl, base)
end
