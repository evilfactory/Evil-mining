AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	if ( CLIENT ) then return end
	self:SetModel( "models/sprops/geometry/fdisc_12.mdl" )	
--	self:SetColor(color_white)
	self:SetMaterial("sprops/textures/sprops_metal4")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.timer = CurTime()
	self:GetPhysicsObject():Wake()
end

function ENT:Think()
	if CLIENT then return end
local detected = {}
if self:GetNWString("typ") == "235" then
	detected = ents.FindInSphere(self:GetPos(),200)
else
	detected = ents.FindInSphere(self:GetPos(),400)
	end
	
	
	for i=1, table.Count(detected) do
	if detected[i]:IsPlayer() then
	local d = DamageInfo()
	d:SetDamage( 1 )
	d:SetAttacker( self )
	d:SetDamageType( DMG_RADIATION )

	detected[i]:TakeDamageInfo( d )
	self:EmitSound("player/geiger"..math.random(1,3)..".wav")
	

	end
		end
	if self:GetNWString("typ") == "235" then
		self:NextThink( (CurTime()+1))
	else
		self:NextThink( (CurTime()+0.5))
		end
	return true
	end

