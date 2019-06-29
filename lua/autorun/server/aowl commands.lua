if CLIENT then return end
aowl.AddCommand("clearores|removeores",function(ply,line)
for _, v in pairs( ents.GetAll() ) do
	if(v:GetClass() == "mining_rock") then
		v:Remove()
	end
end	
end,"developers")