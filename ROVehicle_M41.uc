//=============================================================================
// ROVehicle_M41
//=============================================================================
// Based on T34, seat transitions from PanzerIVG
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - 
//============================================================================
class ROVehicle_M41 extends ROVehicleTank_Ext
	abstract;

var name PeriscopeGunnerCameraTag;


var	array<MaterialInstanceConstant>	ReplacedExteriorMICs;
var	MaterialInstanceConstant		ExteriorMICs[2];		// 0 = Exterior Texture, 1 = Unused
var	bool							bGeneratedExteriorMICs;

var	array<MaterialInstanceConstant>	ReplacedInteriorMICs;
var	MaterialInstanceConstant		InteriorMICs[4];		// 0 = Walls1, 1, Walls2, 2 = Driver/HullMG, 3 = Turret
var	bool							bGeneratedInteriorMICs;

//var	StaticMeshComponent		ExtExtraMesh;
var int TempInt;

/** Seat proxy death hit info */
var repnotify TakeHitInfo DeathHitInfo_ProxyDriver;
var repnotify TakeHitInfo DeathHitInfo_ProxyCommander;
var repnotify TakeHitInfo DeathHitInfo_ProxyLoader;

replication
{
	if (bNetDirty)
		DeathHitInfo_ProxyDriver, DeathHitInfo_ProxyCommander, DeathHitInfo_ProxyLoader;
}

/**
 * This event is triggered when a repnotify variable is received
 *
 * @param	VarName		The name of the variable replicated
 */
simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'DeathHitInfo_ProxyDriver')
	{
		if( IsLocalPlayerInThisVehicle() )
		{
			PlaySeatProxyDeathHitEffects(0, DeathHitInfo_ProxyDriver);
		}
	}
	else if (VarName == 'DeathHitInfo_ProxyCommander')
	{
		if( IsLocalPlayerInThisVehicle() )
		{
			PlaySeatProxyDeathHitEffects(1, DeathHitInfo_ProxyCommander);
		}
	}
	else if (VarName == 'DeathHitInfo_ProxyLoader')
	{
		if( IsLocalPlayerInThisVehicle() )
		{
			PlaySeatProxyDeathHitEffects(2, DeathHitInfo_ProxyLoader);
		}
	}
	else
	{
	   super.ReplicatedEvent(VarName);
	}
}

simulated event PostBeginPlay()
{
    

    super.PostBeginPlay();

		ShellController = ROSkelControlCustomAttach(mesh.FindSkelControl('ShellCustomAttach'));
	
    /*if( WorldInfo.NetMode != NM_DedicatedServer )
    	{
       		mesh.MinLodModel = 1;

		Mesh.AttachComponent(ExtExtraMesh, 'chassis');

		ExtExtraMesh.SetShadowParent(Mesh);
    	}*/
	//if ( bDeleteMe )
	//	return;
}

simulated event TornOff()
{
    // Clear the ambient firing sounds
    //HullMGAmbient.Stop();
    //CoaxMGAmbient.Stop();

    Super.TornOff();
}

/** turns off all sounds */
simulated function StopVehicleSounds()
{
    Super.StopVehicleSounds();

    // Clear the ambient firing sounds
    //HullMGAmbient.Stop();
    //CoaxMGAmbient.Stop();
}

// Overridden to switch to the 6th seat position instead of changing fire mode
simulated exec function SwitchFireMode()
{
	ServerChangeSeat(5);
}



// UC has unusual texture slots for the destroyed mesh. Handle it here.
simulated state DyingVehicle
{
	/** client-side only effects */
	simulated function PlayDeathEffects()
	{
		SwapToDestroyedMesh();

		if ( DestroyedMaterial != none )
		{
			Mesh.SetMaterial(0, DestroyedMaterial);
		}

		PlayVehicleExplosion(false);

		VehicleEvent('Destroyed');
	}
}


/**
 * Handle giving damage to seat proxies
 * @param SeatProxyIndex the Index in the SeatProxies array of the Proxy to Damage
 * @param Damage the base damage to apply
 * @param InstigatedBy the Controller responsible for the damage
 * @param HitLocation world location where the hit occurred
 * @param Momentum force caused by this hit
 * @param DamageType class describing the damage that was done
 * @param DamageCauser the Actor that directly caused the damage (i.e. the Projectile that exploded, the Weapon that fired, etc)
 */
