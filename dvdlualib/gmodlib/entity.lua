local __entity = {}

local mtEntity = {__type = "Entity"}
      mtEntity.__tostring = function(oE) return ("ENT{"..oE:EntIndex().."}{"..oE:GetClass().."}") end
      mtEntity.__index = mtEntity

  function mtEntity:IsValid() return true end
  function mtEntity:IsPlayer() return false end
  function mtEntity:IsVehicle() return false end
  function mtEntity:IsNPC() return false end
  function mtEntity:IsRagdoll() return false end
  function mtEntity:IsWeapon() return false end
  function mtEntity:IsWidget() return false end
  function mtEntity:GetTable() return {} end
      
function ents.Create(cla)
  local self = {}; setmetatable(self, mtEntity)
  local mcla = tostring(cla or "prop_physics")
  local mid = (#__entity + 1)
  local mpos = Vector(0,0,0)
  local mang = Angle(0,0,0)
  local mmodel = ""
  local matach = {ID = {[1]={Pos=Vector(6,6,6), Ang=Angle(7,7,7)}}, Nam = {["test"] = 1}}
  local mbdygrp = {{id=1},{id=2},data={1,2,3,4,5}}
  function self:GetClass() return mcla end
  function self:SetClass(vC) mcla = vC end
  function self:EntIndex() return mid end
  function self:GetPos() return mpos end
  function self:SetPos(vP) mpos:Set(vP) end
  function self:GetAngles() return mang end
  function self:SetAngles(vA) mang:Set(vA) end
  function self:GetBodyGroups() return mbdygrp end
  function self:GetBodygroup(id) return mbdygrp.data[id] end
  function self:SetCollisionGroup() return nil end
  function self:SetSolid() return nil end
  function self:SetMoveType() return nil end
  function self:SetNotSolid() return nil end
  function self:SetNoDraw() return nil end
  function self:SetModel(sM) mmodel = sM end
  function self:GetModel() return mmodel end
  function self:LookupAttachment(sK) return matach.Nam[sK] end
  function self:GetAttachment(iD) return matach.ID[iD] end
  function self:CallOnRemove() return nil end
  function self:IsWorld() return self == game.__world end
  function self:Remove() Msg("Remove: "..tostring(self)) end
  function self:DeleteOnRemove(e) Msg(tostring(self)..":DeleteOnRemove("..tostring(e)..")") end
  table.insert(__entity, mid, self)
  return self
end

ents.CreateClientProp = ents.Create

function Entity(id)
  if(id == nil) then return end
  return __entity[id]
end

function ents.GetAll()
  return __entity
end

RegisterMetaTable(mtEntity.__type, mtEntity)
