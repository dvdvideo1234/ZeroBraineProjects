package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"

require("turtle")
local wx = require("wx")

local wn = "Crop image"
local fi = "CropImage/%s.png"
local bn = "source"
local bm = wx.wxBitmap()
bm:LoadFile(fi:format(bn), wx.wxBITMAP_TYPE_ANY)

open(wn)
size(bm:GetWidth(), bm:GetHeight())
zero(0, 0)
updt(false) 
load(fi:format(bn))

local can = true
local col = colr(255, 0, 0)
local top = wx.wxGetApp():GetTopWindow()
local frm = top and top.FindWindowByLabel(wn)
local sp  = snap()
local x1, y1, x2, y2 -- (left mouse down rectangle)

local function drawRect(a1, b1, a2, b2)
  pncl(col)
  line(a1, b1, a2, b1)
  line(a1, b2, a2, b2)
  line(a1, b1, a1, b2)
  line(a2, b1, a2, b2)
end

-- https://wiki.wxpython.org/ClientCoordinates#

while(true) do wait(0.1)
  local dx, dy = clck('ld')
  if(dx and dy and can) then
    local ux, uy; x1, y1 = dx, dy
    while(not (ux and uy)) do wait(0.1)
      local mp = frm:ScreenToClient(wx.wxGetMousePosition())
      undo(sp); drawRect(dx, dy, mp.x, mp.y); updt()
      ux, uy = clck('lu')
    end
    x2, y2 = ux, uy
    can = false
  else
    local rx, ry = clck('rd')
    if(rx and ry and not can) then
      if(x1 and y1 and x2 and y2) then
        local w = x2 - x1 + 1
        local h = y2 - y1 + 1
        local crop = bm:GetSubBitmap(wx.wxRect(x1, y1, w, h))
              crop:SaveFile(fi:format("out"), wx.wxBITMAP_TYPE_PNG)
        print("Saved ["..w..","..h.."]: "..fi:format("out"))
        can = true
      else
        x1, y1, x2, y2 = nil, nil, nil, nil
      end
    end
    updt()
  end
end

wait()