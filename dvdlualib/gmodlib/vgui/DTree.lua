common = require("common")

function vgui_New_DTree()
  local self = {
    __type = "DTree",
    PX = 0, PY = 0,
    SX = 0, SY = 0,
    TTip = nil,
    Name = "",
    Node = {},
    Item = {Size = 0},
    Skin = nil
  }
  return self
end
