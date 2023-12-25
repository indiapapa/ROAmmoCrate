class ROPlayerControllerAC extends ROPlayerController
config(ROAmmoCrate_Client);

simulated function PreBeginPlay()
{
    super.PreBeginPlay();

    ReplaceRoles();
    ReplaceInventoryManager();

}
simulated function ReceivedGameClass(class<GameInfo> GameClass)
{
    super.ReceivedGameClass(GameClass);

    ReplaceRoles();
    ReplaceInventoryManager();
}

simulated function ReplaceInventoryManager()
{
    ROPawn_Ext(Pawn).InventoryManagerClass = class'ROInventoryManagerAC';
}

simulated function ReplaceRoles()
{
    local ROMapInfo ROMI;
    local RORoleCount RORC;
    local int I;
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());
    if (ROMI != None)
    {
    `log("Replacing roles...");
     I = 0;
        ForEach ROMI.NorthernRoles(RORC)
        { 
	    if (RORC.RoleInfoClass == class'RORoleInfoNorthernRadioman')
            {
                ROMI.NorthernRoles[I].RoleInfoClass = class'RORoleInfoNorthernRadiomanAC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
	    if (RORC.RoleInfoClass == class'RORoleInfoNorthernRadiomanNLF')
            {
                ROMI.NorthernRoles[I].RoleInfoClass = class'RORoleInfoNorthernRadiomanNLF_AC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
	    if (RORC.RoleInfoClass == class'RORoleInfoNorthernSapper')
            {
                ROMI.NorthernRoles[I].RoleInfoClass = class'RORoleInfoNorthernSapperAC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
            if (RORC.RoleInfoClass == class'RORoleInfoNorthernSapperNLF')
            {
                ROMI.NorthernRoles[I].RoleInfoClass = class'RORoleInfoNorthernSapperNLF_AC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
            I++;
        }

        I = 0;
        ForEach ROMI.SouthernRoles(RORC)
        { 
            if (RORC.RoleInfoClass == class'RORoleInfoSouthernRifleman')
            {
                ROMI.SouthernRoles[I].RoleInfoClass = class'RORoleInfoSouthernRiflemanAC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
            if (RORC.RoleInfoClass == class'RORoleInfoSouthernEngineer')
            {
                ROMI.SouthernRoles[I].RoleInfoClass = class'RORoleInfoSouthernEngineerAC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
	    if (RORC.RoleInfoClass == class'RORoleInfoSouthernEngineerARVN')
            {
                ROMI.SouthernRoles[I].RoleInfoClass = class'RORoleInfoSouthernEngineerARVNAC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
	    if (RORC.RoleInfoClass == class'RORoleInfoSouthernEngineerAUS')
            {
                ROMI.SouthernRoles[I].RoleInfoClass = class'RORoleInfoSouthernEngineerAUSAC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
	    if (RORC.RoleInfoClass == class'RORoleInfoSouthernEngineerUSMC')
            {
                ROMI.SouthernRoles[I].RoleInfoClass = class'RORoleInfoSouthernEngineerUSMCAC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
            if (RORC.RoleInfoClass == class'RORoleInfoSouthernGrenadier')
            {
                ROMI.SouthernRoles[I].RoleInfoClass = class'RORoleInfoSouthernGrenadierAC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
	    if (RORC.RoleInfoClass == class'RORoleInfoSouthernGrenadierUSMC')
            {
                ROMI.SouthernRoles[I].RoleInfoClass = class'RORoleInfoSouthernGrenadierUSMCAC';
                `log("Replaced RoleInfoClass " $ RORC.RoleInfoClass);
            }
            I++;
        
    	}
    }
    else
	{
		`log("Unable to replace roles.");
	}
}
reliable client function ClientReplaceRoles()
{
    ReplaceRoles();
}

reliable client function ClientReplaceInventoryManager()
{
    ReplaceInventoryManager();
}

exec function GoThirdPerson()
{
	if (WorldInfo.NetMode != NM_Standalone)
	{
		ClientMessage("Only in Singleplayer");
		return;
	}
	else
	{
		SetCameraMode('ThirdPerson');
	}
}

exec function GoFirstPerson()
{
	if (WorldInfo.NetMode != NM_Standalone)
	{
		ClientMessage("Only in Singleplayer");
		return;
	}
	else
	{
		SetCameraMode('FirstPerson');
	}
}

exec function GoFreeCam()
{
	if (WorldInfo.NetMode != NM_Standalone)
	{
		ClientMessage("Only in Singleplayer");
		return;
	}
	else
	{
		SetCameraMode('FreeCam');
	}
}
simulated exec function SpawnM113US()
{
	local vector                    CamLoc, StartShot, EndShot, X, Y, Z;
	local rotator                   CamRot;
	local class<ROVehicleTransport>          TransportClass;
	Local ROVehicleTransport ROVT;

	if (WorldInfo.NetMode != NM_Standalone)
	{
		ClientMessage("Only in Singleplayer");
		return;
	}
	else
	{
		GetPlayerViewPoint(CamLoc, CamRot);

		// Do ray check and grab actor
		GetAxes( CamRot, X, Y, Z );
		StartShot   = CamLoc;
		EndShot     = StartShot + (200.0 * X);

		TransportClass = class<ROVehicleTransport>(DynamicLoadObject("ROAmmoCrate.ROVehicle_M113_US_Content", class'Class'));
		ClientMessage("Spawned a M113");
		if( TransportClass != none )
		{
			ROVT = Spawn(TransportClass, , , EndShot);
			ROVT.Mesh.AddImpulse(vect(0,0,1), ROVT.Location);
		}
	}
}
simulated exec function SpawnT54()
{
	local vector                    CamLoc, StartShot, EndShot, X, Y, Z;
	local rotator                   CamRot;
	local class<ROVehicle>          TankClass;
	Local ROVehicle ROTank;

	if (WorldInfo.NetMode != NM_Standalone)
	{
		ClientMessage("Only in Singleplayer");
		return;
	}
	else
	{
		GetPlayerViewPoint(CamLoc, CamRot);

		// Do ray check and grab actor
		GetAxes( CamRot, X, Y, Z );
		StartShot   = CamLoc;
		EndShot     = StartShot + (200.0 * X);

		TankClass = class<ROVehicle>(DynamicLoadObject("ROAmmoCrate.ROVehicle_T54_Content", class'Class'));
		ClientMessage("Spawned a T54 Tank");
		if( TankClass != none )
		{
			ROTank = Spawn(TankClass, , , EndShot);
			ROTank.Mesh.AddImpulse(vect(0,0,1), ROTank.Location);
		}
	}
}

simulated exec function SpawnM41()
{
	local vector                    CamLoc, StartShot, EndShot, X, Y, Z;
	local rotator                   CamRot;
	local class<ROVehicle>          TankClass;
	Local ROVehicle ROTank;

	if (WorldInfo.NetMode != NM_Standalone)
	{
		ClientMessage("Only in Singleplayer");
		return;
	}
	else
	{
		GetPlayerViewPoint(CamLoc, CamRot);

		// Do ray check and grab actor
		GetAxes( CamRot, X, Y, Z );
		StartShot   = CamLoc;
		EndShot     = StartShot + (200.0 * X);

		TankClass = class<ROVehicle>(DynamicLoadObject("ROAmmoCrate.ROVehicle_M41_Content", class'Class'));
		ClientMessage("Spawned a M41 Tank");
		if( TankClass != none )
		{
			ROTank = Spawn(TankClass, , , EndShot);
			ROTank.Mesh.AddImpulse(vect(0,0,1), ROTank.Location);
		}
	}
}
simulated exec function SpawnSlickUS()
{
	local vector                    CamLoc, StartShot, EndShot, X, Y, Z;
	local rotator                   CamRot;
	local class<ROVehicleHelicopter_Ext>          HeliClass;
	Local ROVehicleHelicopter_Ext ROHelicopter;

	if (WorldInfo.NetMode != NM_Standalone)
	{
		ClientMessage("Only in Singleplayer");
		return;
	}
	else
	{
		GetPlayerViewPoint(CamLoc, CamRot);

		// Do ray check and grab actor
		GetAxes( CamRot, X, Y, Z );
		StartShot   = CamLoc;
		EndShot     = StartShot + (200.0 * X);

		HeliClass = class<ROVehicleHelicopter_Ext>(DynamicLoadObject("ROAmmoCrate.ROHeli_UH1H_US_Slick_Content", class'Class'));
		ClientMessage("Spawned Slick");
		if( HeliClass != none )
		{
			ROHelicopter = Spawn(HeliClass, , , EndShot);
			ROHelicopter.Mesh.AddImpulse(vect(0,0,1), ROHelicopter.Location);
		}
	}
}