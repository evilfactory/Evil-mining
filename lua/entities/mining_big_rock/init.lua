AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()

	if ( CLIENT ) then return end
local models = {"models/props_wasteland/rockgranite02a.mdl","models/props_wasteland/rockgranite02c.mdl","models/props_wasteland/rockgranite02b.mdl"}

	self:SetModel( models[math.random(1, table.Count(models))] )	
	self:SetColor(color_white)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.timer = CurTime()
	self:GetPhysicsObject():Wake()
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Vida")
	self:NetworkVar("Vector", 1, "Posicao")
	self:SetVida(255)
end

 function ENT:OnTakeDamage(dmg)
    if dmg:GetAttacker():IsPlayer() == false then return end
 	self:SetPosicao(self:GetPos())
 	
 	if dmg:GetDamageType() == 128 then

 			
	self:SetVida(self:GetVida() - dmg:GetDamage())
	self:SetColor(Color(255,self:GetVida(),self:GetVida(),255))
	if self:GetVida() <= 0 then 
		
	for i=1, math.random(2, 6) do
		local Entidade = ents.Create("mining_rock")
		if(!IsValid( Entidade )) then return end
		Entidade:SetPos(self:GetPos())
		Entidade:CPPISetOwner(dmg:GetAttacker())
		Entidade:Spawn()
		
	end
	self:SetSolid(SOLID_NONE)
    self:SetNoDraw( true )

	timer.Simple( 100, function() 
		self:SetVida(255)
		self:SetPos(self:GetPosicao())
		self:SetSolid(SOLID_VPHYSICS)
		self:SetNoDraw( false )
		self:SetColor( Color(255,255,255,255) )
			end )
	end
	
end

 end