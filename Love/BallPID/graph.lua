function NewGraph(iPoint, vInit)
  local mSize = 2 * iPoint
  local mData, self = {}, {}
  
  for i = 1, mSize, 2 do
    mData[i]   = i - 1
    mData[i+1] = vInit
  end
  
  function self:Update(vNew)
    for i = 2, mSize, 2 do
      mData[i] = mData[i+2]
    end
    mData[mSize] = vNew
  end
  
  function self:GetData()
    return mData
  end
  
  return self
end
