
// ROItem_PlaceableAmmoCrate
//=============================================================================
// Placeable Ammo Crate, used to place a ammo resupply volume placed by players
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Callum Coombes @ Antimatter Games LTD
//=============================================================================
// - Many modifications to use faction-based menshes, animations, etc. -Nate
//============================================================================

class ROItem_PlaceableAmmoCrate_Ext extends ROItemPlaceable
	abstract;

var class<ROPlaceableAmmoResupply_Ext>	AmmoCrateClass; 				// Spawning Class Reference
var class<ROPlaceableAmmoResupplyCrate>	PhysicalAmmoCrateClass;		// Preview Mesh Reference

// A proxy constructor item placed in the world. Generally, this is spawned and used to play an animation for the thing "deploying" in the world such as an ammo box with it's lid sliding open. -Nate
var class<ROConstructorProxy> 				ClassConstructorProxy;
var ROConstructorProxy 					ConstructorProxy;

var byte 				TeamIdx;				// Team index of the planter. This will be used to check other players before resupplying them.

var(Animations) name IdleClosedAnim;
var(Animations) name IdleOpenAnim;
var(Animations) name OpenCrateAnim;

var	int			CooldownRemaining;				// Used for HUD messaging

var int 		MinDistFromOtherAmmoCrates; 	// Distance we need to be from other crates in order to be able to plant successfully.
var int 		MinDistFromOtherAmmoCratesSq; 	// Same as above but squared for distance checking.


simulated function PostBeginPlay()
{

	if ( PhysicalAmmoCrateClass != none )
	{
		ReferenceSkeletalMesh = PhysicalAmmoCrateClass.default.CrateMesh.SkeletalMesh;
	}
	else
	{
		WarnInternal("No or Invalid 'PhysicalAmmoCrateClass' set in 'ROItem_PlaceableAmmoCrate'");
	}

	MinDistFromOtherAmmoCratesSq = MinDistFromOtherAmmoCrates * MinDistFromOtherAmmoCrates;
	super.PostBeginPlay();
}

simulated exec function IronSights(){}

simulated function BeginFire(Byte FireModeNum)
{
	// Only default fire mode, please.
	if(FireModeNum > DEFAULT_FIREMODE)
		return;

	// Don't allow us to place a new crate if we've already got one in the world.
	if(!CanPlace())
	{
		return;
	}

	TeamIdx = Instigator.Controller.GetTeamNum();

	// Set our arms animation set to our team's one.
	ArmsAnimSet = ArmsAnimSets[TeamIdx];

	Super.BeginFire(FireModeNum);
}


