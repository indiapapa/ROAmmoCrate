//=============================================================================
// ROVehicleHelicopter Extended
//=============================================================================
// Base class for player controlled helicopters
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
//
//=============================================================================
class ROVehicleHelicopter_Ext extends ROVehicleHelicopter;


simulated function PostBeginPlay()
{
	local int i, NewSeatIndexHealths, LoopMax;
	local ROTeamInfo ROTI;
	local ROGameReplicationInfo ROGRI;
	// local RotorBladeAttachmentInfo CurrentRotorAttachment;
	local float MyMass;
	//local vector RotorHub, RotorTip;

	SeatIndexCopilot = GetCopilotSeatIndex();

	super.PostBeginPlay();

	// Get and store our mass value for access later
	MyMass = Mesh.GetRootBodyInstance().GetBodyMass();

	// Initialize skids. On a timer to prevent spawning shenanigans
	SetTimer(1.5, false, 'InitializeSkidBreakThresholds');

	HalfCeiling = Ceiling / 2;
	RPMCollectiveChangeUp = NormalRPM * RPMCollectiveChangeUpPct;
	RPMCollectiveChangeDown = NormalRPM * RPMCollectiveChangeDownPct;

	//`log("***"@self@"MyMass is:"@MyMass);

	// Set our base level of lift at max collective and normal RPM. Actual lift will depend on RPM (engine integrity), collective pitch, airflow and rotor integrity
	// First calculate how much force is required to equal the effect of gravity i.e. to hover
	// Base lift is considered to be at normal RPM. Actual lift multiples by the actual RPM to get a value, so divide by the NormalRPM value here
	//HoverLiftForce = WorldInfo.WorldGravityZ / -50 * MyMass;
	BaseLiftPerRev = (WorldInfo.WorldGravityZ / -50 * MyMass) / NormalRPM;

	// A simplified all-in-one drag coefficient. Basically at max speed, the drag force will be equal to the thrust force, preventing us from going any faster
	DragCoefficient = MaxSpeed / (MaxSpeed ** 2);

	MinCollective = EvalInterpCurveFloat(CollectivePitchCurve,0.0);
	MaxCollective = EvalInterpCurveFloat(CollectivePitchCurve,1.0);

	// Clamp our damaged effects to make sure that they don't result in unwanted behaviour (e.g. damaged main rotor providing MORE lift)
	//MainRotorDamagedFactor = FClamp(MainRotorDamagedFactor, 0, 1.0);
	//TailRotorDamagedFactor = FClamp(TailRotorDamagedFactor, -1.0, 1.0);

	// Attach sound cues and set SkelControls
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		AttachComponent(EngineStartSound);
		AttachComponent(RotorsImpactingTreeCanopy);
		AttachComponent(EngineStopSound);
		AttachComponent(EngineSound);
		AttachComponent(RotorWashWind);
		AttachComponent(MissileWarningSound);
		AttachComponent(RotorWashPSC);

		SetInteriorEngineSound(false);

		RotorWashPSC.SetScale(RotorWashScale);

		// Attach rotor blade meshes
		AttachMainRotorBladeMeshes();
		AttachTailRotorBladeMeshes();

		RotorWashWindFluid = Spawn(class'ROHelicopterRotorWash', self);
		if(RotorWashWindFluid != none)
		{
			RotorWashWindFluid.SetBase(self,,,RotorWashSocket);
			RotorWashWindFluid.SetHardAttach(true);
		}

		SetupDamageMaterials();
	}

	MainRotorController = ROSkelControlFan(Mesh.FindSkelControl('MainRotor'));
	TailRotorController = ROSkelControlFan(Mesh.FindSkelControl('TailRotor'));
	RotorConeUpController = SkelControlSingleBone(Mesh.FindSkelControl('MainRotor_BladeConeUp'));
	RotorConeDownController = SkelControlSingleBone(Mesh.FindSkelControl('MainRotor_BladeConeDown'));

	if( RotorConeUpController != none && RotorConeUpController.StrengthTarget != 0 )
		RotorConeUpController.SetSkelControlStrength( 0.f, 0.f );

	if( RotorConeDownController != none && RotorConeDownController.StrengthTarget != 1 )
		RotorConeDownController.SetSkelControlStrength( 1.f, 0.f );

	// Initialize vehicle hitzone healths
	for (i = 0; i < VehHitZones.length; i++)
	{
		VehHitZoneHealths[i] = 255;

		if( VehHitZones[i].VehicleHitZoneType == HVHT_CrewHead || VehHitZones[i].VehicleHitZoneType == HVHT_CrewBody )
		{
			CrewVehHitZoneIndexes[CrewVehHitZoneIndexes.Length] = i;
		}
	}

	if( Role == ROLE_Authority )
	{
		if( SeatProxies.Length > 8 )
			LoopMax = 8;
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
			for ( i = 8; i < LoopMax; i++ )
			{
				NewSeatIndexHealths = (NewSeatIndexHealths - (NewSeatIndexHealths & (15 << (4 * (i - 8))))) | (int(SeatProxies[i].Health / 6.6666666) << (4 * (i - 8)));
			}
			ReplicatedSeatProxyHealths2 = NewSeatIndexHealths;
		}

		// Add to TeamInfo so we can keep track of locations for the overhead map as well as for spawning in helos
		ROGRI = ROGameReplicationInfo(WorldInfo.Game.GameReplicationInfo);
		ROTI = ROTeamInfo( ROGRI.Teams[Team] );
		ROTI.AddHelicopterToTeam(self);
	}

	// Hide all crew collision bones so that they don't trigger impacts when there's no player in the seat
	for( i = CrewHitZoneStart; i <= CrewHitZoneEnd; i++ )
	{
		Mesh.HideBoneByName(VehHitZones[i].CrewBoneName, PBO_Disable);
	}

	// Handle a badly configured helo to stop crazy log spam
	//if( EngineMaxRPM <= 0 )
		EngineMaxRPM = NormalRPM;

	BeaconLocation = Location;

	InitializeHitZoneIndexArrayCache();

	// Reset our helicopter training respawn warning.
	VolumeHeloTrainingRespawnTime = -1;

	bInSpawnProtection=false; // RS2PR-730 - Reset our bool.
}
simulated function CalculateLiftAndTorque(float DeltaTime)
{
	local vector LiftForce, DragForce, RollForce, PitchForce, YawForce, NetLift, NetTorque;
	local vector RollDampingForce, PitchDampingForce, YawDampingForce, CollidingVolumeDampingForce;
	local vector localX, localY, localZ, VelNoZ, HitNorm;
	local float	Pitch, Roll, Yaw, RollOrientationFactor, PitchOrientationFactor, YawOrientationFactor;
	local float LiftPerRev, AirflowLiftPerRev, GroundEffectPerRev, ETLPerRev, SettlingPerRev;
	local float DragFactor, AirspeedAlongFuselage, AirspeedAgainstFuselage, MouseTransitionFactor;
	local float	AirspeedNoZ, PctMaxVSpd;
	//local ROPlayerController ROPC;
	local int GroundEffectDist;
	local PhysicsVolume PhysVol;

	if( bDriving || bBackSeatDriving || (!bVehicleOnGround && !bWasChassisTouchingGroundLastTick) )
	{
		GetAxes(Rotation, localX, localY, localZ);

		// TODO: Should set this only when the driver changes instead of every tick! Use a combo of SitDriver and ROPC.ServerSetMouseTurnMode
		// Also Needs to handle backseat drivers
		/*if( bBackSeatDriving )
			ROPC = ROPlayerController(GetControllerForSeatIndex(BackSeatDriverIndex));
		else
			ROPC = ROPlayerController(Controller);*/

		// ===================== //
		//    ForceCalculation   //
		// ===================== //

		// Calculate deviation from horizontal along pitch and roll axes, as well as deviation from direction of travel along yaw axis
		// Used for damping (prevents deliberate looping/rolling) and counter-yaw as a result of airflow at speed
		// Use trig and angles here rather than vector dot products so that we can identify direction of deviation by + or -
		CurrentPitch = Rotator(LocalX).Pitch;
		PitchOrientationFactor = cos( CurrentPitch * 0.0000958738 ); // 0.0000958738 = Pi / 32768
		CurrentRoll = Rotator(LocalY).Pitch;
		RollOrientationFactor = cos( CurrentRoll * 0.0000958738 ); // 0.0000958738 = Pi / 32768

		AirspeedAlongFuselage = Velocity dot LocalX;
		AirspeedAgainstFuselage = Velocity dot LocalY;
		MouseTransitionFactor = FClamp(Abs(AirspeedAlongFuselage) / MouseTransitionSpeed, 0, 1);
		YawOrientationFactor = 1 - (FClamp(Abs(AirspeedAlongFuselage)/AntiTorqueAirSpeed, 0, 0.8));

		// if this aircraft is airborne without a pilot, it's time to crash
		if( !bDriving && !bBackSeatDriving )
		{
			InputPitch = 0.1;
			InputRoll = -0.25;
			InputYaw = 0.05;
		}
		else
		{
			// If yaw key is pressed, use that, otherwise link roll and yaw for ease of flight with a mouse
			if( KeyTurn != 0 || MouseTurnMode == EMTM_RollOnly )
				InputYaw = KeyTurn;
			else
			{
				if( MouseTurnMode != EMTM_Auto )
					InputYaw = MouseTurn/MouseYawDamping;
				// Damp the amount of yaw applied by the mouse as our speed goes up
				else
					InputYaw = (MouseTurn/MouseYawDamping) * (1 - MouseTransitionFactor);
			}

			if( KeyForward != 0 )
				InputPitch = KeyForward;
			else
				InputPitch = MouseLookUp/MousePitchDamping;

			if( KeyStrafe != 0 || MouseTurnMode == EMTM_YawOnly )
				InputRoll = -KeyStrafe;
			else
			{
				if( MouseTurnMode != EMTM_Auto )
					InputRoll = -MouseTurn/MouseRollDamping;
				// Damp the amount of roll applied by the mouse as our speed goes down
				else
					InputRoll = -MouseTurn/MouseRollDamping * MouseTransitionFactor;
			}
		}

		// Set the values we use for the force calculations from the input values
		Pitch = InputPitch;
		Roll = InputRoll;
		Yaw = InputYaw;

		// Without a tail rotor, the engine torque spins us out of control
		// More collective results in higher torque and therefore more yaw
		if( bTailRotorDestroyed && !bEngineDestroyed )
		{
			// No tailboom means more yaw than a simple loss of rotor
			if( bTailBoomDestroyed )
				Yaw = TailBoomDestroyedFactor * FClamp((CollectivePitch - MinCollective) / (MaxCollective - MinCollective),0.1,1.0);
			else
				Yaw = TailRotorDestroyedFactor * FClamp((CollectivePitch - MinCollective) / (MaxCollective - MinCollective),0.1,1.0);
		}
		else
		{
			// if the tail rotor is damaged, add a persistent bit of yaw
			if( bTailRotorDamaged && !bEngineDestroyed )
				Yaw += TailRotorDamagedFactor * FClamp((CollectivePitch - MinCollective) / (MaxCollective - MinCollective),0.1,1.0);
		}

		// Without a main rotor, we can't pitch or roll
		if( bMainRotorDestroyed )
		{
			Pitch = 0;
			Roll = 0;
		}
		// Main Rotor damage reduces our pitch and roll speed
		else
		{
			if( bMainRotorDamaged )
			{
				Pitch *= MainRotorDamagedFactor;
				Roll *= MainRotorDamagedFactor;
			}

			// We're about to damp the inputs based on orientation. Before we do, make sure the player is actually trying to steer in that direction.
			// if not, don't damp the inputs, otherwise you can doom a helo to an unnecessary, fiery death
			if( (CurrentPitch > 0 && Pitch > 0) || (CurrentPitch < 0 && Pitch < 0) )
				PitchOrientationFactor = 1.0;
			if( (CurrentRoll > 0 && Roll < 0) || (CurrentRoll < 0 && Roll > 0) )
				RollOrientationFactor = 1.0;
		}

		// Inputs are less effective if RPM is low
		if( CurrentRPM < MinRPM )
		{
			Pitch *= CurrentRPM/MinRPM;
			Roll *= CurrentRPM/MinRPM;
			Yaw *= CurrentRPM/MinRPM;
			

			// TODO: Potentially switch this from a linear relationship to one that matches the actual lift at the current RPM
			//EvalInterpCurveFloat(LiftVsRPMCurve, CurrentRPM / NormalRPM)
		}

		//
		// Roll-Yaw-Pitch Calculations
		//
		PitchForce = localY * Pitch * PitchOrientationFactor * PitchTorqueFactor;
		RollForce = localX * Roll * RollOrientationFactor * RollTorqueYawFactor;
		YawForce = localZ * Yaw * YawOrientationFactor * YawTorqueFactor;

		// Clamp all force values to help maintain control
		PitchForce = ClampLength(PitchForce, PitchTorqueMax);
		RollForce = ClampLength(RollForce, RollTorqueMax);

		if( !bTailRotorDestroyed && !bTailboomDestroyed )
			YawForce = ClampLength(YawForce, YawTorqueMax);

		/*
		 * --- Lift calculations ---
		 */
		// Zero collective pitch still provides positive lift. if this calculation changes, make sure to change MaxCollective/MinCollective to reflect the new values
		/*if( !bDriving && !bVehicleOnGround && bBackSeatDriving )
		{
			// if the pilot is killed or leaves the game but the copilot is still alive, automatically try to hover rather than going into a death dive
			CollectivePitch = 1;
		}
		else*/
			//CollectivePitch = 1 + KeyUp * 0.5; // This gives us a range of 0.5 -> 1.5
			//CollectivePitch = 1 + (KeyUp + Abs(KeyUp) * 0.5) / 2; // This gives us a range of 0.75 -> 1.75
		CollectivePitch = EvalInterpCurveFloat(CollectivePitchCurve,KeyUp);

		// Calculate the direction of incoming air to the rotor. Simplified since there is no wind.
		// Used for calculating drag, ETL and RPM.
		AirflowFactor = (localZ dot Normal(Velocity)) * -1;
		// The rotor wouldn't be level with the airframe, so fudge things slightly to allow "upwards" airflow in level flight
		AirflowFactor += 0.1;

		// No rotor, no lift
		if( bMainRotorDestroyed )
			LiftPerRev = 0;
		else if( bMainRotorDamaged )
			LiftPerRev = BaseLiftPerRev * MainRotorDamagedFactor;
		else
			LiftPerRev = BaseLiftPerRev;

		// Get our airspeed value without the vertical component
		VelNoZ = Velocity;
		VelNoZ.Z = 0;
		AirspeedNoZ = VSize(VelNoZ);

		/**
		 * Ground Effect
		 *
		 * This creates additional lift while the helo's altitude is lower than 1.25x the diameter of its main rotor. The max additional lift is 30%
		 * but that only applies when full collective is applied at ground level. The strength of the effect is roughly halved for every 25% of the
		 * rotor's diameter that is gained in height.
		 */
		if( bUseAdvancedFlightModel && (!bVehicleOnGround || CollectivePitch > MinCollective ) && Trace(GroundEffectTestLoc, HitNorm, Location + localZ * GroundEffectHeight * -1.25) != none )
		{
			GroundEffectDist = Round(VSize(GroundEffectTestLoc - Location)) - AltitudeOffset;
			if( GroundEffectDist <= GroundEffectHeight * 1.25 )
			{
				GroundEffectPerRev = BaseLiftPerRev * EvalInterpCurveFloat(GroundEffectCurve, GroundEffectDist / GroundEffectHeight) * GroundEffectLiftFactor;

				// Simplified ground effect more suitable for landing with a non-analogue collective
				/*if( bUseAdvancedFlightModel )
				{
					// if the player clearly wants to descend, then reduce the ground effect by a factor of the descent speed to cushion without causing a bounce
					if( CollectivePitch <= HoverCollectivePitch )
						GroundEffectPerRev *= FClamp(Velocity.Z / MaxRateOfDescent,0,1);
					// Otherwise, clamp the max ground effect to prevent rapid climbs
					else if( Velocity.Z >= 0 )
						//GroundEffectPerRev *= FMax(1 - (MaxCollective - CollectivePitch)/(MaxCollective - HoverCollectivePitch),0.05);
						GroundEffectPerRev = 0;
				}*/
			}
		}

		/**
		  * Effective Translational Lift (ETL)
		  *
		  * At airspeeds at around 8-24 knots, induced flow is reduced, resulting in a higher relative angle of attack. The net result
		  * is that effective lift is increased. This effect increases with airspeed and maxes out at 45 knots.
		  * For this implementation, 16 knots is used as a nice middle-ground starting value and we're adding a max of 15% additional lift.
		  * 16 knots = ~8m/s = 400uu/s
		  * 45 knots = ~23m/s = 1150uu/s
		  */
		if( AirspeedNoZ > 400 )
		{
			bApplyETL = true;
			ETLPerRev = BaseLiftPerRev * ETLGainFactor;

			if( AirspeedNoZ < 1150 )
				ETLPerRev *= AirspeedNoZ / 1150;

			// Simplified controls do not allow the collective to drop as far as advanced mode,
			// so we need to reduce ETL based on the collective pitch in order to actually descend
			if( !bUseAdvancedFlightModel && CollectivePitch < HoverCollectivePitch )
			{
				ETLPerRev *= (CollectivePitch - MinCollective) / (HoverCollectivePitch - MinCollective);
			}
		}
		/*Settling with power*/
		if( AirspeedNoZ < 335 && AirspeedNoZ > -315)
		{
 			if (Velocity.Z < -200 && CollectivePitch > 1)
			SettlingPerRev = - BaseLiftPerRev * 1;

		}
		/* force lower camera view*/


		// Calculate changes in lift and drag as a result of angle vs direction of travel
		if( AirflowFactor > 0 )
		{
			// ***** TODO: Calculate drag separately for yaw/pitch vs direction of travel, then add the two values together to get the final drag
			DragFactor = -AirflowFactor * AgainstRotorDragFactor;
			// Only increase lift if we have a horizontal component to our velocity - descending through our own downwash should not increase lift
			if( bApplyETL )
			{
				// Add lift proportional to our percentage of max speed. In reality it's a little more complicated, but we don't need that here
				AirflowLiftPerRev += AirflowFactor * AirflowLiftGainFactor * BaseLiftPerRev * (VSize(Velocity)/MaxSpeed);
			}
		}
		else
		{
			DragFactor = AirflowFactor * ThroughRotorDragFactor;
			AirflowLiftPerRev += AirflowFactor * AirflowLiftLossFactor * BaseLiftPerRev * (VSize(Velocity)/MaxSpeed);
		}

		/** Cap our rate of climb/descent by forcing (ba dum tish! ...*ahem*) an equilibrium of forces. This prevents negative collective
		  input from causing constant negative acceleration and vice versa */
		// TODO: Take orientation into account - Only our Z component of lift should be capped
		if( Velocity.Z < -10 && CollectivePitch <= 1 )
		{
			PctMaxVSpd = FClamp(1 - (Velocity.Z * localZ dot vect(0,0,1.0)) / FClamp(MaxRateofDescent * (1 - CollectivePitch) / (1 - MinCollective) - MaxRateofDescent * (((GroundEffectPerRev + ETLPerRev) * 2 + AirflowLiftPerRev) / BaseLiftPerRev),MaxRateOfDescent,-1),-1,1);

			if( PctMaxVSpd >= 0 )
			{
				LiftPerRev *= 1 - (1 - MinCollective) * PctMaxVSpd;
			}
			else
			{
				LiftPerRev *= 1 - 0.1 * PctMaxVSpd;
			}
		}
		else if( Velocity.Z > 10 && CollectivePitch >= 1 )
		{
			PctMaxVSpd = FClamp(1 - (Velocity.Z * localZ dot vect(0,0,1.0)) / FClamp(MaxRateofClimb * (CollectivePitch - 1) / (MaxCollective - 1) + MaxRateofClimb * (((GroundEffectPerRev + ETLPerRev) * 2 + AirflowLiftPerRev) / BaseLiftPerRev),1,MaxRateOfClimb),-1,1);

			if( PctMaxVSpd >= 0 )
				LiftPerRev *= 1 + (MaxCollective - 1) * PctMaxVSpd;
			else
				LiftPerRev *= 1 + 0.1 * PctMaxVSpd;
		}
		else
			LiftPerRev *= CollectivePitch;

		// Now calculate the actual lift and drag forces and apply them
		LiftForce = localZ * CurrentRPM * EvalInterpCurveFloat(LiftVsRPMCurve, CurrentRPM / NormalRPM) * (LiftPerRev + GroundEffectPerRev + ETLPerRev + AirflowLiftPerRev + SettlingPerRev);
		//LiftForce = localZ * CurrentRPM * LiftPerRev * CollectivePitch;
		DragForce = Normal(Velocity) * DragCoefficient * VSizeSq(Velocity) * DragFactor;

		// Damp Z component of lift based on altitude
		// Native code also handles a cap on the vertical speed, preventing any overshoot of the ceiling
		if( Altitude > HalfCeiling )
		{
			LiftForce.Z *= 1.0 - (float(Altitude - HalfCeiling) / HalfCeiling) / 3;
		}

		// Apply the net result of our combined lift and drag
		//AddForce(LiftForce + DragForce);
		NetLift = LiftForce + DragForce;

		// TODO: Move this to debug output instead
		/*if( WorldInfo.NetMode != NM_DedicatedServer )
		{
			//ClientMessage("RPM: " $CurrentRPM $ " Speed: " $ VSize(Velocity) @ "Vertical Speed:" @ Velocity.Z);
			ClientMessage("LiftForce: " $LiftForce);
			//ClientMessage("DragForce: " $DragForce);
		}*/

		// Automatically level out the pitch and roll if we have a pilot (if not, we want to crash, not be auto-saved)
		if( (bDriving || bBackSeatDriving) && !bMainRotorDestroyed )
		{
			PitchOrientationFactor = sin( CurrentPitch * 0.0000958738 ); // 0.0000958738 = Pi / 32768
			PitchDampingForce = localY * PitchOrientationFactor * PitchDamping;

			RollOrientationFactor = sin( CurrentRoll * 0.0000958738 ); // 0.0000958738 = Pi / 32768
			RollDampingForce = localX * -RollOrientationFactor * RollDamping;
		}

		// Automatically align yaw to the direction of flight (adverse-yaw as a result of airflow along the tailboom)
		YawOrientationFactor = AirspeedAgainstFuselage/AntiTorqueAirSpeed;	//MaxSpeed
		YawDampingForce = localZ * YawOrientationFactor * YawDamping * 1.5;

		// Without a tailboom, this effect should be drastically reduced, having only the fuselage to provide force
		if( bTailBoomDestroyed )
			YawDampingForce *= 0.25;

		foreach TouchingActors(class'PhysicsVolume', PhysVol)
		{
			CollidingVolumeDampingForce = ClampLength(Mass * PhysVol.RigidBodyDamping * -0.02 * (Normal(PhysVol.Location - Location) cross Velocity), PhysVol.MaxDampingForce);
			// CollidingVolumeDampingForce += Mass * PhysVol.RigidBodyDamping * (Normal(PhysVol.Location - Location) cross Velocity) * vector(Rotation);
			break;
		}

		// Handle turning at speed
		YawDampingForce += localZ * -RollOrientationFactor * MouseTransitionFactor * YawDamping; // MouseTransitionFactor is just a convenient value to reuse, as it's already set to what we want

		// Add all TorqueForces together and apply them
		//AddTorque(PitchForce + RollForce + YawForce + RollDampingForce + PitchDampingForce + YawDampingForce);
		// NetTorque = PitchForce + RollForce + YawForce + RollDampingForce + PitchDampingForce + YawDampingForce;
		NetTorque = PitchForce + RollForce + YawForce + RollDampingForce + PitchDampingForce + YawDampingForce + CollidingVolumeDampingForce;

	//	if( Role == ROLE_Authority )
			ApplyLiftAndTorque(NetLift, NetTorque);
	}
	else
	{
		InputPitch = 0;
		InputRoll = 0;
		InputYaw = 0;
	}
}

