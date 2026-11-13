surface = {__fonts = {}, __font = true}

function surface.CreateFont(sK, tD)
  if(not sK) then return nil end
  surface.__fonts[sK] = tD
  print("surface.CreateFont", sK)
end

function surface.SetFont(sK)
  if(not sK) then return end
  local vF = surface.__fonts[sK]
  if(not vF) then return end
  surface.__font = vF
  print("surface.SetFont", sK)
end

function surface.GetTextSize()
  if(not __font) then return 0, 0 end
  local nY = __font.size
  local nX = math.floor(nY * 1.618)
  return nX, nY
end