// @TODO: Move this up to the parent class?
simulated function bool CanPlace(optional bool bIsInitialCheck = true)
{
	local ROPlayerController ROPC;
	local ROTeamInfo ROTI;
	// local byte MySquad;
	local int i;
	local Actor	HitActor;
	local vector	HitNormal, HitLocation, ViewDirection, TraceEnd, TraceStart;
	local TraceHitInfo HitInfo;
	local ROPlaceableAmmoResupply_Ext ROAC;
	local float TraceBuff, TraceLength, VerticalAngle, LimitedVerticalAngle;

	ROPC = ROPlayerController(Instigator.Controller);

	// If this material physically doesn't support it or we've already got one in the world, bail.
	if(!Super.CanPlace() || ROPC.NumPlacedAmmoCrates > 0)
	{
		return false;
	}

	// Next, if we've recently placed one within 30 seconds and our cooldown is ongoing, bail (with a warning).
	if(ROPC != None)
	{
		CooldownRemaining = ROPC.LastPlaceAmmoCrateTime - WorldInfo.GRI.ElapsedTime;
	}
	else
	{
		CooldownRemaining = 0;
	}

	if(CooldownRemaining > 0)
	{
		ROPC.ReceiveLocalizedMessage(class'ROLocalMessagePlantedItem', ROTMSG_PlaceAmmoCrateCooldown,,,self);
		HidePreviewMesh();
		return false;
	}

	// Finally, make sure we're not within a certain range (30m by default) of another ammo resupply crate.
	VerticalAngle = acos(-ViewDirection.Z);
	ViewDirection = Vector(Instigator.GetViewRotation());
	TraceBuff = (Role == Role_Authority || IsInState('PlacingItem')) ? 1.15f : 1.0f; // I'm giving the server a buff as it often seems to have about 10UU differencein height

	if( Instigator.bIsCrouched )
	{
		TraceLength = PlaceCrouchDist;
		LimitedVerticalAngle = FMin(VerticalAngle, 45 * DegToRad);
	}
	else
	{
		TraceLength = PlaceStandingDist;
		LimitedVerticalAngle = FMin(VerticalAngle, 46 * DegToRad);
	}

	if (LimitedVerticalAngle < VerticalAngle && VerticalAngle < 120 * DegToRad) // Limit vertical angle to 120à¸¢à¸š
	{
		TraceStart = Instigator.GetPawnViewLocation();
		TraceEnd = TraceStart + ViewDirection * (TraceLength * TraceBuff * 1.2f);

		HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false,, HitInfo, TRACEFLAG_Bullet/**TRACEFLAG_NeedsTerrainMaterial*/); // TRACEFLAG_Bullet |
		if( HitActor != none && HitActor.bWorldGeometry && TraceStart.Z - HitLocation.Z <= 80 )
		{
			ROTI = ROTeamInfo(Instigator.PlayerReplicationInfo.Team);
			// MySquad = ROPlayerReplicationInfo(Instigator.PlayerReplicationInfo).SquadIndex;

			if(ROTI != None)
			{
				for(i = 0; i < 10	; i++)
				{
					// Bypassing the "Squad" check for now because potentially we could have a couple combat engineers/sappers in our squad. -Nate
					if(/*i != MySquad
						&&*/ ROTI.PlaceableAmmoCrates[i] != None
						&& VSizeSq(HitLocation - ROTI.PlaceableAmmoCrates[i].Location) <  MinDistFromOtherAmmoCratesSq
						)
					{
						if(ROPC != None)
						{
							ROPC.ReceiveLocalizedMessage(class'ROLocalMessagePlantedItem', ROTMSG_PlaceAmmoTooCloseToOtherCrate);

							HidePreviewMesh();
							return false;
						}
					}
				}

				// Or too close to other placeable ammo crates being placed.
				if( !IsInState('PlacingItem') )
				{
					foreach CollidingActors(class'ROPlaceableAmmoResupply_Ext', ROAC, MinDistFromOtherAmmoCrates * 2, HitLocation)
					{
						if( ROAC != none )
						{
							if (ROPC != none)
							{
								ROPC.ReceiveLocalizedMessage(class'ROLocalMessagePlantedItem', ROTMSG_PlaceAmmoTooCloseToOtherCrate);
							}

							HidePreviewMesh();
							return false;
						}
					}
				}
			}
			else // If we can't get our team info, bail.
			{
				HidePreviewMesh();
				return false;
			}

			return true;
		}
	}

	// Failsafe.
	return false;
}

// OVERRRIDDEN to use our version of CanPlace which checks for disnace to other ammo crates.
simulated event Tick(float DeltaTime)
{
	if ( Instigator.IsLocallyControlled() ) // Only do these checks on the controlling client, nowhere else
	{
		if (IsInState('Active') && !IsInState('PlacingItem'))
		{
			bLastCheckSuccessful = CanPlace() && CanPhysicallyPlace();

			if(!bLastCheckWasHardFail)
			{
				ShowPreviewMesh();
				UpdatePreviewMesh();
			}
			else
			{
				HidePreviewMesh();
			}
		}
		else
		{
			bLastCheckSuccessful = false;
			bLastCheckWasHardFail = true;
			HidePreviewMesh();
		}
	}

	// Call ROWeapon's super so we can bypass the parent class' version of the checks which would turn on the preview mesh unnecessarily.
	Super(ROweapon).Tick(DeltaTime);
}

simulated function StartPlacingItem()
{
	GotoState('PlacingItem');

	// Now try to spawn our proxy constructor and kick off it's "constructing" animation.
	if(Role == ROLE_Authority)
	{
		if(ConstructorProxy != None)
		{
			ConstructorProxy.Destroyed();
			ConstructorProxy = None;
		}

		ConstructorProxy = Spawn(ClassConstructorProxy, self, , PlaceLoc, PlaceRot);

		if(ConstructorProxy != none)
		{
			// This will play the animation at the rate from the animation or just play it at a default if it can't get that for some reason.
			ConstructorProxy.PlayConstructingAnimation();
		}
	}
}

