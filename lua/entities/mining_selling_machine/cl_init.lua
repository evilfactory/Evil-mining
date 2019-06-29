include('shared.lua')


function ENT:Draw()
	if SERVER then return end
	self:DrawModel() 
	
	end

function ENT:DrawTranslucent()
if SERVER then return end
	
        self:SetNWInt( "rota", self:GetNWInt("rota", 0)+1 )
        
		 cam.Start3D2D(self:GetPos()+Vector(0,0,45), Angle(0,self:GetNWInt("rota", 0),90), 0.1)
		 	draw.SimpleText( "Selling Machine", "FonteEntidade1", 0, -100, Color( 0, 255, 0, 255 ),1, 1 )
		 	draw.SimpleText( math.Round(self:GetNWInt("Money")).."$", "FonteEntidade1", 0, 0, Color( 0, 255, 0, 255 ),1, 1 )
	
		 cam.End3D2D()

		 cam.Start3D2D(self:GetPos()+Vector(0,0,45), Angle(0,self:GetNWInt("rota", 0)+180,90), 0.1)
		 	draw.SimpleText( "Selling Machine", "FonteEntidade1", 0, -100, Color( 0, 255, 0, 255 ),1, 1 )
		 	 	draw.SimpleText( math.Round(self:GetNWInt("Money")).."$", "FonteEntidade1", 0, 0, Color( 0, 255, 0, 255 ),1, 1 )
		 cam.End3D2D()
		 
end