function DamageSeatProxy(int SeatProxyIndex, int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional Actor DamageCauser)
{
	// Update the hit info for each seat proxy pertaining to this vehicle
	switch( SeatProxyIndex )
	{
	case 0:
		// Driver
		DeathHitInfo_ProxyDriver.Damage = Damage;
		DeathHitInfo_ProxyDriver.HitLocation = HitLocation;
		DeathHitInfo_ProxyDriver.Momentum = Momentum;
		DeathHitInfo_ProxyDriver.DamageType = DamageType;
		break;
	case 1:
		// Commander
		DeathHitInfo_ProxyCommander.Damage = Damage;
		DeathHitInfo_ProxyCommander.HitLocation = HitLocation;
		DeathHitInfo_ProxyCommander.Momentum = Momentum;
		DeathHitInfo_ProxyCommander.DamageType = DamageType;
		break;

	case 2:
		// Loader
		DeathHitInfo_ProxyLoader.Damage = Damage;
		DeathHitInfo_ProxyLoader.HitLocation = HitLocation;
		DeathHitInfo_ProxyLoader.Momentum = Momentum;
		DeathHitInfo_ProxyLoader.DamageType = DamageType;
		break;
	}

	// Call super!
	Super.DamageSeatProxy(SeatProxyIndex, Damage, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}
simulated function int GetCommanderSeatIndex()
{
	return GetSeatIndexFromPrefix("Turret");
}

simulated function ZoneHealthDamaged(int ZoneIndexUpdated, optional Controller DamageInstigator)
{
    local float ZoneHealthPercentage;

    super.ZoneHealthDamaged(ZoneIndexUpdated, DamageInstigator);

    if ( WorldInfo.NetMode != NM_DedicatedServer )
    {
        if ( VehHitZones[ZoneIndexUpdated].ZoneName == 'MAINCANNONREAR' )
        {
            ZoneHealthPercentage = float(VehHitzones[ZoneIndexUpdated].ZoneHealth) / float(default.VehHitzones[ZoneIndexUpdated].ZoneHealth);

            if ( Mesh.ForcedLodModel == 1 )
            {
                // Main gun
                InteriorMICs[2].SetScalarParameterValue('damage01', 1.0 - ZoneHealthPercentage);
            }
        }
    }
}

simulated function ZoneHealthRepaired(int ZoneIndexUpdated)
{
    local float ZoneHealthPercentage;

    super.ZoneHealthRepaired(ZoneIndexUpdated);

    if ( WorldInfo.NetMode != NM_DedicatedServer )
    {
        if ( VehHitZones[ZoneIndexUpdated].ZoneName == 'MAINCANNONREAR' )
        {
            ZoneHealthPercentage = float(VehHitzones[ZoneIndexUpdated].ZoneHealth) / float(default.VehHitzones[ZoneIndexUpdated].ZoneHealth);

            if ( Mesh.ForcedLodModel == 1 )
            {
                // Main gun
                InteriorMICs[2].SetScalarParameterValue('damage01', 1.0 - ZoneHealthPercentage);
            }
        }
    }
}

/**
 * Called when the health of a ArmorPlateZoneHealths changes. Called directly on
 * the server and through replication of ArmorPlateZoneHealthsCompressed on the
 * client.
 *
 * @param	HitArmorZoneType  The index of the ArmorPlateZoneHealths whose health changed
 */
simulated function ArmorZoneHealthUpdated(int HitArmorZoneType)
{
	local float FrontHealthPercentage, BackHealthPercentage;
	local float LeftHealthPercentage, RightHealthPercentage;
	local float TurretHealthPercentage;
	local int MostDamagedTurretZone;

	super.ArmorZoneHealthUpdated(HitArmorZoneType);

	if ( WorldInfo.NetMode != NM_DedicatedServer )
	{
		if( HitArmorZoneType == AZT_Front || HitArmorZoneType == AZT_Left || HitArmorZoneType == AZT_Right )
		{
			FrontHealthPercentage = float(ArmorPlateZoneHealths[AZT_Front]) / float(default.ArmorPlateZoneHealths[AZT_Front]);
			LeftHealthPercentage = float(Max(ArmorPlateZoneHealths[AZT_Left],0)) / float(default.ArmorPlateZoneHealths[AZT_Left]);
			RightHealthPercentage = float(Max(ArmorPlateZoneHealths[AZT_Right],0)) / float(default.ArmorPlateZoneHealths[AZT_Right]);

			// Handle Interior damage
			if ( Mesh.ForcedLodModel == 1 )
			{
				if( FrontHealthPercentage < LeftHealthPercentage || FrontHealthPercentage < RightHealthPercentage )
				{
					//Damage the whole interior front if the front is more damaged than the sides
					// Driver area
					// TODO: Commented out til the textures are set up to show damage on the interior
//    				InteriorMICs[0].SetScalarParameterValue('damage02', 1.0 - FrontHealthPercentage);
//    				InteriorMICs[1].SetScalarParameterValue('damage02', 1.0 - FrontHealthPercentage);
//    				// Hull MG Area
//    				InteriorMICs[0].SetScalarParameterValue('damage03', 1.0 - FrontHealthPercentage);
//    				InteriorMICs[1].SetScalarParameterValue('damage03', 1.0 - FrontHealthPercentage);
				}
				else
				{
					// Driver area
					// TODO: Commented out til the textures are set up to show damage on the interior
//    				InteriorMICs[0].SetScalarParameterValue('damage02', 1.0 - LeftHealthPercentage);
//    				InteriorMICs[1].SetScalarParameterValue('damage02', 1.0 - LeftHealthPercentage);
//    				// Hull MG Area
//    				InteriorMICs[0].SetScalarParameterValue('damage03', 1.0 - RightHealthPercentage);
//    				InteriorMICs[1].SetScalarParameterValue('damage03', 1.0 - RightHealthPercentage);
				}
			}

			// Exterior damage
			ExteriorMICs[0].SetScalarParameterValue('Damage01', 1.0 - FrontHealthPercentage);
			ExteriorMICs[0].SetScalarParameterValue('Damage02', 1.0 - LeftHealthPercentage);
			ExteriorMICs[0].SetScalarParameterValue('Damage03', 1.0 - RightHealthPercentage);
		}
		else if( HitArmorZoneType == AZT_Back )
		{
			BackHealthPercentage = float(Max(ArmorPlateZoneHealths[AZT_Back],0)) / float(default.ArmorPlateZoneHealths[AZT_Back]);

			// Exterior damage
			ExteriorMICs[0].SetScalarParameterValue('Damage04', 1.0 - BackHealthPercentage);
		}
		else if( HitArmorZoneType == AZT_TurretFront || HitArmorZoneType == AZT_TurretBack ||
			HitArmorZoneType == AZT_TurretLeft || HitArmorZoneType == AZT_TurretRight )
		{
			MostDamagedTurretZone = AZT_TurretFront;

			if( ArmorPlateZoneHealths[AZT_TurretBack] < ArmorPlateZoneHealths[AZT_TurretFront] )
			{
				MostDamagedTurretZone = AZT_TurretBack;
			}

			if( ArmorPlateZoneHealths[AZT_TurretLeft] < ArmorPlateZoneHealths[MostDamagedTurretZone] )
			{
				MostDamagedTurretZone = AZT_TurretLeft;
			}

			if( ArmorPlateZoneHealths[AZT_TurretRight] < ArmorPlateZoneHealths[MostDamagedTurretZone] )
			{
				MostDamagedTurretZone = AZT_TurretRight;
			}

			TurretHealthPercentage = float(Max(ArmorPlateZoneHealths[MostDamagedTurretZone],0)) / float(default.ArmorPlateZoneHealths[MostDamagedTurretZone]);

			// Handle Interior damage
			if ( Mesh.ForcedLodModel == 1 )
			{
				// Turret area
				// TODO: Commented out til the textures are set up to show damage on the interior
				//InteriorMICs[0].SetScalarParameterValue('damage01', 1.0 - TurretHealthPercentage);
			}

			// Exterior damage
			ExteriorMICs[0].SetScalarParameterValue('Damage05', 1.0 - TurretHealthPercentage);
		}
	}
}
/**
 * Handle transitions between seats in the vehicle which need to be animated or
 * swap meshes. Here we handle the specific per vehicle implementation of the
 * visible animated transitions between seats or the mesh swapped proxy mesh
 * instant transitions. For animated transitions that involve the turret area,
 * it performs the first half of the transition, moving them to a position
 * under the turret area. These transitions must be split into two parts,
 * since the turret can rotate, we move the players to a position under the
 * turret that will always be in the same place no matter which direction the
 * turret is rotated. Then the second half of the transition starts from this
 * position.
 *
 * @param	DriverPawn	      The pawn driver that is transitioning seats
 * @param	NewSeatIndex      The SeatIndex the pawn is moving to
 * @param	OldSeatIndex      The SeatIndex the pawn is moving from
 * @param	bInstantTransition    True if this is an instant transition not an animated transition
 * Network: Called on network clients when the ROPawn Driver's VehicleSeatTransition
 * is changed. HandleSeatTransition is called directly on the server and in standalone
 */
simulated function HandleSeatTransition(ROPawn DriverPawn, int NewSeatIndex, int OldSeatIndex, bool bInstantTransition)
{
	local bool bAttachDriverPawn, bUseExteriorAnim;
	local float AnimTimer;
	local name TransitionAnim, TimerName;

	super.HandleSeatTransition(DriverPawn, NewSeatIndex, OldSeatIndex, bInstantTransition);

	if( bInstantTransition )
	{
		return;
	}

	bUseExteriorAnim = IsSeatPositionOutsideTank(OldSeatIndex);

	// Moving out of the driver seat
	if( OldSeatIndex == 0 )
	{
		// Transition from driver to commander
		if( NewSeatIndex == 1 )
		{
			TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranTurret' : 'Driver_TranTurret';
			TimerName = 'SeatTransitioningDriverToTurretGoalCommander';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
			bAttachDriverPawn = true;
		}
		// Transition from driver to loader
		else if( NewSeatIndex == 2 )
		{
			TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranTurret' : 'Driver_TranTurret';
			TimerName = 'SeatTransitioningDriverToTurretGoalLoader';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
			bAttachDriverPawn = true;
		}
	}
	// moving into the driver seat
	else if( NewSeatIndex == 0 )
	{
		// Transition from commander to driver
		if( OldSeatIndex == 1 )
		{
		    // Commander
			TransitionAnim = (bUseExteriorAnim) ? 'Com_Open_TranTurret' : 'Com_TranTurret';
			TimerName = 'SeatTransitioningCommanderToTurretGoalDriver';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
			bAttachDriverPawn = true;
		}
		// Transition from loader to driver
		else if( OldSeatIndex == 2 )
		{
		    // Gunner
			TransitionAnim = 'Loader_TranTurret';
			TimerName = 'SeatTransitioningLoaderToTurretGoalDriver';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
			bAttachDriverPawn = true;
		}
	}
	// Transition to Commander
	else if( NewSeatIndex == 1 )
	{
		// Transition from gunner to commander
		if( OldSeatIndex == 2 )
		{
		    // Gunner
			TransitionAnim = 'Com_gunnerTOclose';
			TimerName = 'SeatTransitioningOne';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
			//bAttachDriverPawn = true;
		}
	}
	// Transition to loader
	else if( NewSeatIndex == 2 )
	{
		// Transition from commander to loader
		if( OldSeatIndex == 1 )
		{
		    // Loader/gunner
			TransitionAnim = 'Com_closeTOloader';
			TimerName = 'SeatTransitioningTwo';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
			//bAttachDriverPawn = true;
		}
	}

	// Store a reference to the driver pawn making the transition so we can use
	// it for the second part of timer driven transitions
	Seats[NewSeatIndex].TransitionPawn = DriverPawn;

	// If this transition requires us to attach the driver to a different bone, do that here
	if( bAttachDriverPawn )
	{
		DriverPawn.SetBase( Self, , Mesh, Seats[NewSeatIndex].SeatTransitionBoneName);
		DriverPawn.SetRelativeLocation( Seats[NewSeatIndex].SeatOffset );
		DriverPawn.SetRelativeRotation( Seats[NewSeatIndex].SeatRotation );
	}

	Seats[OldSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);

	// Set up the transition and animation
	Seats[NewSeatIndex].bTransitioningToSeat = true;
	Seats[NewSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);

	AnimTimer = DriverPawn.Mesh.GetAnimLength(TransitionAnim);
	DriverPawn.PlayFullBodyAnimation(TransitionAnim);

	// Set up the timer for ending the transition
	SetTimer(AnimTimer, false, TimerName);
}

/**
 * Handle SeatProxy transitions between seats in the vehicle which need to be
 * animated or swap meshes. When called on the server the subclasses handle
 * replicating the information so the animations happen on the client
 * Since the transitions are very vehicle specific, all of the actual animations,
 * etc must be implemented in subclasses
 * @param	NewSeatIndex          The SeatIndex the proxy is moving to
 * @param	OldSeatIndex          The SeatIndex the proxy is moving from
 * Network: Called on network clients when the ProxyTransition variables
 * implemented in subclassare are changed. HandleProxySeatTransition is called
 * directly on the server and in standalone
 */
simulated function HandleProxySeatTransition(int NewSeatIndex, int OldSeatIndex)
{
	local bool bAttachProxy;
	local float AnimTimer;
	local name TransitionAnim, TimerName;
	local VehicleCrewProxy VCP;
	local bool bTransitionWithoutProxy;
	local bool bUseExteriorAnim;

	super.HandleProxySeatTransition(NewSeatIndex, OldSeatIndex);

	VCP = SeatProxies[GetSeatProxyIndexForSeatIndex(NewSeatIndex)].ProxyMeshActor;

	bUseExteriorAnim = IsSeatPositionOutsideTank(OldSeatIndex);

	// if there is no proxy it is likely the dedicated server. Set a flag
	// so we know we are doing the transition without a proxy
	if( VCP == none )
	{
		bTransitionWithoutProxy = true;
	}

	// Moving out of the driver seat
	if( OldSeatIndex == 0 )
	{
		// Transition from driver to commander
		if( NewSeatIndex == 1 )
		{
			TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranTurret' : 'Driver_TranTurret';
			TimerName = 'SeatProxyTransitioningDriverToTurretGoalCommander';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
			bAttachProxy = true;
		}
		// Transition from driver to loader
		else if( NewSeatIndex == 2 )
		{
			TransitionAnim = (bUseExteriorAnim) ? 'Driver_Open_TranTurret' : 'Driver_TranTurret';
			TimerName = 'SeatProxyTransitioningDriverToTurretGoalLoader';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
			bAttachProxy = true;
		}
	}
	// moving into the driver seat
	else if( NewSeatIndex == 0 )
	{
		// Transition from commander to driver
		if( OldSeatIndex == 1 )
		{
		    // Commander
			TransitionAnim = (bUseExteriorAnim) ? 'Com_Open_TranTurret' : 'Com_TranTurret';
			TimerName = 'SeatProxyTransitioningCommanderToTurretGoalDriver';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
			bAttachProxy = true;
		}
		// Transition from Loader to driver
		else if( OldSeatIndex == 2 )
		{
		    // Gunner
			TransitionAnim = 'Loader_TranTurret';
			TimerName = 'SeatProxyTransitioningLoaderToTurretGoalDriver';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
			bAttachProxy = true;
		}

	}
	// Transition to Commander
	else if( NewSeatIndex == 1 )
	{
		// Transition from Loader to commander
		if( OldSeatIndex == 2 )
		{
		    // Loader/gunner
			TransitionAnim = 'Com_loaderTOclose';
			TimerName = 'SeatTransitioningOne';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
		}
		
	}

	// Transition to Loader
	else if( NewSeatIndex == 2 )
	{
		// Transition from commander to loader
		if( OldSeatIndex == 1 )
		{
			TransitionAnim = (bUseExteriorAnim) ? 'Com_Open_TranLoader' : 'Com_TranLoader';
			TimerName = 'SeatTransitioningFour';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
		}
		// Transition from gunner to loader
		else if( OldSeatIndex == 2 )
		{
			TransitionAnim = 'Gunner_TranLoader';
			TimerName = 'SeatTransitioningFour';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Turret';
		}
		// Transition from hull MG to loader
		else if( OldSeatIndex == 3 )
		{
		    // Commander
			TransitionAnim = (bUseExteriorAnim) ? 'MG_Open_TranTurret' : 'MG_TranTurret';
			TimerName = 'SeatProxyTransitioningMGToTurretGoalLoader';
			Seats[NewSeatIndex].SeatTransitionBoneName = 'Chassis';
			bAttachProxy = true;
		}
	}

	// Store a reference to the driver pawn making the transition so we can use
	// it for the second part of timer driven transitions
	Seats[NewSeatIndex].TransitionProxy = VCP;

	// If this transition requires us to attach the driver to a different bone, do that here
	if( bAttachProxy && !bTransitionWithoutProxy )
	{
		VCP.SetBase( Self, , Mesh, Seats[NewSeatIndex].SeatTransitionBoneName);
		VCP.SetRelativeLocation( Seats[NewSeatIndex].SeatOffset );
		VCP.SetRelativeRotation( Seats[NewSeatIndex].SeatRotation );
	}

	if( bTransitionWithoutProxy )
	{
	   // Set up the transition timer
	   AnimTimer = SeatProxyAnimSet.GetAnimLength(TransitionAnim);
	}
	else
	{
		// Set up the transition and animation
		AnimTimer = VCP.Mesh.GetAnimLength(TransitionAnim);
	}

	Seats[OldSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);

	Seats[NewSeatIndex].bTransitioningToSeat = true;
	Seats[NewSeatIndex].PositionBlend.HandleAnimPlay(TransitionAnim, false);

	if( !bTransitionWithoutProxy )
	{
	   VCP.PlayFullBodyAnimation(TransitionAnim, 0.f);
	}

	// Set up the timer for ending the transition
	SetTimer(AnimTimer, false, TimerName);
}

/**
 * Finish a visible animated transition to Seat Index 0
 */
simulated function SeatTransitioningZero()
{
	FinishTransition(0);
}

/**
 * Finish a visible animated transition to Seat Index 1
 */
simulated function SeatTransitioningOne()
{
	FinishTransition(1);
}

/**
 * Finish a visible animated transition to Seat Index 2
 */
simulated function SeatTransitioningTwo()
{
	FinishTransition(2);
}

/**
 * Finish a visible animated transition to Seat Index 3
 */
simulated function SeatTransitioningThree()
{
	FinishTransition(3);
}

/**
 * Finish a visible animated transition to Seat Index 3
 */
simulated function SeatTransitioningFour()
{
	FinishTransition(4);
}

/**
 * Handle the second half of a visible animated transition from the driver
 * position to the Commander Cuppola in the turret.
 */
simulated function SeatTransitioningDriverToTurretGoalCommander()
{
	StartTurretTransition('Turret', 'Turret_TranCom', 1, 'SeatTransitioningOne');
}

/**
 * Handle the second half of a visible animated transition from the driver
 * position to the Gunner position in the turret.
 */
simulated function SeatTransitioningDriverToTurretGoalLoader()
{
	StartTurretTransition('Turret', 'Turret_TranLoader', 2, 'SeatTransitioningTwo');
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the driver position.
 */
simulated function SeatTransitioningCommanderToTurretGoalDriver()
{
	StartTurretTransition('Chassis', 'Turret_TranDriver', 0, 'SeatTransitioningZero');
}

/**
 * Handle the second half of a visible animated transition from the gunner
 * position in the turret to the driver position.
 */
simulated function SeatTransitioningLoaderToTurretGoalDriver()
{
	StartTurretTransition('Chassis', 'Turret_TranDriver', 0, 'SeatTransitioningZero');
}








/**
 * Handle the second half of a visible animated transition from the driver
 * position to the Commander Cuppola in the turret.
 */
simulated function SeatProxyTransitioningDriverToTurretGoalCommander()
{
	StartTurretTransition('Turret', 'Turret_TranCom', 1, 'SeatTransitioningOne', true);
}

/**
 * Handle the second half of a visible animated transition from the driver
 * position to the Gunner position in the turret.
 */
simulated function SeatProxyTransitioningDriverToTurretGoalLoader()
{
	StartTurretTransition('Turret', 'Turret_TranLoader', 2, 'SeatTransitioningTwo', true);
}

/**
 * Handle the second half of a visible animated transition from the commander
 * position in the turret to the driver position.
 */
simulated function SeatProxyTransitioningCommanderToTurretGoalDriver()
{
	StartTurretTransition('Chassis', 'Turret_TranDriver', 0, 'SeatTransitioningZero', true);
}

/**
 * Handle the second half of a visible animated transition from the gunner
 * position in the turret to the driver position.
 */
simulated function SeatProxyTransitioningLoaderToTurretGoalDriver()
{
	StartTurretTransition('Chassis', 'Turret_TranDriver', 0, 'SeatTransitioningZero', true);
}






/*********************************************************************************************
 * Periscope
 *********************************************************************************************/

simulated function bool IsInPeriscope(byte SeatIndex, byte PositionIndex)
{
	if ( SeatIndex != GetGunnerSeatIndex() )
		return false;
	if ( Seats[SeatIndex].bPositionTransitioning )
		return false;
	if ( PositionIndex != (Seats[SeatIndex].SeatPositions.Length - 1) )
		return false;

	return true;
}

/**
 * Network: Server and Local Player
 */
simulated function PositionIndexUpdated(int SeatIndex, byte NewPositionIndex)
{
	local int i;
	local ROPlayerController ROPC;
	local name UseKeyBinding;
	if( SeatIndex == GetCommanderSeatIndex() )
	{
	// Commander... reset periscope
	if ( IsInPeriscope(SeatIndex, NewPositionIndex) )
	{
		ROPC = ROPlayerController(Seats[SeatIndex].SeatPawn.Controller);
		if ( ROPC != None && LocalPlayer(ROPC.Player) != none )
		{
			if ( !ROPC.PlayerInput.FindKeyNameForCommand("Interact", UseKeyBinding, true) )
			{
				ROPC.PlayerInput.FindKeyNameForCommand("UseKey", UseKeyBinding, true);
			}
			//ROPC.ClientMessage(repl(UsePeriscodeString, "%KEY%", UseKeyBinding));
		}

		LinkPeriscope(false, true);
	}
	}
	// HullMG... toggle gun SkelControl
	else if( SeatIndex == GetHullMGSeatIndex() )
	{
		for (i=0;i<Seats[SeatIndex].TurretControllers.Length;i++)
		{
			Seats[SeatIndex].TurretControllers[i].SetSkelControlActive(NewPositionIndex == 1);
			if( NewPositionIndex != Seats[SeatIndex].FiringPositionIndex )
				Seats[SeatIndex].Gun.ForceEndFire();
		}
	}
	else if( SeatIndex == GetGunnerSeatIndex() )
	{
		if( NewPositionIndex != Seats[SeatIndex].FiringPositionIndex )
		{
			Seats[SeatIndex].Gun.ForceEndFire();
		}
	}

	super.PositionIndexUpdated(SeatIndex, NewPositionIndex);
}

/**
 * Network: Server and Local Player
 *
 * @design - Should we seperate the periscope into two positions?
 */
simulated function LinkPeriscope(bool bNewIsLinked, optional bool bIsPendingPosition)
{
	local ROWeaponPawn ROWP;
	local ROPlayerController ROPC;
	local byte SeatIdx, PositionIdx;
	local rotator NewViewRotation;

	SeatIdx = GetGunnerSeatIndex();
	PositionIdx = (Seats[SeatIdx].SeatPositions.Length - 1);

	ROWP = ROWeaponPawn(Seats[SeatIdx].SeatPawn);
	ROPC = ROPlayerController(Seats[SeatIdx].SeatPawn.Controller);

	// Setup position
	if ( bNewIsLinked )
	{
		Seats[SeatIdx].SeatPositions[PositionIdx].bRotateGunOnCommand = false;
		Seats[SeatIdx].SeatPositions[PositionIdx].bConstrainRotation = false;
		Seats[SeatIdx].SeatPositions[PositionIdx].bCamRotationFollowSocket = true;

		ROWP.bAllowCameraRotation = false;
		Seats[SeatIdx].CameraTag = PeriscopeGunnerCameraTag;

		// Update the desired aim to lock the gun into place
		ROPC.DesiredVehicleAim = SeatWeaponRotation(SeatIdx,,true);
	}
	else
	{
		Seats[SeatIdx].SeatPositions[PositionIdx].bRotateGunOnCommand = true;
		Seats[SeatIdx].SeatPositions[PositionIdx].bConstrainRotation = true;
		Seats[SeatIdx].SeatPositions[PositionIdx].bCamRotationFollowSocket = false;

		if ( !bIsPendingPosition )
		{
			ROWP.bAllowCameraRotation = true;
			Seats[SeatIdx].CameraTag = Seats[SeatIdx].SeatPositions[PositionIdx].PositionCameraTag;

			// zero yaw offset onto the periscope socket
			NewViewRotation = ROPC.Rotation;
			NewViewRotation.Yaw = 0;
			ROPC.SetRotation( NewViewRotation );
		}
	}
}

DefaultProperties
{
	Health=600
	Team=1 //us
	bOpenVehicle=true
	//bUseLoopedMGSound=false

	ExitRadius=180

	Begin Object Name=CollisionCylinder
		CollisionHeight=60.0
		CollisionRadius=260.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object
	CylinderComponent=CollisionCylinder

	bDontUseCollCylinderForRelevancyCheck=true

	RelevancyHeight=80.0
	RelevancyRadius=155.0

	Begin Object class=PointLightComponent name=InteriorLight_0
		Radius=100.0
		LightColor=(R=255,G=170,B=130)
		UseDirectLightMap=FALSE
		Brightness=1.0
		LightingChannels=(Unnamed_1=TRUE,BSP=FALSE,Static=FALSE,Dynamic=FALSE,CompositeDynamic=FALSE)
	End Object

	Begin Object class=PointLightComponent name=InteriorLight_1
		Radius=100.0
		LightColor=(R=255,G=170,B=130)
		UseDirectLightMap=FALSE
		Brightness=1.0
		LightingChannels=(Unnamed_1=TRUE,BSP=FALSE,Static=FALSE,Dynamic=FALSE,CompositeDynamic=FALSE)
	End Object

	// TODO - See if these are actually needed - Ramm
	VehicleLights(0)={(AttachmentName=InteriorLightComponent0,Component=InteriorLight_0,bAttachToSocket=true,AttachmentTargetName=interior_light_0)}
	VehicleLights(1)={(AttachmentName=InteriorLightComponent1,Component=InteriorLight_1,bAttachToSocket=true,AttachmentTargetName=interior_light_1)}

	bNoAnimTransition=true
	// SRS - Commenting this out because of the ROGameContent system. Move this to child class when created


		Seats(0)={(	CameraTag=None,
				CameraOffset=-420,
				SeatAnimBlendName=DriverPositionNode,
				SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=0.0,PositionUpAnim=Driver_open,PositionIdleAnim=Driver_open_idle,DriverIdleAnim=Driver_open_idle,AlternateIdleAnim=Driver_open_idle_AI,SeatProxyIndex=0,
									bIsExterior=true,
									LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverLeftBrake,DefaultEffectorRotationTargetName=IK_DriverLeftBrake),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverRightBrake,DefaultEffectorRotationTargetName=IK_DriverRightBrake,
										AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchLever,EffectorRotationTargetName=IK_DriverClutchLever))),
									LeftFootIKInfo=(IKEnabled=false,
										AlternateEffectorTargets=((Action=DAct_ShiftGears,IKEnabled=true,EffectorLocationTargetName=IK_DriverClutchPedal,EffectorRotationTargetName=IK_DriverClutchPedal))),
									RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DriverGasPedal,DefaultEffectorRotationTargetName=IK_DriverGasPedal),
									HipsIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(Driver_open_flinch),
									PositionDeathAnims=(Driver_open_Death)),
							(bDriverVisible=false,bAllowFocus=false,PositionCameraTag=Driver_Camera,ViewFOV=70.0,bViewFromCameraTag=true,bDrawOverlays=true, bIsExterior=false,
									PositionDownAnim=Driver_close,PositionIdleAnim=Driver_close_idle,DriverIdleAnim=Driver_close_idle,AlternateIdleAnim=Driver_close_idle_AI,SeatProxyIndex=0,
									PositionFlinchAnims=(Driver_close_flinch),
									PositionDeathAnims=(Driver_close_Death))
								),
				bSeatVisible=true,
				SeatBone=Chassis,
				DriverDamageMult=1.0,
				InitialPositionIndex=0,
				SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore02,
