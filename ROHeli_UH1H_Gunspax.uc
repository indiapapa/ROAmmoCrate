//=============================================================================
// ROHeli_UH1H_Guns
//=============================================================================
// Australian Bell UH-1H Iroquois "Huey Bushranger" Gunship Helicopter with Pax
//=============================================================================
// DirtyGrandpa
//=============================================================================
class ROHeli_UH1H_Gunspax extends ROVehicleHelicopter_Ext
	abstract;

// Replicated information about the Copilot's minigun weapons
var repnotify vector CopilotFlashLocation;
var	repnotify byte CopilotFlashCount;
var repnotify rotator CopilotWeaponRotation;

/** ambient sound component for machine gun */
var AkComponent	MinigunLAmbient;
var AkEvent	MinigunLAmbientEvent;
var AkEvent	MinigunLAmbientLowEvent;
var AkComponent	MinigunRAmbient;
var AkEvent	MinigunRAmbientEvent;
var AkEvent	MinigunRAmbientLowEvent;
var AkComponent DoorMGLAmbient;
var AkEvent DoorMGLAmbientEvent;
var AkComponent DoorMGRAmbient;
var AkEvent DoorMGRAmbientEvent;

/** sound to play when maching gun stops firing. */
var AkComponent MinigunLStopSound;
var AkEvent MinigunLStopSoundEvent;
var AkComponent MinigunRStopSound;
var AkEvent MinigunRStopSoundEvent;
var AkComponent DoorMGLStopSound;
var AkEvent DoorMGLStopEvent;
var AkComponent DoorMGRStopSound;
var AkEvent DoorMGRStopEvent;

// Replicated information about the left Door MG
var repnotify vector DoorMGLeftFlashLocation;
var	repnotify byte DoorMGLeftFlashCount;
var repnotify rotator DoorMGLeftWeaponRotation;
var byte DoorMGLeftFiringMode;

// Replicated information about the right Door MG
var repnotify vector DoorMGRightFlashLocation;
var	repnotify byte DoorMGRightFlashCount;
var repnotify rotator DoorMGRightWeaponRotation;
var byte DoorMGRightFiringMode;

// Replicated information about the passenger positions
var repnotify byte DoorMGLeftCurrentPositionIndex;
var repnotify bool bDrivingDoorMGLeft;
var repnotify byte DoorMGRightCurrentPositionIndex;
var repnotify bool bDrivingDoorMGRight;
var repnotify byte PassengerOneCurrentPositionIndex;
var repnotify bool bDrivingPassengerOne;
var repnotify byte PassengerTwoCurrentPositionIndex;
var repnotify bool bDrivingPassengerTwo;
var repnotify byte PassengerThreeCurrentPositionIndex;
var repnotify bool bDrivingPassengerThree;
var repnotify byte PassengerFourCurrentPositionIndex;
var repnotify bool bDrivingPassengerFour;

/** Seat proxy death hit info */
var repnotify TakeHitInfo DeathHitInfo_ProxyPilot;
var repnotify TakeHitInfo DeathHitInfo_ProxyCopilot;
var repnotify TakeHitInfo DeathHitInfo_ProxyDoorMGLeft;
var repnotify TakeHitInfo DeathHitInfo_ProxyDoorMGRight;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassOne;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassTwo;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassThree;
var repnotify TakeHitInfo DeathHitInfo_ProxyPassFour;

// Cached vars for seat indexes to prevent them being calculated every tick for replication
var int SeatIndexDoorMGLeft;
var int SeatIndexDoorMGRight;

// Static meshes for the bulk of weaponry as seen by external viewers
var	StaticMeshComponent		ExtArmamentsMesh;
var	StaticMeshComponent		ExtM60MeshLeft;
var	StaticMeshComponent		ExtM60MeshRight;

// Wrecked static mesh for the armaments. Needs to be separate as the skelmesh is out of polys
var	StaticMeshComponent		WreckedArmamentsMesh;

/** Spawns tracers and muzzle flash **/
var ParticleSystemComponent MinigunLTracerComponent;
var ParticleSystemComponent MinigunRTracerComponent;

var ROSkelControlFan	MinigunRotController;

var byte				ActiveMinigun;		// Which of the M21 mount's miniguns are currently firing
var byte				LastActiveMinigun;

// TEMP BECAUSE THE PARENT class REFUSES TO REPLICATE THESE
// Replicated information about the passenger positions
var repnotify byte CopilotCurrentPositionIndex;
var repnotify bool bDrivingCopilot;
// END TEMP

var protected int RocketAmmoIncr;
var protected int MinigunAmmoIncr;
var protected int M60AmmoIncr;

var name CanopyFrontLeftParamName;
var name CanopyFrontRightParamName;
var name CanopyLeftParamName;
var name CanopyRightParamName;

var name  TracerRateParamName;
var float TracerRateHighRPM;
var float TracerRateLowRPM;

replication
{
	if (SeatIndexDoorMGLeft >= 0 && !IsSeatControllerReplicationViewer(SeatIndexDoorMGLeft))
		DoorMGLeftFlashCount, DoorMGLeftWeaponRotation;

	if (SeatIndexDoorMGRight >= 0 && !IsSeatControllerReplicationViewer(SeatIndexDoorMGRight))
		DoorMGRightFlashCount, DoorMGRightWeaponRotation;

	if ( SeatIndexCopilot >= 0 && !IsSeatControllerReplicationViewer(SeatIndexCopilot))
		CopilotFlashCount, CopilotWeaponRotation, ActiveMinigun;

	if (bNetDirty)
		DoorMGLeftFlashLocation, DoorMGRightFlashLocation, CopilotFlashLocation;

	// TEMP
	if (bNetDirty)
		CopilotCurrentPositionIndex, bDrivingCopilot;
	// END TEMP

	if (bNetDirty)
		DoorMGLeftCurrentPositionIndex, DoorMGRightCurrentPositionIndex,
		PassengerOneCurrentPositionIndex, PassengerTwoCurrentPositionIndex,
		PassengerThreeCurrentPositionIndex, PassengerFourCurrentPositionIndex,
		bDrivingDoorMGLeft, bDrivingDoorMGRight,
		bDrivingPassengerOne,
		bDrivingPassengerTwo, bDrivingPassengerThree, bDrivingPassengerFour;

	if (bNetDirty)
		DeathHitInfo_ProxyPilot, DeathHitInfo_ProxyCopilot, DeathHitInfo_ProxyDoorMGLeft, DeathHitInfo_ProxyDoorMGRight,
		DeathHitInfo_ProxyPassOne, DeathHitInfo_ProxyPassTwo, DeathHitInfo_ProxyPassThree, DeathHitInfo_ProxyPassFour;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	SeatIndexDoorMGLeft = GetDoorMGLeftSeatIndex();
	SeatIndexDoorMGRight = GetDoorMGRightSeatIndex();

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		Mesh.AttachComponentToSocket(MinigunLTracerComponent, 'Minigun_L_Muzzle');
		Mesh.AttachComponentToSocket(MinigunRTracerComponent, 'Minigun_R_Muzzle');
		Mesh.AttachComponentToSocket(MinigunLAmbient, 'Minigun_L_Muzzle');
		Mesh.AttachComponentToSocket(MinigunLStopSound, 'Minigun_L_Muzzle');
		Mesh.AttachComponentToSocket(MinigunRAmbient, 'Minigun_R_Muzzle');
		Mesh.AttachComponentToSocket(MinigunRStopSound, 'Minigun_R_Muzzle');
		Mesh.AttachComponent(ExtArmamentsMesh, 'Fuselage');
		Mesh.AttachComponentToSocket(DoorMGLAmbient, 'MG_Barrel_L');
		Mesh.AttachComponentToSocket(DoorMGRAmbient, 'MG_Barrel_R');
		Mesh.AttachComponentToSocket(DoorMGLStopSound, 'MG_Barrel_L');
		Mesh.AttachComponentToSocket(DoorMGRStopSound, 'MG_Barrel_R');
		Mesh.AttachComponent(ExtM60MeshLeft, 'MG_Frontend_L');
		Mesh.AttachComponent(ExtM60MeshRight, 'MG_Frontend_R');

		ExtM60MeshLeft.SetShadowParent(Mesh);
		ExtM60MeshRight.SetShadowParent(Mesh);
		ExtArmamentsMesh.SetShadowParent(Mesh);

		MinigunRotController = ROSkelControlFan(Mesh.FindSkelControl('Minigun_Barrel_Rot'));
	}

	// Setup entry point actors if any have been configured
	EntryPoints[2].EntryActor.MySeatType = VST_Gunner;
	EntryPoints[1].EntryActor.MySeatType = VST_Pilot;
}

/*
 *	Initializes MICs for modification of damage parameters
 */
simulated function SetupDamageMaterials()
{
	ExteriorGlassMIC = Mesh.CreateAndSetMaterialInstanceConstant(1);
	InteriorGlassMIC = MeshAttachments[0].Component.CreateAndSetMaterialInstanceConstant(2); // Glass MIC on exterior attachment

	super.SetupDamageMaterials();
}

