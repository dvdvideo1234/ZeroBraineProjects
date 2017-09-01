require("ZeroBraineProjects/dvdlualib/common")

local gsSentHash = "aaaaa"

  local tBroadCast = {
    [1] = {"SetNWFloat", gsSentHash.."_power", 11},
    [2] = {"SetNWFloat", gsSentHash.."_lever", 0}
  }

function newThing(sName)
  local self = {}
  local Data = {}
  function self:SetNWFloat(sKey, anyValue)
    Data[sKey] = anyValue
  end
  function self:GetData() return Data end
  return self
end

local self = newThing("Hand Adams")

logTable(self:GetData(), "lol")

arList = {nil,2}

for ID = 1, #tBroadCast do         -- Go trough all like a list
        local set = tBroadCast[ID]       -- Get broadcaster setup
        local val = arList[ID] or set[3] -- Take current
        local foo, key = set[1], set[2]  -- Get the setup pair values
        self[foo](self, key, val)        -- Send to the client
      end

logTable(self:GetData(), "lol")
