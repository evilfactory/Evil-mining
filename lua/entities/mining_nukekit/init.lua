AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local Max=600
function ENT:SpawnFunction( ply, tr, ClassName )
if ( !tr.Hit ) then return end
local ent = ents.Create( ClassName )
ent:SetPos( tr.HitPos + tr.HitNormal + Vector(0, 0, 30) )
ent:Spawn()
ent:Activate()
return ent
end

function ENT:Initialize()
if ( CLIENT ) then return end
self:SetModel( "models/props/de_nuke/nuclearcontainerboxclosed.mdl" )
self:SetColor(color_white)
self:PhysicsInit(SOLID_VPHYSICS)
self:SetMoveType(MOVETYPE_VPHYSICS)
self:SetSolid(SOLID_VPHYSICS)
self:SetUseType(SIMPLE_USE)
self:GetPhysicsObject():Wake()
end
local function Produce(Ent)
 if CLIENT then return end
 timer.Simple(3,function() 
  if Ent:IsValid()~=true then return end
  local Nuke=ents.Create("mining_nuke")
  Nuke:CPPISetOwner(Ent:CPPIGetOwner())
  Nuke:SetPos(Ent:GetPos())
  Nuke:Spawn()
  Ent:Remove()
 end)
end
function ENT:Touch(ent)
 if CLIENT then return end
 if ent:GetClass()=="mining_uranium" and ent:GetNWString("typ") == "235" 
 and self:GetNWInt("count",0)<Max and ent:GetNWInt("toRemove",0)==0 then
  if self:GetNWInt("count",0)+ent:GetNWFloat("Money",0)<=Max then
   self:SetNWInt("count",self:GetNWInt("count",0)+ent:GetNWFloat("Money",0))
   ent:SetNWInt("toRemove",1)
   ent:Remove()
  elseif self:GetNWInt("count",0)+ent:GetNWFloat("Money",0)>Max then
  local m=ent:GetNWFloat("Money",0)
   ent:SetNWFloat("Money", (self:GetNWInt("count",0)+m) - Max )    
   self:SetNWInt("count",Max)
  end
  print(self:GetNWInt("count",0))
 end
 if self:GetNWInt("count",0)>=Max and self:GetNWBool("NukeKitInTimer",false)==false then
  self:SetNWBool("NukeKitInTimer",true)
  Produce(self)
 end
end