// Damage the canopy materials
simulated function TakeCanopyDamage(name ZoneName)
{
	local byte NumHits;

	if(ZoneName == 'CANOPY_FRONT_RIGHT')
	{
		// Decode
		NumHits = CanopyGlassDamageStatus[3];
		NumHits = Min(20, NumHits + 1);

		if( InteriorGlassMIC != none )
			InteriorGlassMIC.SetScalarParameterValue(CanopyFrontRightParamName, NumHits);
		if( ExteriorGlassMIC != none )
			ExteriorGlassMIC.SetScalarParameterValue(CanopyFrontRightParamName, NumHits);

		// Encode
		CanopyGlassDamageStatus[3] = NumHits;
	}
	else if (ZoneName == 'CANOPY_FRONT_LEFT')
	{
		// Decode
		NumHits = CanopyGlassDamageStatus[2];
		NumHits = Min(20, NumHits + 1);

		if( InteriorGlassMIC != none )
			InteriorGlassMIC.SetScalarParameterValue(CanopyFrontLeftParamName, NumHits);
		if( ExteriorGlassMIC != none )
			ExteriorGlassMIC.SetScalarParameterValue(CanopyFrontLeftParamName, NumHits);

		// Encode
		CanopyGlassDamageStatus[2] = NumHits;
	}
	else if (ZoneName == 'CANOPY_RIGHT')
	{
		// Decode
		NumHits = CanopyGlassDamageStatus[1];
		NumHits = Min(20, NumHits + 1);

		if( InteriorGlassMIC != none )
			InteriorGlassMIC.SetScalarParameterValue(CanopyRightParamName, NumHits);
		if( ExteriorGlassMIC != none )
			ExteriorGlassMIC.SetScalarParameterValue(CanopyRightParamName, NumHits);

		// Encode
		CanopyGlassDamageStatus[1] = NumHits;
	}
	else //  left
	{
		// Decode
		NumHits = CanopyGlassDamageStatus[0];
		NumHits = Min(20, NumHits + 1);

		if( InteriorGlassMIC != none )
			InteriorGlassMIC.SetScalarParameterValue(CanopyLeftParamName, NumHits);
		if( ExteriorGlassMIC != none )
			ExteriorGlassMIC.SetScalarParameterValue(CanopyLeftParamName, NumHits);

		// Encode
		CanopyGlassDamageStatus[0] = NumHits;
	}

	// `Log("Canopy hit:"@ZoneName@"NumHits"@NumHits);
}

// Reset canopy materials
simulated function RepairCanopy()
{
	local int i;
	local name ParamName;

	super.RepairCanopy();

	if( InteriorGlassMIC != none )
	{
		InteriorGlassMIC.SetScalarParameterValue(CanopyFrontRightParamName, 0);
		InteriorGlassMIC.SetScalarParameterValue(CanopyFrontLeftParamName, 0);
		InteriorGlassMIC.SetScalarParameterValue(CanopyRightParamName, 0);
		InteriorGlassMIC.SetScalarParameterValue(CanopyLeftParamName, 0);
	}

	if( ExteriorGlassMIC != none )
	{
		ExteriorGlassMIC.SetScalarParameterValue(CanopyFrontRightParamName, 0);
		ExteriorGlassMIC.SetScalarParameterValue(CanopyFrontLeftParamName, 0);
		ExteriorGlassMIC.SetScalarParameterValue(CanopyRightParamName, 0);
		ExteriorGlassMIC.SetScalarParameterValue(CanopyLeftParamName, 0);
	}

	// Clean up blood
	for(i = 0; i < Seats.Length; i++)
	{
		ParamName = Seats[i].VehicleBloodMICParameterName;

		if( InteriorGlassMIC != none )
			InteriorGlassMIC.SetScalarParameterValue(ParamName, 0.f);
		if( ExteriorGlassMIC != none )
			ExteriorGlassMIC.SetScalarParameterValue(ParamName, 0.f);
	}

	for(i = 0; i < 4; i++)
	{
		CanopyGlassDamageStatus[i] = 0;
	}
}

simulated function int GetDoorMGLeftSeatIndex()
{
	return GetSeatIndexFromPrefix("DoorMGLeft");
}

simulated function int GetDoorMGRightSeatIndex()
{
	return GetSeatIndexFromPrefix("DoorMGRight");
}

/**
 * This event is called when the pawn is torn off
 */
simulated event TornOff()
{
	// Clear the ambient firing sounds
	if( bUseLoopedMGSound )
	{
		MinigunLAmbient.StopEvents();
		MinigunRAmbient.StopEvents();
		DoorMGLAmbient.StopEvents();
		DoorMGRAmbient.StopEvents();
	}

	if(MinigunLTracerComponent != none)
		MinigunLTracerComponent.SetActive(false);
	if(MinigunRTracerComponent != none)
		MinigunRTracerComponent.SetActive(false);

	if ( MinigunRotController != none )
		MinigunRotController.RotationRate.Roll = 0;

	Super.TornOff();
}

/** turns off all sounds */
simulated function StopVehicleSounds()
{
	Super.StopVehicleSounds();

	// Clear the ambient firing sounds
	if( bUseLoopedMGSound )
	{
		MinigunLAmbient.StopEvents();
		MinigunRAmbient.StopEvents();
		DoorMGLAmbient.StopEvents();
		DoorMGRAmbient.StopEvents();
	}
}

simulated function VehicleWeaponFireEffects(vector HitLocation, int SeatIndex)
{
	local byte CurrentFiringMode;

	CurrentFiringMode = SeatFiringMode(SeatIndex,,true);

	if( Seats[SeatIndex].GunClass != none )
	{
		// Special handling for the miniguns, to only display effects for the one that's firing
		if( SeatIndex == SeatIndexCopilot &&
			CurrentFiringMode == 0 )
		{
			if( ActiveMinigun != 1 )
				VehicleEvent(Seats[SeatIndex].GunClass.static.GetFireTriggerTag(0, CurrentFiringMode));
			else
				VehicleEvent( Name( "STOP_"$Seats[SeatIndex].GunClass.static.GetFireTriggerTag(0, 0) ) );

			if( ActiveMinigun != 0 )
				VehicleEvent(Seats[SeatIndex].GunClass.static.GetFireTriggerTag(1, CurrentFiringMode));
			else
				VehicleEvent( Name( "STOP_"$Seats[SeatIndex].GunClass.static.GetFireTriggerTag(1, 0) ) );
		}
		else
		{
			VehicleEvent(Seats[SeatIndex].GunClass.static.GetFireTriggerTag(GetBarrelIndex(SeatIndex), CurrentFiringMode));
		}
	}

	// @todo: for local players we can update tracers in ProjectileFire() for better accuracy
	UpdateTracers(SeatIndex, CurrentFiringMode );

	if( bUseLoopedMGSound )
	{
		if( SeatIndex == SeatIndexCopilot )
		{
			if( SeatFiringMode(SeatIndex,,true) == 0 )
			{
				if( ActiveMinigun != 1 )
				{
					if( !MinigunLAmbient.IsPlaying() )
					{
						if (MinigunLStopSound.IsPlaying())
						{
							MinigunLStopSound.StopEvents();
						}

						if( ActiveMinigun == 0 )
							MinigunLAmbient.PlayEvent(MinigunLAmbientEvent);
						else
							MinigunLAmbient.PlayEvent(MinigunLAmbientLowEvent);
					}
					else if( ActiveMinigun != LastActiveMinigun )
					{
						MinigunLAmbient.StopEvents();

						if( ActiveMinigun == 0 )
							MinigunLAmbient.PlayEvent(MinigunLAmbientEvent);
						else
							MinigunLAmbient.PlayEvent(MinigunLAmbientLowEvent);
					}
				}
				else
				{
					if ( MinigunLAmbient.IsPlaying() )
					{
						MinigunLAmbient.StopEvents();
						MinigunLStopSound.PlayEvent(MinigunLStopSoundEvent);
					}
				}

				if( ActiveMinigun != 0 )
				{
					if( !MinigunRAmbient.IsPlaying() )
					{
						if (MinigunRStopSound.IsPlaying())
						{
							MinigunRStopSound.StopEvents();
						}

						if( ActiveMinigun == 1 )
							MinigunRAmbient.PlayEvent(MinigunRAmbientEvent);
						else
							MinigunRAmbient.PlayEvent(MinigunRAmbientLowEvent);
					}
					else if( ActiveMinigun != LastActiveMinigun )
					{
						MinigunRAmbient.StopEvents();

						if( ActiveMinigun == 1 )
							MinigunRAmbient.PlayEvent(MinigunRAmbientEvent);
						else
							MinigunRAmbient.PlayEvent(MinigunRAmbientLowEvent);
					}
				}
				else
				{
					if ( MinigunRAmbient.IsPlaying() )
					{
						MinigunRAmbient.StopEvents();
						MinigunRStopSound.PlayEvent(MinigunRStopSoundEvent);
					}
				}
			}
		}

	}

	if( SeatIndex == SeatIndexCopilot )
	{
		if( ActiveMinigun != 1 )
		{
			if(MinigunLTracerComponent != none)
			{
				MinigunLTracerComponent.SetActive(true);
				MinigunLTracerComponent.SetFloatParameter(TracerRateParamName, TracerRateLowRPM);

				if(MinigunRTracerComponent != none)
				{
					MinigunRTracerComponent.SetFloatParameter(TracerRateParamName, TracerRateLowRPM);
				}
			}
		}
		else
		{
			if(MinigunLTracerComponent != none)
			{
				MinigunLTracerComponent.SetActive(false);

				if(MinigunRTracerComponent != none)
				{
					MinigunRTracerComponent.SetFloatParameter(TracerRateParamName, TracerRateHighRPM);
				}
			}
		}

		if( ActiveMinigun != 0 )
		{
			if(MinigunRTracerComponent != none)
			{
				MinigunRTracerComponent.SetActive(true);
				MinigunRTracerComponent.SetFloatParameter(TracerRateParamName, TracerRateLowRPM);

				if(MinigunLTracerComponent != none)
				{
					MinigunLTracerComponent.SetFloatParameter(TracerRateParamName, TracerRateLowRPM);
				}
			}
		}
		else
		{
			if(MinigunRTracerComponent != none)
			{
				MinigunRTracerComponent.SetActive(false);

				if(MinigunLTracerComponent != none)
				{
					MinigunLTracerComponent.SetFloatParameter(TracerRateParamName, TracerRateHighRPM);
				}
			}
		}

		if ( MinigunRotController != none && MinigunRotController.RotationRate.Roll == 0 )
		{
			MinigunRotController.RotationRate.Roll = 5.55 * 65536;  // 2000 rounds per min, 333 revolutions per min
		}
	}

	LastActiveMinigun = ActiveMinigun;
}

