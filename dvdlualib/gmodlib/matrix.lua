local mtMatrix = {__type = "Matrix"}
      mtMatrix.__tostring = function(self)
        local sM = ""
        for iR = 1, 4 do
          sM = sM.."["..table.concat(self[iR], ",").."]"
          if(self[iR+1]) then sM = sM.."\n" end
        end; return sM
      end
      mtMatrix.__index = mtMatrix

function Matrix()
  local self = {{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}; setmetatable(self, mtMatrix)
  function self:ToTable() local tM = {}
    for iR = 1, 4 do tM[iR] = {}
      for iC = 1, 4 do tM[iR][iC] = self[iR][iC] end
    end; return tM
  end

  return self
end

RegisterMetaTable(mtMatrix.__type, mtMatrix)
