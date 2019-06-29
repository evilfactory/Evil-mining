include('shared.lua')

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


if CLIENT then
	
		net.Receive( "initminingderma", function( len, ply )
	local entisa = net.ReadEntity()
	local selected = 1
			
local Frame = vgui.Create( "DFrame" )
Frame:SetSize( 300, 300 )
Frame:Center()
Frame:SetTitle( "Select Recipe" )
Frame:SetVisible( true )
Frame:SetDraggable( false )
Frame:ShowCloseButton( true )
Frame:MakePopup()

function Frame:Paint( w, h )
	draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0,200 ) )
end

local need1 = {"Iron","Tin","Zinco"}
local need2 = {"Carbon","Copper","Copper"}
local reward = {"Steel","Bronze","Brass"}	
local value = {4,8,12}
local color = {Vector(90,90,90),Vector(255,135,0),Vector(255,100,0)
	
}

if entisa:IsValid() == false then return end 
local buttonos = {}
for i=1, table.Count(need1) do 
buttonos[i] = vgui.Create( "DButton", Frame ) 
buttonos[i]:SetText( need1[i].." Ingot + "..need2[i].." Ingot = "..reward[i] )		
buttonos[i]:SetSize( 250, 30 )
buttonos[i]:SetPos( 25, 50*i )

local current = buttonos[i]

function current:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 10, 10 ) )
end

if i > entisa:GetNWInt("smeltlevel") then continue end


function current:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
end

if entisa:GetNWInt("indexx") == i then
	function current:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 150, 0 ) )
end

	end

buttonos[i].DoClick = function()
	
    if entisa:IsValid() == false then return end 
	
	net.Start("modificaaiman")
	entisa:SetNWInt("indexx", i)
	net.WriteString(need1[i])
	net.WriteString(need2[i])
	net.WriteString(reward[i])
    net.WriteFloat(value[i])
    net.WriteVector(color[i])
	net.SendToServer()


selected = i
for i=1, entisa:GetNWInt("smeltlevel") do 
	local paint = buttonos[i]
	function paint:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
end

end

function current:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 150, 0 ) )
end

	
end

end
		end)
	
	end


function ENT:Draw()
	if SERVER then return end
	self:DrawModel() 
	
	end

function ENT:DrawTranslucent()  -- Combustivel
if SERVER then return end
	
	        local porce = self:GetNWFloat("porce")
        local combusti = self:GetNWFloat("combustivel")
	
         self:SetNWInt("rota", self:GetNWInt("rota", 0)+1) 
		 cam.Start3D2D(self:GetPos()+Vector(0,0,45), Angle(0,self:GetNWInt("rota", 0),90), 0.1)
		 	draw.SimpleText( "Quick Smelting", "FonteEntidade1", 0, -200, Color( 0, 255, 0, 255 ),1, 1 )
		 	
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
		 	draw.SimpleText( "Quick Smelting", "FonteEntidade1", 0, -200, Color( 0, 255, 0, 255 ),1, 1 )
		 	draw.SimpleText( "Combustivel "..math.Round(combusti), "FonteEntidade2", 0, -100, Color( 255, 78, 0, 255 ),1, 0 )
		 	
		 
		 cam.End3D2D()

end