simulated function VehicleWeaponStoppedFiring(bool bViaReplication, int SeatIndex)
{
	Super.VehicleWeaponStoppedFiring(bViaReplication, SeatIndex);

	if( bUseLoopedMGSound )
	{
		if ( SeatIndex == SeatIndexCopilot )
		{
			if ( MinigunLAmbient.IsPlaying() )
			{
				MinigunLAmbient.StopEvents();
				MinigunLStopSound.PlayEvent(MinigunLStopSoundEvent);
			}

			if ( MinigunRAmbient.IsPlaying() )
			{
				MinigunRAmbient.StopEvents();
				MinigunRStopSound.PlayEvent(MinigunRStopSoundEvent);
			}
		}

	}

	if ( SeatIndex == SeatIndexCopilot )
	{
		if(MinigunLTracerComponent != none)
			MinigunLTracerComponent.SetActive(false);
		if(MinigunRTracerComponent != none)
			MinigunRTracerComponent.SetActive(false);

		if ( MinigunRotController != none )
		{
			MinigunRotController.RotationRate.Roll = 0;
		}
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
	local TakeHitInfo ProxyHitInfo;

	// Update the hit info for each seat proxy pertaining to this vehicle
	switch( SeatProxyIndex )
	{
	case 0:
		// Pilot
		DeathHitInfo_ProxyPilot.Damage = Damage;
		DeathHitInfo_ProxyPilot.HitLocation = HitLocation;
		DeathHitInfo_ProxyPilot.Momentum = Momentum;
		DeathHitInfo_ProxyPilot.DamageType = DamageType;

		ProxyHitInfo = DeathHitInfo_ProxyPilot;

		break;
	case 1:
		// Copilot
		DeathHitInfo_ProxyCopilot.Damage = Damage;
		DeathHitInfo_ProxyCopilot.HitLocation = HitLocation;
		DeathHitInfo_ProxyCopilot.Momentum = Momentum;
		DeathHitInfo_ProxyCopilot.DamageType = DamageType;

		ProxyHitInfo = DeathHitInfo_ProxyCopilot;

		break;
	case 2:
		// LeftMG
		DeathHitInfo_ProxyDoorMGLeft.Damage = Damage;
		DeathHitInfo_ProxyDoorMGLeft.HitLocation = HitLocation;
		DeathHitInfo_ProxyDoorMGLeft.Momentum = Momentum;
		DeathHitInfo_ProxyDoorMGLeft.DamageType = DamageType;

		ProxyHitInfo = DeathHitInfo_ProxyDoorMGLeft;

		break;
	case 3:
		// RightMG
		DeathHitInfo_ProxyDoorMGRight.Damage = Damage;
		DeathHitInfo_ProxyDoorMGRight.HitLocation = HitLocation;
		DeathHitInfo_ProxyDoorMGRight.Momentum = Momentum;
		DeathHitInfo_ProxyDoorMGRight.DamageType = DamageType;

		ProxyHitInfo = DeathHitInfo_ProxyDoorMGRight;

		break;
	case 4:
		// Passenger One
		DeathHitInfo_ProxyPassOne.Damage = Damage;
		DeathHitInfo_ProxyPassOne.HitLocation = HitLocation;
		DeathHitInfo_ProxyPassOne.Momentum = Momentum;
		DeathHitInfo_ProxyPassOne.DamageType = DamageType;

		ProxyHitInfo = DeathHitInfo_ProxyPassOne;

		break;
	case 5:
		// Passenger Two
		DeathHitInfo_ProxyPassTwo.Damage = Damage;
		DeathHitInfo_ProxyPassTwo.HitLocation = HitLocation;
		DeathHitInfo_ProxyPassTwo.Momentum = Momentum;
		DeathHitInfo_ProxyPassTwo.DamageType = DamageType;

		ProxyHitInfo = DeathHitInfo_ProxyPassTwo;

		break;
	case 6:
		// Passenger Three
		DeathHitInfo_ProxyPassThree.Damage = Damage;
		DeathHitInfo_ProxyPassThree.HitLocation = HitLocation;
		DeathHitInfo_ProxyPassThree.Momentum = Momentum;
		DeathHitInfo_ProxyPassThree.DamageType = DamageType;

		ProxyHitInfo = DeathHitInfo_ProxyPassThree;

		break;
	case 7:
		// Passenger Four
		DeathHitInfo_ProxyPassFour.Damage = Damage;
		DeathHitInfo_ProxyPassFour.HitLocation = HitLocation;
		DeathHitInfo_ProxyPassFour.Momentum = Momentum;
		DeathHitInfo_ProxyPassFour.DamageType = DamageType;

		ProxyHitInfo = DeathHitInfo_ProxyPassFour;

		break;

	}

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		PlaySeatProxyDeathHitEffects(SeatProxyIndex, ProxyHitInfo);
	}

	// Call super!
	Super.DamageSeatProxy(SeatProxyIndex, Damage, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}

/**
 * Copied from ROWeapon. Hacked in here to add spread to huey tracers -Austin
 * Adds any fire spread offset to the passed in rotator. Overriden to support our additional spread properties
 * @param Aim the base aim direction
 * @return the adjusted aim direction
 */
simulated function Vector AddSpreadVector(Rotator BaseAim)
{
	local vector X, Y, Z;
	local float CurrentSpread, RandY, RandZ;

	CurrentSpread = 0.004; // Match to ROHWeap_UH1_DoorMG_L Spread

	// Add in any spread.
	GetAxes(BaseAim, X, Y, Z);
	RandY = FRand() - 0.5;
	RandZ = Sqrt(0.5 - Square(RandY)) * (FRand() - 0.5);

	return X + RandY * CurrentSpread * Y + RandZ * CurrentSpread * Z;
}

/**
 * Increment tracer count and spawn tracer round if needed.
 * Network: ALL
 * Now has handling to change the tracer direction based on whether the weapon's in sights mode or not
 */
simulated function UpdateTracers(int SeatIndex, byte FireModeNum)
{
	local class<ROBulletTracer> TracerClass;
	local vector			StartLocation;
	local rotator			Direction;
	local ROBulletTracer	SpawnedTracer;
	local name				GunCameraSocket;

	// tracers are client only effects
	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	if ( Seats[SeatIndex].WeaponTracerClass.Length > FireModeNum )
	{
		TracerClass = Seats[SeatIndex].WeaponTracerClass[FireModeNum];
	}

	if ( TracerClass != None && Seats[SeatIndex].TracerFrequency > 0 )
	{
		--Seats[SeatIndex].TracerFrequency;
		if ( Seats[SeatIndex].TracerFrequency == 0 )
		{
			Seats[SeatIndex].TracerFrequency = default.Seats[SeatIndex].TracerFrequency;

			// Door MGs should use the centre of the screen if firing from the gun's sights, so that the tracers line up with the sights
			if ( (SeatIndex == SeatIndexDoorMGLeft || SeatIndex == SeatIndexDoorMGRight) && SeatPositionIndex(SeatIndex,,true) != Seats[SeatIndex].FiringPositionIndex )
			{
				GetBarrelLocationAndRotation(SeatIndex, StartLocation, Direction);
			}
			else
			{
				GunCameraSocket = Seats[SeatIndex].SeatPositions[SeatPositionIndex(SeatIndex,,true)].PositionCameraTag;
				Mesh.GetSocketWorldLocationAndRotation(GunCameraSocket, StartLocation, Direction);
			}

			// Spawn projectile
			SpawnedTracer = Spawn(TracerClass,,, StartLocation);
			if( SpawnedTracer != none && !SpawnedTracer.bDeleteMe )
			{
				SpawnedTracer.Init( AddSpreadVector(Direction), Velocity );
			}
		}
	}
}

/**
 * This event is triggered when a repnotify variable is received
 *
 * @param	VarName		The name of the variable replicated
 */
simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'DeathHitInfo_ProxyPilot')
	{
		PlaySeatProxyDeathHitEffects(0, DeathHitInfo_ProxyPilot);
	}
	else if (VarName == 'DeathHitInfo_ProxyCopilot')
	{
		PlaySeatProxyDeathHitEffects(1, DeathHitInfo_ProxyCopilot);
	}
	else if (VarName == 'DeathHitInfo_ProxyDoorMGLeft')
	{
		PlaySeatProxyDeathHitEffects(2, DeathHitInfo_ProxyDoorMGLeft);
	}
	else if (VarName == 'DeathHitInfo_ProxyDoorMGRight')
	{
		PlaySeatProxyDeathHitEffects(3, DeathHitInfo_ProxyDoorMGRight);
	}
	else if (VarName == 'DeathHitInfo_ProxyPassOne')
	{
		PlaySeatProxyDeathHitEffects(4, DeathHitInfo_ProxyPassOne);
	}
	else if (VarName == 'DeathHitInfo_ProxyPassTwo')
	{
		PlaySeatProxyDeathHitEffects(5, DeathHitInfo_ProxyPassTwo);
	}
	else if (VarName == 'DeathHitInfo_ProxyPassThree')
	{
		PlaySeatProxyDeathHitEffects(6, DeathHitInfo_ProxyPassThree);
	}
	else if (VarName == 'DeathHitInfo_ProxyPassFour')
	{
		PlaySeatProxyDeathHitEffects(7, DeathHitInfo_ProxyPassFour);
	}
	else
	{
	   super.ReplicatedEvent(VarName);
	}
}