simulated function SpawnPlaceable()
{
	// Destory our constructor proxy.
	if(ConstructorProxy != None)
	{
		ConstructorProxy.Destroy();
		ConstructorProxy = None;
	}

	Super.SpawnPlaceable();
}


function bool DoActualSpawn()
{
	local ROPlaceableAmmoResupply_Ext ROPAR;
	local Controller ConOwner;
	local ROPlayerController ROPC;

	ConOwner = (Instigator != none) ? Instigator.Controller : none;

	ROPAR = Spawn(AmmoCrateClass, ConOwner,, PlaceLoc, PlaceRot);

	if ( ROPAR != none )
	{
		ROPC = ROPlayerController(ConOwner);

		if(ROPC != None)
		{
			ROPC.AddPlacedAmmoCrate(ROPAR);
		}

		if(Instigator != None && Instigator.InvManager != None)
		{
			Instigator.InvManager.RemoveFromInventory(self);
		}

		return true;
	}

	return false;
}

simulated function AlertPlacingTime(float PlacingTime)
{
	if ( Role == ROLE_Authority )
	{
	   	// Show the progress bar
	   	if ( ROPawn(Instigator) != none )
	  		ROPawn(Instigator).StartDeployAmmoCrate(PlacingTime);
	}
}

DefaultProperties
{
	WeaponContentClass(0)="ROAmmoCrate.ROItem_PlaceableAmmoCrate_Ext_Content"
	RoleSelectionImage(0)=Texture2D'VN_UI_Textures_Four.WeaponTex.US_Crate'

	WeaponIdleAnims(0)=Placeable_idle
	WeaponIdleAnims(ALTERNATE_FIREMODE)=Placeable_idle

	// Anims
	WeaponPutDownAnim=Placeable_Putaway
	WeaponEquipAnim=Placeable_Pullout
	WeaponDownAnim=Placeable_Down
	WeaponUpAnim=Placeable_Up

	// Prone Crawl
	WeaponCrawlingAnims(0)=Placeable_CrawlF
	WeaponCrawlStartAnim=Placeable_Crawl_into
	WeaponCrawlEndAnim=Placeable_Crawl_out

	// Sprinting
	WeaponSprintStartAnim=Placeable_sprint_into
	WeaponSprintLoopAnim=Placeable_Sprint
	WeaponSprintEndAnim=Placeable_sprint_out

	// Mantling
	WeaponMantleOverAnim=Placeable_Mantle

	// Enemy Spotting
	WeaponSpotEnemyAnim=Placeable_SpotEnemy

	WeaponPlaceAnimCameraAnim=CameraAnim'1stperson_Cameras.Anim.TunnelTool_Dig'
	WeaponPlaceAnim=Placeable_Open_Crate

	// Melee
	WeaponMeleeAnims(0)=Placeable_Bash
	WeaponMeleeHardAnim=Placeable_BashHard
	MeleePullbackAnim=Placeable_Pullback
	MeleeHoldAnim=Placeable_Pullback_Hold

	// Crate-specific
	IdleClosedAnim=Idle_Closed
	IdleOpenAnim=Idle_Open
	OpenCrateAnim=Open_Crate

	//bPlacingUsesSingleAnim=true

	PlaceOffset=0

	// Ammo
	AmmoClass=class'ROAmmo_Placeable_AmmoCrate'
	InvIndex=`ROII_Placeable_Ammo
	ROTM_PlacingMessage=ROTMSG_PlaceAmmoCrate

	AmmoCrateClass=class'ROPlaceableAmmoResupply_Ext'
	PhysicalAmmoCrateClass=class'ROGame.ROPlaceableAmmoResupplyCrate'

	DroppedPickupClass=None
	bCanThrow=false

	MinDistFromOtherAmmoCrates=1500 // 30m = 30 * 50. 30m sq. = 30 * 50 ^ 2
}