//				SeatIconPos=(X=0.33,Y=0.35),
				//MuzzleFlashLightClass=class'UTTankMuzzleFlash',
//				WeaponEffects=((SocketName=TurretFireSocket,Offset=(X=-125),Scale3D=(X=14.0,Y=10.0,Z=10.0)))
				)}
// turret root - 2.269  29.218 -10.0
	Seats(1)={(	GunClass=class'ROVWeap_M41_Turret',
	            		BinocOverlayTexture=Texture2D'WP_VN_VC_Binoculars.Materials.BINOC_overlay',
	            		BarTexture=Texture2D'ui_textures.Textures.button_128grey',
				RangeOverlayTexture=Texture2D'VH_VN_M41.VehicleOptics.ui_hud_vehicle_optics_M41_range',
				PeriscopeRangeTexture=Texture2D'VH_VN_M41.VehicleOptics.ui_hud_vehicle_optics_M41_Periscope_range',
				VignetteOverlayTexture=Texture2D'VH_VN_M41.VehicleOptics.ui_hud_vehicle_optics_vignette',
				GunSocket=(Barrel,CoaxMG),
				GunPivotPoints=(gun_base,gun_base),
				TurretVarPrefix="Turret",
				TurretControls=(Turret_Gun,Turret_Main),
				CameraTag=None,
				CameraOffset=-420,
				bSeatVisible=true,
				SeatBone=Turret,
				SeatAnimBlendName=CommanderPositionNode,
				SeatPositions=(	
								 //Binoculars topmost
								(bDriverVisible=true,bAllowFocus=false,bDrawOverlays=false,bBinocsPosition=true,PositionCameraTag=None,ViewFOV=5.4,bRotateGunOnCommand=true,
									PositionUpAnim=Com_open_idle,PositionIdleAnim=Com_open_idle,DriverIdleAnim=Com_open_idle,AlternateIdleAnim=Com_open_idle_AI,SeatProxyIndex=1,
				                    bIsExterior=true,
									LeftHandIKInfo=(PinEnabled=true),
				                    RightHandIKInfo=(PinEnabled=true),
									HipsIKInfo=(PinEnabled=true),
									LeftFootIKInfo=(PinEnabled=true),
				                    RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(Com_open_flinch),
									PositionDeathAnims=(Com_open_death)),
								//position 1, std, above hatch
								(bDriverVisible=true,bAllowFocus=true,PositionCameraTag=None,ViewFOV=0.0,bRotateGunOnCommand=true, 
							   PositionUpAnim=Com_open,PositionDownAnim=Com_open_idle,PositionIdleAnim=Com_open_idle,DriverIdleAnim=Com_open_idle,AlternateIdleAnim=Com_open_idle_AI,SeatProxyIndex=1,
				                    bIsExterior=true,
							       		LeftHandIKInfo=(PinEnabled=true),
                                    					RightHandIKInfo=(PinEnabled=true),
                                    					HipsIKInfo=(PinEnabled=true),
                                    					LeftFootIKInfo=(PinEnabled=true),
                                    					RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(Com_open_flinch),
									PositionDeathAnims=(Com_open_death)),
								// position 2, std gunner view
								(bDriverVisible=false,bAllowFocus=false,PositionCameraTag=Camera_Gunner,ViewFOV=13.5,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bDrawOverlays=true, 
								PositionDownAnim=Com_close,PositionIdleAnim=Com_close_idle,DriverIdleAnim=Com_close_idle,AlternateIdleAnim=Com_close_idle_AI,SeatProxyIndex=1,
									LeftHandIKInfo=(PinEnabled=true),
                                    					RightHandIKInfo=(PinEnabled=true),
                                    					HipsIKInfo=(PinEnabled=true),
                                    					LeftFootIKInfo=(PinEnabled=true),
                                    					RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(Com_close_flinch),
									PositionDeathAnims=(Com_close_death)),
								//Periscope
								(bDriverVisible=false,bAllowFocus=false,PositionCameraTag=Camera_Periscope,ViewFOV=13.5,bRotateGunOnCommand=true,bViewFromCameraTag=true,bDrawOverlays=true,SeatProxyIndex=1,
								    PositionDownAnim=Com_close_idle,PositionUpAnim=Com_close_idle,PositionIdleAnim=Com_close_idle,DriverIdleAnim=Com_close_idle,AlternateIdleAnim=Com_close_idle_AI,
									bConstrainRotation=true,YawContraintIndex=1,PitchContraintIndex=0,
									InteractionSocketTag=Interact_Periscope, LinkedPositionIndex=2,
									PositionFlinchAnims=(Com_close_flinch),
									PositionDeathAnims=(Com_close_death))),
				DriverDamageMult=1.0,
				InitialPositionIndex=2,
				FiringPositionIndex=2,
				HatchDownPositionIndex=2,
				//SeatIconPos=(X=0.33,Y=0.35),
				TracerFrequency=5,
				WeaponTracerClass=(none,class'RPDBulletTracer'),
				MuzzleFlashLightClass=(class'ROGrenadeExplosionLight',class'ROVehicleMGMuzzleFlashLight'),
				SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore01,
				//WeaponEffects=((SocketName=TurretFireSocket,Offset=(X=-125),Scale3D=(X=14.0,Y=10.0,Z=10.0)))
				)}

	

	Seats(2)={(	bNonEnterable=true,
				SeatAnimBlendName=LoaderPositionNode,
				TurretVarPrefix="Loader",
				SeatPositions=((bDriverVisible=false,PositionIdleAnim=Loader_idle,AlternateIdleAnim=Loader_idle_AI,SeatProxyIndex=2,
				                    PositionFlinchAnims=(Loader_idle),
						    PositionDeathAnims=(Loader_idle)
				                    
								)),
				bSeatVisible=true,
				SeatBone=Turret,
				SeatRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore01
				)}

	CrewAnimSet=AnimSet'VH_VN_M41.Anim.CHR_M41_anim_Master'
	//_________________________
	// ROSkelControlTankWheels
	//
	LeftWheels(0)="L0_Wheel_Static"
	LeftWheels(1)="L1_Wheel"
	LeftWheels(2)="L2_Wheel"
	LeftWheels(3)="L3_Wheel"
	LeftWheels(4)="L4_Wheel"
	LeftWheels(5)="L5_Wheel"
	LeftWheels(6)="L8_Wheel_Static"
	LeftWheels(7)="L9_Wheel"
	LeftWheels(8)="L10_11_Wheel"
	//
	RightWheels(0)="R0_Wheel_Static"
	RightWheels(1)="R1_Wheel"
	RightWheels(2)="R2_Wheel"
	RightWheels(3)="R3_Wheel"
	RightWheels(4)="R4_Wheel"
	RightWheels(5)="R5_Wheel"
	RightWheels(6)="R8_Wheel_Static"
	RightWheels(7)="R9_Wheel"
	RightWheels(8)="R10_11_Wheel"

	//WheelSuspensionDamping=40.0
	//WheelSuspensionBias=0.1
	//WheelLongExtremumSlip=1.5
		