/** Turn the vehicle interior visibility on or off. */
simulated function SetInteriorVisibility(bool bVisible)
{
	if( bInteriorVisible != bVisible )
	{
		ExtArmamentsMesh.SetHidden(bVisible);
		ExtM60MeshLeft.SetHidden(bVisible);
		ExtM60MeshRight.SetHidden(bVisible);
	}

	super.SetInteriorVisibility(bVisible);
}

// called by ammo volumes. Incrementally refill ammo
function RefilledSomeAmmo()
{
	local int Amt;
	local ROHelicopterWeapon ROHW;

	ROHW = ROHelicopterWeapon(Seats[0].Gun);

	if(ROHW != none)
	{
		if(ROHW.AmmoCount < ROHW.default.MaxAmmoCount) // pilot weapons
		{
			Amt = (ROHW.default.MaxAmmoCount - ROHW.AmmoCount >= RocketAmmoIncr) ? RocketAmmoIncr : ROHW.default.MaxAmmoCount - ROHW.AmmoCount;
			ROHW.AddAmmo(Amt);
		}
	}

	ROHW = ROHelicopterWeapon(Seats[1].Gun);

	if(ROHW != none) // gunner weapons
	{
		if(ROHW.AmmoCount < ROHW.default.MaxAmmoCount) // pilot weapons
		{
			Amt = (ROHW.default.MaxAmmoCount - ROHW.AmmoCount >= MinigunAmmoIncr) ? MinigunAmmoIncr : ROHW.default.MaxAmmoCount - ROHW.AmmoCount;
			ROHW.AddAmmo(Amt);
		}
	}
	if(Seats[2].Gun != none && Seats[2].Gun.AmmoCount < Seats[2].Gun.default.MaxAmmoCount) // left door gun
	{
		Amt = (Seats[2].Gun.default.MaxAmmoCount - Seats[2].Gun.AmmoCount >= M60AmmoIncr) ? M60AmmoIncr : Seats[2].Gun.default.MaxAmmoCount - Seats[2].Gun.AmmoCount;
		Seats[2].Gun.AddAmmo(Amt);
	}

	if(Seats[3].Gun != none && Seats[3].Gun.AmmoCount < Seats[3].Gun.default.MaxAmmoCount) // right door gun
	{
		Amt = (Seats[3].Gun.default.MaxAmmoCount - Seats[3].Gun.AmmoCount >= M60AmmoIncr) ? M60AmmoIncr : Seats[3].Gun.default.MaxAmmoCount - Seats[3].Gun.AmmoCount;
		Seats[3].Gun.AddAmmo(Amt);
	}


}

// called by ammo volumes. Incrementally refill ammo. This value is then multiplied by the volume's interval, so this time is if that interval is one second
function int GetResupplyTime()
{
	local int TimeRemaining;
	local ROHelicopterWeapon ROHW;

	TimeRemaining = -1;

	ROHW = ROHelicopterWeapon(Seats[0].Gun);

	if(ROHW != none)
	{
		if(ROHW.AmmoCount < ROHW.default.MaxAmmoCount) // pilot weapons
		{
			TimeRemaining = Max( TimeRemaining, FCeil((ROHW.default.MaxAmmoCount - ROHW.AmmoCount) / float(RocketAmmoIncr)) );
		}
	}

	ROHW = ROHelicopterWeapon(Seats[1].Gun);

	if(ROHW != none) // gunner weapons
	{
		if(ROHW.AmmoCount < ROHW.default.MaxAmmoCount)
		{
			TimeRemaining = Max( TimeRemaining, FCeil((ROHW.default.MaxAmmoCount - ROHW.AmmoCount) / float(MinigunAmmoIncr)) );
		}
	}


	return (TimeRemaining > 0) ? TimeRemaining * class'ROVolumeAmmoResupply'.default.HelicopterResupplyInterval : -1;
}

simulated function HideTailBoomOnDestroyedMesh()
{
	super.HideTailBoomOnDestroyedMesh();
	Mesh.HideBoneByName('Tail', PBO_Term);
}

simulated function HideMainRotorsOnDestroyedMesh()
{
	Mesh.HideBoneByName('Blade_01', PBO_Term);
	Mesh.HideBoneByName('Blade_02', PBO_Term);
}

simulated function HideTailRotorsOnDestroyedMesh()
{
	// Mesh.HideBoneByName('Tail', PBO_Term);
}

function TriggerDeadCrewBattleChatter(int VictimSeatIndex)
{
	if ( VictimSeatIndex == SeatIndexDoorMGLeft || VictimSeatIndex == SeatIndexDoorMGRight )
	{
		//HandleBattleChatterEvent(`BATTLECHATTER_HeloDoorGunnerDead);
	}
	else
		super.TriggerDeadCrewBattleChatter(VictimSeatIndex);
}

simulated event Destroyed()
{
	super.Destroyed();

	if(MinigunLTracerComponent != none)
	{
		MinigunLTracerComponent.DetachFromAny();
		MinigunLTracerComponent = none;
	}

	if(MinigunRTracerComponent != none)
	{
		MinigunRTracerComponent.DetachFromAny();
		MinigunRTracerComponent = none;
	}
}

state DyingVehicle
{
	simulated function SwapToDestroyedMesh()
	{
		if(MinigunLTracerComponent != none)
		{
			MinigunLTracerComponent.DetachFromAny();
			MinigunLTracerComponent = none;
		}

		if(MinigunRTracerComponent != none)
		{
			MinigunRTracerComponent.DetachFromAny();
			MinigunRTracerComponent = none;
		}

		Super.SwapToDestroyedMesh();

		Mesh.AttachComponent(WreckedArmamentsMesh, 'Fuselage');
		WreckedArmamentsMesh.SetHidden(false);
	}
}

// Special function that applies only to the M21 dual minigun weapon
// Set which of the two miniguns are active and should therefore be displaying effects and spawning bullets
simulated function SetActiveMiniguns(byte ActiveGun)
{
	ActiveMinigun = ActiveGun;
}

// Overridden to let us choose which side we're firing from for miniguns on the fly
simulated event GetBarrelLocationAndRotation(int SeatIndex, out vector SocketLocation, optional out rotator SocketRotation)
{
	local byte CurrentFiringMode;
	if ( SeatIndex >= 0 && Seats[SeatIndex].GunSocket.Length > 0 )
	{
		// TODO: This will get the proper barrel location for our tanks,
		// but won't work with the UT stuff we brought over for multi-barrel
		// weapons. Add support back in for that if we need to - Ramm
		CurrentFiringMode = SeatFiringMode(SeatIndex,, true);

		// Small hack to allow an override for which minigun barrel to fire from
		if( SeatIndex == SeatIndexCopilot && Seats[SeatIndex].Gun != none && ActiveMinigun != 255 )
		{
			if( ActiveMinigun == 0 )
				Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].GunSocket[0], SocketLocation, SocketRotation);
			else if( ActiveMinigun == 1 )
				Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].GunSocket[1], SocketLocation, SocketRotation);
			else
				Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].GunSocket[GetBarrelIndex(SeatIndex)], SocketLocation, SocketRotation);
		}
		else if( CurrentFiringMode < Seats[SeatIndex].GunSocket.Length && !Seats[SeatIndex].bAlternatingBarrelIndices )
		{
			Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].GunSocket[CurrentFiringMode], SocketLocation, SocketRotation);
		}
		else
		{
			Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].GunSocket[GetBarrelIndex(SeatIndex)], SocketLocation, SocketRotation);
		}
	}
	else
	{
		SocketLocation = Location;
		SocketRotation = Rotation;
	}
}

function UpdateSeatProxyHealth(int SeatProxyIndex, int NewHealth, optional bool bIsTransition)
{
	super.UpdateSeatProxyHealth(SeatProxyIndex, NewHealth, bIsTransition);

	// For achievement ACHID_TwoEnterOneLeaves. Either the pilot or the gunner must have been killed in the air.
	// We don't bother checking if both die because then there's no-one left to exit the vehicle and trigger the achievement anywway
	if( !bIsTransition && (SeatProxyIndex == 0 || SeatProxyIndex == SeatIndexCopilot) )
	{
		//if( SeatProxies[SeatProxyIndex].Health <= 0 && Altitude / 50 >= `REQ_MinOneLeavesHeight )
		//	bPilotKilledInAir = true;
	}
}

// Achievement Helper
function CheckCrashLandings()
{
	local ROPawn ROP;

	super.CheckCrashLandings();

	if( bPilotKilledInAir )
	{
		bPilotKilledInAir = false;

		if( bVehicleOnGround )
		{
			if( bBackSeatDriving )
			{
				ROP = GetDriverForSeatIndex(BackSeatDriverIndex);
			}
			else if( bDriving )
			{
				ROP = GetDriverForSeatIndex(0);
			}

			if( ROP != none )
				ROP.bLandedBushrangerSolo = true;
		}
	}
}

