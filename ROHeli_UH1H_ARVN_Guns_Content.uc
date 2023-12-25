//=============================================================================
// ROHeli_UH1H_ARVN_Guns_Content
//=============================================================================
// Content for the UH-1H Iroquois "Bushranger" Gunship/Transport, ARVN paintjob
//=============================================================================
// DirtyGrandpa
//=============================================================================
class ROHeli_UH1H_ARVN_Guns_Content extends ROHeli_UH1H_ARVN_Gunship
	placeable;

DefaultProperties
{
	Begin Object Name=ROSVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_VN_AUS_Bushranger_pax.Mesh.SGuns_Rig_Master'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=TRUE,bInitialized=TRUE)
		AnimTreeTemplate=AnimTree'VH_VN_AUS_Bushranger_pax.Anim.AT_VH_SGuns'
		PhysicsAsset=PhysicsAsset'VH_VN_AUS_Bushranger_pax.Phys.SGuns_Rig_Master_Physics'
		AnimSets.Add(AnimSet'VH_VN_AUS_Bushranger_pax.Anim.VH_Guns_Anims')
		AnimSets.Add(AnimSet'VH_VN_AUS_Bushranger_pax.Anim.VH_Huey_Anims')
	End Object

PhysAssetNoTail=PhysicsAsset'VH_VN_AUS_Bushranger_pax.Phys.Guns_Rig_NoTail_Master_Physics'	DestroyedSkeletalMesh=SkeletalMesh'VH_VN_AUS_Bushranger_pax.Mesh.SGuns_Destroyed_Master'
	DestroyedPhysicsAsset=PhysicsAsset'VH_VN_US_UH1H.Phys.US_UH1H_Destroyed_Master_Physics'
DestroyedMaterial=MaterialInstanceConstant'VH_VN_ARVN_UH1H.Materials.M_ARVN_Huey_WRECK'
	//DestroyedTurretClass=none
DestroyedMainRotorGibClass=class'ROGameContent.UH1H_MainRotorGib'
	DestroyedMainRotorAltGibClass=class'ROGameContent.UH1H_MainRotorYellowGib'
	DestroyedTailRotorGibClass=class'ROGameContent.UH1H_TailRotorAusGib'
	DestroyedTailBoomGibClass=class'ROGameContent.UH1H_TailBoomAusGib'

	ExplosionSound=AkEvent'WW_VEH_Shared.Play_VEH_Helicopter_Explode_Close'

	// -------------------------------- Sounds -----------------------------------------------------------

	// Engine running sound
	Begin Object Class=AkComponent Name=EngineRotorSound
		Bonename=dummy
		bStopWhenOwnerDestroyed=true
	End Object
	EngineSound=EngineRotorSound
	EngineSoundEvent=AkEvent'WW_VEH_UH1.Play_UH1_Run'

	// Engine startup sound
	Begin Object Class=AkComponent Name=StartEngineSound
		Bonename=dummy
		bStopWhenOwnerDestroyed=true
	End Object
	EngineStartSound=StartEngineSound
	EngineStartSoundEvent=AkEvent'WW_VEH_UH1.Play_UH1_Startup'

	// Engine shutdown sound
	/*Begin Object Class=AudioComponent Name=StopEngineSound
		SoundCue=SoundCue'AUD_VN_Vehicles_Heli_OH6.Movement.OH6_Movement_Engine_Start_Cue'
	End Object
	EngineStartSound=StopEngineSound*/

	// SAM Alert
	Begin Object Class=AkComponent Name=MissileWarningAudio
		bStopWhenOwnerDestroyed=true
	End Object
	MissileWarningSound=MissileWarningAudio
	MissileWarningSoundEvent=AkEvent'WW_VEH_UH1.Play_Helicopter_Missile_Warning'

	Begin Object Class=AkComponent name=MinigunLSoundComponent
		BoneName=dummy
		bStopWhenOwnerDestroyed=true
	End Object
	MinigunLAmbient=MinigunLSoundComponent
	Components.Add(MinigunLSoundComponent)
	MinigunLAmbientEvent=AkEvent'WW_M134_Minigun.Play_MG_M134_Loop_3p'
	MinigunLAmbientLowEvent=AkEvent'WW_M134_Minigun.Play_MG_M134_Low_Vehicle_Fire_Loop_3p'

	Begin Object Class=AkComponent name=MinigunLStopSoundComponent
		BoneName=dummy
		bStopWhenOwnerDestroyed=true
	End Object
	MinigunLStopSound=MinigunLStopSoundComponent
	Components.Add(MinigunLStopSoundComponent)
	MinigunLStopSoundEvent=AkEvent'WW_M134_Minigun.Play_MG_M134_LoopEnd_3p'

	Begin Object Class=AkComponent name=MinigunRSoundComponent
		BoneName=dummy
		bStopWhenOwnerDestroyed=true
	End Object
	MinigunRAmbient=MinigunRSoundComponent
	Components.Add(MinigunRSoundComponent)
	MinigunRAmbientEvent=AkEvent'WW_M134_Minigun.Play_MG_M134_Loop_3p'
	MinigunRAmbientLowEvent=AkEvent'WW_M134_Minigun.Play_MG_M134_Low_Vehicle_Fire_Loop_3p'

	Begin Object Class=AkComponent name=MinigunRStopSoundComponent
		BoneName=dummy
		bStopWhenOwnerDestroyed=true
	End Object
	MinigunRStopSound=MinigunRStopSoundComponent
	Components.Add(MinigunRStopSoundComponent)
	MinigunRStopSoundEvent=AkEvent'WW_M134_Minigun.Play_MG_M134_LoopEnd_3p'

	Begin Object Class=AkComponent name=DoorMGLSoundComponent
		bStopWhenOwnerDestroyed=true
	End Object
	DoorMGLAmbient=DoorMGLSoundComponent
	Components.Add(DoorMGLSoundComponent)
	//DoorMGLAmbientEvent=AkEvent'WW_WEP_M60.Play_WEP_M60_Fire_Loop_3P'

	Begin Object Class=AkComponent name=DoorMGRSoundComponent
		bStopWhenOwnerDestroyed=true
	End Object
	DoorMGRAmbient=DoorMGRSoundComponent
	Components.Add(DoorMGRSoundComponent)
	//DoorMGRAmbientEvent=AkEvent'WW_WEP_M60.Play_WEP_M60_Fire_Loop_3P'

	Begin Object Class=AkComponent name=DoorMGLStopSoundComponent
		bStopWhenOwnerDestroyed=true
	End Object
	DoorMGLStopSound=DoorMGLStopSoundComponent
	Components.Add(DoorMGLStopSoundComponent)
	//DoorMGLStopEvent=AkEvent'WW_WEP_M60.Play_WEP_M60_Tail_3P'

	Begin Object Class=AkComponent name=DoorMGRStopSoundComponent
		bStopWhenOwnerDestroyed=true
	End Object
	DoorMGRStopSound=DoorMGRStopSoundComponent
	Components.Add(DoorMGRStopSoundComponent)
	//DoorMGRStopEvent=AkEvent'WW_WEP_M60.Play_WEP_M60_Tail_3P'

	Begin Object class=ParticleSystemComponent name=ParticleSystemComponent0
		Template=ParticleSystem'FX_VN_Helicopters.Emitter.FX_VN_M134_Tracer'
		bAutoActivate=false
	End Object
	MinigunLTracerComponent=ParticleSystemComponent0

	Begin Object class=ParticleSystemComponent name=ParticleSystemComponent1
		Template=ParticleSystem'FX_VN_Helicopters.Emitter.FX_VN_M134_Tracer'
		bAutoActivate=false
	End Object
	MinigunRTracerComponent=ParticleSystemComponent1

	// HUD
	DriverOverlayTexture=none
	HUDBodyTexture=Texture2D'VN_UI_Textures_Three.HUD.Vehicles.UI_HUD_Helo_Bush_BodyOnly'
	HUDGearBoxTexture=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_transmition_PZ'
	HUDMainRotorTexture=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_mainrotor'
	HUDTailRotorTexture=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_tailrotor'
	HUDLeftSkidTexture=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_leftskid'
	HUDRightSkidTexture=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_rightskid'
	HUDTailBoomTexture=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_tailboom'
	HUDAmmoTextures[0]=Texture2D'VN_UI_Textures_Three.HUD.Vehicles.UI_HUD_Helo_Bush_Ammo_Pilot'
	HUDAmmoTextures[1]=Texture2D'VN_UI_Textures_Three.HUD.Vehicles.UI_HUD_Helo_Bush_Ammo_Gunner'
	HUDAmmoTextures[2]=Texture2D'VN_UI_Textures.HUD.Vehicles.UI_HUD_Helo_Ammo_UH1H_LeftDoor'
	HUDAmmoTextures[3]=Texture2D'VN_UI_Textures.HUD.Vehicles.UI_HUD_Helo_Ammo_UH1H_RightDoor'
	RPMGaugeTexture=Texture2D'VN_UI_Textures.HUD.Vehicles.UI_HUD_Helo_RPM_AH1'
	// Pilot
	SeatProxies(0)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head6_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_06_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=0,
		PositionIndex=0,
		bExposedToRain=false)}

	// Copilot
	SeatProxies(1)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head7_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_07_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=1,
		PositionIndex=0,
		bExposedToRain=false)}

	// Crew Chief
	SeatProxies(2)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head8_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_08_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		HeadgearSocket=helmet,
		SeatIndex=2,
		PositionIndex=0,
		bExposedToRain=true)}

	// Door Gunner
	SeatProxies(3)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head9_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_09_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		HeadgearSocket=helmet,
		SeatIndex=3,
		PositionIndex=0,
		bExposedToRain=true)}

	// Passenger 1
	SeatProxies(4)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head6_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_06_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		SeatIndex=4,
		PositionIndex=0,
		bExposedToRain=false)}

	// Passenger 2
	SeatProxies(5)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head7_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_07_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		SeatIndex=5,
		PositionIndex=0,
		bExposedToRain=false)}

	// Passenger 3
	SeatProxies(6)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head8_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_08_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		SeatIndex=6,
		PositionIndex=0,
		bExposedToRain=false)}

	// Passenger 4
	SeatProxies(7)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head9_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_09_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		SeatIndex=7,
		PositionIndex=0,
		bExposedToRain=false)}

