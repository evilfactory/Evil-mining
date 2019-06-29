AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	if ( CLIENT ) then return end
	self:SetModel( "models/props_wasteland/laundry_washer003.mdl" )	
	self:SetColor(color_white)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.timer = CurTime()
	self:GetPhysicsObject():Wake()
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 2, "Vida")
	self:SetVida(255)
end
local delay = 0
function ENT:Touch( entity )
	
   if entity:GetClass() == "mining_rock" || entity:GetClass() == "mining_ingot" || entity:GetClass() == "mining_uranium" then
   	if entity:IsValid() then

   		 if CurTime() < delay then return end
   		 self:SetNWInt("Money",self:GetNWInt("Money")+entity:GetNWInt("Money"))
     --   entity:CPPIGetOwner():SaveMoedaTXT()	
     entity:Remove() 
   		print("Jogador "..entity:CPPIGetOwner():GetName().." vendeu um item")
   	  


	delay = CurTime() + 0.1
   	   
   	   end
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

function ENT:Use(ply)
	if self:GetNWInt("Money") > 0 then
	ply:AddMoeda(math.Round(self:GetNWInt("Money")))
    ply:SaveMoeda()	
    self:EmitSound( "ambient/office/coinslot1.wav")
   self:SetNWInt("Money", 0)
    end
	end