function DriverLeft()
{
	CheckForLandedBushranderSoloAchievement(ROPawn(Driver));

	super.DriverLeft();
}

function PassengerLeave(int SeatIndex)
{
	CheckForLandedBushranderSoloAchievement(ROPawn(Seats[SeatIndex].StoragePawn));

	Super.PassengerLeave(SeatIndex);
}

function CheckForLandedBushranderSoloAchievement(ROPawn Left)
{
	if( Left != none && !Left.bSwitchingVehicleSeats && Left.Health > 0 && Left.bLandedBushrangerSolo )
	{
		Left.bLandedBushrangerSolo = false;

	}
}

defaultproperties
{
	Team=1
	bTransportHelicopter=false
	bIsGunship=true // CFR-942

	// Centre of mass
	COMOffset=(x=20.0,y=0.0,z=-85.0)

	Begin Object Name=CollisionCylinder
		CollisionHeight=120
		CollisionRadius=500.0
		Translation=(X=0.0,Y=0.0,Z=0.0) // TODO: Offset this backwards!
	End Object
	CylinderComponent=CollisionCylinder

	DefaultPhysicalMaterial=PhysicalMaterial'VH_VN_US_UH1H.Phys.PhysMat_UH1H'
	DrivingPhysicalMaterial=PhysicalMaterial'VH_VN_US_UH1H.Phys.PhysMat_UH1H'

	bCopilotCanFly=true
	bCopilotMustBePilot=true

	Seats(0)={(	CameraTag=None,
				CameraOffset=-420,
				SeatAnimBlendName=PilotPositionNode,
				SeatPositions=((bDriverVisible=true,bAllowFocus=false,PositionCameraTag=none,ViewFOV=0.0,bViewFromCameraTag=false,bDrawOverlays=false,
									PositionIdleAnim=Pilot_Idle,DriverIdleAnim=Pilot_Idle,AlternateIdleAnim=Pilot_Idle_AI,SeatProxyIndex=0,
									LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_PilotCollective,DefaultEffectorRotationTargetName=IK_PilotCollective),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_PilotCyclic,DefaultEffectorRotationTargetName=IK_PilotCyclic),
									LeftFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_PilotLPedal,DefaultEffectorRotationTargetName=IK_PilotLPedal),
									RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_PilotRPedal,DefaultEffectorRotationTargetName=IK_PilotRPedal),
									PositionFlinchAnims=(Pilot_Flinch),
									PositionDeathAnims=(Pilot_Death))
								),
				bSeatVisible=true,
				SeatBone=Pilot_Attach,
				DriverDamageMult=0.5,
				InitialPositionIndex=0,
				SeatRotation=(Pitch=0,Yaw=0,Roll=0),
				VehicleBloodMICParameterName=Gore02,
				GunClass=class'ROHWeap_UH1H_RocketPods',
				GunSocket=(Launcher_L_Front,Launcher_R_Front),
				GunPivotPoints=(),
				TurretControls=(),
				FiringPositionIndex=0,
				TracerFrequency=5,
				WeaponTracerClass=(none, none),
				MuzzleFlashLightClass=(none, none), //(class'ROVehicleMGMuzzleFlashLight',class'ROVehicleMGMuzzleFlashLight'),
				bAlternatingBarrelIndices=true,
				)}

	Seats(1)={(	CameraTag=None,
				CameraOffset=-420,
				SeatAnimBlendName=CopilotPositionNode,
				SeatPositions=(// Flying
								(bDriverVisible=true,bCanFlyHelo=true,bAllowFocus=false,PositionCameraTag=none,ViewFOV=0.0,
								PositionUpAnim=copilot_IdleToFlight,PositionIdleAnim=copilot_Flight_Idle,DriverIdleAnim=copilot_Flight_Idle,AlternateIdleAnim=copilot_Flight_Idle_AI,SeatProxyIndex=1,
								LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_CopilotCollective,DefaultEffectorRotationTargetName=IK_CopilotCollective),
								RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_CopilotCyclic,DefaultEffectorRotationTargetName=IK_CopilotCyclic),
								LeftFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_CopilotLPedal,DefaultEffectorRotationTargetName=IK_CopilotLPedal),
								RightFootIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_CopilotRPedal,DefaultEffectorRotationTargetName=IK_CopilotRPedal),
								PositionFlinchAnims=(copilot_Flight_Flinch),
								PositionDeathAnims=(copilot_Flight_Death)),
								// Freelooking
								(bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=0.0,
									PositionUpAnim=copilot_SightToIdle,PositionDownAnim=copilot_FlightToIdle,PositionIdleAnim=copilot_Idle,DriverIdleAnim=copilot_Idle,AlternateIdleAnim=copilot_Idle_AI,SeatProxyIndex=1,bIgnoreWeapon=true,bRotateGunOnCommand=true,
									LeftHandIKInfo=(PinEnabled=true),
									RightHandIKInfo=(PinEnabled=true),
									LeftFootIKInfo=(PinEnabled=true),
									RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(copilot_Flinch),
									PositionDeathAnims=(copilot_Death)),
								// Gunsight
								(bDriverVisible=true,bAllowFocus=false,PositionCameraTag=CPG_Camera,ViewFOV=70.0,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bDrawOverlays=true,bUseDOF=true,
									PositionDownAnim=copilot_IdleToSight,PositionIdleAnim=copilot_Sight_Idle,DriverIdleAnim=copilot_Sight_Idle,AlternateIdleAnim=copilot_Sight_Idle_AI,SeatProxyIndex=1,
									LeftHandIKInfo=(PinEnabled=true),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_CPGRight,DefaultEffectorRotationTargetName=IK_CPGRight),
									LeftFootIKInfo=(PinEnabled=true),
									RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(copilot_Sight_Flinch),
									PositionDeathAnims=(copilot_Sight_Death))
								),
				TurretVarPrefix="Copilot",
				bSeatVisible=true,
				SeatBone=copilot_Attach,
				DriverDamageMult=0.5,
				InitialPositionIndex=2,
				FiringPositionIndex=2,
				SeatRotation=(Pitch=0,Yaw=0,Roll=0),
				VehicleBloodMICParameterName=Gore02,
				GunClass=class'ROHWeap_UH1H_M21',
				GunSocket=(Minigun_L_Muzzle,Minigun_R_Muzzle),
				GunPivotPoints=(M21_Rot_Yaw, M21_Rot_Yaw),
				TurretControls=(M21_Rot_Yaw, M21_Rot_Pitch, M21_L_Rot_Yaw, M21_R_Rot_Yaw),
				DetachedTurretPivotSockets=(,, Minigun_L_Muzzle, Minigun_R_Muzzle),
				MuzzleFlashLightClass=(none, none), //(class'ROVehicleMGMuzzleFlashLight',class'ROVehicleMGMuzzleFlashLight'),
				bAlternatingBarrelIndices=true,
				)}
	Seats(2)={(	GunClass=class'ROHWeap_UH1_DoorMG_L',
				GunSocket=(MG_Barrel_L),
				GunPivotPoints=(MG_Pitch_L),
				TurretControls=(MGL_Rot_Yaw,MGL_Rot_Pitch),
				CameraTag=None,
				CameraOffset=-420,
				SeatAnimBlendName=CrewChiefPositionNode,
				SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=0.0,
									bIsExterior=true, bIgnoreWeapon=true,bRotateGunOnCommand=true,
									PositionUpAnim=LGunner_Idle_pose,PositionIdleAnim=LGunner_Idle,DriverIdleAnim=LGunner_Idle,AlternateIdleAnim=LGunner_Idle_AI,SeatProxyIndex=2,
									LeftHandIKInfo=(PinEnabled=true),
									RightHandIKInfo=(PinEnabled=true),
									HipsIKInfo=(PinEnabled=true),
									LeftFootIKInfo=(PinEnabled=true),
									RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(LGunner_Idle),
									PositionDeathAnims=(LGunner_Death),
									ChestIKInfo=(PinEnabled=true)),
								// Above gun sights
								(bDriverVisible=true,bAllowFocus=true,PositionCameraTag=MGL_Camera_High,ViewFOV=0.0,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bUseDOF=true,
									bIsExterior=true,
									PositionUpAnim=LGunner_Ironsight_Idle_pose,PositionDownAnim=LGunner_Ironsight_Idle_pose,PositionIdleAnim=LGunner_Idle,bConstrainRotation=false,YawContraintIndex=0,PitchContraintIndex=1,DriverIdleAnim=LGunner_Ironsight_Idle,AlternateIdleAnim=LGunner_Ironsight_Idle_AI,SeatProxyIndex=2,
									LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGLLeftHand,DefaultEffectorRotationTargetName=IK_DoorMGLLeftHand),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGLRightHand,DefaultEffectorRotationTargetName=IK_DoorMGLRightHand),
									HipsIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGLHips,DefaultEffectorRotationTargetName=IK_DoorMGLHips),
									LeftFootIKInfo=(PinEnabled=true),
									RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(LGunner_Idle),
									PositionDeathAnims=(LGunner_Death),
									ChestIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGLChest,DefaultEffectorRotationTargetName=IK_DoorMGLChest)),
								// Gun sights
								(bDriverVisible=true,bAllowFocus=true,PositionCameraTag=MGL_Camera,ViewFOV=0.0,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bUseDOF=true,
									bIsExterior=true,
									PositionDownAnim=LGunner_Ironsight_Idle_pose,PositionIdleAnim=LGunner_Idle,bConstrainRotation=false,YawContraintIndex=0,PitchContraintIndex=1,DriverIdleAnim=LGunner_Ironsight_Idle,AlternateIdleAnim=LGunner_Ironsight_Idle_AI,SeatProxyIndex=2,
									LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGLLeftHand,DefaultEffectorRotationTargetName=IK_DoorMGLLeftHand),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGLRightHand,DefaultEffectorRotationTargetName=IK_DoorMGLRightHand),
									HipsIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGLHips,DefaultEffectorRotationTargetName=IK_DoorMGLHips),
									LeftFootIKInfo=(PinEnabled=true),
									RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(LGunner_Idle),
									PositionDeathAnims=(LGunner_Death),
									ChestIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGLChest,DefaultEffectorRotationTargetName=IK_DoorMGLChest))),
				TurretVarPrefix="DoorMGLeft",
				bSeatVisible=true,
				SeatBone=L_Gunner_Attach,
				DriverDamageMult=1.0,
				InitialPositionIndex=2,
				FiringPositionIndex=2,
				SeatRotation=(Pitch=0,Yaw=0,Roll=0),
				WeaponRotation=(Pitch=0,Yaw=16384,Roll=0),
				VehicleBloodMICParameterName=Gore02,
				TracerFrequency=5,
				WeaponTracerClass=(class'M60DBulletTracer',class'M60DBulletTracer'),
				MuzzleFlashLightClass=(none, none), //(class'ROVehicleMGMuzzleFlashLight',class'ROVehicleMGMuzzleFlashLight'),
				)}

	Seats(3)={(	GunClass=class'ROHWeap_UH1_DoorMG_R',
				GunSocket=(MG_Barrel_R),
				GunPivotPoints=(MG_Pitch_R),
				TurretControls=(MGR_Rot_Yaw,MGR_Rot_Pitch),
				CameraTag=None,
				CameraOffset=-420,
				SeatAnimBlendName=DoorGunnerPositionNode,
				SeatPositions=((bDriverVisible=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=0.0,
									bIsExterior=true, bIgnoreWeapon=true,bRotateGunOnCommand=true,
									PositionUpAnim=RGunner_Idle_pose,PositionIdleAnim=RGunner_Idle,DriverIdleAnim=RGunner_Idle,AlternateIdleAnim=RGunner_Idle_AI,SeatProxyIndex=3,
									LeftHandIKInfo=(PinEnabled=true),
									RightHandIKInfo=(PinEnabled=true),
									HipsIKInfo=(PinEnabled=true),
									LeftFootIKInfo=(PinEnabled=true),
									RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(RGunner_Idle),
									PositionDeathAnims=(RGunner_Death),
									ChestIKInfo=(PinEnabled=true)),
								// Above gun sights
								(bDriverVisible=true,bAllowFocus=true,PositionCameraTag=MGR_Camera_High,ViewFOV=0.0,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bUseDOF=true,
									bIsExterior=true,
									PositionUpAnim=RGunner_Ironsight_Idle_pose,PositionDownAnim=RGunner_Ironsight_Idle_pose,PositionIdleAnim=RGunner_Idle,bConstrainRotation=false,YawContraintIndex=0,PitchContraintIndex=1,DriverIdleAnim=Lgunner_Ironsight_Idle,AlternateIdleAnim=Lgunner_Ironsight_Idle_AI,SeatProxyIndex=3,
									LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGRLeftHand,DefaultEffectorRotationTargetName=IK_DoorMGRLeftHand),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGRRightHand,DefaultEffectorRotationTargetName=IK_DoorMGRRightHand),
									HipsIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGRHips,DefaultEffectorRotationTargetName=IK_DoorMGRHips),
									LeftFootIKInfo=(PinEnabled=true),
									RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(RGunner_Idle),
									PositionDeathAnims=(RGunner_Death),
									ChestIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGRChest,DefaultEffectorRotationTargetName=IK_DoorMGRChest)),
								// Gun sights
								(bDriverVisible=true,bAllowFocus=true,PositionCameraTag=MGR_Camera,ViewFOV=0.0,bCamRotationFollowSocket=true,bViewFromCameraTag=true,bUseDOF=true,
									bIsExterior=true,
									PositionDownAnim=RGunner_Ironsight_Idle_pose,PositionIdleAnim=RGunner_Idle,bConstrainRotation=false,YawContraintIndex=0,PitchContraintIndex=1,DriverIdleAnim=Lgunner_Ironsight_Idle,AlternateIdleAnim=Lgunner_Ironsight_Idle_AI,SeatProxyIndex=3,
									LeftHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGRLeftHand,DefaultEffectorRotationTargetName=IK_DoorMGRLeftHand),
									RightHandIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGRRightHand,DefaultEffectorRotationTargetName=IK_DoorMGRRightHand),
									HipsIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGRHips,DefaultEffectorRotationTargetName=IK_DoorMGRHips),
									LeftFootIKInfo=(PinEnabled=true),
									RightFootIKInfo=(PinEnabled=true),
									PositionFlinchAnims=(RGunner_Idle),
									PositionDeathAnims=(RGunner_Death),
									ChestIKInfo=(IKEnabled=true,DefaultEffectorLocationTargetName=IK_DoorMGRChest,DefaultEffectorRotationTargetName=IK_DoorMGRChest))),
				TurretVarPrefix="DoorMGRight",
				bSeatVisible=true,
				SeatBone=R_Gunner_Attach,
				DriverDamageMult=1.0,
				InitialPositionIndex=2,
				FiringPositionIndex=2,
				SeatRotation=(Pitch=0,Yaw=0,Roll=0),
				WeaponRotation=(Pitch=0,Yaw=-16384,Roll=0),
				VehicleBloodMICParameterName=Gore02,
				TracerFrequency=5,
				WeaponTracerClass=(class'M60DBulletTracer',class'M60DBulletTracer'),
				MuzzleFlashLightClass=(none, none), //(class'ROVehicleMGMuzzleFlashLight',class'ROVehicleMGMuzzleFlashLight'),
				)}

	Seats(4)={(	CameraTag=None,
		CameraOffset=-420,
		SeatAnimBlendName=Pass1PositionNode,
		SeatPositions=((bDriverVisible=true,bIsExterior=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=0.0,PositionIdleAnim=Pass01_Idle,DriverIdleAnim=Pass01_Idle,AlternateIdleAnim=Pass01_Idle_AI,SeatProxyIndex=4,
							bIsExterior=true,
							PositionFlinchAnims=(Pass01_Idle),
							PositionDeathAnims=(Pass01_Death))
						),
		TurretVarPrefix="PassengerOne",
		bSeatVisible=true,
		DriverDamageMult=1.0,
		InitialPositionIndex=0,
		SeatRotation=(Pitch=0,Yaw=0,Roll=0),
		SeatBone=passenger_01_Attach,
		VehicleBloodMICParameterName=Gore04
		)}

	Seats(5)={(	CameraTag=None,
		CameraOffset=-420,
		SeatAnimBlendName=Pass2PositionNode,
		SeatPositions=((bDriverVisible=true,bIsExterior=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=0.0,PositionIdleAnim=Pass02_Idle,DriverIdleAnim=Pass02_Idle,AlternateIdleAnim=Pass02_Idle_AI,SeatProxyIndex=5,
							bIsExterior=true,
							PositionFlinchAnims=(Pass02_Idle),
							PositionDeathAnims=(Pass02_Death))
						),
		TurretVarPrefix="PassengerTwo",
		bSeatVisible=true,
		DriverDamageMult=1.0,
		InitialPositionIndex=0,
		SeatRotation=(Pitch=0,Yaw=0,Roll=0),
		SeatBone=passenger_02_Attach,
		VehicleBloodMICParameterName=Gore04
		)}

	Seats(6)={(	CameraTag=None,
		CameraOffset=-420,
		SeatAnimBlendName=Pass3PositionNode,
		SeatPositions=((bDriverVisible=true,bIsExterior=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=0.0,PositionIdleAnim=Pass03_Idle,DriverIdleAnim=Pass03_Idle,AlternateIdleAnim=Pass03_Idle_AI,SeatProxyIndex=6,
							bIsExterior=true,
							PositionFlinchAnims=(Pass03_Idle),
							PositionDeathAnims=(Pass03_Death))
						),
		TurretVarPrefix="PassengerThree",
		bSeatVisible=true,
		DriverDamageMult=1.0,
		InitialPositionIndex=0,
		SeatRotation=(Pitch=0,Yaw=0,Roll=0),
		SeatBone=passenger_03_Attach,
		VehicleBloodMICParameterName=Gore04
		)}
	Seats(7)={(	CameraTag=None,
		CameraOffset=-420,
		SeatAnimBlendName=Pass4PositionNode,
		SeatPositions=((bDriverVisible=true,bIsExterior=true,bAllowFocus=true,PositionCameraTag=none,ViewFOV=0.0,PositionIdleAnim=Pass04_Idle,DriverIdleAnim=Pass04_Idle,AlternateIdleAnim=Pass04_Idle_AI,SeatProxyIndex=7,
							bIsExterior=true,
							PositionFlinchAnims=(Pass04_Idle),
							PositionDeathAnims=(Pass04_Death))
						),
		TurretVarPrefix="PassengerFour",
		bSeatVisible=true,
		DriverDamageMult=1.0,
		InitialPositionIndex=0,
		SeatRotation=(Pitch=0,Yaw=0,Roll=0),
		SeatBone=passenger_04_Attach,
		VehicleBloodMICParameterName=Gore04
		)}

	

	MaxSpeed = 3014; // 217 km/h

	MaxRPM = 340
	NormalRPM = 324
	MinRPM = 294

	YawTorqueFactor = 1900.0
	YawTorqueMax = 2000.0
	YawDamping = 750

	PitchTorqueFactor = 1250.0
	PitchTorqueMax = 1350.0
	PitchDamping = 190

	RollTorqueYawFactor = 500.0
	RollTorqueMax = 600
	RollDamping = 190

	MouseYawDamping=150
	MousePitchDamping=250
	MouseRollDamping=75

	//AntiTorqueAirSpeed=2430 // 175km/h //2055 // 148km/h, 80kt
	AntiTorqueAirSpeed=1542 // 111km/h, 60kt
	MouseTransitionSpeed=500 // 36km/h

	/*AirflowLiftGainFactor=1.5
	AirflowLiftLossFactor=0.25
	ThroughRotorDragFactor=2.0
	AgainstRotorDragFactor=1.25*/

	GroundEffectHeight=732 // 14.63m
	MaxRateOfClimb=446		// 8.92m/s

	AltitudeOffset=100

	CrewAnimSet=AnimSet'VH_VN_AUS_Bushranger_pax.Anim.CHR_Guns_Anims'
	PassengerAnimTree=AnimTree'CHR_Playeranimtree_Master.CHR_Tanker_animtree'

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
	VehicleLights(0)={(AttachmentName=InteriorLightComponent0,Component=InteriorLight_0,bAttachToSocket=true,AttachmentTargetName=interior_light_0)}
	VehicleLights(1)={(AttachmentName=InteriorLightComponent1,Component=InteriorLight_1,bAttachToSocket=true,AttachmentTargetName=interior_light_1)}

	// Right Rear Wheel
	Begin Object Name=RRSkid
		BoneName="RightSkid_02"
		BoneOffset=(X=0.0,Y=0.0,Z=5.0)
	End Object
	Wheels(0)=RRSkid

	// Right Middle Wheel
	Begin Object Name=RMSkid
		BoneName="RightSkid_02"
		BoneOffset=(X=64.0,Y=0.0,Z=5.0)
	End Object
	Wheels(1)=RMSkid

	// Right Front Wheel
	Begin Object Name=RFSkid
		BoneName="RightSkid_01"
		BoneOffset=(X=0.0,Y=0.0,Z=5.0)
	End Object
	Wheels(2)=RFSkid

	// Left Rear Wheel
	Begin Object Name=LRSkid
		BoneName="LeftSkid_02"
		BoneOffset=(X=0.0,Y=0.0,Z=5.0)
	End Object
	Wheels(3)=LRSkid

	// Left Middle Wheel
	Begin Object Name=LMSkid
		BoneName="LeftSkid_02"
		BoneOffset=(X=64.0,Y=0.0,Z=5.0)
	End Object
	Wheels(4)=LMSkid

	// Left Front Wheel
	Begin Object Name=LFSkid
		BoneName="LeftSkid_01"
		BoneOffset=(X=0.0,Y=0.0,Z=5.0)
	End Object
	Wheels(5)=LFSkid

	// Muzzle Flashes
	VehicleEffects(HeliVFX_Firing1)=(EffectStartTag=UH1RocketL,EffectTemplate=ParticleSystem'FX_VN_Helicopters.Emitter.FX_VN_RocketPod',EffectSocket=Launcher_L_Rear)
	VehicleEffects(HeliVFX_Firing2)=(EffectStartTag=UH1RocketR,EffectTemplate=ParticleSystem'FX_VN_Helicopters.Emitter.FX_VN_RocketPod',EffectSocket=Launcher_R_Rear)
	VehicleEffects(HeliVFX_Firing3)=(EffectStartTag=UH1HMinigunL,EffectTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_round',EffectSocket=Minigun_L_Muzzle,bNoKillOnRestart=true)
	VehicleEffects(HeliVFX_Firing4)=(EffectStartTag=UH1HMinigunR,EffectTemplate=ParticleSystem'FX_VN_Weapons.MuzzleFlashes.FX_VN_MuzzleFlash_3rdP_Rifles_round',EffectSocket=Minigun_R_Muzzle,bNoKillOnRestart=true)
	VehicleEffects(HeliVFX_Firing5)=(EffectStartTag=UH1DoorMGL,EffectTemplate=ParticleSystem'FX_VN_Helicopters.Emitter.FX_VN_M60D_Muzzle_Flash',EffectSocket=MG_Barrel_L)
	VehicleEffects(HeliVFX_Firing6)=(EffectStartTag=UH1DoorMGR,EffectTemplate=ParticleSystem'FX_VN_Helicopters.Emitter.FX_VN_M60D_Muzzle_Flash',EffectSocket=MG_Barrel_R)
	// Shell Ejects
	VehicleEffects(HeliVFX_Firing7)=(EffectStartTag=UH1DoorMGL,EffectTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_USA_M60_Huey',EffectSocket=ShellEjectSocket_L,bInteriorEffect=false,bNoKillOnRestart=true)
	VehicleEffects(HeliVFX_Firing8)=(EffectStartTag=UH1DoorMGR,EffectTemplate=ParticleSystem'FX_VN_Weapons.ShellEjects.FX_Wep_ShellEject_USA_M60_Huey',EffectSocket=ShellEjectSocket_R,bInteriorEffect=false,bNoKillOnRestart=true)
	// Driving effects
	VehicleEffects(HeliVFX_Exhaust)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,EffectTemplate=ParticleSystem'FX_VN_Helicopters.Emitter.FX_VN_EngineExhaust',EffectSocket=Exhaust)
	//VehicleEffects(HeliVFX_Downdraft)=(EffectStartTag=EngineStart,EffectEndTag=EngineStop,bStayActive=true,EffectTemplate=ParticleSystem'FX_VEH_Tank_Three.FX_VEH_Tank_A_Wing_Dirt_T34',EffectSocket=FX_Master)
	// Damage
	VehicleEffects(HeliVFX_EngineDmgSmoke)=(EffectStartTag=EngineSmoke,EffectEndTag=NoEngineSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'FX_VN_Helicopters.Emitter.FX_Helo_Engine_Damaged',EffectSocket=Exhaust)
	VehicleEffects(HeliVFX_EngineDmgFire)=(EffectStartTag=EngineFire,EffectEndTag=NoEngineFire,bRestartRunning=false,EffectTemplate=ParticleSystem'FX_VN_Helicopters.Emitter.FX_Helo_Engine_Destroyed',EffectSocket=Exhaust)
	VehicleEffects(HeliVFX_TailDmgSmoke)=(EffectStartTag=TailSmoke,EffectEndTag=NoTailSmoke,bRestartRunning=false,EffectTemplate=ParticleSystem'FX_VN_Helicopters.Emitter.FX_Helo_Tail_Smoke',EffectSocket=TailSmokeSocket)
	// Death
	VehicleEffects(HeliVFX_DeathSmoke1)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VN_Helicopters.Emitter.FX_VN_HelicopterBurning',EffectSocket=FX_Fire)
	//VehicleEffects(HeliVFX_DeathSmoke2)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke2)
	//VehicleEffects(HeliVFX_DeathSmoke3)=(EffectStartTag=Destroyed,EffectEndTag=NoDeathSmoke,EffectTemplate=ParticleSystem'FX_VEH_Tank_Two.FX_VEH_Tank_A_SmallSmoke',EffectSocket=FX_Smoke3)

	BigExplosionSocket=FX_Fire
	ExplosionTemplate=none
	SecondaryExplosion=ParticleSystem'FX_VN_Helicopters.Emitter.FX_VN_HelicopterExplosion'

	ExplosionDamageType=class'RODmgType_VehicleExplosion'
	ExplosionDamage=250.0
	ExplosionRadius=600.0
	ExplosionMomentum=60000
	ExplosionInAirAngVel=1.5
	InnerExplosionShakeRadius=400.0
	OuterExplosionShakeRadius=1000.0
	ExplosionLightClass=none//class'ROGame.ROGrenadeExplosionLight'
	MaxExplosionLightDistance=2500.0//4000.0
	TimeTilSecondaryVehicleExplosion=0//2.0f
	bHasTurretExplosion=false


	// HUD ICONS
	EngineTextureOffset=(PositionOffset=(X=58,Y=61,Z=0),MySizeX=24,MYSizeY=24)
	TransmissionTextureOffset=(PositionOffset=(X=52,Y=90,Z=0),MySizeX=38,MYSizeY=36)
	MainRotorTextureOffset=(PositionOffset=(X=0,Y=0,Z=0),MySizeX=140,MYSizeY=140)
	TailRotorTextureOffset=(PositionOffset=(X=59,Y=122,Z=0),MySizeX=8,MYSizeY=33)
	LeftSkidTextureOffset=(PositionOffset=(X=51,Y=34,Z=0),MySizeX=22,MYSizeY=72)
	RightSkidTextureOffset=(PositionOffset=(X=68,Y=34,Z=0),MySizeX=22,MYSizeY=72)
	TailBoomTextureOffset=(PositionOffset=(X=0,Y=0,Z=0),MySizeX=140,MYSizeY=140)

	SeatTextureOffsets(0)=(PositionOffSet=(X=+5,Y=-30,Z=0),bTurretPosition=0)
	SeatTextureOffsets(1)=(PositionOffSet=(X=-5,Y=-30,Z=0),bTurretPosition=0)
	SeatTextureOffsets(2)=(PositionOffSet=(X=-8,Y=-10,Z=0),bTurretPosition=0)
	SeatTextureOffsets(3)=(PositionOffSet=(X=+8,Y=-10,Z=0),bTurretPosition=0)
	SeatTextureOffsets(4)=(PositionOffSet=(X=+8,Y=-18,Z=0),bTurretPosition=0)
	SeatTextureOffsets(5)=(PositionOffSet=(X=+3,Y=-18,Z=0),bTurretPosition=0)
	SeatTextureOffsets(6)=(PositionOffSet=(X=-3,Y=-18,Z=0),bTurretPosition=0)
	SeatTextureOffsets(7)=(PositionOffSet=(X=-8,Y=-18,Z=0),bTurretPosition=0)
	

	SpeedoMinDegree=5461
	SpeedoMaxDegree=56000
	SpeedoMaxSpeed=3861 //278 km/h, 150kts
	EngineRPMMinAngle=-24758
	EngineRPMMaxAngle=21481
	RotorRPMMinAngle=-24758
	RotorRPMMaxAngle=27307

	VSIGaugeMax=30.48 // m/s, 6000 f/m

	EngineMaxRPM=324
	RotorRPMGaugeMax=360

	// 3D Cockpit Instruments
	RPM3DGaugeMinAngle=0
	RPM3DGaugeMaxAngle=49152
	RPM3DGauge2MinAngle=0
	RPM3DGauge2MaxAngle=48462
	RotorRPM3DGaugeMinAngle=0
	RotorRPM3DGaugeMaxAngle=53772
	Speedo3DGaugeMaxAngle=60985
	VSI3DGaugeMinMaxAngle=32500
	EngineOil3DGaugeMinAngle=0
	EngineOil3DGaugeMaxAngle=21845
	EngineOil3DGaugeDamageAngle=5462
	EngineTemp3DGaugeNormalAngle=1820
	EngineTemp3DGaugeEngineDamagedAngle=4096
	EngineTemp3DGaugeFireDamagedAngle=8192
	EngineTemp3DGaugeFireDestroyedAngle=12288
	Engine2Temp3DGaugeNormalAngle=1820
	Engine2Temp3DGaugeEngineDamagedAngle=4096
	Engine2Temp3DGaugeFireDamagedAngle=8192
	Engine2Temp3DGaugeFireDestroyedAngle=12288

	ExitRadius=180
	ExitOffset=(X=-150,Y=0,Z=0)

	EntryPoints(0)=(CollisionRadius=30, CollisionHeight=35, AttachBone=Passenger_root, LocationOffset=(X=-30,Y=0,Z=25), SeatIndex = 255)
	EntryPoints(1)=(CollisionRadius=4, CollisionHeight=35, AttachBone=Passenger_root, LocationOffset=(X=50,Y=30,Z=25), SeatIndex = 0) // pilot
	EntryPoints(2)=(CollisionRadius=4, CollisionHeight=35, AttachBone=Passenger_root, LocationOffset=(X=50,Y=-30,Z=25), SeatIndex = 1) // gunner

	VehHitZones(0)=(ZoneName=PASS1BODY,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewBody,CrewSeatIndex=4,SeatProxyIndex=4,CrewBoneName=passenger_01_HITBOX)
	VehHitZones(1)=(ZoneName=PASS1HEAD,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewHead,CrewSeatIndex=4,SeatProxyIndex=4,CrewBoneName=passenger_01_head_HITBOX)
	VehHitZones(2)=(ZoneName=PASS2BODY,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewBody,CrewSeatIndex=5,SeatProxyIndex=5,CrewBoneName=passenger_02_HITBOX)
	VehHitZones(3)=(ZoneName=PASS2HEAD,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewHead,CrewSeatIndex=5,SeatProxyIndex=5,CrewBoneName=passenger_02_head_HITBOX)
	VehHitZones(4)=(ZoneName=PASS3BODY,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewBody,CrewSeatIndex=6,SeatProxyIndex=6,CrewBoneName=passenger_03_HITBOX)
	VehHitZones(5)=(ZoneName=PASS3HEAD,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewHead,CrewSeatIndex=6,SeatProxyIndex=6,CrewBoneName=passenger_03_head_HITBOX)
	VehHitZones(6)=(ZoneName=PASS4BODY,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewBody,CrewSeatIndex=7,SeatProxyIndex=7,CrewBoneName=passenger_04_HITBOX)
	VehHitZones(7)=(ZoneName=PASS4HEAD,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewHead,CrewSeatIndex=7,SeatProxyIndex=7,CrewBoneName=passenger_04_head_HITBOX)
	
	VehHitZones(8)=(ZoneName=LEFTMGBODY,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewBody,CrewSeatIndex=2,SeatProxyIndex=2,CrewBoneName=L_Gunner_HITBOX)
	VehHitZones(9)=(ZoneName=LEFTMGHEAD,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewHead,CrewSeatIndex=2,SeatProxyIndex=2,CrewBoneName=L_Gunner_head_HITBOX)
	VehHitZones(10)=(ZoneName=RIGHTMGBODY,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewBody,CrewSeatIndex=3,SeatProxyIndex=3,CrewBoneName=R_Gunner_HITBOX)
	VehHitZones(11)=(ZoneName=RIGHTMGHEAD,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewHead,CrewSeatIndex=3,SeatProxyIndex=3,CrewBoneName=R_Gunner_head_HITBOX)
	VehHitZones(12)=(ZoneName=COPILOTBODY,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewBody,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=copilot_HITBOX,NumPensToCount=2)
	VehHitZones(13)=(ZoneName=COPILOTHEAD,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewHead,CrewSeatIndex=1,SeatProxyIndex=1,CrewBoneName=copilot_head_HITBOX,NumPensToCount=2)
	VehHitZones(14)=(ZoneName=PILOTBODY,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewBody,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Pilot_HITBOX,NumPensToCount=2)
	VehHitZones(15)=(ZoneName=PILOTHEAD,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_CrewHead,CrewSeatIndex=0,SeatProxyIndex=0,CrewBoneName=Pilot_head_HITBOX,NumPensToCount=2)
	VehHitZones(16)=(ZoneName=FUSELAGE,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_Airframe,PhysBodyBoneName=Fuselage)
	VehHitZones(17)=(ZoneName=TAILBOOM,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_TailBoom,ZoneHealth=300, PhysBodyBoneName=Tail_Boom)
	VehHitZones(18)=(ZoneName=MAINROTORSHAFT,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_MainRotorShaft,ZoneHealth=150,PhysBodyBoneName=Main_Rotor)
	VehHitZones(19)=(ZoneName=MAINROTORBLADE1,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_MainRotor,ZoneHealth=150,PhysBodyBoneName=Blade_01)
	VehHitZones(20)=(ZoneName=MAINROTORBLADE2,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_MainRotor,ZoneHealth=150,PhysBodyBoneName=Blade_02)
	VehHitZones(21)=(ZoneName=TAILROTORSHAFT,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_TailRotorShaft,ZoneHealth=125,PhysBodyBoneName=Tail_Rotor)
	VehHitZones(22)=(ZoneName=TAILROTORBLADES,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_TailRotor,ZoneHealth=125,PhysBodyBoneName=Tail_Rotor)
	VehHitZones(23)=(ZoneName=ENGINEHOUSING,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_Engine,ZoneHealth=100)
	VehHitZones(24)=(ZoneName=ENGINECORE,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_Engine,ZoneHealth=200,NumPensToCount=2)
	VehHitZones(25)=(ZoneName=CANOPY_FRONT_LEFT,DamageMultiplier=0.0,VehicleHitZoneType=HVHT_Canopy,ZoneHealth=20,NumPensToCount=0)
	VehHitZones(26)=(ZoneName=CANOPY_FRONT_RIGHT,DamageMultiplier=0.0,VehicleHitZoneType=HVHT_Canopy,ZoneHealth=20,NumPensToCount=0)
	VehHitZones(27)=(ZoneName=CANOPY_LEFT,DamageMultiplier=0.0,VehicleHitZoneType=HVHT_Canopy,ZoneHealth=20,NumPensToCount=0)
	VehHitZones(28)=(ZoneName=CANOPY_RIGHT,DamageMultiplier=0.0,VehicleHitZoneType=HVHT_Canopy,ZoneHealth=20,NumPensToCount=0)
	VehHitZones(29)=(ZoneName=JESUSNUT,DamageMultiplier=1.5,VehicleHitZoneType=HVHT_JesusNut,ZoneHealth=100,PhysBodyBoneName=Main_Rotor)
	VehHitZones(30)=(ZoneName=COCKPIT,DamageMultiplier=1.0,VehicleHitZoneType=HVHT_Airframe,NumPensToCount=0, PhysBodyBoneName=Fuselage)

	CrewHitZoneStart=0
	CrewHitZoneEnd=15

	RocketAmmoIncr=4
	MinigunAmmoIncr=2000
	M60AmmoIncr = 250

	ActiveMinigun=255

	CanopyFrontLeftParamName=UH1H_FrontLeft
	CanopyFrontRightParamName=UH1H_FrontRight
	CanopyLeftParamName=UH1H_SideLeft
	CanopyRightParamName=UH1H_SideRight

	TracerRateHighRPM=7.407407f
	TracerRateLowRPM=3.703703f
	TracerRateParamName=TracerPerSecond
}
