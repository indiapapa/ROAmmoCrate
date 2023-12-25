class ROVehicleTank_Ext extends ROVehicleTank;


var RODestroyedTankTrack DestroyedLeftTrack;
var RODestroyedTankTrack DestroyedRightTrack;

var int CachedWheelRadius;

var byte LeftTrackMaterialIndex;
var byte RightTrackMaterialIndex;

var int CrewHitZoneStart, CrewHitZoneEnd;

//var byte TankArrayIndex;	// Which index we are within the TeamInfo's location array

var Animtree PassengerAnimTree;

enum EROTankType
{
	ROT_Undefined,
	ROT_T54,
	ROT_M41,
};

var  EROTankType TankType;


/*
replication
{
	
	if( bNetDirty && Role == ROLE_Authority )
		TankArrayIndex;
}*/
	

simulated function PostBeginPlay()
{
	//local ROTeamInfo_Ext ROTI;
	//local ROGameReplicationInfo ROGRI;
	local int i, NewSeatIndexHealths, LoopMax;

    	super.PostBeginPlay();
    	CachedWheelRadius = Wheels[0].WheelRadius;


	if (Role == ROLE_Authority)
	{
		if( SeatProxies.Length > 7 )
			LoopMax = 7;
		else
			LoopMax = SeatProxies.Length;

		// Initialize the replicated seat proxy healths
		for ( i = 0; i < LoopMax; i++ )
		{
			NewSeatIndexHealths = (NewSeatIndexHealths - (NewSeatIndexHealths & (15 << (4 * i)))) | (int(SeatProxies[i].Health / 6.6666666) << (4 * i));
		}
		ReplicatedSeatProxyHealths = NewSeatIndexHealths;

		if( LoopMax < SeatProxies.Length )
		{
			LoopMax = SeatProxies.Length;
			NewSeatIndexHealths = 0;

			// Initialize the remaining replicated seat proxy healths
			for ( i = 7; i < LoopMax; i++ )
			{
				NewSeatIndexHealths = (NewSeatIndexHealths - (NewSeatIndexHealths & (15 << (4 * (i - 7))))) | (int(SeatProxies[i].Health / 6.6666666) << (4 * (i - 7)));
			}
			ReplicatedSeatProxyHealths2 = NewSeatIndexHealths;
		}

		// Add to TeamInfo so we can keep track of locations for the overhead map
		//ROGRI = ROGameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
		//ROTI = ROTeamInfo_Ext( ROGRI.Teams[Team] );
		//ROTI.AddTankToTeam(self);
	}
	// Hide all crew collision bones so that they don't trigger impacts when there's no player in the seat
	for( i = CrewHitZoneStart; i <= CrewHitZoneEnd; i++ )
	{
		Mesh.HideBoneByName(VehHitZones[i].CrewBoneName, PBO_Disable);
	}
		
}	
/*
simulated function Destroyed()
{
	local ROTeamInfo_Ext ROTI;
	local ROGameReplicationInfo ROGRI;

 	/// Remove from TeamInfo transports array. Have to do this before the super call, otherwise the vehicle fails to blow up
 	if (Role == ROLE_Authority)
	{
		// Remove from TeamInfo helicopters array. Have to do this before the super call, otherwise the vehicle fails to blow up
		ROGRI = ROGameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
		//ROTI = ROTeamInfo_Ext(ROPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo).Team);
		ROTI = ROTeamInfo_Ext(ROGRI.Teams[Team]);
		ROTI.RemoveTankFromTeam(self);
		ClearTimer('OneSecondLoopingTimer');
	}
	Super.Destroyed();
}*/