// Seat proxy animations
	SeatProxyAnimSet=AnimSet'VH_VN_AUS_Bushranger_pax.Anim.CHR_Guns_anims'
	//SeatProxyAnimSet(1)=AnimSet'VH_VN_AUS_Bushranger_pax.Anim.CHR_Huey_anims'

	// -------------- Exterior attachments ------------------//

	Begin Object class=StaticMeshComponent name=ExtBodyAttachment0
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Mesh.SGuns_Fuselage_SM'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_Foreground
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object

	Begin Object class=StaticMeshComponent name=ExtBodyAttachment1
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Mesh.Guns_TailBoom_SM'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_Foreground
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object

	Begin Object class=StaticMeshComponent name=ExtBodyAttachment2
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Mesh.SGuns_Armament_SM'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_Foreground
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object
	
	Begin Object class=StaticMeshComponent name=IntM60Attachment0
		StaticMesh=StaticMesh'VH_VN_US_UH1H.Mesh.M60D_1p_SM'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_Foreground
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object

	Begin Object class=StaticMeshComponent name=IntM60Attachment1
		StaticMesh=StaticMesh'VH_VN_US_UH1H.Mesh.M60D_1p_SM'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_Foreground
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object


	// -------------- Interior attachments ------------------//

	// NO INTERNAL ATTACHMENTS CURRENTLY

	MeshAttachments(0)={(AttachmentName=ExtBodyComponent,Component=ExtBodyAttachment0,AttachmentTargetName=Fuselage)}
	MeshAttachments(1)={(AttachmentName=ExtTailComponent,Component=ExtBodyAttachment1,AttachmentTargetName=Tail_Boom)}
	MeshAttachments(2)={(AttachmentName=ExtArmamentComponent,Component=ExtBodyAttachment2,AttachmentTargetName=Fuselage)}
	MeshAttachments(3)={(AttachmentName=IntM60LComponent,Component=IntM60Attachment0,AttachmentTargetName=MG_Frontend_L)}
	MeshAttachments(4)={(AttachmentName=IntM60RComponent,Component=IntM60Attachment1,AttachmentTargetName=MG_Frontend_R)}

	// -------------- Additional external attachments ------------------//
	// Note, these are separate from the regular attachments list and only exist on this helo
	// They're for display to external players rather than internal ones
	Begin Object class=StaticMeshComponent name=ExtArmamentsAttachment0
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Mesh.SGuns_Armament_SM'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=false
		DepthPriorityGroup=SDPG_World
		HiddenGame=false
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object
	ExtArmamentsMesh=ExtArmamentsAttachment0
	
	Begin Object class=StaticMeshComponent name=ExtM60Attachment0
		StaticMesh=StaticMesh'VH_VN_US_UH1H.Mesh.M60D_3p_SM'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=false
		DepthPriorityGroup=SDPG_World
		HiddenGame=false
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object
	ExtM60MeshLeft=ExtM60Attachment0

	Begin Object class=StaticMeshComponent name=ExtM60Attachment1
		StaticMesh=StaticMesh'VH_VN_US_UH1H.Mesh.M60D_3p_SM'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=false
		DepthPriorityGroup=SDPG_World
		HiddenGame=false
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object
	ExtM60MeshRight=ExtM60Attachment1
	

	// Special case for wrecked helo only. Only attached AFTER the helo has been destroyed
	Begin Object class=StaticMeshComponent name=WreckedArmamentAttachment
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Damage.SGuns_Armament_Damaged_SM'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=false
		DepthPriorityGroup=SDPG_World
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object
	WreckedArmamentsMesh=WreckedArmamentAttachment

	// ------------------ Rotor Blade Attachments ------------------ //

	Begin Object class=StaticMeshComponent name=MainRotorAttachment0
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Mesh.MainBlade'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_World
		//HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object

	Begin Object class=StaticMeshComponent name=MainRotorAttachment1
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Mesh.MainBlade_02'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_World
		//HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object

	Begin Object class=StaticMeshComponent name=TailRotorAttachment
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Mesh.TailBlade'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_World
		//HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object

	// Blurred rotor meshes

	Begin Object class=StaticMeshComponent name=MainRotorBlurAttachment0
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Mesh.MainBlade_Blurred'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_World
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object

	Begin Object class=StaticMeshComponent name=MainRotorBlurAttachment1
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Mesh.MainBlade_Blurred_02'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_World
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object

	Begin Object class=StaticMeshComponent name=TailRotorBlurAttachment
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Mesh.TailBlade_Blurred'
		LightingChannels=(Dynamic=TRUE,Unnamed_1=FALSE,bInitialized=TRUE)
		LightEnvironment = MyLightEnvironment
		CastShadow=true
		DepthPriorityGroup=SDPG_World
		HiddenGame=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		bAcceptsDynamicDecals=FALSE
	End Object

	RotorMeshAttachments(0)=(AttachmentName=MainRotorComponent0,Component=MainRotorAttachment0,BlurredComponent=MainRotorBlurAttachment0,DestroyedMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Damage.MainBlade_Stub01',AttachmentTargetName=Blade_01,bMainRotor=true, HitZoneIndex=MAINROTORBLADE1)
	RotorMeshAttachments(1)=(AttachmentName=MainRotorComponent1,Component=MainRotorAttachment1,BlurredComponent=MainRotorBlurAttachment1,DestroyedMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Damage.MainBlade_Stub02',AttachmentTargetName=Blade_02,bMainRotor=true, HitZoneIndex=MAINROTORBLADE2)
	RotorMeshAttachments(2)=(AttachmentName=TailRotorComponent,Component=TailRotorAttachment,BlurredComponent=TailRotorBlurAttachment,DestroyedMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Damage.TailRotor_stub',AttachmentTargetName=Tail_Rotor,bMainRotor=false, HitZoneIndex=TAILROTORBLADES)


	// Gibs
	Begin Object name=TailBoomDestroyed
		StaticMesh=StaticMesh'VH_VN_AUS_Bushranger_pax.Damage.TailBoom_Stub'
	End Object
}
