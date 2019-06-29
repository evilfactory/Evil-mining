AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	if ( CLIENT ) then return end
	


	local Values = {2,
		2,
		1.2,1.2,
		1,1,
		1.3,1.3,
		1.7,
		2.5, 
		5,
		5.5,
		25,
		70
	}
	local types = {"Iron",
	"Zinco",
	"Tin","Tin",
	"Coal","Coal",
	"Aluminium","Aluminium",
	"Silicon",
	"Copper",
	"Gold",
	"Uranium",
	"Ruby",
	"???"
	}
	local Colors = {
		Color(200, 90, 25),
		Color(130, 160, 150),
		Color(220,240,190),Color(220,240,190),
		Color(0,0,0),Color(0,0,0),
		Color(255,255,255),Color(255,255,255),
		Color(110,115,140),
		Color(255,160,0),
		Color(255,200,0),
	    Color(40,60,40),
	    Color(255,0,0),
	    Color(221,51,221)
	}
	local Ingot_Colors = {
		Color(170,170,170),
		Color(190, 190, 190),	
		Color(220,240,190),Color(220,240,190),	
		Color(0,0,0),Color(0,0,0),
		Color(255,255,255),Color(255,255,255),
		Color(35,25,40),
		Color(195,95,25),
		Color(255,200,0),
	    Color(30,40,30),
	    Color(255,0,0),
	    Color(30,255,200)
	}

		
	self:SetModel( "models/props_junk/rock001a.mdl" )
	local rand = math.random(1,table.Count(types))
    
    if rand == 13 then
    	if math.random(1, 100) > 20 then
    		rand = math.random(1,table.Count(types))
    	end
    end
    if rand == 14 then
    	if math.random(1, 100) > 5 then
    		rand = 1
    	end
    end

	local mass = math.random(1, 18)
    self:SetNWString("typ",types[rand])
	self:SetNWFloat("Money",(Values[rand]*mass)*0.5)
	self:SetColor(Colors[rand])
	self:SetNWVector("ingot_color_to", Vector(Ingot_Colors[rand].r,Ingot_Colors[rand].g,Ingot_Colors[rand].b))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.timer = CurTime()
	self:GetPhysicsObject():Wake()
	self:GetPhysicsObject():SetMass(mass)
	self:SetNWFloat("omass",mass)
end



function ENT:Think()
	if self:GetNWString("typ") == "Uranium" then
	if CLIENT then return end
	local detected = ents.FindInSphere(self:GetPos(),self:GetNWFloat("omass")*15)
	
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
	
		self:NextThink( (CurTime()+18.5)-self:GetNWFloat("omass"))
	return true
	end
	end