simulated function bool SafeToBailOut()
{
	return (Altitude + AltitudeOffset <= 300 && VSizeSq(Velocity) <= 22500); // 150*150 
	/*    256 UU = 487,68 cm = 16 ft, 1m = 52,5 UU 1ft = 16 uu, 50 uu's/s thats 1m/s*/
}

function SendBailout()
{
	local int i, PilotIndex;
	local ROPlayerReplicationInfoAC ROPRI;
	local ROPlayerControllerAC ROPC;

	ROPRI = ROPlayerReplicationInfoAC(GetValidPRI());

	if( bDriving )
		PilotIndex = 0;
	else if( bBackSeatDriving )
		PilotIndex = BackSeatDriverIndex;

	for(i = 0; i < Seats.Length; i++)
	{
		if(Seats[i].SeatPawn != none && Seats[i].SeatPawn.IsHumanControlled())
		{
			ROPC = ROPlayerControllerAC(Seats[i].SeatPawn.Controller);

			if( ROPC != none )
			{
				ROPC.ReceiveLocalizedVoiceCom(Seats[PilotIndex].SeatPawn, PilotIndex, ROPRI, Seats[PilotIndex].SeatPawn.Location, `VOICECOM_HeloGetOut);
				if (ROPC != ROPlayerControllerAC(Seats[0].SeatPawn.Controller) && ROPC != ROPlayerControllerAC(Seats[1].SeatPawn.Controller) && SafeToBailOut()) //(bVehicleOnGround || bChassisTouchingGround || bVehicleOnWater))
				DisembarkAllPax(ROPC);
			}
		}
	}
}

reliable server function DisembarkAllPax(ROPlayerControllerAC ROPC)
{
	local string msx;
	
    msx = "Jumped out!";
	
	if (ROPC != none)
	{
		ROPC.ExitVehicle();
		ROPC.ClientMessage(msx);
	}
}



defaultproperties
{
		//ori CollectivePitchCurve=(Points=((InVal=0.0,OutVal=0.25),(InVal=0.75,OutVal=1.0),(InVal=1.0,OutVal=1.5)))
		CollectivePitchCurve=(Points=((InVal=0.0,OutVal=0.10),(InVal=0.5,OutVal=1.0),(InVal=1.0,OutVal=1.5)))
		MaxRateOfDescent=-1000
{