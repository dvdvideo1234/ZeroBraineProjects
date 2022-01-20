function GetSign(num)
  return num / math.abs(num)
end

function NewPoint(X,Y)
  return {x = X, y = Y}
end

function Clamp(nNum, nMin, nMax)
  if(not nNum) then return nNum end
  if(nMin and nNum < nMin) then return nMin end
  if(nMax and nNum > nMax) then return nMax end
  return nNum
end

-- 100 - 250
-- 150 - 500
function Remap(num,iMin,iMax,oMin,oMax)
  local N = (iMin + iMax) / 2
  local V = (oMin + oMax) / 2
  local S = (oMax - oMin) / (iMax - iMin)
  return V + (N - num) * S
end

function Roll(nNum, nMin, nMax)
  if(nNum > nMax) then return nMin end
  if(nNum < nMin) then return nMax end
  return nNum
end