/* Physics Wheels */

	// Right Rear Wheel
	Begin Object Name=RRWheel
		BoneName="R_Wheel_05"
		BoneOffset=(X=0.0,Y=0,Z=0.0)
		WheelRadius=28
	End Object

	// Right middle wheel
	Begin Object Name=RMWheel
		BoneName="R_Wheel_03"
		BoneOffset=(X=0.0,Y=0,Z=0.0)
		WheelRadius=28
	End Object

	// Right Front Wheel
	Begin Object Name=RFWheel
		BoneName="R_Wheel_01"
		BoneOffset=(X=0.0,Y=0,Z=0.0)
		WheelRadius=28
	End Object

	// Left Rear Wheel
	Begin Object Name=LRWheel
		BoneName="L_Wheel_05"
		BoneOffset=(X=0.0,Y=0,Z=0.0)
		WheelRadius=28
	End Object

	// Left Middle Wheel
	Begin Object Name=LMWheel
		BoneName="L_Wheel_03"
		BoneOffset=(X=0.0,Y=0,Z=0.0)
		WheelRadius=28
	End Object

	// Left Front Wheel
	Begin Object Name=LFWheel
		BoneName="L_Wheel_01"
		BoneOffset=(X=0.0,Y=0,Z=0.0)
		WheelRadius=28
	End Object

