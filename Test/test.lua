local drpath = require("directories")
      drpath.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      drpath.addBase("D:/LuaIDE").setBase(1)

require("turtle")
require("gmodlib")
local com = require("common")
local cpx = require("complex")
local tableRemove = table and table.remove
local gsSentHash = "test"
local SERVER = true

ENT = {[gsSentHash] = {AxiL = Vector(1,0,0), LevL = Vector(0,5,0), ForL = Vector(0,0,9)}}

function ENT:GetTorqueAxis()
  local vAxi = Vector(); if(SERVER) then
    vAxi:Set(self[gsSentHash].AxiL)
  elseif(CLIENT) then
    vAxi:Set(self:GetNWVector(gsSentHash.."_adir"))
  end; vAxi:Normalize(); return vAxi
end

function ENT:GetTorqueLever()
  local vLev = Vector(); if(SERVER) then
    vLev:Set(self[gsSentHash].LevL)
  elseif(CLIENT) then
    vLev:Set(self:GetNWVector(gsSentHash.."_ldir"))
  end; vLev:Normalize(); return vLev
end

function ENT:GetTorqueForce()
  local vFor = Vector(); if(SERVER) then
    vFor:Set(self[gsSentHash].ForL)
  elseif(CLIENT) then
    vFor:Set(self:GetNWVector(gsSentHash.."_fdir"))
  end; vFor:Normalize(); return vFor
end

print(ENT:GetTorqueAxis())
print(ENT:GetTorqueLever())
print(ENT:GetTorqueForce())