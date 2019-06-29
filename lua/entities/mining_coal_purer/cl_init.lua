include('shared.lua')


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


function ENT:Draw()
	if SERVER then return end
	self:DrawModel() 
	
	end

function ENT:DrawTranslucent() -- Combustivel
if SERVER then return end
        
        local porce = self:GetNWFloat("porce")
        local combusti = self:GetNWFloat("combustivel")
        local Ang = self:LocalToWorldAngles(Angle(0,270,90))
        local Pos = self:LocalToWorld(Vector(30,0,-50))
		 cam.Start3D2D(Pos,Ang, 0.1)
		 	draw.SimpleText( "Coal Purifier", "FonteEntidade1", 0, -150, Color( 0, 255, 0, 255 ),1, 1 )
		 	
            	surface.SetDrawColor( 100, 100, 100, 255 )           	
            	surface.DrawRect( -100*10/2, -15, 100*10, 50 )

            	
                surface.SetDrawColor( 0, 0, 255, 255 )
            	surface.DrawOutlinedRect( -100*10/2, -15, 100*10, 51 )
            	
            	surface.SetDrawColor( 150, 150, 0, 255 )
            	surface.DrawRect( -porce*10/2, -15, porce*10, 50 )
         
         		draw.SimpleText( "Progress "..math.Round(porce), "FonteEntidade2", 0, -15, Color( 255, 255, 0, 255 ),1, 0 )
		 	   
		 	   
		 
		 	
		 cam.End3D2D()
local Ang = self:LocalToWorldAngles(Angle(0,90,90))
		 cam.Start3D2D(Pos,Ang, 0.1)	 	
		 draw.SimpleText( "Progress "..math.Round(porce), "FonteEntidade2", 0, -15, Color( 255, 255, 0, 255 ),1, 0 )
		 	draw.SimpleText(  "Coal Purer", "FonteEntidade1", 0, -150, Color( 0, 255, 0, 255 ),1, 1 )
		
		 cam.End3D2D()	
		 
end