simulated function float GetEngineOutput()
{
    // EvalInterpCurveFloat(EngineRPMCurve, Vehicle.ForwardVel)
    return ROVehicleSimTreaded(SimObj).EngineRPM / (ROVehicleSimTreaded(SimObj).ChangeUpPoint * 1.1f);
}
simulated function DetachDriver(Pawn P)
{
	local ROPawn ROP;

	ROP = ROPawn(P);

	// Unhide the relevant bits and give us a regular player anim again
	if (ROP != None)
	{
		ROP.Mesh.SetAnimTreeTemplate(ROP.Mesh.default.AnimTreeTemplate);
		ROSkeletalMeshComponent(ROP.Mesh).AnimSets[0]=ROSkeletalMeshComponent(ROP.Mesh).default.AnimSets[0];

		ROP.ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(ROP.HeadAndArmsMesh);
		ROP.ThirdPersonHeadgearMeshComponent.SetHidden(false);
		ROP.FaceItemMeshComponent.SetHidden(false);
		ROP.FacialHairMeshComponent.SetHidden(false);
		ROP.HideGear(false);
	}

	Super.DetachDriver(P);
}
simulated function SitDriver( ROPawn ROP, int SeatIndex )
{
	local ROPlayerController ROPC;
	local Pawn LocalPawn;

	super.SitDriver(ROP, SeatIndex);
	//`logd("Setting Driver Skeletal Mesh to "$ROP.Mesh);

	// Here we need to find the local PlayerController for either the SeatPawn
	// or the Pawn we're putting in the seat. Have to search a couple different
	// ways, since this code has to run on the server and the client, and the
	// Pawns get possessed in a different order on the client and the server.
	if( Seats[SeatIndex].SeatPawn != none && Seats[SeatIndex].SeatPawn.Driver != none )
	{
		ROPC = ROPlayerController(Seats[SeatIndex].SeatPawn.Driver.Controller);
	}

	// Couldn't find the Controller for the driver, check the seatpawn
	if( ROPC == none && Seats[SeatIndex].SeatPawn != none )
	{
		ROPC = ROPlayerController(Seats[SeatIndex].SeatPawn.Controller);
	}

	// Look at the controller of the incoming pawn's DrivenVehicle,
	// and see if it matches the local playercontroler
	if( ROPC == none )
	{
		if( ROP.DrivenVehicle.Controller != none && ROP.DrivenVehicle.Controller == GetALocalPlayerController() )
		{
			ROPC = ROPlayerController(ROP.DrivenVehicle.Controller);
		}
	}

	// Another check, if we are looking for the controller for the vehicle itself
	// just check and see if the controller for the local playercontroller is set
	// to this vehicle.
	if( ROPC == none && SeatIndex == 0 )
	{
		if( GetALocalPlayerController() != none && GetALocalPlayerController().Pawn == self )
		{
			ROPC = ROPlayerController(GetALocalPlayerController());
		}
	}

	// Final check, if we are looking for the controller for a particular seat
	// just check and see if the controller for the local playercontroller is set
	// to that seat's seatpawn
	if( ROPC == none  )
	{
		LocalPawn = GetALocalPlayerController().Pawn;

		//`log("Local Pawn = "$LocalPawn$" GetALocalPlayerController() = "$GetALocalPlayerController()$" Local Pawn Controller = "$LocalPawn.Controller);

		if( GetALocalPlayerController() != none && LocalPawn == Seats[SeatIndex].SeatPawn )
		{
			ROPC = ROPlayerController(GetALocalPlayerController());
		}
	}

	if( ROPC != none && (WorldInfo.NetMode == NM_Standalone || IsLocalPlayerInThisVehicle()) )
	{
		// Force the driver's view rotation to default to forward instead of some arbitrary angle
		ROPC.SetRotation(rot(0,0,0));
	}

	if( ROP != none )
	{
  		ROP.Mesh.SetAnimTreeTemplate(PassengerAnimTree);
   	    ROP.HideGear(true);
   	    if( ROP.CurrentWeaponAttachment != none )
   	    	ROP.PutAwayWeaponAttachment();

   	    // Set the proxy health to be whatever our pawn had on entry
		if( Role == ROLE_Authority )
		{
			UpdateSeatProxyHealth(GetSeatProxyIndexForSeatIndex(SeatIndex), ROP.Health, false);
		}
   	}

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// Display the vehicle interior if a local player is getting into it
		// Check for IsLocalPlayerInThisVehicle shouldn't normally be required, but it prevents a nasty bug when new players
		// connect and briefly think that they control every pawn, leading to invisible heads for all vehicle passengers - Ch!cken
		if ( ROPC != None && LocalPlayer(ROPC.Player) != none && (WorldInfo.NetMode == NM_Standalone || IsLocalPlayerInThisVehicle()) )
		{
			if ( Mesh.DepthPriorityGroup == SDPG_World )
			{
			//	ROPawnTanker(ROP).ShowFirstPersonHands();
				SetVehicleDepthToForeground();
			}

			// If our local playcontroller is getting into this seat set up the
			// hands and head meshes so we see what we need to see (like our
			// third person hands, and don't see what we don't (like our own head)
			if (ROP != None)
			{
				if( ROP.ThirdPersonHeadphonesMeshComponent != none )
				{
					ROP.ThirdPersonHeadphonesMeshComponent.SetOwnerNoSee(true);
				}

				if( ROP.ThirdPersonHeadgearMeshComponent != none )
				{
					ROP.ThirdPersonHeadgearMeshComponent.SetHidden(true);
				}

				if( ROP.FaceItemMeshComponent != none )
				{
					ROP.FaceItemMeshComponent.SetHidden(true);
				}

				if( ROP.FacialHairMeshComponent != none )
				{
					ROP.FacialHairMeshComponent.SetHidden(true);
				}

				ROP.ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(ROP.ArmsOnlyMesh);
				ROP.ArmsMesh.SetHidden(true);
			}
		}

		SpawnOrReplaceSeatProxy(SeatIndex, ROP);
	}

	if( ROP != none )
	{
	   ROP.SetRelativeRotation(Seats[SeatIndex].SeatRotation);
	   // IK update here to force client replication on vehicle entry, otherwise IK doesn't update until position change
	   ROP.UpdateVehicleIK(self, SeatIndex, SeatPositionIndex(SeatIndex,, true));
   	}
}
simulated function PlayerController FindVehicleLocalPlayerController(ROPawn ROP, int SeatIndex, optional out Pawn LocalPawn)
{
    local ROPlayerController ROPC;


    if ((Seats[SeatIndex].SeatPawn != none) && (Seats[SeatIndex].SeatPawn.Driver != none))
    {
        ROPC = ROPlayerController(Seats[SeatIndex].SeatPawn.Driver.Controller);
    }


    if ((ROPC == none) && (Seats[SeatIndex].SeatPawn != none))
    {
        ROPC = ROPlayerController(Seats[SeatIndex].SeatPawn.Controller);
    }

    // Look at the controller of the incoming pawn's DrivenVehicle,
    // and see if it matches the local PlayerController.
    if (ROPC == none)
    {
        if (ROP != None)
        {
            if ((ROP.DrivenVehicle.Controller != none) && (ROP.DrivenVehicle.Controller == GetALocalPlayerController()))
            {
                ROPC = ROPlayerController(ROP.DrivenVehicle.Controller);
            }
        }
    }


    if ((ROPC == none) && (SeatIndex == 0))
    {
        if ((GetALocalPlayerController() != none) && (GetALocalPlayerController().Pawn == self))
        {
            ROPC = ROPlayerController(GetALocalPlayerController());
        }
    }


    if (ROPC == none)
    {
        LocalPawn = GetALocalPlayerController().Pawn;


        if ((GetALocalPlayerController() != none) && (LocalPawn == Seats[SeatIndex].SeatPawn))
        {
            ROPC = ROPlayerController(GetALocalPlayerController());
        }
    }

    return ROPC;
}

