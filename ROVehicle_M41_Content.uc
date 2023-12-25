//=============================================================================
// ROVehicle_M41_Content
//=============================================================================
// Content for M41
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// -
//
// -
//=============================================================================
class ROVehicle_M41_Content extends ROVehicle_M41
	placeable;

DefaultProperties
{
	// ------------------------------- Mesh --------------------------------------------------------------

	Begin Object Name=ROSVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_VN_M41.Mesh.M41_Rig_Master'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
		AnimTreeTemplate=AnimTree'VH_VN_M41.Anim.AT_VH_M41'
		PhysicsAsset=PhysicsAsset'VH_VN_M41.Phys.M41_Rig_Master_Physics'
		AnimSets.Add(AnimSet'VH_VN_M41.Anim.M41_anim_Master')
		AnimSets.Add(AnimSet'VH_VN_M41.Anim.M41_Destroyed_anim_Master')
		
	End Object

	// // -------------------------------- Sounds -----------------------------------------------------------

	// // Engine start sounds
	/*
	Begin Object Class=AudioComponent Name=StartEngineLSound
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Engine_Start_Cabin_L_Cue'
	End Object
	EngineStartLeftSound=StartEngineLSound

	Begin Object Class=AudioComponent Name=StartEngineRSound
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Engine_Start_Cabin_R_Cue'
	End Object
	EngineStartRightSound=StartEngineRSound

	Begin Object Class=AudioComponent Name=StartEngineExhaustSound
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Engine_Start_Exhaust_Cue'
	End Object
	EngineStartExhaustSound=StartEngineExhaustSound

	// Engine idle sounds
	Begin Object Class=AudioComponent Name=IdleEngineLeftSound
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Engine_Run_Cabin_L_Cue'
		bShouldRemainActiveIfDropped=TRUE
	End Object
	EngineIntLeftSound=IdleEngineLeftSound

	Begin Object Class=AudioComponent Name=IdleEngineRighSound
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Engine_Run_Cabin_R_Cue'
		bShouldRemainActiveIfDropped=TRUE
	End Object
	EngineIntRightSound=IdleEngineRighSound

	Begin Object Class=AudioComponent Name=IdleEngineExhaustSound
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Engine_Run_Exhaust_Cue'
		bShouldRemainActiveIfDropped=TRUE
	End Object
	EngineSound=IdleEngineExhaustSound

	// Track sounds
	Begin Object Class=AudioComponent Name=TrackLSound
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Treads_L_Cue'
	End Object
	TrackLeftSound=TrackLSound

	Begin Object Class=AudioComponent Name=TrackRSound
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Treads_R_Cue'
	End Object
	TrackRightSound=TrackRSound

	// Brake sounds
	Begin Object Class=AudioComponent Name=BrakeLeftSnd
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Treads_Brake_Cue'
	End Object
	BrakeLeftSound=BrakeLeftSnd

	Begin Object Class=AudioComponent Name=BrakeRightSnd
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Treads_Brake_Cue'
	End Object
	BrakeRightSound=BrakeRightSnd

	// Damage sounds
	//EngineIdleDamagedSound=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Engine_Broken_Cue'
	//TrackTakeDamageSound=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Treads_Brake_Cue'
	//TrackDamagedSound=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Treads_Broken_Cue'
	//TrackDestroyedSound=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Treads_Skid_Cue'

	// Destroyed tranmission
	Begin Object Class=AudioComponent Name=BrokenTransmissionSnd
		SoundCue=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Transmission_Broken_Cue'
		bStopWhenOwnerDestroyed=TRUE
	End Object
	BrokenTransmissionSound=BrokenTransmissionSnd
	
	// Gear shift sounds
	//ShiftUpSound=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Engine_Exhaust_ShiftUp_Cue'
	//ShiftDownSound=SoundCue'WW_VN_M41.Movement.Panzer_Movement_Engine_Exhaust_ShiftDown_Cue'
	//ShiftLeverSound=SoundCue'WW_VN_M41.Foley.Panzer_Lever_GearShift_Cue'

	// Turret sounds
	Begin Object Class=AudioComponent Name=TurretTraverseComponent
		SoundCue=SoundCue'WW_VN_T54.Turret.Turret_Traverse_Manual_Cue'
	End Object
	TurretTraverseSound=TurretTraverseComponent
	Components.Add(TurretTraverseComponent);

	Begin Object Class=AudioComponent Name=TurretMotorTraverseComponent
		SoundCue=SoundCue'WW_VN_T54.Turret.Turret_Traverse_Electric_Cue'
	End Object
	TurretMotorTraverseSound=TurretMotorTraverseComponent
	Components.Add(TurretMotorTraverseComponent);

	Begin Object Class=AudioComponent Name=TurretElevationComponent
		SoundCue=SoundCue'WW_VN_T54.Turret.Turret_Elevate_Cue'
	End Object
	TurretElevationSound=TurretElevationComponent
	Components.Add(TurretElevationComponent);
	*/
	//only working event
	Begin Object Class=AkComponent Name=IdleEngineExhaustSound
		Bonename=chassis
		bStopWhenOwnerDestroyed=true
	End Object
	
	EngineSound=IdleEngineExhaustSound
	EngineSoundEvent=AkEvent'WW_ENV_Shared.Play_ENV_Diesel_Idle'

	// Begin Object Class=AudioComponent name=HullMGSoundComponent
	// 	bShouldRemainActiveIfDropped=true
	// 	bStopWhenOwnerDestroyed=true
	// 	SoundCue=SoundCue'AUD_Firearms_MG_DP28.Fire_3P.MG_DP28_Tank_Fire_Loop_M_Cue'
	// End Object

	// HullMGAmbient=HullMGSoundComponent
	// Components.Add(HullMGSoundComponent)

	// HullMGStopSound=SoundCue'AUD_Firearms_MG_DP28.Fire_3P.MG_DP28_Tank_Fire_Loop_Tail_M_Cue'
	
	ExplosionSound=AkEvent'WW_EXP_C4.Play_EXP_C4_Explosion'
	

	// // -------------------------------- Dead -----------------------------------------------------------

	DestroyedSkeletalMesh=SkeletalMesh'VH_VN_M41.Mesh.M41_Destroyed_Master'
	DestroyedSkeletalMeshWithoutTurret=SkeletalMesh'VH_VN_M41.Mesh.M41_Body_Destroyed_Master'
	DestroyedPhysicsAsset=PhysicsAsset'VH_VN_M41.Phys.M41_Destroyed_Physics'
	DestroyedMaterial=MaterialInstanceConstant'VH_VN_M41.Materials.M_M41_Rear_D'
 	DestroyedTurretClass=class'ROAmmoCrate.ROVehicleDeathTurret_M41'
	

	// // HUD
	DriverOverlayTexture=none
	HUDBodyTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_pz4_body'
	HUDTurretTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_pz4_turret'
	//DriverOverlayTexture=Texture2D'ui_textures.VehicleOptics.ui_hud_vehicle_optics_T34_driver'
	HUDMainCannonTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_GunPZ'
	HUDGearBoxTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_transmition_PZ'
	HUDFrontArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_front'
	HUDBackArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_back'
	HUDLeftArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_left'
	HUDRightArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_PZ4armor_right'
	//HUDTurretFrontArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_T34armor_turretfront'
	//HUDTurretBackArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_T34armor_turretback'
	//HUDTurretLeftArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_T34armor_turretleft'
	//HUDTurretRightArmorTexture=Texture2D'ui_textures.HUD.Vehicles.ui_tank_hud_T34armor_turretright'
	RoleSelectionImage=Texture2D'ui_textures.Textures.ger_tank_pzIVg'

	// Driver
	SeatProxies(0)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Long_INST',
		SeatIndex=0,
		PositionIndex=1)}

	// Cmndr
	SeatProxies(1)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Long_INST',
		SeatIndex=1,
		PositionIndex=2)}



	//Loader
	SeatProxies(2)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Long_INST',
		SeatIndex=2,
		PositionIndex=0)}



	// Seat proxy animations
	SeatProxyAnimSet=AnimSet'VH_VN_M41.Anim.CHR_M41_anim_Master'
		//----------------------------------------------------------------
	//                 Tank Attachments
	//
	// Exterior attachments use the exterior light environment,
	// accept light from the dominant directional light only and
	// cast shadows
	//
	// Interior attachments use the interior light environment,
	// accept light from both the dominant directional light and
	// the vehicle interior lights. They do not usually cast shadows.
	// Exceptions are attachments which share a part of the mesh with
	// the exterior.
	//----------------------------------------------------------------

	// -------------- Exterior attachments ------------------//


	Begin Object class=StaticMeshComponent name=ExtBodyAttachment0
		StaticMesh=StaticMesh'VH_VN_M41.Mesh.M41_Body'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_Foreground
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
	End Object
	//ExtExtraMesh=ExtBodyAttachment0

	Begin Object class=StaticMeshComponent name=ExtBodyAttachment1
		StaticMesh=StaticMesh'VH_VN_M41.Mesh.M41_Turret'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_Foreground
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
	End Object
		
	//MeshAttachments(0)={(AttachmentName=ExtBodyComponent,Component=ExtBodyAttachment0,AttachmentTargetName=chassis)}
	//MeshAttachments(1)={(AttachmentName=ExtTurretComponent,Component=ExtBodyAttachment1,AttachmentTargetName=turret)}
}
