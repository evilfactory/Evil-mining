AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end
	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal + Vector(0, 0, 100) )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	if ( CLIENT ) then return end
	self:SetModel( "models/props_granary/grain_machinery_set2.mdl" )	
	self:SetColor(color_white)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.timer = CurTime()
	self:GetPhysicsObject():Wake()
end


function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Refining")
	self:NetworkVar("Entity", 1, "pers")
	self:NetworkVar("Bool", 1, "can")
	self:NetworkVar("Int", 2, "ore")
	self:NetworkVar("Vector", 0, "orecol")
	self:NetworkVar("Float",2,"oremass")
	self:NetworkVar("String",0,"oretype")
	self:NetworkVar("Int",3,"Vida")
                  
	          
	self:SetVida(255)
end

local delay = 0


function ENT:Touch( entity )

   if entity:GetClass() == "mining_rock" then
   	if entity:IsValid() then

   	if self:GetRefining() == false && entity:GetNWString("typ") == "Coal" then
  	
   		 if CurTime() < delay then return end
        self:Setpers(entity:CPPIGetOwner())
        self:Setoremass(entity:GetNWFloat("omass"))
        self:Setoretype(entity:GetNWString("typ"))
        self:Setcan(false)
        self:Setore(entity:GetNWFloat("Money"))
 	   entity:Remove() 

   	 --  self:EmitSound( "ambient/office/coinslot1.wav")
        self:SetRefining(true)
	delay = CurTime() + 1
   	   end
   	end	 
   	end
end
local delay2 = 2



function ENT:Think()
--if CLIENT then return end

	if self:GetRefining() == true or false then
		
		
	if self:GetNWFloat("porce") >= 100 && self:GetRefining() == true  then
		if CurTime() < delay2 then return end
		
		if self:Getcan() == false then
		
		self:EmitSound( "buttons/button5.wav")
		if SERVER then
    local Pos = self:LocalToWorld(Vector(0,150,0))
		local Entidade = ents.Create("mining_ingot")
		Entidade:SetPos(Pos)
		Entidade:CPPISetOwner(self:Getpers())
		Entidade:SetNWFloat("Money",self:Getore()*2)
		Entidade:SetColor(Color(0,0,0,255))
		Entidade:SetNWString("typ","Carbon")
		Entidade:SetNWFloat("omass",self:Getoremass())
		Entidade:Spawn()
		Entidade:SetMaterial("WTP/plastic_2")
		Entidade:GetPhysicsObject():SetMass(self:Getoremass())
		self:Setcan(true)
		
		end
		end
		
		self:SetNWFloat("porce",0)
		delay2 = 5
		self:SetRefining(false)
		return
	end

    self:SetNWFloat("porce",self:GetNWFloat("porce")+1)
    
		self:NextThink( CurTime() )
	return true
	end
end




 function ENT:OnTakeDamage(dmg)
if dmg:GetAttacker():GetNWBool( "build_pvp" ) == false && self:GetVida() > 0 then

	self:SetVida(self:GetVida() - dmg:GetDamage())
	self:SetColor(Color(255,self:GetVida(),self:GetVida(),255))
	if self:GetVida() <= 0 then
		self:Remove()
		local explode = ents.Create( "env_explosion" ) 
	explode:SetPos( self:GetPos() )
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", "220" ) 
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound( "weapon_AWP.Single", 400, 400 ) 
	end
	end
	end

