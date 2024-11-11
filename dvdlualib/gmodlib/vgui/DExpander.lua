 function vgui_New_DExpander()
  local self = {}
  function self.SetImage(sI)
     if(sI == nil) then
       common.logStatus("VGUI["..self.__type.."].Icon.SetImage(nil)"); return end
     self.Icon.IMG = tostring(sI)
  end
  return self
end
