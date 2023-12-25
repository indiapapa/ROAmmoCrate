//=============================================================================
// ROVolumeSpawnProtection
//=============================================================================
// A Volume that protects a spawn by killing anyone who enters and is not on
//  the Owning Team
//
//  Modified for RS2 to force weapon lowering and "grandfather" players who are
//  within the volume when it activates. - Austin
//  Modified for RS2: Vietnam to trigger a 'Retreat!' message for grandfathered
//  players. - Nate
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2007 Tripwire Interactive LLC
// - Dayle "Xienen" Flowers
//=============================================================================

class ROVolumeSpawnProtection_Ext extends ROVolumeSpawnProtection;

var  	class<DamageType>	DamageType;

function OnTouch(Actor Other)
{
	local ROPawn ROP;
	local ROVehicle ROV;
	local ROTurret ROTu;
	local ROVehicleHelicopter ROVH;
	local bool bValidVehicle;
	

	if(!bEnabled)
		return;

	ROP = ROPawn(Other);
	ROV = ROVehicle(Other);
	ROVH = ROVehicleHelicopter(Other);
	ROTu = ROTurret(Other);

	// RS2PR-6061 - Updated this to function properly when the helo enters the active spawn protection volume.
	bValidVehicle = bIgnoreAirborne || ROVehicleHelicopter(ROV) == none || (!bIgnoreAirborne && ROVehicleHelicopter(ROV).bVehicleOnGround) ||  ROVehicleHelicopter(ROV).bWasChassisTouchingGroundLastTick;

	if( ROTu != none )
	{
	    ROP = ROPawn(ROTu.Driver);
	}

	if ( ROP != none )
	{
		ROP.VolumeEnterCountBothSpawnProt++;

		if ( ROP.GetTeamNum() == OwningTeam )
		{
			return;
		}

		ROP.VolumeEnterCountSpawnProt++;

		if( !ROP.bImmuneToSpawnProtection )
		{
			if(ROTu != none) // kick us out of the turret
			{
				ROTu.DriverLeave(true);
			}

			// lower weapons

			if( WorldInfo.TimeSeconds - ROP.VolumeExitTimeSpawnProt < 0.5 )
				ROP.ForceLowerWeapons();
			else
				ROP.ForceLowerWeaponsWithDelay();
		}

		if(ROPlayerController(ROP.Controller) != none)
		{
			if(ROP.bImmuneToSpawnProtection && !ROP.bWasInVolForTeamFlip)
			{
				// Tell the player they have left the combat zone.
				ROPlayerController(ROP.Controller).ReceiveLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_SpawnProtectionWarning,,, self);
				ROPlayerController(ROP.Controller).ClientTriggerSpawnProtection();
			}
			//else if(ROP.bWasInVolForTeamFlip && !ROP.bImmuneToSpawnProtection && !ROP.IsTimerActive('ShowGrandfatherSpawnProtectionMessage'))
			else if(!ROP.IsTimerActive('ShowGrandfatherSpawnProtectionMessage'))
			{
				// Tell the player they have left the combat zone.
				// Fix CLBIT-3453 Send our initial "GTFO" grandfathered spawn protection message. -Nate
				ROPlayerController(ROP.Controller).ReceiveLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_SpawnProtGrandfathered,,, self);

				// Kick off our timer to pester the player to gtfo.
				ROP.ToggleGrandfatherSpawnProtectionMessage();
			}
		}
	}
	else if ( ROVH != none && ROVH.bTransportHelicopter && !bValidVehicle)
	{
		if (ROVH.GetTeamNum() == OwningTeam) // Futre/Mod proofing?
		{
			return;
		}

		ROVH.bInSpawnProtection = true; // RS2PR-730 -Nate
	}
	else if(ROV != none)
	{
		if(ROV.GetTeamNum()== OwningTeam)
		{
			return;
		}
		if(ROVehicleTank(ROV) != none)
		{
			ROV.TakeDamage(10000, none, Location, vect(0, 0, 0), DamageType);
		}
		if(ROVehicleTransport(ROV) != none)
		{
			ROV.TakeDamage(10000, none, Location, vect(0, 0, 0), DamageType);
		}
	}

}

