include('shared.lua')


function ENT:Draw()
	if SERVER then return end
	self:DrawModel() 
	
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
		Entidade:SetNWFloat("Money",self:Getore()*3)
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
    self:SetNWFloat("porce",self:GetNWFloat("porce")+0.5)
  
    self:SetNWFloat("combustivel",self:GetNWFloat("combustivel")-(self:Getoremass()/10)*0.025)
else
	self:SetColor(Color(255,255,255))
	end
		self:NextThink( CurTime() )
	return true
	end
end






function ENT:DrawTranslucent() -- Combustivel
if SERVER then return end
        
        self:SetNWInt("rota", self:GetNWInt("rota", 0)+1)
        local porce = self:GetNWFloat("porce")
        local combusti = self:GetNWFloat("combustivel")
        
		 cam.Start3D2D(self:GetPos()+Vector(0,0,45), Angle(0,self:GetNWInt("rota", 0),90), 0.1)
		 	draw.SimpleText( "Modern Refinary", "FonteEntidade1", 0, -200, Color( 0, 255, 0, 255 ),1, 1 )
		 	
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

		 cam.Start3D2D(self:GetPos()+Vector(0,0,45), Angle(0,self:GetNWInt("rota", 0)+180,90), 0.1)
		 	draw.SimpleText( "Progress "..math.Round(porce), "FonteEntidade2", 0, -15, Color( 255, 255, 0, 255 ),1, 0 )
		 	draw.SimpleText( "Modern Refinary", "FonteEntidade1", 0, -200, Color( 0, 255, 0, 255 ),1, 1 )
		 	draw.SimpleText( "Combustivel "..math.Round(combusti), "FonteEntidade2", 0, -100, Color( 255, 78, 0, 255 ),1, 0 )
		 	
		 
		 cam.End3D2D()
		 
end