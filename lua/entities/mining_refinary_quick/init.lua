AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



function ENT:Initialize()
	if ( CLIENT ) then return end
	self:SetModel( "models/props_wasteland/laundry_washer001a.mdl" )	
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
   	if entity:GetNWString("typ") == "Coal" then
   		self:SetNWFloat("combustivel",self:GetNWFloat("combustivel") + math.Round(entity:GetNWFloat("omass")))
   		   self:SetColor(Color(254,255,255))
   		if self:GetNWFloat("combustivel") > 99 then
   			self:SetNWFloat("combustivel",100)
    entity:Remove()
   		else
   		entity:Remove()
   	end
   	
   		elseif self:GetRefining() == false && entity:GetNWString("typ") ~= "Uranium" then
  	
   		 if CurTime() < delay then return end
        self:Setpers(entity:CPPIGetOwner())
        self:Setoremass(entity:GetNWFloat("omass"))
        self:Setoretype(entity:GetNWString("typ"))
        self:Setcan(false)
        self:Setore(entity:GetNWFloat("Money"))
        self:Setorecol(entity:GetNWVector("ingot_color_to"))
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

	if self:GetRefining() or false == true then
		
		
	if self:GetNWFloat("porce") >= 100 && self:GetRefining() == true  then
		if CurTime() < delay2 then return end
		
		if self:Getcan() == false then
		
		self:EmitSound( "buttons/button5.wav")
		if SERVER then
			
--		PrintMessage( HUD_PRINTTALK, "Speed: "..Speeds[numbertomake])
--		PrintMessage( HUD_PRINTTALK, "Efficiencia: "..Efficiencies[numbertomake])
--		PrintMessage( HUD_PRINTTALK, "BaseConsumi: "..coalconsu[numbertomake])
 --       PrintMessage( HUD_PRINTTALK, "Formula: "..(coalconsu[numbertomake]/Efficiencies[numbertomake])*(Speeds[numbertomake]/Efficiencies[numbertomake]))
		local Entidade = ents.Create("mining_ingot")
		
        local Pos = self:LocalToWorld(Vector(0,50,0))
		
		Entidade:SetPos(Pos)
		Entidade:CPPISetOwner(self:Getpers())
		Entidade:SetNWFloat("Money",self:Getore()*1.7)
		Entidade:SetColor(Color(self:Getorecol().x,self:Getorecol().y,self:Getorecol().z,255))
		Entidade:SetNWString("typ",self:Getoretype())
		Entidade:SetNWFloat("omass",self:Getoremass())
		Entidade:Spawn()
		Entidade:GetPhysicsObject():SetMass(self:Getoremass())
		self:Setcan(true)
		end
		end
		
		self:SetNWFloat("porce",0)
		delay2 = 5
		self:SetRefining(false)
		return
	end
	if self:GetNWFloat("combustivel") > 0 then
    self:SetNWFloat("porce",self:GetNWFloat("porce")+1.5)
  // consumo antigo 0.02
    self:SetNWFloat("combustivel",self:GetNWFloat("combustivel")-(self:Getoremass()/10)*0.05)
else 
	self:SetColor(Color(255,255,255))
	end
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