event SetEnabled(bool bNewValue)
{
	local int i;
	local ROPlantedTrap trap;
	local ROSatchelChargeProjectile VNREP;
	local ROGunshipTarget VNGT;
	local ROTeamInfo EnemyTeam;
	local Pawn P;
	local ROPawn ROP;
	local ROVehicle ROV;
	local ROGameInfo ROGI;

	if ( bEnabled == bNewValue )
		return;

	if ( bNewValue )
	{
		// Must do grandfathering BEFORE enabling collision, otherwise
		// everyone is 'Touched' before bImmuneToSpawnProtection is set!
		if(Role == ROLE_Authority)
		{
			foreach WorldInfo.AllPawns(class'Pawn', P)
			{
				if( P.GetTeamNum() == OwningTeam || !Encompasses(P) )
				{
					continue;
				}

				if(ROTurret(P) != none)
				{
					ROP = ROPawn(ROTurret(P).Driver);
				}
				else if(ROVehicle(P) != none)
				{
					ROV = ROVehicle(P);
					for ( i = 0; i < ROV.Seats.Length; i++ )
					{
						if ( ROPawn(ROV.Seats[i].StoragePawn) != none )
						{
							ROPawn(ROV.Seats[i].StoragePawn).bWasInVolForTeamFlip = true;

							// Initially immune so we can warn them.
							if( ROPawn(ROV.Seats[i].StoragePawn).VolumeEnterCountSpawnProt == 0 )
								ROPawn(ROV.Seats[i].StoragePawn).bImmuneToSpawnProtection = true;
						}
					}
				}
				else if(ROPawn(P) != none)
				{
					ROP = ROPawn(P);
				}

				if(ROP != none)
				{
					ROP.bWasInVolForTeamFlip = true;

					if( ROP.VolumeEnterCountSpawnProt == 0 && WorldInfo.TimeSeconds - ROP.VolumeExitTimeSpawnProt >= 0.5 )
					{
						// Initially immune so we can warn them.
						ROP.bImmuneToSpawnProtection = true;
					}
				}
			}
		}

		bEnabled = true;
		SetCollision(true, bBlockActors);
	}
	else
	{
		// Clear bEnabled after SetCollision so we get eventUnTouch
		SetCollision(false, bBlockActors);
		bEnabled = false;
	}

	// Cleanup traps, targets, etc, within this volume

	if( OwningTeam == `ALLIES_TEAM_INDEX )
	{
		foreach DynamicActors(class'ROPlantedTrap', trap)
		{
			if( Encompasses(trap) )
			{
				ROPlayerController(trap.Instigator.Controller).RemovePlantedTrap(trap);
				trap.Shutdown();
			}
		}

		foreach DynamicActors(class'ROGunshipTarget', VNGT )
		{
			if( Encompasses(VNGT) )
			{
				VNGT.Destroy();
			}
		}
	}
	else
	{
		foreach DynamicActors(class'ROSatchelChargeProjectile', VNREP)
		{
			if( Encompasses(VNREP) && VNREP.IsA('VNRemoteExplosiveProjectile') )
			{
				ROPlayerController(VNREP.Instigator.Controller).RemoveCharge(VNREP);
				VNREP.Shutdown();
			}
		}
	}

	EnemyTeam =	ROTeamInfo(WorldInfo.GRI.Teams[1 - OwningTeam]);

	ROGI = ROGameInfo(WorldInfo.Game);
	for( i=0; i<`MAX_SQUADS; i++ )
	{
		if( EnemyTeam.SpawnTunnels[i] != none && EncompassesPoint(EnemyTeam.SpawnTunnels[i].Location) )
		{
			ROGI.AnalyticsLog("tunnel_Destroyed", "Enabled Volume Spawn Protection");
			EnemyTeam.SpawnTunnels[i].DestroySpawnPoint(true);
		}
	}
}

