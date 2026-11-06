local function vgui_New_DImage(...)
  local self = {__type = "DImage"}
  function self:SetImage(sI)
    if(sI == nil) then
      common.logStatus("["..self.__type.."].Icon.SetImage(nil)"); return end
    self.IMG = tostring(sI)
  end
  return self
end

return vgui_New_DImage
