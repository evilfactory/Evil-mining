include('shared.lua')
function ENT:Draw()
	if SERVER then return end
	self:DrawModel() 
	
	end