event UnTouch(Actor Other)
{
	if( bEnabled )
	{
		OnUnTouch( Other );
	}
}

function OnUnTouch(Actor Other)
{
	local ROPawn ROP;
	local ROVehicle ROV;
	local ROVehicleHelicopter ROVH;
	local ROTurret ROTu;
	local int i;
	local bool bValidVehicle;

	// Bail if we're in a training mode game.
	if(WorldInfo.GRI.GameClass.static.GetGameType() == ROGT_SinglePlayer)
	{
		return;
	}

	ROP = ROPawn(Other);
	ROTu = ROTurret(Other);
	ROV = ROVehicle(Other);
	ROVH = ROVehicleHelicopter(Other);

	// RS2PR-3371
	bValidVehicle = !bIgnoreAirborne || ROVehicleHelicopter(ROV) == none || ROVehicleHelicopter(ROV).bVehicleOnGround || ROVehicleHelicopter(ROV).bWasChassisTouchingGroundLastTick;

	// Even though turrets can't move, if the volume becomes disabled this function still gets triggered
	// We have to UnTouch the turret's driver, otherwise that player will have a permanent spawn protection warning stuck on their screen
	if( ROTu != none )
	{
		ROP = ROPawn(ROTu.Driver);
	}

	if ( ROP != none )
	{
		if ( ROP.VolumeEnterCountBothSpawnProt > 0 )
		{
			ROP.VolumeEnterCountBothSpawnProt--;
		}

		if ( ROP.GetTeamNum() == OwningTeam )
		{
			// ROP.ForceRaiseWeapons(); // Just in case
			return;
		}

		if ( ROP.VolumeEnterCountSpawnProt > 0 )
		{
			ROP.VolumeEnterCountSpawnProt--;
		}

		if( ROP.VolumeEnterCountSpawnProt == 0 )
		{
			if ( ROP.Controller != none && ROPlayerController(ROP.Controller) != none )
			{
				// Tell the player they have returned to the combat zone.
				ROPlayerController(ROP.Controller).ReceiveLocalizedMessage(class'ROLocalMessageGameRedAlert', RORAMSG_SpawnProtectionWarningUnTouch, , , self);
			}
			ROP.bImmuneToSpawnProtection = false;
			ROP.bWasInVolForTeamFlip = false;
			ROP.VolumeExitTimeSpawnProt = WorldInfo.TimeSeconds;
			ROP.ForceRaiseWeapons();

			ROP.ToggleGrandfatherSpawnProtectionMessage(true);
		}
	}
	else if(ROV != none && bValidVehicle)
	{
		for ( i = 0; i < ROV.Seats.Length; i++ )
		{
			if ( ROVehicleBase(ROV.Seats[i].SeatPawn) != none )
			{
				// Not 100% sure this is still needed but we'll leave it just in case (don't want players walking around immune to spawn protection). -Nate
				if(ROPawn(ROV.Seats[i].StoragePawn) != none)
				{
					ROPawn(ROV.Seats[i].StoragePawn).bImmuneToSpawnProtection = false;
					ROPawn(ROV.Seats[i].StoragePawn).bWasInVolForTeamFlip = false;

				}
			}
		}
	}
	else if (ROVH != none && ROVH.bTransportHelicopter)
	{
		if(ROVH.GetTeamNum() == OwningTeam) // Futre/Mod proofing?
		{
			return;
		}

		ROVH.bInSpawnProtection = false; // RS2PR-730 -Nate
	}
	else if(ROV != none)
	{
		if(ROV.GetTeamNum()== OwningTeam)
			return;
	}
}

DefaultProperties
{
	bPawnsOnly=true
	bCollideActors=false
	bStatic=false
	DamageType = class'RODmgTypeMineField';
	bColored=true
	BrushColor=(R=169,G=93,B=22,A=255)

	WarningInterval=5.f
}
