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
            
    local letsee = math.random(0,100)

   

if letsee < 70 then
    local Pos = self:LocalToWorld(Vector(0,80,0))
        local Entidade = ents.Create("mining_uranium")
        Entidade:SetPos(Pos)
        Entidade:CPPISetOwner(self:Getpers())
        Entidade:SetNWFloat("Money",self:Getore()*3.25)
        Entidade:SetColor(Color(75,90,75,255))
        Entidade:SetNWString("typ","238")
        Entidade:SetNWFloat("omass",self:Getoremass())
        Entidade:Spawn()
        Entidade:GetPhysicsObject():SetMass(self:Getoremass())
        self:Setcan(true)
else
    local Pos = self:LocalToWorld(Vector(0,80,0))
        local Entidade = ents.Create("mining_uranium")
        Entidade:SetPos(Pos)
        Entidade:CPPISetOwner(self:Getpers())
        Entidade:SetNWFloat("Money",self:Getore()*15)
        Entidade:SetColor(Color(30,40,30,255))
        Entidade:SetNWString("typ","235")
        Entidade:SetNWFloat("omass",self:Getoremass())
        Entidade:Spawn()
        Entidade:GetPhysicsObject():SetMass(self:Getoremass())
        self:Setcan(true)
    
end
        
        end
        end
        
        self:SetNWFloat("porce",0)
        delay2 = 5
        self:SetRefining(false)
        return
    end
    if self:GetNWFloat("combustivel") > 0 then
    self:SetNWFloat("porce",self:GetNWFloat("porce")+1)
  
    self:SetNWFloat("combustivel",self:GetNWFloat("combustivel")-(self:Getoremass()/10)*0.03)
else
    self:SetColor(Color(255,255,255))
    end
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
        local Ang = self:LocalToWorldAngles(Angle(0,180,90))
        local Pos = self:LocalToWorld(Vector(0,67,45))
		 cam.Start3D2D(Pos,Ang, 0.1)
		 	draw.SimpleText( "Centrifuge", "FonteEntidade1", 0, -200, Color( 0, 255, 0, 255 ),1, 1 )
		 	
            	surface.SetDrawColor( 100, 100, 100, 255 )           	
            	surface.DrawRect( -100*10/2, -15, 100*10, 50 )

            	
                surface.SetDrawColor( 0, 0, 255, 255 )
            	surface.DrawOutlinedRect( -100*10/2, -15, 100*10, 51 )
            	
            	surface.SetDrawColor( 150, 150, 0, 255 )
            	surface.DrawRect( -porce*10/2, -15, porce*10, 50 )
         
         		draw.SimpleText( "Progress "..math.Round(porce), "FonteEntidade2", 0, -15, Color( 255, 255, 0, 255 ),1, 0 )
		 	   
		 	   
		 	   
		 	    surface.SetDrawColor( 100, 100, 100, 255 )           	
            	surface.DrawRect( -100*10/2, -100, 100*10, 50 )

            	
                surface.SetDrawColor( 0, 0, 255, 255 )
            	surface.DrawOutlinedRect( -100*10/2, -100, 100*10, 51 )
            	
            	surface.SetDrawColor( 200, 78, 0, 255 )
            	surface.DrawRect( -combusti*10/2, -100, combusti*10, 50 )
         
         		draw.SimpleText( "Combustivel "..math.Round(combusti), "FonteEntidade2", 0, -100, Color( 255, 78, 0, 255 ),1, 0 )
		 	
		 cam.End3D2D()
local Ang = self:LocalToWorldAngles(Angle(0,0,90))
		 cam.Start3D2D(Pos,Ang, 0.1)	 	
		 draw.SimpleText( "Progress "..math.Round(porce), "FonteEntidade2", 0, -15, Color( 255, 255, 0, 255 ),1, 0 )
		 	draw.SimpleText(  "Centrifuge", "FonteEntidade1", 0, -200, Color( 0, 255, 0, 255 ),1, 1 )
		 	draw.SimpleText( "Combustivel "..math.Round(combusti), "FonteEntidade2", 0, -100, Color( 255, 78, 0, 255 ),1, 0 )
		
		 cam.End3D2D()
		 
end