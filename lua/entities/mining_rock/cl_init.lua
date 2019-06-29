include('shared.lua')


function ENT:Draw() 
if SERVER then return end
	self:DrawModel() 
end

function ENT:DrawTranslucent()
if SERVER then return end
	
  self:SetNWInt( "rota", self:GetNWInt("rota", 0)+1 )
     
    if ply:GetEyeTrace().Entity == self || ply:GetNWBool("mining_aiminfo") == false then
    
		 cam.Start3D2D(self:GetPos()+Vector(0,0,15), Angle(0,self:GetNWInt("rota", 0),90), 0.1)
		 	draw.SimpleText( self:GetNWFloat("omass").."KG", "FonteEntidade1", 0, 0, Color( 0, 255, 0, 255 ),1, 1 )
		 draw.SimpleText( self:GetNWString("typ"), "FonteEntidade1", 0, -100, Color( 0, 255, 0, 255 ),1, 1 )
		 cam.End3D2D()

		 cam.Start3D2D(self:GetPos()+Vector(0,0,15), Angle(0,self:GetNWInt("rota", 0)+180,90), 0.1)
		 draw.SimpleText( self:GetNWString("typ"), "FonteEntidade1", 0, -100, Color( 0, 255, 0, 255 ),1, 1 )
		 	draw.SimpleText( self:GetNWFloat("omass").."KG", "FonteEntidade1", 0, 0, Color( 0, 255, 0, 255 ),1, 1 )
		 cam.End3D2D()
		 end
		 
end	