/*
function bool DriverEnter(Pawn P)
{
	local ROPlayerReplicationInfo ROPRI;

	ROPRI = ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo);

	if( Super.DriverEnter(P) )
	{
		if( ROPRI != none )
		{
			ROPRI.TeamTransportArrayIndex = TransportArrayIndex;
			
		}

		return true;
	}

	return false;
}
function DriverLeft()
{
	local ROPlayerReplicationInfoAC ROPRI;

	if( Driver != none )
	{
		ROPRI = ROPlayerReplicationInfoAC(Driver.Controller.PlayerReplicationInfo);

		if( ROPRI != none )
		{
			ROPRI.TeamTransportArrayIndex = 255;
			
		}
	}

	Super.DriverLeft();
}*/

simulated function ChangeCrewCollision(bool bEnable, int SeatIndex)
{
	local int i;

	// Hide or unhide our driver collision cylinders
	for( i = CrewHitZoneStart; i <= CrewHitZoneEnd; i++ )
	{
		if( VehHitZones[i].CrewSeatIndex == SeatIndex )
		{
			if( bEnable )
			{
				Mesh.UnhideBoneByName(VehHitZones[i].CrewBoneName);
			}
			else
			{
				Mesh.HideBoneByName(VehHitZones[i].CrewBoneName,PBO_Disable);
			}
		}
	}
}
simulated function DrivingStatusChanged()
{
	super.DrivingStatusChanged();

	// Update the driver's hit detection
	ChangeCrewCollision(bDriving, 0);
} 

DefaultProperties
{
    LeftTrackMaterialIndex=1
    RightTrackMaterialIndex=2
    CachedWheelRadius=15

    
    //TankArrayIndex=255
    PassengerAnimTree=AnimTree'CHR_Playeranimtree_Master.CHR_Tanker_animtree'
}