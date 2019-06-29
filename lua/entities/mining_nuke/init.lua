AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

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
self:SetModel( "models/props/de_train/processor_nobase.mdl" )
self:SetColor(color_white)
self:PhysicsInit(SOLID_VPHYSICS)
self:SetMoveType(MOVETYPE_VPHYSICS)
self:SetSolid(SOLID_VPHYSICS)
self:SetUseType(SIMPLE_USE)
self:GetPhysicsObject():Wake()
end
local Time=25
local function Explode(Ent)
 if CLIENT then return end
 if Ent:IsValid()~=true then return end
 local explosion = ents.Create( "env_explosion" )
 explosion:CPPISetOwner(Ent:CPPIGetOwner())
 explosion:SetKeyValue( "spawnflags", 144 )
 explosion:SetKeyValue( "iMagnitude", 1115 ) 
 explosion:SetKeyValue( "iRadiusOverride", 3656 ) 
 explosion:SetPos(Ent:GetPos())
 explosion:Spawn( ) 
 explosion:Fire("explode","",0)
 local rad=ents.Create("prop_physics")
 rad:SetPos(Ent:GetPos())
 rad:CPPISetOwner(Ent:CPPIGetOwner())	
 timer.Create("NukeRad"..rad:EntIndex(),0.1,350,function()
  rad:SetNWFloat("Radtime",rad:GetNWFloat("Radtime",0)+0.1)
  for k,v in pairs(ents.FindInSphere(rad:GetPos(),4300)) do
   if (v:IsPlayer() or v:IsNPC()) and v:IsValid() then
   	if rad:CPPIGetOwner():GetNWBool("build_pvp",false)==false 
   	and v:GetNWBool("build_pvp",false)==false then 
   	 local d=DamageInfo()
   	 d:SetDamage(math.random(1,3))
   	 d:SetAttacker(v)
   	 d:SetInflictor(rad:CPPIGetOwner())
   	 d:SetDamageType(DMG_RADIATION)
   	 v:TakeDamageInfo(d)	
   	 v:EmitSound("player/geiger".. tostring(math.random(1,3)).. 	".wav")
    end
   end
  end
  if rad:GetNWFloat("Radtime",0)>=350 then rad:Remove() end
 end)

 Ent:Remove()
end
local function NTick(Ent)
 if CLIENT then return end
 if Ent:IsValid()==true then
  timer.Create("NTick"..Ent:EntIndex(),1,Time,function()
   if Ent:IsValid()~=true then  return end
   Ent:EmitSound("weapons/grenade/tick1.wav")
  end)
 end
end
function ENT:Use( activator, caller )
	if IsValid( caller ) and caller:IsPlayer() and self:GetNWBool("CanUse",true)==true then
		self:EmitSound("buttons/button1.wav")
		self:SetNWBool("CanUse",false)
		timer.Create("Explosion"..self:EntIndex(),Time,1,function() Explode(self) end)
		NTick(self)
		CanUse=false
	end
end