/* Vehicle Sim */

	Begin Object Name=SimObject
		WheelSuspensionStiffness=450.0
		WheelSuspensionBias=0.2
		// Transmission - GearData
		GearArray(0)={(
			// Real world - [5.64] 5.5 kph reverse
			GearRatio=-5.64,
			AccelRate=7.5,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=-3000),
				(InVal=300,OutVal=-1000),
				(InVal=2800,OutVal=-3000.0),
				(InVal=3000,OutVal=-1000),
				(InVal=3200,OutVal=-0.0)
				)}),
			TurningThrottle=0.86
			)}
		GearArray(1)={(
			// [N/A]  reserved for neutral
			)}
		GearArray(2)={(
			// Real world - [6.89] 4.5 kph at 2800rpm
			GearRatio=6.89,
			AccelRate=9.50,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=12480),
				(InVal=300,OutVal=4000),
				(InVal=2800,OutVal=12480.0),
				(InVal=3000,OutVal=7500.0),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.85
			)}
		GearArray(3)={(
			// Real world - [3.60] 8.6 kph
			GearRatio=3.60,
			AccelRate=10.00,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=3400),
				(InVal=300,OutVal=2700),
				(InVal=2800,OutVal=3500),
				(InVal=3000,OutVal=1000),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.85
			)}
		GearArray(4)={(
			// Real world - [2.14] 14.5 kph
			GearRatio=2.14,
			AccelRate=9.35,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=5000),
				(InVal=300,OutVal=3000),
				(InVal=2800,OutVal=6000),
				(InVal=3000,OutVal=2000),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.75
			)}
		GearArray(5)={(
			// Real world - [1.42] 21.9 kph
			GearRatio=1.42,
			AccelRate=11.00,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=5000),
				(InVal=300,OutVal=3300),
				(InVal=2800,OutVal=7800),
				(InVal=3000,OutVal=4000),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.85
			)}
		GearArray(6)={(
			// Real world - [1.00] 31.0 kph
			GearRatio=1.00,
			AccelRate=11.20,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=5000),
				(InVal=300,OutVal=3400),
				(InVal=2800,OutVal=10800),
				(InVal=3000,OutVal=5500),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.80
			)}
		GearArray(7)={(
			// Real world - [0.78] 40.0 kph
			GearRatio=0.78,
			AccelRate=11.20,
			TorqueCurve=(Points={(
				(InVal=0,OutVal=5000),
				(InVal=300,OutVal=3500),
				(InVal=2800,OutVal=13800),
				(InVal=3000,OutVal=6000),
				(InVal=3200,OutVal=0.0)
				)}),
			TurningThrottle=0.80
			)}
		// Transmission - Misc
		FirstForwardGear=3
	End Object

	

	
	
	VehicleEffects(TankVFX_Firing1)=(EffectStartTag=M41Cannon,EffectTemplate=ParticleSystem'VH_VN_M41.ParticleSystems.M41_B_TankMuzzle',EffectSocket=Barrel,bRestartRunning=true)
	VehicleEffects(TankVFX_Firing2)=(EffectStartTag=M41Cannon,EffectTemplate=ParticleSystem'VH_VN_M41.ParticleSystems.M41_TankCannon_Dust',EffectSocket=attachments_body_ground,bRestartRunning=true)
	//VehicleEffects(TankVFX_Firing3)=(EffectStartTag=M41HullMG,EffectTemplate=ParticleSystem'FX_MuzzleFlashes.Emitters.muzzleflash_3rdP',EffectSocket=MG_Barrel)
	VehicleEffects(TankVFX_Firing4)=(EffectStartTag=M41CoaxMG,EffectTemplate=ParticleSystem'VH_VN_M41.Emitters.MuzzleFlash_3rdP',EffectSocket=CoaxMG)
	// Driving effects
	VehicleEffects(TankVFX_Exhaust)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,EffectTemplate=ParticleSystem'VH_VN_M41.ParticleSystems.M41_A_TankExhaust',EffectSocket=Exhaust)
	VehicleEffects(TankVFX_TreadWing)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bStayActive=true,EffectTemplate=ParticleSystem'VH_VN_M41.ParticleSystems.A_Wing_Dirt_M41',EffectSocket=attachments_body_ground)
	// Damage
	VehicleEffects(TankVFX_DmgSmoke)=(EffectStartTag=DamageSmoke,EffectEndTag=NoDamageSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'VH_VN_M41.ParticleSystems.M41_A_Damage',EffectSocket=attachments_engine)
	VehicleEffects(TankVFX_DmgInterior)=(EffectStartTag=DamageInterior,EffectEndTag=NoInternalSmoke,bRestartRunning=false,bInteriorEffect=true,EffectTemplate=ParticleSystem'VH_VN_M41.ParticleSystems.M41_Interior_Penetrate',EffectSocket=attachments_body)
	// Death
	VehicleEffects(TankVFX_DeathSmoke1)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'VH_VN_M41.ParticleSystems.M41_A_SmallSmoke',EffectSocket=FX_Smoke_1)
	VehicleEffects(TankVFX_DeathSmoke2)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'VH_VN_M41.ParticleSystems.M41_A_SmallSmoke',EffectSocket=FX_Smoke_2)
	VehicleEffects(TankVFX_DeathSmoke3)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'VH_VN_M41.ParticleSystems.M41_A_SmallSmoke',EffectSocket=FX_Smoke_3)

	bHasTurret=true
	bInfantryCanUse=true

		

	DrivingPhysicalMaterial=PhysicalMaterial'VH_VN_M41.Phys.PhysMat_M41_Moving'
	DefaultPhysicalMaterial=PhysicalMaterial'VH_VN_M41.Phys.PhysMat_M41'

	TreadSpeedParameterName=Tank_Tread_Speed
	TrackSoundParamScale=0.000033
	TreadSpeedScale=2.5
	
	
	

	RPM3DGaugeMaxAngle=40000
	EngineIdleRPM=500
	EngineNormalRPM=1800
	EngineMaxRPM=2500
	Speedo3DGaugeMaxAngle=103765
	EngineOil3DGaugeMinAngle=16384
	EngineOil3DGaugeMaxAngle=35000
	EngineOil3DGaugeDamageAngle=8192
	GearboxOil3DGaugeMinAngle=15000
	GearboxOil3DGaugeNormalAngle=22500
	GearboxOil3DGaugeMaxAngle=30000
	GearboxOil3DGaugeDamageAngle=5000
	EngineTemp3DGaugeNormalAngle=7500
	EngineTemp3DGaugeEngineDamagedAngle=13000
	EngineTemp3DGaugeFireDamagedAngle=15000
	EngineTemp3DGaugeFireDestroyedAngle=16384


	BigExplosionSocket=FX_Fire
	ExplosionTemplate=ParticleSystem'VH_VN_M41.ParticleSystems.M41_C_Explosion'

	ExplosionDamageType=class'RODmgType_VehicleExplosion'
	ExplosionDamage=100.0
	ExplosionRadius=300.0
	ExplosionMomentum=60000
	ExplosionInAirAngVel=1.5
	InnerExplosionShakeRadius=400.0
	OuterExplosionShakeRadius=1000.0
	ExplosionLightClass=none//class'ROGame.ROGrenadeExplosionLight'
	MaxExplosionLightDistance=4000.0
	TimeTilSecondaryVehicleExplosion=2.0f
	SecondaryExplosion=ParticleSystem'VH_VN_M41.ParticleSystems.M41_C_Explosion_Ammo'
	bHasTurretExplosion=true
	TurretExplosiveForce=15000

	SquealThreshold=250.0
	EngineStartOffsetSecs=2.0
	EngineStopOffsetSecs=0.0//1.0
	
	HUDBodyTexture=none
	
	ArmorTextureOffsets(0)=(PositionOffset=(X=36,Y=6,Z=0),MySizeX=68,MYSizeY=68)
	ArmorTextureOffsets(1)=(PositionOffset=(X=36,Y=63,Z=0),MySizeX=68,MYSizeY=68)
	ArmorTextureOffsets(2)=(PositionOffset=(X=40,Y=38,Z=0),MySizeX=17,MYSizeY=68)
	ArmorTextureOffsets(3)=(PositionOffset=(X=82,Y=38,Z=0),MySizeX=17,MYSizeY=68)

	SprocketTextureOffsets(0)=(PositionOffset=(X=45,Y=24,Z=0),MySizeX=8,MYSizeY=16)
	SprocketTextureOffsets(1)=(PositionOffset=(X=87,Y=24,Z=0),MySizeX=8,MYSizeY=16)

	TransmissionTextureOffset=(PositionOffset=(X=51,Y=19,Z=0),MySizeX=38,MYSizeY=36)

	TreadTextureOffsets(0)=(PositionOffset=(X=36,Y=35,Z=0),MySizeX=8,MYSizeY=69)
	TreadTextureOffsets(1)=(PositionOffset=(X=96,Y=35,Z=0),MySizeX=8,MYSizeY=69)

	AmmoStorageTextureOffsets(0)=(PositionOffset=(X=41,Y=56,Z=0),MySizeX=16,MYSizeY=16)
	AmmoStorageTextureOffsets(1)=(PositionOffset=(X=83,Y=56,Z=0),MySizeX=16,MYSizeY=16)

	FuelTankTextureOffsets(0)=(PositionOffset=(X=62,Y=62,Z=0),MySizeX=16,MYSizeY=16)

	TurretRingTextureOffset=(PositionOffset=(X=51,Y=51,Z=0),MySizeX=38,MYSizeY=38)

	EngineTextureOffset=(PositionOffset=(X=56,Y=88,Z=0),MySizeX=28,MYSizeY=28)

	TurretArmorTextureOffsets(0)=(PositionOffset=(X=-0,Y=-16,Z=0),MySizeX=40,MYSizeY=20)
	TurretArmorTextureOffsets(1)=(PositionOffset=(X=-0,Y=+20,Z=0),MySizeX=38,MYSizeY=19)
	TurretArmorTextureOffsets(2)=(PositionOffset=(X=-10,Y=+2,Z=0),MySizeX=16,MYSizeY=64)
	TurretArmorTextureOffsets(3)=(PositionOffset=(X=+9,Y=0,Z=0),MySizeX=16,MYSizeY=66)

	MainGunTextureOffset=(PositionOffset=(X=-0,Y=-40,Z=0),MySizeX=14,MYSizeY=37)
	CoaxMGTextureOffset=(PositionOffset=(X=+6,Y=-14,Z=0),MySizeX=6,MYSizeY=14)

	SeatTextureOffsets(0)=(PositionOffSet=(X=0,Y=-28,Z=0),bTurretPosition=0)
	SeatTextureOffsets(1)=(PositionOffSet=(X=+8,Y=-2,Z=0),bTurretPosition=0)
	SeatTextureOffsets(2)=(PositionOffSet=(X=-8,Y=-2,Z=0),bTurretPosition=1)

	SpeedoMinDegree=5461
	SpeedoMaxDegree=60075
	SpeedoMaxSpeed=1365 //100 km/h

	//CabinL_FXSocket=Sound_Cabin_L
	//CabinR_FXSocket=Sound_Cabin_R
	Exhaust_FXSocket=Exhaust
	//TreadL_FXSocket=Sound_Tread_L
	//TreadR_FXSocket=Sound_Tread_R

	VehHitZones(0)=(ZoneName=ENGINEBLOCK,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=100,VisibleFrom=14)
	VehHitZones(1)=(ZoneName=ENGINECORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Engine,ZoneHealth=300,VisibleFrom=14)
	VehHitZones(2)=(ZoneName=MGAMMOSTOREONE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,VisibleFrom=9)
	VehHitZones(3)=(ZoneName=AMMOSTOREONE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.3,VisibleFrom=13)
	VehHitZones(4)=(ZoneName=AMMOSTORETWO,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.2,VisibleFrom=5)
	VehHitZones(5)=(ZoneName=AMMOSTORETHREE,DamageMultiplier=100.0,VehicleHitZoneType=VHT_Ammo,ZoneHealth=10,KillPercentage=0.2,VisibleFrom=9)
	VehHitZones(6)=(ZoneName=FUELTANKONE,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=50,KillPercentage=0.2,VisibleFrom=5)
	VehHitZones(7)=(ZoneName=FUELTANKTWO,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=50,KillPercentage=0.2,VisibleFrom=6)
	VehHitZones(8)=(ZoneName=FUELTANKTHREE,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=50,KillPercentage=0.2,VisibleFrom=9)
	VehHitZones(9)=(ZoneName=FUELTANKFOUR,DamageMultiplier=10.0,VehicleHitZoneType=VHT_Fuel,ZoneHealth=50,KillPercentage=0.2,VisibleFrom=10)
	VehHitZones(10)=(ZoneName=GEARBOX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=100,VisibleFrom=14)
	VehHitZones(11)=(ZoneName=GEARBOXCORE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=200,VisibleFrom=14)
	VehHitZones(12)=(ZoneName=LEFTBRAKES,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=6)
	VehHitZones(13)=(ZoneName=RIGHTBRAKES,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25,VisibleFrom=10)
	VehHitZones(14)=(ZoneName=TRAVERSEMOTOR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=15)
	VehHitZones(15)=(ZoneName=TURRETRINGONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=13)
	VehHitZones(16)=(ZoneName=TURRETRINGTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=10)
	VehHitZones(17)=(ZoneName=TURRETRINGTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=9)
	VehHitZones(18)=(ZoneName=TURRETRINGFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=14)
	VehHitZones(19)=(ZoneName=TURRETRINGFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=6)
	VehHitZones(20)=(ZoneName=TURRETRINGSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=10,VisibleFrom=5)
	VehHitZones(21)=(ZoneName=COAXIALMG,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=25)
	VehHitZones(22)=(ZoneName=MAINCANNONREAR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Mechanicals,ZoneHealth=50,KillPercentage=0.3)
	VehHitZones(23)=(ZoneName=DRIVERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Driver_bone)
	VehHitZones(24)=(ZoneName=DRIVERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Driver_bone)
	VehHitZones(25)=(ZoneName=COMMANDERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Commander_Bone)
	VehHitZones(26)=(ZoneName=COMMANDERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=Commander_Bone)
	VehHitZones(27)=(ZoneName=LOADERBODY,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewBody,CrewSeatIndex=3,SeatProxyIndex=3,CrewBoneName=Loader_Bone)
	VehHitZones(28)=(ZoneName=LOADERHEAD,DamageMultiplier=1.0,VehicleHitZoneType=VHT_CrewHead,CrewSeatIndex=3,SeatProxyIndex=3,CrewBoneName=Loader_Bone)
	VehHitZones(29)=(ZoneName=RIGHTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
	VehHitZones(30)=(ZoneName=LEFTDRIVEWHEEL,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=400)
	VehHitZones(31)=(ZoneName=LEFTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(32)=(ZoneName=LEFTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(33)=(ZoneName=LEFTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(34)=(ZoneName=LEFTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(35)=(ZoneName=LEFTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(36)=(ZoneName=LEFTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(37)=(ZoneName=LEFTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(38)=(ZoneName=LEFTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(39)=(ZoneName=LEFTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(40)=(ZoneName=LEFTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(41)=(ZoneName=RIGHTTRACKONE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(42)=(ZoneName=RIGHTTRACKTWO,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=200)
	VehHitZones(43)=(ZoneName=RIGHTTRACKTHREE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(44)=(ZoneName=RIGHTTRACKFOUR,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(45)=(ZoneName=RIGHTTRACKFIVE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(46)=(ZoneName=RIGHTTRACKSIX,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(47)=(ZoneName=RIGHTTRACKSEVEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(48)=(ZoneName=RIGHTTRACKEIGHT,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(49)=(ZoneName=RIGHTTRACKNINE,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)
	VehHitZones(50)=(ZoneName=RIGHTTRACKTEN,DamageMultiplier=1.0,VehicleHitZoneType=VHT_Track,ZoneHealth=800)


	// Hit zones in the physics asset that detect armor hits
	ArmorHitZones(0)=(ZoneName=FRONTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTLOWER)
	ArmorHitZones(1)=(ZoneName=FRONTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTGLACIS)
	ArmorHitZones(2)=(ZoneName=FRONTARMORTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=FRONTUPPER)
	ArmorHitZones(3)=(ZoneName=LEFTFRONTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONT)
	ArmorHitZones(4)=(ZoneName=LEFTFRONTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONT)
	ArmorHitZones(5)=(ZoneName=LEFTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTLOWER)
	ArmorHitZones(6)=(ZoneName=LEFTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTUPPER)
	ArmorHitZones(7)=(ZoneName=LEFTARMORTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTUPPERCENTER)
	ArmorHitZones(8)=(ZoneName=LEFTREARARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTUPPERREAR)
	ArmorHitZones(9)=(ZoneName=LEFTREARARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTLOWERREAR)
	ArmorHitZones(10)=(ZoneName=LEFTOVERHANGARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTFRONTOVERHANG)
	ArmorHitZones(11)=(ZoneName=LEFTOVERHANGARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTREAROVERHANG)
	ArmorHitZones(12)=(ZoneName=ROOFARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=ROOFREAR)
	ArmorHitZones(13)=(ZoneName=ROOFARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=ROOFFRONT)
	ArmorHitZones(14)=(ZoneName=ROOFARMORLEFTFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=ROOFFRONT)
	ArmorHitZones(15)=(ZoneName=ROOFARMORRIGHTFRONT,PhysBodyBoneName=Chassis,ArmorPlateName=ROOFFRONT)
	ArmorHitZones(16)=(ZoneName=FLOORARMOR,PhysBodyBoneName=Chassis,ArmorPlateName=FLOOR)
	ArmorHitZones(17)=(ZoneName=REARARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=REARLOWER)
	ArmorHitZones(18)=(ZoneName=REARARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=REARUPPER)
	ArmorHitZones(19)=(ZoneName=RIGHTFRONTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONT)
	ArmorHitZones(20)=(ZoneName=RIGHTFRONTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONT)
	ArmorHitZones(21)=(ZoneName=RIGHTARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTLOWER)
	ArmorHitZones(22)=(ZoneName=RIGHTARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTUPPER)
	ArmorHitZones(23)=(ZoneName=RIGHTREARARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTUPPERREAR)
	ArmorHitZones(24)=(ZoneName=RIGHTREARARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTLOWERREAR)
	ArmorHitZones(25)=(ZoneName=RIGHTARMORTHREE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTUPPERCENTER)
	ArmorHitZones(26)=(ZoneName=RIGHTOVERHANGARMORONE,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTFRONTOVERHANG)
	ArmorHitZones(27)=(ZoneName=RIGHTOVERHANGARMORTWO,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTREAROVERHANG)
	ArmorHitZones(28)=(ZoneName=TURRETFRONTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETFRONT)
	ArmorHitZones(29)=(ZoneName=TURRETFRONTLEFTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETFRONT)
	ArmorHitZones(30)=(ZoneName=LEFTFRONTTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFTFRONT)
	ArmorHitZones(31)=(ZoneName=LEFTREARTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETLEFTREAR)
	ArmorHitZones(32)=(ZoneName=TURRETREARARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETREAR)
	ArmorHitZones(33)=(ZoneName=TURRETREARLEFTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETREAR)
	ArmorHitZones(34)=(ZoneName=TURRETREARRIGHTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETREAR)
	ArmorHitZones(35)=(ZoneName=RIGHTREARTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHTREAR)
	ArmorHitZones(36)=(ZoneName=RIGHTFRONTTURRETARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETRIGHTFRONT)
	ArmorHitZones(37)=(ZoneName=TURRETFRONTRIGHTARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETFRONT)
	ArmorHitZones(38)=(ZoneName=TURRETROOFARMOR,PhysBodyBoneName=Turret,ArmorPlateName=TURRETROOF)
	ArmorHitZones(39)=(ZoneName=CUPPOLAARMORONE,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLA)
	ArmorHitZones(40)=(ZoneName=CUPPOLAARMORTWO,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLA)
	ArmorHitZones(41)=(ZoneName=CUPPOLAARMORTHREE,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLA)
	ArmorHitZones(42)=(ZoneName=CUPPOLAARMORFOUR,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLA)
	ArmorHitZones(43)=(ZoneName=CUPPOLAROOFARMOR,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAROOF)
	ArmorHitZones(44)=(ZoneName=CANNONGLACISARMOR,PhysBodyBoneName=gun_base,ArmorPlateName=CANNONGLACIS)
	ArmorHitZones(45)=(ZoneName=DRIVERFRONTVISIONSLIT,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERFRONTVISIONSLIT)
	ArmorHitZones(46)=(ZoneName=DRIVERSIDEVISIONSLIT,PhysBodyBoneName=Chassis,ArmorPlateName=DRIVERSIDEVISIONSLIT)
	ArmorHitZones(47)=(ZoneName=HULLMGSIDEVISIONSLIT,PhysBodyBoneName=Chassis,ArmorPlateName=HULLMGSIDEVISIONSLIT)
	ArmorHitZones(48)=(ZoneName=RIGHTENGINEDECKGRATING,PhysBodyBoneName=Chassis,ArmorPlateName=RIGHTENGINEDECKGRATING)
	ArmorHitZones(49)=(ZoneName=LEFTENGINEDECKGRATING,PhysBodyBoneName=Chassis,ArmorPlateName=LEFTENGINEDECKGRATING)
	ArmorHitZones(50)=(ZoneName=GUNNERFRONTVISIONSLIT,PhysBodyBoneName=Turret,ArmorPlateName=GUNNERFRONTVISIONSLIT)
	ArmorHitZones(51)=(ZoneName=GUNNERREARVISIONSLIT,PhysBodyBoneName=Turret,ArmorPlateName=GUNNERREARVISIONSLIT)
	ArmorHitZones(52)=(ZoneName=LOADERFRONTVISIONSLIT,PhysBodyBoneName=Turret,ArmorPlateName=LOADERFRONTVISIONSLIT)
	ArmorHitZones(53)=(ZoneName=LOADERREARVISIONSLIT,PhysBodyBoneName=Turret,ArmorPlateName=LOADERREARVISIONSLIT)
	ArmorHitZones(54)=(ZoneName=CUPPOLAVIEWSLITONE,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAVIEWSLITONE)
	ArmorHitZones(55)=(ZoneName=CUPPOLAVIEWSLITTWO,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAVIEWSLITTWO)
	ArmorHitZones(56)=(ZoneName=CUPPOLAVIEWSLITTHREE,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAVIEWSLITTHREE)
	ArmorHitZones(57)=(ZoneName=CUPPOLAVIEWSLITFOUR,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAVIEWSLITFOUR)
	ArmorHitZones(58)=(ZoneName=CUPPOLAVIEWSLITFIVE,PhysBodyBoneName=Turret,ArmorPlateName=CUPPOLAVIEWSLITFIVE)

	// Armor plates that store the info for the actual plates
	ArmorPlates(0)=(PlateName=FRONTLOWER,ArmorZoneType=AZT_Front,PlateThickness=50,OverallHardness=400,bHighHardness=true)
	ArmorPlates(1)=(PlateName=FRONTGLACIS,ArmorZoneType=AZT_Front,PlateThickness=25,OverallHardness=400,bHighHardness=true)
	ArmorPlates(2)=(PlateName=FRONTUPPER,ArmorZoneType=AZT_Front,PlateThickness=50,OverallHardness=400,bHighHardness=false)
	ArmorPlates(3)=(PlateName=LEFTFRONT,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=400,bHighHardness=false)
	ArmorPlates(4)=(PlateName=LEFTLOWER,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=400,bHighHardness=false)
	ArmorPlates(5)=(PlateName=LEFTUPPER,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=400,bHighHardness=false)
	ArmorPlates(6)=(PlateName=LEFTUPPERCENTER,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=400,bHighHardness=false)
	ArmorPlates(7)=(PlateName=LEFTUPPERREAR,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=400,bHighHardness=false)
	ArmorPlates(8)=(PlateName=LEFTLOWERREAR,ArmorZoneType=AZT_Left,PlateThickness=30,OverallHardness=400,bHighHardness=false)
	ArmorPlates(9)=(PlateName=LEFTFRONTOVERHANG,ArmorZoneType=AZT_Left,PlateThickness=10,OverallHardness=380,bHighHardness=true)
	ArmorPlates(10)=(PlateName=LEFTREAROVERHANG,ArmorZoneType=AZT_Left,PlateThickness=10,OverallHardness=380,bHighHardness=true)
	ArmorPlates(11)=(PlateName=ROOFREAR,ArmorZoneType=AZT_Roof,PlateThickness=10,OverallHardness=380,bHighHardness=true)
	ArmorPlates(12)=(PlateName=ROOFFRONT,ArmorZoneType=AZT_Roof,PlateThickness=10,OverallHardness=400,bHighHardness=true)
	ArmorPlates(13)=(PlateName=FLOOR,ArmorZoneType=AZT_Floor,PlateThickness=10,OverallHardness=400,bHighHardness=true)
	ArmorPlates(14)=(PlateName=REARLOWER,ArmorZoneType=AZT_Back,PlateThickness=20,OverallHardness=350,bHighHardness=false)
	ArmorPlates(15)=(PlateName=REARUPPER,ArmorZoneType=AZT_Back,PlateThickness=20,OverallHardness=350,bHighHardness=false)
	ArmorPlates(16)=(PlateName=RIGHTFRONT,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=380,bHighHardness=false)
	ArmorPlates(17)=(PlateName=RIGHTLOWER,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=380,bHighHardness=false)
	ArmorPlates(18)=(PlateName=RIGHTUPPER,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=380,bHighHardness=false)
	ArmorPlates(19)=(PlateName=RIGHTUPPERCENTER,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=380,bHighHardness=false)
	ArmorPlates(20)=(PlateName=RIGHTUPPERREAR,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=380,bHighHardness=false)
	ArmorPlates(21)=(PlateName=RIGHTLOWERREAR,ArmorZoneType=AZT_Right,PlateThickness=30,OverallHardness=380,bHighHardness=false)
	ArmorPlates(22)=(PlateName=RIGHTFRONTOVERHANG,ArmorZoneType=AZT_Right,PlateThickness=10,OverallHardness=400,bHighHardness=true)
	ArmorPlates(23)=(PlateName=RIGHTREAROVERHANG,ArmorZoneType=AZT_Right,PlateThickness=10,OverallHardness=400,bHighHardness=true)
	ArmorPlates(24)=(PlateName=TURRETFRONT,ArmorZoneType=AZT_TurretFront,PlateThickness=50,OverallHardness=400,bHighHardness=false)
	ArmorPlates(25)=(PlateName=TURRETLEFTFRONT,ArmorZoneType=AZT_TurretLeft,PlateThickness=30,OverallHardness=350,bHighHardness=false)
	ArmorPlates(26)=(PlateName=TURRETLEFTREAR,ArmorZoneType=AZT_TurretLeft,PlateThickness=30,OverallHardness=350,bHighHardness=false)
	ArmorPlates(27)=(PlateName=TURRETREAR,ArmorZoneType=AZT_TurretBack,PlateThickness=30,OverallHardness=340,bHighHardness=false)
	ArmorPlates(28)=(PlateName=TURRETRIGHTREAR,ArmorZoneType=AZT_TurretRight,PlateThickness=30,OverallHardness=340,bHighHardness=false)
	ArmorPlates(29)=(PlateName=TURRETRIGHTFRONT,ArmorZoneType=AZT_TurretRight,PlateThickness=30,OverallHardness=340,bHighHardness=false)
	ArmorPlates(30)=(PlateName=TURRETROOF,ArmorZoneType=AZT_TurretRoof,PlateThickness=20,OverallHardness=350,bHighHardness=false)
	ArmorPlates(31)=(PlateName=CUPPOLA,ArmorZoneType=AZT_Cuppola,PlateThickness=50,OverallHardness=331,bHighHardness=false)
	ArmorPlates(32)=(PlateName=CUPPOLAROOF,ArmorZoneType=AZT_Cuppola,PlateThickness=9,OverallHardness=450,bHighHardness=true)
	ArmorPlates(33)=(PlateName=CANNONGLACIS,ArmorZoneType=AZT_TurretFront,PlateThickness=50,OverallHardness=400,bHighHardness=false)
	ArmorPlates(34)=(PlateName=DRIVERFRONTVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=80,OverallHardness=150,bHighHardness=false)
	ArmorPlates(35)=(PlateName=DRIVERSIDEVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(36)=(PlateName=HULLMGSIDEVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(37)=(PlateName=GUNNERFRONTVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(38)=(PlateName=GUNNERREARVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(39)=(PlateName=LOADERFRONTVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(40)=(PlateName=LOADERREARVISIONSLIT,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(41)=(PlateName=CUPPOLAVIEWSLITONE,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(42)=(PlateName=CUPPOLAVIEWSLITTWO,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(43)=(PlateName=CUPPOLAVIEWSLITTHREE,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(44)=(PlateName=CUPPOLAVIEWSLITFOUR,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(45)=(PlateName=CUPPOLAVIEWSLITFIVE,ArmorZoneType=AZT_WeakSpots,PlateThickness=70,OverallHardness=150,bHighHardness=false)
	ArmorPlates(46)=(PlateName=RIGHTENGINEDECKGRATING,ArmorZoneType=AZT_WeakSpots,PlateThickness=10,OverallHardness=150,bHighHardness=false)
	ArmorPlates(47)=(PlateName=LEFTENGINEDECKGRATING,ArmorZoneType=AZT_WeakSpots,PlateThickness=10,OverallHardness=150,bHighHardness=false)

	GroundSpeed=655
	MaxSpeed=655	//682- 48 km/h
	TankControllerClass=class'CCSTankControllerPIII'
	//ScopeLensMaterial=Material'Vehicle_Mats.M_Common_Vehicles.scope_lens'
	//TankType=ROT_M41
	CrewHitZoneStart=23
	CrewHitZoneEnd=28
	RanOverDamageType=RODmgType_RunOver_M41
	
}