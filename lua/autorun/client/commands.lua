if CLIENT then

concommand.Add( "mining_aiminfo_enable", function( ply, cmd, args )
    ply:SetNWBool("mining_aiminfo",true)
end )
concommand.Add( "mining_aiminfo_disable", function( ply, cmd, args )
ply:SetNWBool("mining_aiminfo",false)
end )
concommand.Add( "mining_version", function( ply, cmd, args )
     print("V1.3.6")
end )


end