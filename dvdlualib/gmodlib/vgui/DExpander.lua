local function vgui_New_DExpander(...)
  local self = {__type = "DExpander"}
  function self:SetImage(sI)
    if(sI == nil) then
      common.logStatus("["..self.__type.."].Icon.SetImage(nil)"); return end
    self.Icon.IMG = tostring(sI)
  end
  return self
end

return vgui_New_DExpander
