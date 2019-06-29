AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



function ENT:Initialize()
	if ( CLIENT ) then return end
	
	util.AddNetworkString("initminingderma")
	util.AddNetworkString("modificaaiman")
	
	net.Receive( "modificaaiman", function( len, ply )
	self:Setoreneed1(net.ReadString())
	self:Setoreneed2(net.ReadString())
	self:Setoretomake(net.ReadString())
	self:Setoretomakevalue(net.ReadFloat())
	self:Setoretomakecolor(net.ReadVector())
	end)
	
	self:SetModel( "models/props_wasteland/laundry_basket001.mdl" )	
	self:SetColor(color_white)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.timer = CurTime()
	self:GetPhysicsObject():Wake()
	self:SetNWInt("smeltlevel", 1)
end	


function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Refining")
	self:NetworkVar("Entity", 1, "pers")
	self:NetworkVar("Bool", 1, "can")
	
	self:NetworkVar("String", 0, "oreneed1")
	self:NetworkVar("String", 1, "oreneed2")
	
	self:NetworkVar("String", 2, "oretomake")
	self:NetworkVar("Float", 3, "oretomakevalue")
	
	self:NetworkVar("Bool", 2, "ison1")
	self:NetworkVar("Bool", 3, "ison2")
	
	self:NetworkVar("Float",2,"oremass1")
	self:NetworkVar("Int",3,"Vida")
    self:NetworkVar("Float",5,"oremass2")
    
	self:NetworkVar("Vector",0,"oretomakecolor")
	
	
	self:SetVida(255)
	
	self:Setison1(false)
	self:Setison2(false)
	
--	self:Setoreneed1("Iron")
--	self:Setoreneed2("Copper")
--	self:Setoretomake("Steel")
--	self:Setoretomakevalue(7)
self:SetNWBool("initializedd", true)
end

local delay = 0

function ENT:Touch( entity )

   if entity:GetClass() == "mining_ingot" || entity:GetClass() == "mining_rock" then
   	if entity:IsValid() then
   		
   	if entity:GetNWString("typ") == "Coal" then
   		self:SetNWFloat("combustivel",self:GetNWFloat("combustivel") + math.Round(entity:GetNWFloat("omass")))
   		self:SetColor(Color(254,255,255))
   		if self:GetNWFloat("combustivel") > 99 then
   			self:SetNWFloat("combustivel", 100)
   			entity:Remove()
   		else
   		entity:Remove()
   	end
   	
   		elseif self:GetRefining() == false && entity:GetNWString("typ") == self:Getoreneed1() && self:Getison1() == false && entity:GetClass() == "mining_ingot" then

   		 if CurTime() < delay then return end
self:Setcan(false)
       self:Setison1(true)
       self:Setoremass1(entity:GetNWFloat("omass"))
       self:Setpers(entity:CPPIGetOwner())
   entity:Remove() 


	delay = CurTime() + 1
      elseif self:GetRefining() == false && entity:GetNWString("typ") == self:Getoreneed2() && self:Getison2() == false && entity:GetClass() == "mining_ingot" then
      	self:Setison2(true)
      	self:Setcan(false)
      	self:Setpers(entity:CPPIGetOwner())
      	 self:Setoremass2(entity:GetNWFloat("omass"))
      	entity:Remove() 
      	delay = CurTime() + 1
      end
   	end	 
   	end
end
local delay2 = 2
function ENT:Think()
	
	if self:GetNWBool("initializedd") == true then
	
	if self:Getison1() == true && self:Getison2() == true then
		
	if self:GetNWFloat("porce") >= 100 && self:Getison1() == true && self:Getison2() == true  then
		if CurTime() < delay2 then return end
		
		if self:Getcan() == false then
		
		self:EmitSound( "buttons/button5.wav")
		if SERVER then
			
        local Pos = self:LocalToWorld(Vector(0,50,0))			

		local Entidade = ents.Create("mining_ingot")
		Entidade:SetPos(Pos)
		Entidade:CPPISetOwner(self:Getpers())

		Entidade:SetNWFloat("Money",self:Getoretomakevalue()*self:Getoremass1()+self:Getoremass2())
		Entidade:SetNWString("typ",self:Getoretomake())
		Entidade:SetColor(Color(self:Getoretomakecolor().x,self:Getoretomakecolor().y,self:Getoretomakecolor().z))
		Entidade:Spawn()
		Entidade:GetPhysicsObject():SetMass(self:Getoremass1()+self:Getoremass2())
		self:Setcan(true)
		self:Setison2(false)
		self:Setison1(false)
		self:SetRefining(false)
		end
		end
		
		self:SetNWFloat("porce",0)
		delay2 = 5
		self:SetRefining(false)
		return
	end
	if self:GetNWFloat("combustivel") > 0 then
    self:SetNWFloat("porce",self:GetNWFloat("porce")+1.5)
    self:SetNWFloat("combustivel",self:GetNWFloat("combustivel")-(self:Getoremass1()/10+self:Getoremass2()/10)*0.07)
else
	self:SetColor(Color(255,255,255))
	end
	self:NextThink( CurTime() )
	return true

end
end
end

function ENT:Use( activator, caller )
	
   net.Start("initminingderma")
   net.WriteEntity(self)
   net.Send(caller)
    	
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