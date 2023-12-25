class ROPawn_Ext extends ROPawn;

var int dripcount;
var SkeletalMeshComponent LowerBodyMesh;
var SkeletalMeshComponent FPGear;
var SkeletalMesh CompositedLegs;
var ROSkeletalMeshComponent HideHeadComponent;
var ParticleSystemComponent BloodyWaterComp;      // blood

simulated event PreBeginPlay()
{
	PawnHandlerClass = class'ROPawnHandler_Ext';

	super.PreBeginPlay();
}

simulated event PostBeginPlay()
{
	//local SkeletalMeshSocket CameraSocket;

	super.PostBeginPlay();

	if (!bWeaponAttachmentVisible) // This is for optimization purposes too
	{
		WeaponShadow();
	}

	//CameraSocket = mesh.GetSocketByName(CameraSocketName);
	//CameraSocket.RelativeLocation = CameraSocketRelativeLocation;

	mesh.bCastHiddenShadow = true;
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp) //
{
	super.PostInitAnimTree(SkelComp);


	if(!bWeaponAttachmentVisible)
	{
		ROFPPShadow();
	}

	//CameraSocketName = default.RagdollCameraSocketName;
}



simulated function ROFPPShadow()
{
	EnableLeftHandIK(true,0.1f);
	EnableRightHandIK(true,0.1f);
	EnableWeaponLookAt(true,0.1f);
	EnableHandsAnimation(true, 0.1f);
	SetWeaponNoClip(true);
	SetWeaponAttachmentVisibility(true);
	Mesh.bUpdateKinematicBonesFromAnimation = true;
	Mesh.bNoSkeletonUpdate = false;
	Mesh.ForceSkelUpdate();
	Mesh.bIgnoreControllersWhenNotRendered = false;
	mesh.bCastHiddenShadow = true;
	mesh.AnimatingIntoView(2.f);
	CurrentWeaponAttachment.Mesh.bIgnoreControllersWhenNotRendered = false;
}

simulated event StopDriving(Vehicle V)
{
	Super.StopDriving(V);
	ROFPPShadow();
}

simulated function SetMeshVisibility(bool bVisible)
{
	super.SetMeshVisibility(bVisible);
	if(!default.ThirdPersonHeadAndArmsMeshComponent.bOwnerNoSee )
    	{
        	ThirdPersonHeadAndArmsMeshComponent.SetOwnerNoSee(!bVisible);
    	}

	if ( !bVisible || WorldInfo.NetMode == NM_DedicatedServer || WorldInfo.NetMode == NM_ListenServer )
	{
		mesh.bUpdateSkelWhenNotRendered = true;
		ThirdPersonHeadAndArmsMeshComponent.bUpdateSkelWhenNotRendered = true;
		ThirdPersonHeadgearMeshComponent.bUpdateSkelWhenNotRendered = true;		
		LowerBodyMesh.bUpdateSkelWhenNotRendered = true;
		
        	WeaponShadow();

		if ( ClothComponent != none )
		{
			ClothComponent.bUpdateSkelWhenNotRendered = true;
		}

		if ( FaceItemMeshComponent != none )
		{
			FaceItemMeshComponent.bUpdateSkelWhenNotRendered = true;
		}

		if ( FacialHairMeshComponent != none )
		{
			FacialHairMeshComponent.bUpdateSkelWhenNotRendered = true;
		}
	}
	else
	{
		Mesh.AnimatingIntoView(2.0);
		ThirdPersonHeadAndArmsMeshComponent.AnimatingIntoView(2.0);
		ThirdPersonHeadgearMeshComponent.AnimatingIntoView(2.0);
		LowerBodyMesh.AnimatingIntoView(2.0);
	

		if( ClothComponent != none )
		{
			ClothComponent.AnimatingIntoView(2.0);
		}

		if( FaceItemMeshComponent != none )
		{
			FaceItemMeshComponent.AnimatingIntoView(2.0);
		}

		if( FacialHairMeshComponent != none )
		{
			FacialHairMeshComponent.AnimatingIntoView(2.0);
		}
	}
	
	if( LowerBodyMesh != none )
	{
		LowerBodyMesh.SetHidden(true); //changed
	}

	//EnableFirstPersonBody(!bVisible);
	
	// Handle third person weapon
	SetWeaponAttachmentVisibility(bVisible);

	// Handle any weapons they might have
	SetWeaponVisibility(!bVisible);

}

simulated function BleedingDecalEffect() //
{
    if(dripcount < 12)
    {
        ROLeaveABloodDripDecal();
        dripcount++;
    }
    else
    {
        ClearTimer('BleedingDecalEffect');
        dripcount = 0;
    }
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local vector ApplyImpulse, ShotDir, VelocityBeforeDeath;
	local PlayerController PC;
	local ROPlayerController ROPC;
	// local Array<Name> ImpaleBoneNames;

	// Abort current special move
	if( IsDoingASpecialMove() )
	{
		DoSpecialMove(SM_None);
	}

	// If we're in training mode and we're just changing teams, don't do my death effects, just destroy the pawn and bail.
	if(ROGameInfoTraining(WorldInfo.Game) != None && ROGameInfoTraining(WorldInfo.Game).bRespawnDueToTeamRolechange)
	{
		Destroy();
		return;
	}

	// H
	if( bPlayedDeath )
	   return;

	// Temp slow dying effect - TODO: Replace when we rework slow dying
	ClearTimer('BleedingDecalEffectSlow');
	ClearTimer('BleedingDecalEffect');
	ClearTimer('BleedingDecalEffectFast');

	VelocityBeforeDeath = Velocity;

	bCanTeleport = false;
	bReplicateMovement = false;
	bTearOff = true;
	bPlayedDeath = true;
	bFallen = false;
	//bPlayingFeignDeathRecovery = false;

	HitDamageType = DamageType;	// these are replicated to other clients
	TakeHitLocation = HitLoc;

	// make sure I don't have an active weaponattachment
	CurrentWeaponAttachmentClass = None;
	WeaponAttachmentChanged();

	// On death ThrowWeaponOnDeath() drops all weapon as pickups, so need to destroy all remaining weapon attachments
	ClearWeaponAttachments();

	// if ( InactiveWeaponAttachment != none )
	// {
	// 	InactiveWeaponAttachment.DetachFrom(Mesh);
	// 	InactiveWeaponAttachment.Destroy();
	// }

	if( DeathHandsAnim != '' )
	{
		// @todo: this doesn't work because there is no anim weight on the ragdoll
		EnableHandsAnimation(true,0.1f);
		SetHandsAnimation(DeathHandsAnim);
	}

	// Have to find the player watching us die in first person, since on
	// the client in net games, the controller could have already been
	// delinked from the Pawn by the time we get here - Ramm
	foreach LocalPlayerControllers( class'PlayerController', PC )
	{
		if( PC.ViewTarget == self && PC.UsingFirstPersonCamera() )
		{
			HideHead(PC);

			// RS2: Make sure progress bar widget is hidden -Austin
			ROPC = ROPlayerController(PC);

			if( ROPC != none && ROPC.myROHUD != none )
			{
				ROPC.myROHUD.HideProgressBarWidget();
			}
		}
	}

	// CameraStuff
	CameraSocketName = RagdollCameraSocketName;
	SetCameraSocketWeight(1.0f, 0.0f, 1.0f, 0.0f);





	Mesh.ForceSkelUpdate();
	Mesh.MinDistFactorForKinematicUpdate = 0.f; 	// 0 means, always update RB, no matter the distance
	Mesh.bUpdateJointsFromAnimation = true;         // need to turn this on for motorized joints!
	Mesh.bUpdateKinematicBonesFromAnimation = true; // need to make sure the the rigid body bones actually work...
	Mesh.UpdateRBBonesFromSpaceBases(true, true); 	// need to force RB updating.
	// Mesh.bForceDiscardRootMotion = true;

	// Make the mesh visible when you die so you can see it in first person
	SetMeshVisibility(true);

	// On death, update the pawn mesh even if it is not rendered, to fix floating/stretching mesh attachments
	Mesh.bUpdateSkelWhenNotRendered = true;
	ThirdPersonHeadAndArmsMeshComponent.bUpdateSkelWhenNotRendered = true;

	// Play full ragdoll if there isn't a special death animation
	// for the bone that was hit.
	// TODO: For now applying the impact force all the time as it didnt seem
	// right NOT to do it even if you had a custom death anim. Look at
	// removing this check altogether if it doesn't cause any problems - Ramm
	if( true /*!HasCustomDeathAnimation(KillingHitInfo.BoneName)*/ ) // Employ full ragdoll
	{
		/*
		RO, Cooney: Lame but, we don't exactly want this method for
		handling ragdolls since we want an awesome gore system. Left
		in for reference. Take me out later.

		// Is this the local player's ragdoll?
		foreach LocalPlayerControllers(class'PlayerController', PC)
		{
			if( PC.ViewTarget == self )
			{
				bPlayersRagdoll = true;
				break;
			}
		}

		if ( (WorldInfo.TimeSeconds - LastRenderTime > 3) && (WorldInfo.NetMode != NM_ListenServer) && !bPlayersRagdoll )
		{
			// In low physics detail, if we were not just controlling this pawn,
			// and it has not been rendered in 3 seconds, just destroy it.
			Destroy();
			return;
		}
		*/

		// if we had some other rigid body thing going on, cancel it
		if (Physics == PHYS_RigidBody)
		{
			//@note: Falling instead of None so Velocity/Acceleration don't get cleared
			setPhysics(PHYS_Falling);
		}

		PreRagdollCollisionComponent = CollisionComponent;
		CollisionComponent = Mesh;

		SetPhysics(PHYS_RigidBody);
		Mesh.SetBlockRigidBody(true);
		Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
		Mesh.PhysicsWeight = 1.0f;
		Mesh.SetNotifyRigidBodyCollision(true);
		Mesh.SetRBLinearVelocity(VelocityBeforeDeath, false);

		if( TearOffMomentum != vect(0,0,0) )
		{
			// should be normal(DecodeSmallVector(TearOffMomentum)), but that's redundant
			ShotDir = normal(TearOffMomentum);
			ApplyImpulse = ShotDir * DamageType.default.KDamageImpulse;

			// if not moving downwards - give extra upward kick
			// if ( Velocity.Z > -10  && !bIsProning)
			// {
			// 	ApplyImpulse += Vect(0,0,1)*DamageType.default.KDeathUpKick;
			// }

			Mesh.AddImpulse(ApplyImpulse, TakeHitLocation, mesh.PhysicsAsset.BodySetup[KillingHitBoneIndex].BoneName, true);
		}
	}

	// handle stopping any current speech, if any
	if (DialogAkComp != None && bOnFireType <= ROBET_None)
	{
		DialogAkComp.StopEvents();
	}

	// Adding this here to ensure that remote clients destroy the radio at the same time as the server
	if( MyRadio != none )
		MyRadio.Destroy();

	SetTimer(1.0f,false,'DelayedDeathEffects',);

	GotoState('Dying');

	if (LowerBodyMesh != none)
	{
		LowerBodyMesh.SetHidden(true);
	}
	

}



simulated function SetPawnElementsByConfig(bool bViaReplication, optional ROPlayerReplicationInfo OverrideROPRI)
{
	local int TeamNum, ArmyIndex, ClassIndex, HonorLevel;
	local ROMapInfo ROMI;
	local ROPlayerReplicationInfo ROPRI;
	local byte IsHelmet, TunicID, TunicMatID, ShirtID, HeadID, HairID, HeadgearID, HeadgearMatID, SkinID, FaceItemID, FacialHairID, TattooID, bPilot;
 	local Texture2D ShirtD, ShirtN, ShirtS, TattooTex;
 	local float TattooUOffset, TattooVOffset, TattooDrawScale;
 	local byte bNoHeadgear, bNoFacialHair;

 	//if( PawnHandlerClass == none )
	//{
	//PawnHandlerClass = class<ROGameInfo>(WorldInfo.GetGameClass()).default.PawnHandlerClass;
	PawnHandlerClass = class'ROPawnHandler_Ext';
	//}

	if( PawnHandlerClass == none )
	{
		`warn(self@"does not have a PawnHandlerClass! Unable to set character customisation.");
		return;
	}

	TeamNum = GetTeamNum();
	ROMI = ROMapInfo(WorldInfo.GetMapInfo());

	if( OverrideROPRI != none )
		ROPRI = OverrideROPRI;
	else
		ROPRI = ROPlayerReplicationInfo(PlayerReplicationInfo);

	if( ROPRI != none )
	{
		if( ROPRI.RoleInfo != none )
		{
			ClassIndex = ROPRI.RoleInfo.ClassIndex;
		}

		if( !ROPRI.bBot )
		{
			if( bViaReplication )
			{
				HonorLevel = int(ROPRI.HonorLevel);
			}
			else if( ROPlayerController(Controller) != none )
			{
				ROPlayerController(Controller).StatsWrite.UpdateHonorLevel();
				HonorLevel = ROPlayerController(Controller).StatsWrite.HonorLevel;
			}
		}
	}

	// Sometimes when joining a game in progress, the team will not replicate in time and will be 255.
	// This failsafe catches that and works out the correct team based on the type of pawn
	if( TeamNum == 255 )
	{
		if( IsA('RONorthPawn') )
			TeamNum = `AXIS_TEAM_INDEX;
		else if( IsA('ROSouthPawn') )
			TeamNum = `ALLIES_TEAM_INDEX;
	}

	if( ROMI != none )
	{
		if( TeamNum == `AXIS_TEAM_INDEX )
			ArmyIndex = ROMI.NorthernForce;
		else
			ArmyIndex = ROMI.SouthernForce;
	}

	if( bIsPilot )
	{
		if( ArmyIndex == SFOR_ARVN && ROPRI.RoleInfo != none && !ROPRI.RoleInfo.bIsTransportPilot )
			bPilot = 2;
		else
			bPilot = 1;
	}

	if( !bViaReplication && IsHumanControlled() )
	{
	//	if(  )
			PawnHandlerClass.static.GetCharConfig(TeamNum, ArmyIndex, bPilot, ClassIndex, HonorLevel, TunicID, TunicMatID, ShirtID, HeadID, HairID, HeadgearID, HeadgearMatID, FaceItemID, FacialHairID, TattooID, ROPRI);

			// Hardcoded for ARVN, until such time as we ever have any other factions that require alternate nationality pilots
			if( ArmyIndex == SFOR_ARVN && bPilot == 2 )
				ROPRI.bUsesAltVoicePacks = true;
			else
				ROPRI.bUsesAltVoicePacks = false;
	//	else
	//		PawnHandlerClass.static.GetCharConfig(TeamNum, ArmyIndex, bPilot, HonorLevel, TunicID, TunicMatID, ShirtID, HeadID, HairID, HeadgearID, FaceItemID, FacialHairID, TattooID, ROPRI, true);
	}
	else if( ROPRI != none )
	{
		TunicID = ROPRI.CurrentCharConfig.TunicMesh;
		TunicMatID = ROPRI.CurrentCharConfig.TunicMaterial;
		ShirtID = ROPRI.CurrentCharConfig.ShirtTexture;
		HeadID = ROPRI.CurrentCharConfig.HeadMesh;
		HairID = ROPRI.CurrentCharConfig.HairMaterial;
		HeadgearID = ROPRI.CurrentCharConfig.HeadgearMesh;
		HeadgearMatID = ROPRI.CurrentCharConfig.HeadgearMaterial;
		FaceItemID = ROPRI.CurrentCharConfig.FaceItemMesh;
		FacialHairID = ROPRI.CurrentCharConfig.FacialHairMesh;
		TattooID = ROPRI.CurrentCharConfig.TattooTex;

		// This is a remote player's config, so lets sanity check it to make sure they've not sent something invalid
		PawnHandlerClass.static.ValidateCharConfig(TeamNum, ArmyIndex, bPilot, HonorLevel, TunicID, TunicMatID, ShirtID, HeadID, HairID, HeadgearID, HeadgearMatID, FaceItemID, FacialHairID, TattooID, ROPRI);
	}
	else
	{
		TunicID = 0;
		TunicMatID = 0;
		ShirtID = 0;
		HeadID = 0;
		HairID = 0;
		HeadgearID = 0;
		HeadgearMatID = 0;
		FaceItemID = 0;
		FacialHairID = 0;
		TattooID = 0;
	}

	// Set Tunic Meshes and Materials
	TunicMesh = PawnHandlerClass.static.GetTunicMeshes(TeamNum, ArmyIndex, bPilot, TunicID, bNoHeadgear);
	BodyMICTemplate = PawnHandlerClass.static.GetBodyMIC(TeamNum, ArmyIndex, bPilot, TunicID, TunicMatID);

	PawnMesh_SV = PawnHandlerClass.static.GetTunicMeshSV(TeamNum, ArmyIndex, ClassIndex, bPilot, bHasFlamethrower, BodyMICTemplate_SV);

	// Set Fieldgear mesh
	if( TeamNum == `AXIS_TEAM_INDEX )
		FieldgearMesh = PawnHandlerClass.static.GetFieldgearMesh(TeamNum, ArmyIndex, TunicID, ClassIndex, TunicMatID);
	else
		FieldgearMesh = PawnHandlerClass.static.GetFieldgearMesh(TeamNum, ArmyIndex, TunicID, ClassIndex, byte(bHasFlamethrower));

	// Set Head Mesh and Mats
	HeadAndArmsMesh = PawnHandlerClass.static.GetHeadAndArmsMesh(TeamNum, ArmyIndex, bPilot, HeadID, SkinID);
	CompositedLegs = class'ROPawnHandler_Ext'.static.GetLowerBody(TeamNum, ArmyIndex, 0, bPilot); //TunicID=0

	// Quick and dirty hack to fix single variant meshes not having foot textures if the player's actual chosen tunic was fancy
	if( bUseSingleCharacterVariant )
		HeadAndArmsMICTemplate = PawnHandlerClass.static.GetHeadMIC(TeamNum, ArmyIndex, HeadID, 0, bPilot);
	else
		HeadAndArmsMICTemplate = PawnHandlerClass.static.GetHeadMIC(TeamNum, ArmyIndex, HeadID, TunicID, bPilot);

	// Set Shirt Texture if required
	if( ShirtID > 0 && HeadAndArmsMIC != none && PawnHandlerClass.static.GetShirtTextures(TeamNum, ArmyIndex, bPilot, TunicID, ShirtID, ShirtD, ShirtN, ShirtS) )
	{
		HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.ShirtDiffuseParam,ShirtD);
		HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.ShirtNormalParam,ShirtN);
		HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.ShirtSpecParam,ShirtS);
	}

	// Set Tattoo Texture if required
	if( TattooID > 0 )
	{
		TattooTex = PawnHandlerClass.static.GetTattooTexture(TeamNum, ArmyIndex, bPilot, TattooID, TattooUOffset, TattooVOffset, TattooDrawScale);

		if( TattooTex != none && HeadAndArmsMIC != none )
		{
			HeadAndArmsMIC.SetTextureParameterValue(PawnHandlerClass.default.TattooParam,TattooTex);
			HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.TattooUOffsetParam,TattooUOffset);
			HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.TattooVOffsetParam,TattooVOffset);
			HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.TattooDrawScaleParam,TattooDrawScale);
		}
	}

	// Gore meshes
	if( !bUseSingleCharacterVariant )
	{
		UberGoreMesh = PawnHandlerClass.static.GetGoreMeshes(TeamNum, ArmyIndex, TunicID, SkinID, GoreMIC, Gore_LeftHand.GibClass, Gore_RightHand.GibClass, Gore_LeftLeg.GibClass, Gore_RightLeg.GibClass);
	}

	// Set first person arms mesh and skin texture
	ArmsOnlyMeshFP = PawnHandlerClass.static.GetFPArmsMesh(TeamNum, ArmyIndex, bPilot, TunicID, TunicMatID, SkinID, FPArmsSkinMaterialTemplate, FPArmsSleeveMaterialTemplate);
		
	CompositedLegs = class'ROPawnHandler_Ext'.static.GetLowerBody(TeamNum, ArmyIndex, TunicID, bPilot);

	// Set Headgear
	if( bNoHeadgear == 0 )
		HeadgearMesh = PawnHandlerClass.static.GetHeadgearMesh(TeamNum, ArmyIndex, bPilot, HeadID, HairID, HeadgearID, HeadgearMatID, HeadgearMICTemplate, HairMICTemplate, HeadgearAttachSocket, IsHelmet);
	else
		HeadgearMesh = none;

	// Set the type of sound played on headshot
	if( IsHelmet != 0 )
		bHeadGearIsHelmet = true;
	else
		bHeadGearIsHelmet = false;

	// Set Face Items
	FaceItemMesh = PawnHandlerClass.static.GetFaceItemMesh(TeamNum, ArmyIndex, bPilot, HeadgearID, FaceItemID, FaceItemAttachSocket, bNoFacialHair);
	FacialHairMesh = bNoFacialHair == 1 ? none : PawnHandlerClass.static.GetFacialHairMesh(TeamNum, ArmyIndex, FacialHairID, FacialHairAttachSocket);

	// Set the voice locally if we're playing offline or as a listen server
	if( Role == ROLE_Authority && ROPlayerController(Controller) != none )
	{
		if( TeamNum == `AXIS_TEAM_INDEX )
			ROPlayerController(Controller).SetSuitableVoicePack(TeamNum, ArmyIndex, 0);
		else
			ROPlayerController(Controller).SetSuitableVoicePack(TeamNum, ArmyIndex, SkinID);
	}
}

simulated function CreatePawnMesh()
{
	local ROMapInfo ROMI;
	local float HonourPct;
	local ROPlayerReplicationInfo ROPRI;
	local MaterialInterface GearMat;

	// Since this function now gets called twice, make sure that it can't run if the player is dead, as that leads to major problems
	if( Health <= 0 )
		return;

	// Third person MICs
	if( HeadAndArmsMIC == none )
		HeadAndArmsMIC = new class'MaterialInstanceConstant';
	if( BodyMIC == none )
		BodyMIC = new class'MaterialInstanceConstant';
	if( GearMIC == none )
		GearMIC = new class'MaterialInstanceConstant';
	if( HeadgearMIC == none )
		HeadgearMIC = new class'MaterialInstanceConstant';
	if( HairMIC == none && HairMICTemplate != none )
		HairMIC = new class'MaterialInstanceConstant';
	if( FPArmsSleeveMaterial == none && FPArmsSleeveMaterialTemplate != none )
		FPArmsSleeveMaterial = new class'MaterialInstanceConstant';
	if( FPArmsSkinMaterial == none && FPArmsSkinMaterialTemplate != none )
		FPArmsSkinMaterial = new class'MaterialInstanceConstant';

	if( bUseSingleCharacterVariant && BodyMICTemplate_SV != none )
		BodyMIC.SetParent(BodyMICTemplate_SV);
	else
		BodyMIC.SetParent(BodyMICTemplate);

	HeadAndArmsMIC.SetParent(HeadAndArmsMICTemplate);
	HeadgearMIC.SetParent(HeadgearMICTemplate);

	if( HairMIC != none )
		HairMIC.SetParent(HairMICTemplate);

	if( FPArmsSleeveMaterial != none )
		FPArmsSleeveMaterial.SetParent(FPArmsSleeveMaterialTemplate);

	if( FPArmsSkinMaterial != none )
		FPArmsSkinMaterial.SetParent(FPArmsSkinMaterialTemplate);

	MeshMICs.Length = 0;
	MeshMICs.AddItem(BodyMIC);
	MeshMICs.AddItem(HeadAndArmsMIC);
	MeshMICs.AddItem(HeadgearMIC);
	MeshMICs.AddItem(GearMIC);

	// Remove existing attachments before we start setting new ones. If we don't do this, we cause a whole world of problems later
	if( ThirdPersonHeadgearMeshComponent.AttachedToSkelComponent != none )
		mesh.DetachComponent(ThirdPersonHeadgearMeshComponent);
	if( FaceItemMeshComponent.AttachedToSkelComponent != none )
		mesh.DetachComponent(FaceItemMeshComponent);
	if( FacialHairMeshComponent.AttachedToSkelComponent != none )
		mesh.DetachComponent(FacialHairMeshComponent);
	if( ThirdPersonHeadAndArmsMeshComponent.AttachedToSkelComponent != none )
		DetachComponent(ThirdPersonHeadAndArmsMeshComponent);
	if( TrapDisarmToolMeshTP.AttachedToSkelComponent != none )
		mesh.DetachComponent(TrapDisarmToolMeshTP);

	ROMI = ROMapInfo(WorldInfo.GetMapInfo());

	if( !bUseSingleCharacterVariant && ROMI != none)
	{
		CompositedBodyMesh = ROMI.GetCachedCompositedPawnMesh(TunicMesh, FieldgearMesh);
	}
	else
	{
		// Use the single-variant mesh
		CompositedBodyMesh = PawnMesh_SV;
	}

	// Assign the HumanIK characterization
	CompositedBodyMesh.Characterization = PlayerHIKCharacterization;

	// Apply the body mesh and material to the pawn's third person mesh
	ROSkeletalMeshComponent(mesh).ReplaceSkeletalMesh(CompositedBodyMesh);


	mesh.SetMaterial(0, BodyMIC);

	//GearMat = mesh.GetMaterial(1);
	GearMat = FieldgearMesh.Materials[1];

	if( GearMIC != none && GearMat != none )
	{
		GearMIC.SetParent(GearMat);
		mesh.SetMaterial(1, GearMIC);
	}

	// Generate list of bones which override the animation transforms (this is usually the face bones)
	ROSkeletalMeshComponent(mesh).GenerateAnimationOverrideBones(HeadAndArmsMesh);

	// Parent the third person head and arms mesh to the body mesh
	ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(HeadAndArmsMesh);
	ThirdPersonHeadAndArmsMeshComponent.SetMaterial(0, HeadAndArmsMIC);
	ThirdPersonHeadAndArmsMeshComponent.SetParentAnimComponent(mesh);
	ThirdPersonHeadAndArmsMeshComponent.SetShadowParent(mesh);
	ThirdPersonHeadAndArmsMeshComponent.SetLODParent(mesh);
	AttachComponent(ThirdPersonHeadAndArmsMeshComponent);

	
	HideHeadComponent.SetSkeletalMesh(ArmsOnlyMesh);
	HideHeadComponent.SetMaterial(0, HeadAndArmsMIC);
	HideHeadComponent.SetLODParent(mesh);
	HideHeadComponent.SetParentAnimComponent(mesh);
	HideHeadComponent.SetShadowParent(mesh);

	// if(WorldInfo.NetMode != NM_DedicatedServer)
	// {
	// 	HeadAndArmsMIC.SetTextureParameterValue(HitMaskParamName, HitMaskRenderTargetHeadArms);
	// }
	
	if ( LowerBodyMesh != none)
	{		
		//LowerBodyMesh.SetSkeletalMesh(SkeletalMesh'CHR_VN_Common.Mesh_REF.US_Master_REF');
		LowerBodyMesh.SetSkeletalMesh(CompositedLegs);
    		LowerBodyMesh.SetActorCollision(false, false);
   		LowerBodyMesh.SetNotifyRigidBodyCollision(false);
    		LowerBodyMesh.SetTraceBlocking(true, true);
    		LowerBodyMesh.SetParentAnimComponent(mesh);
		LowerBodyMesh.SetShadowParent(mesh);
		LowerBodyMesh.SetHidden(true);
    		LowerBodyMesh.SetMaterial(0, BodyMIC);
		
		/*if (CompositedLegs.Materials[1] != none)
		{
			LowerBodyMesh.SetMaterial(1, GearMIC);
		}*/
	}


	// Attach headgear
	if( HeadgearMesh != none )
	{
		AttachNewHeadgear(HeadgearMesh);
	}

	// Attach face item
	if( FaceItemMesh != none )
	{
		AttachNewFaceItem(FaceItemMesh);
	}

	// Attach facial hair
	if( FacialHairMesh != none )
	{
		AttachNewFacialHair(FacialHairMesh);
	}

	// Attach cloth if there is any
	if ( ClothComponent != None )
	{
		ClothComponent.SetParentAnimComponent(mesh);
		ClothComponent.SetShadowParent(mesh);
		AttachComponent(ClothComponent);
		ClothComponent.SetEnableClothSimulation(true);
		ClothComponent.SetAttachClothVertsToBaseBody(true);
	}

	// Set first person arms mesh
	if ( ArmsMesh != None )
	{
		ArmsMesh.SetSkeletalMesh(ArmsOnlyMeshFP);

		if( FPArmsSkinMaterial != none )
			ArmsMesh.SetMaterial(0, FPArmsSkinMaterial);

		if( FPArmsSleeveMaterial != none )
			ArmsMesh.SetMaterial(1, FPArmsSleeveMaterial);
	}

	// Set first person bandage
	if ( BandageMesh != none )
	{
		BandageMesh.SetSkeletalMesh(BandageMeshFP);
		BandageMesh.SetHidden(true);
	}

	// Set first and third person trap disarm tool
	if ( ROMI != none )
	{
		// First Person
		if ( TrapDisarmToolMesh != none )
		{
			TrapDisarmToolMesh.SetSkeletalMesh(GetTrapDisarmToolMesh(true));
		}

		// Third Person
		if ( TrapDisarmToolMeshTP != none )
		{
			TrapDisarmToolMeshTP.SetSkeletalMesh(GetTrapDisarmToolMesh(false));
		}
	}

	if ( TrapDisarmToolMesh != none )
	{
		TrapDisarmToolMesh.SetHidden(true);
	}

	if ( TrapDisarmToolMeshTP != none )
	{
		Mesh.AttachComponentToSocket(TrapDisarmToolMeshTP, GrenadeSocket);
		TrapDisarmToolMeshTP.SetHidden(true);
	}

	ROPRI = ROPlayerReplicationInfo(PlayerReplicationInfo);

	if( ROPRI != none )
		HonourPct = FClamp(ROPRI.HonorLevel / 100.f, 0.0, 1.0);

	// PAX Build, to randomise grime when everyone's level 0
	//HonourPct = FRand();

	// Pilots should not be very dirty since they're not running around on the ground!
	if( bIsPilot )
		HonourPct *= 0.5;

	if( PawnHandlerClass != none )
	{
		// Apply a wear level to our head and tunic as appropriate for our current honour level
		BodyMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicGrimeParam, HonourPct);
		BodyMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicMudParam, HonourPct * 5.0);
		HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadGrimeParam, HonourPct);
		HeadAndArmsMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadMudParam, HonourPct * 5.0);

		if( GearMIC != none && GearMat != none )
		{
			GearMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicGrimeParam, HonourPct);
			GearMIC.SetScalarParameterValue(PawnHandlerClass.default.TunicMudParam, HonourPct * 5.0);
		}

		if( HeadgearMIC != none )
		{
			HeadgearMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadGrimeParam, HonourPct);
			HeadgearMIC.SetScalarParameterValue(PawnHandlerClass.default.HeadMudParam, HonourPct * 5.0);
		}
	}

	if ( bOverrideLighting )
	{
		ThirdPersonHeadAndArmsMeshComponent.SetLightingChannels(LightingOverride);
		ThirdPersonHeadgearMeshComponent.SetLightingChannels(LightingOverride);
	}

	// Set the server to use the lowest LOD for the mesh
	if ( WorldInfo.NetMode == NM_DedicatedServer )
	{
		mesh.ForcedLODModel = 1000;
		ThirdPersonHeadAndArmsMeshComponent.ForcedLodModel = 1000;
		ThirdPersonHeadgearMeshComponent.ForcedLodModel = 1000;
		FaceItemMeshComponent.ForcedLodModel = 1000;
		FacialHairMeshComponent.ForcedLodModel = 1000;
		LowerBodyMesh.ForcedLodModel = 1000;
	}
}

simulated event BecomeViewTarget( PlayerController PC )
{
	local ROPlayerController ROPC;

	Super.BecomeViewTarget(PC);

	if (LocalPlayer(PC.Player) != None)
	{
		// Hide the first person arms if we're not viewing this pawn in first person
		if(ArmsMesh != none)
		{
			ArmsMesh.SetHidden(!IsFirstPerson());
		}



		//PawnAmbientSound.bAllowSpatialization = false;

		// TODO: Need to handle switching between first/third person sounds here
		//WeaponAmbientSound.bAllowSpatialization = false;

		AttachComponent(ArmsMesh);
		AttachComponent(BandageMesh);
		AttachComponent(TrapDisarmToolMesh);
		AttachComponent(LowerBodyMesh);

		if (LowerBodyMesh != none)
		{
			LowerBodyMesh.SetHidden(IsFirstPerson()); //changed
		}

   		ROPC = ROPlayerController(PC);

		if (ROPC != None)
		{
			SetMeshVisibility(!ROPC.UsingFirstPersonCamera());
		}
		else
		{
			SetMeshVisibility(true);
		}

		bUpdateEyeHeight = true;
	}
}
/* EndViewTarget(PlayerController PC)
	Called by Camera when this actor becomes its ViewTarget */
simulated event EndViewTarget( PlayerController PC )
{
	//PawnAmbientSound.bAllowSpatialization = true;

	// TODO: Need to handle switching between first/third person sounds here
	//WeaponAmbientSound.bAllowSpatialization = true;

	// This should only happen for infantry after ragdoll and HideHead()
	if (LocalPlayer(PC.Player) != None && PC.Pawn != self && DrivenVehicle == none)
	{
 	    	UnHideHead(PC);
		SetMeshVisibility(true);
		DetachComponent(ArmsMesh);
		DetachComponent(BandageMesh);
		DetachComponent(TrapDisarmToolMesh);
		DetachComponent(LowerBodyMesh);
	}
}


simulated function SetLightingChannels(LightingChannelContainer InLightingChannels)
{
	super.SetLightingChannels(InLightingChannels);

	if ( LowerBodyMesh != none )
	{
		LowerBodyMesh.SetLightingChannels(InLightingChannels);
	}
}



simulated function ROBleedingDecalEffectGORERightHand(GoreLimbInfo Limb) 
{
    if(dripcount < 12)
    {
    	ROGoreBleedingDecal(Gore_RightHand);
        dripcount++;
    }
    else
    {
        ClearTimer('ROBleedingDecalEffectGORERightHand');
        dripcount = 0;
    }
}

simulated function ROBleedingDecalEffectGORELeftHand(GoreLimbInfo Limb) 
{
    if(dripcount < 12)
    {
    	ROGoreBleedingDecal(Gore_LeftHand);
        dripcount++;
    }
    else
    {
        ClearTimer('ROBleedingDecalEffectGORELeftHand');
        dripcount = 0;
    }
}

simulated function ROBleedingDecalEffectGORERightLeg(GoreLimbInfo Limb) 
{
    if (dripcount < 12)
    {
    	ROGoreBleedingDecal(Gore_RightLeg);
        dripcount++;
    }
    else
    {
        ClearTimer('ROBleedingDecalEffectGORERightLeg');
        dripcount = 0;
    }
}

simulated function ROBleedingDecalEffectGORELeftLeg(GoreLimbInfo Limb)
{
    if (dripcount < 12)
    {
    	ROGoreBleedingDecal(Gore_LeftLeg);
        dripcount++;
    }
    else
    {
        ClearTimer('ROBleedingDecalEffectGORELeftLeg');
        dripcount = 0;
    }
}

simulated function ROBleedingDecalEffectGOREPelvis(GoreLimbInfo Limb) 
{
    if(dripcount < 12)
    {
    	ROGoreBleedingDecal(Gore_Pelvis);
        dripcount++;
    }
    else
    {
        ClearTimer('ROBleedingDecalEffectGOREPelvis');
        dripcount = 0;
    }
}

simulated function ROBleedingDecalEffectGOREHead(GoreLimbInfo Limb) 
{
    if(dripcount < 12)
    {
    	ROGoreBleedingDecal(Gore_Head);
        dripcount++;
    }
    else
    {
        ClearTimer('ROBleedingDecalEffectGOREHead');
        dripcount = 0;
    }
}

simulated function ROGoreBleedingDecal(GoreLimbInfo Limb)
{
	local Actor TraceActor;
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local TraceHitInfo HitInfo;
	local MaterialInstanceTimeVarying MITV;
	local int DecalScaler;

	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	if( class'GameInfo'.default.GoreLevel < 2 )
	{
		if( Limb == Gore_Head )
		{
			TraceStart = Mesh.GetBoneLocation('CHR_Neck', 0);
		}
		else if ( Limb == Gore_Pelvis)
		{
			TraceStart = Mesh.GetBoneLocation('CHR_Stomach', 0);
		}
		else if ( Limb == Gore_LeftLeg)
		{
			TraceStart = Mesh.GetBoneLocation('CHR_LCalf', 0);
		}
		else if ( Limb == Gore_RightLeg)
		{
			TraceStart = Mesh.GetBoneLocation('CHR_Rcalf', 0);
		}
		else if ( Limb == Gore_LeftHand)
		{
			TraceStart = Mesh.GetBoneLocation('CHR_LArmWrist', 0);
		}
		else if ( Limb == Gore_RightHand)
		{
			TraceStart = Mesh.GetBoneLocation('CHR_RArmWrist', 0);
		}

		TraceDest =  TraceStart + vect(0,0,-128);
		TraceActor = Trace( out_HitLocation, out_HitNormal, TraceDest, TraceStart, false,, HitInfo, TRACEFLAG_PhysicsVolumes );

		if (TraceActor != None && Pawn(TraceActor) == None)
		{
			MITV = new(Outer) class'MaterialInstanceTimeVarying';
			MITV.SetParent( default.BloodDripDecalMaterials[ Rand(BloodDripDecalMaterials.Length) ] );

			DecalScaler = Rand(3);
			WorldInfo.MyDecalManager.SpawnDecal(
				MITV,
				out_HitLocation, rotator(-out_HitNormal),
				24.0f + DecalScaler, 24.0f + DecalScaler, 50,
				false, FRand() * 360.f, HitInfo.HitComponent, true, false,
				HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex,
				RagdollLifespan * FXLifetimeMultiplier);
		}
	}
}


simulated function ROLeaveABloodDripDecal()
{
	local Actor TraceActor;
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local TraceHitInfo HitInfo;
	local MaterialInstanceTimeVarying MITV;
	local int DecalScaler;

	if( WorldInfo.NetMode == NM_DedicatedServer )
	{
		return;
	}

	if( class'GameInfo'.default.GoreLevel < 2 )
	{
		TraceStart = Mesh.GetBoneLocation(GetHitZoneBoneName(LastTakeHitInfo.HitBone));
		TraceDest =  TraceStart + vect(0,0,-128);

		TraceActor = Trace( out_HitLocation, out_HitNormal, TraceDest, TraceStart, false,, HitInfo, TRACEFLAG_PhysicsVolumes );

		if (TraceActor != None && Pawn(TraceActor) == None)
		{
			MITV = new(Outer) class'MaterialInstanceTimeVarying';
			MITV.SetParent( default.BloodDripDecalMaterials[ Rand(BloodDripDecalMaterials.Length) ] );

			DecalScaler = Rand(3);
			WorldInfo.MyDecalManager.SpawnDecal(
				MITV,
				out_HitLocation, rotator(-out_HitNormal),
				24.0f + DecalScaler, 24.0f + DecalScaler, 50,
				false, FRand() * 360.f, HitInfo.HitComponent, true, false,
				HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex,
				RagdollLifespan * FXLifetimeMultiplier);
		}
	}
}

simulated function ApplyGeneralizedGore(GoreType InGoreType, class<RODamageType> InDamageType, vector InDamageOrigin, vector InHitLocation)
{
	local int LimbIndex;
	local array<GoreLimbInfo> DismemberedLimbs;
	local GoreLimbInfo CurrentLimb;
	local int NumLimbsToDismember;
	local ROGib Gib;
	local vector DamageNormal, GibMomentum;

	DamageNormal = normal(InDamageOrigin - InHitLocation);
	GibMomentum = DamageNormal * InDamageType.default.RadialDamageImpulse;

	
	if( InGoreType == GT_LowDismemberment )
	{
		
		NumLimbsToDismember = 1;

		if( NumLimbsToDismember > 0 )
		{
			
			GetClosestGoreLimbs(NumLimbsToDismember, InDamageOrigin,
				DismemberedLimbs, false, false);
		}

				// Apply a blood overlay to the head
		LeaveBloodOverlay(Gore_Head, 0.25);
		
		DoBloodSplash(InHitLocation);

		
		SetTimer(BloodPoolSpawnDelay,false,'LeaveABloodPoolDecal');
	}
	
	else if( InGoreType == GT_MediumDismemberment )
	{
		
		NumLimbsToDismember = 2 + rand(2);

		
		GetClosestGoreLimbs(NumLimbsToDismember, InDamageOrigin,
			DismemberedLimbs, false, false);

		
		// Apply a blood overlay to the head
		LeaveBloodOverlay(Gore_Head, 0.5);

		
		DoBloodSplash(InHitLocation);
		

		
		SetTimer(BloodPoolSpawnDelay,false,'LeaveABloodPoolDecal');

	}
	
	else if( InGoreType == GT_SevereDismemberment )
	{
		
		NumLimbsToDismember = 3 + rand(3);

		
		GetClosestGoreLimbs(NumLimbsToDismember, InDamageOrigin,
			DismemberedLimbs, true, false);

		
				// Apply a blood overlay to the head
		LeaveBloodOverlay(Gore_Head, 0.75);

		
		DoBloodSplash(InHitLocation);
		
		
		SetTimer(BloodPoolSpawnDelay,false,'LeaveABloodPoolDecal');


		LeaveAnObliterationDecal(DamageNormal, InHitLocation);
	}
	
	else if( InGoreType == GT_UberGore )
	{
		if( class'GameInfo'.default.GoreLevel < 1 )
		{
	    	
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(BleedingEffectTemplate, mesh, Gore_Head.AttachSocketName, true);
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(BleedingEffectTemplate, mesh, Gore_LeftHand.AttachSocketName, true);
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(BleedingEffectTemplate, mesh, Gore_RightHand.AttachSocketName, true);
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(BleedingEffectTemplate, mesh, Gore_LeftLeg.AttachSocketName, true);
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(BleedingEffectTemplate, mesh, Gore_RightLeg.AttachSocketName, true);

			WorldInfo.MyEmitterPool.SpawnEmitter(ObliterationEffectTemplate, InHitLocation);
			SetTimer(0.15, true, 'ROBleedingDecalEffectGOREHead');
			SetTimer(0.15, true, 'ROBleedingDecalEffectGORELeftLeg');
			SetTimer(0.15, true, 'ROBleedingDecalEffectGORERightLeg');
			SetTimer(0.15, true, 'ROBleedingDecalEffectGORELeftHand');
			SetTimer(0.15, true, 'ROBleedingDecalEffectGORERightHand');
			
			ROSkeletalMeshComponent(mesh).ReplaceSkeletalMesh(UberGoreMesh);
			
			mesh.SetPhysicsAsset(PhysicsAsset'VN_UI_Textures_Four.Phy.Fubar_Physasset');

			mesh.SetMaterial(0, GoreMIC);
			
			mesh.DetachComponent(ThirdPersonHeadgearMeshComponent);
		    

			if( FaceItemMeshComponent != none )
				mesh.DetachComponent(FaceItemMeshComponent);

			if( FacialHairMeshComponent != none )
				mesh.DetachComponent(FacialHairMeshComponent);

			DetachComponent(ThirdPersonHeadAndArmsMeshComponent);


			if( mesh != none)
			{
				mesh.DetachComponent(Gore_Head.AttachChunk);
				mesh.DetachComponent(Gore_LeftHand.AttachChunk);
				mesh.DetachComponent(Gore_RightHand.AttachChunk);
				mesh.DetachComponent(Gore_LeftLeg.AttachChunk);
				mesh.DetachComponent(Gore_RightLeg.AttachChunk);
			}

			
		}

		GoSilence();
		
		LeaveAnObliterationDecal(DamageNormal, InHitLocation);

		SetTimer(BloodPoolSpawnDelay,false,'LeaveABloodPoolDecal');
	}
	
	else if( InGoreType == GT_Obliteration )
	{
		if( class'GameInfo'.default.GoreLevel < 1 )
		{
			
			Gib = SpawnGib(Gore_LeftHand.GibClass, Gore_LeftHand.ShrinkBones[0], InDamageType, InHitLocation, GibMomentum, false);
			if( Gib != none ) Gib.GibMeshComp.SetMaterial(0, GoreMIC);
			Gib = SpawnGib(Gore_RightHand.GibClass, Gore_RightHand.ShrinkBones[0], InDamageType, InHitLocation, GibMomentum, false);
			if( Gib != none ) Gib.GibMeshComp.SetMaterial(0, GoreMIC);

			if(FRand() < 0.33)
			{
				Gib = SpawnGib(Gore_LeftLeg.GibClass, Gore_LeftLeg.ShrinkBones[0], InDamageType, InHitLocation, GibMomentum, false);
				if( Gib != none ) Gib.GibMeshComp.SetMaterial(0, GoreMIC);
				Gib = SpawnGib(Gore_RightLeg.GibClass, Gore_RightLeg.ShrinkBones[0], InDamageType, InHitLocation, GibMomentum, false);
				if( Gib != none ) Gib.GibMeshComp.SetMaterial(0, GoreMIC);
			}

			WorldInfo.MyEmitterPool.SpawnEmitter(ObliterationEffectTemplate, InHitLocation);
			SetHidden(true);
			mesh.CastShadow=False;
			bSpawnGibs=false; 
		}
		GoSilence();
		
		LeaveAnObliterationDecal(DamageNormal, InHitLocation);
	}

	
	for( LimbIndex=0; LimbIndex<DismemberedLimbs.length; LimbIndex++ )
	{
		CurrentLimb = DismemberedLimbs[LimbIndex];
		DismemberLimb(CurrentLimb, InDamageType, InHitLocation, GibMomentum);
	}
}

simulated function GoSilence()
{
	ClearTimer('PlayQueuedSpeakLine');

	if ( DialogAkComp != none )
	{
		DetachComponent(DialogAkComp);
	}

	if ( HeavyBreathingComp != none )
	{
		DetachComponent(HeavyBreathingComp);
	}
}

simulated function HideHead(PlayerController LocalPC)
{
	super.HideHead(LocalPC);


	// Headgear
	ThirdPersonHeadgearMeshComponent.bCastHiddenShadow=true;
	ThirdPersonHeadgearMeshComponent.CastShadow=true;
	AttachComponent(HideHeadComponent);

	// Head and Arms
	ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(HeadAndArmsMesh);
	ThirdPersonHeadAndArmsMeshComponent.SetHidden(true);
	ThirdPersonHeadAndArmsMeshComponent.bCastHiddenShadow=true;
	ThirdPersonHeadAndArmsMeshComponent.CastShadow=true;

	// Face Items
	FaceItemMeshComponent.bCastHiddenShadow=true;
	FaceItemMeshComponent.CastShadow=true;

	// Facial Hair
	FacialHairMeshComponent.bCastHiddenShadow=true;
	FacialHairMeshComponent.CastShadow=true;
}

simulated function UnHideHead(PlayerController LocalPC)
{
	local ROPlayerController ROPC;

	ROPC = ROPlayerController(LocalPC);
	if ( ROPC != None )
	{
		ROPC.RestoreWorldNearClippingPlane();
	}
	DetachComponent(HideHeadComponent);

	// Headgear
	ThirdPersonHeadgearMeshComponent.SetHidden(false);
	ThirdPersonHeadgearMeshComponent.bCastHiddenShadow=true;
	ThirdPersonHeadgearMeshComponent.CastShadow=true;


	// Head and Arms
	ThirdPersonHeadAndArmsMeshComponent.SetSkeletalMesh(HeadAndArmsMesh);
	ThirdPersonHeadAndArmsMeshComponent.SetHidden(false);
	ThirdPersonHeadAndArmsMeshComponent.bCastHiddenShadow=true;
	ThirdPersonHeadAndArmsMeshComponent.CastShadow=true;

	// Face Items
	FaceItemMeshComponent.SetHidden(false);
	FaceItemMeshComponent.bCastHiddenShadow=true;
	FaceItemMeshComponent.CastShadow=true;

	// Facial Hair
	FaceItemMeshComponent.SetHidden(false);
	FacialHairMeshComponent.bCastHiddenShadow=true;
	FacialHairMeshComponent.CastShadow=true;

}

simulated function PlayBloodWater()
{
	local vector WaterWorldLocation;

	WaterWorldLocation = Location;
	WaterWorldLocation.Z -= (GetCollisionHeight() - WadingDepth);
	UpdateComponentWorldLocation(BloodyWaterComp, WaterWorldLocation);
	if (!BloodyWaterComp.bIsActive)
	{
		BloodyWaterComp.ActivateSystem();
	}
}

simulated function SetWeaponAttachmentVisibility(bool bAttachmentVisible)
{
	super.SetWeaponAttachmentVisibility(bAttachmentVisible);

	WeaponShadow();
}
simulated function WeaponAttachmentChanged()
{
	Super.WeaponAttachmentChanged();

	WeaponShadow();
}
simulated function EnableRightHandIK(optional bool bEnable=true, float BlendInTime=0.0f)
{
	if( HandsEffectorSet != none )
	{
		HandsEffectorSet.RightHand.EnableHandIK = bEnable;
	}
}

simulated function EnableLeftHandIK(optional bool bEnable=true, float BlendInTime=0.0f)
{
	if( HandsEffectorSet != none )
	{
		HandsEffectorSet.LeftHand.EnableHandIK = bEnable;
	}
}


simulated function SetLightEnvironment(LightEnvironmentComponent InLightEnvironment)
{
	super.SetLightEnvironment(InLightEnvironment);
	if ( LowerBodyMesh != none )
	{
		LowerBodyMesh.SetLightEnvironment(InLightEnvironment);
	}

}

simulated function WeaponShadow()
{
	if (CurrentWeaponAttachment != none)
	{
		CurrentWeaponAttachment.Mesh.bCastHiddenShadow = true;
		CurrentWeaponAttachment.Mesh.bCastDynamicShadow = true;
		CurrentWeaponAttachment.Mesh.bNoSkeletonUpdate = false;
		CurrentWeaponAttachment.Mesh.ForceSkelUpdate();
		CurrentWeaponAttachment.Mesh.AnimatingIntoView(0.0f);
		//CurrentWeaponAttachment.SetTickIsDisabled(false);
		CurrentWeaponAttachment.Mesh.bUpdateSkelWhenNotRendered = true;
		CurrentWeaponAttachment.Mesh.bIgnoreControllersWhenNotRendered = false;
		CurrentWeaponAttachment.Mesh.SetForceRefPose(FALSE);
		CurrentWeaponAttachment.ClearTimer('CheckToForceRefPose');
		//Mesh.SetAnimTreeTemplate(Mesh.default.AnimTreeTemplate);
	}

	if (CurrentWeaponAttachmentClass != none)
	{
		SetHandsIKProfile(CurrentWeaponAttachmentClass.default.IKProfileName);
	}
}
defaultproperties
{
	
    Begin Object class=ROSkeletalMeshComponent name=DeadGuy0
        LightEnvironment = MyLightEnvironment
        bUpdateSkelWhenNotRendered=false
        bNoSkeletonUpdate=true
        CastShadow=FALSE
        MaxDrawDistance=2500    // 50m
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    End Object
    HideHeadComponent=DeadGuy0

   // LowerBodyMesh
	Begin Object class=ROSkeletalMeshComponent name=LowerBodyMesh0
		SkeletalMesh=SkeletalMesh'CHR_Playeranim_Master.HumanIK.CHR_HUMANIK_MASTER_RIG'
		AnimTreeTemplate=AnimTree'CHR_VN_Playeranimtree_Master.CHR_Player_animtree'
		//MorphSets(0)=MorphTargetSet'Sov_Prototype_player.morphs.bodyweight'
		PhysicsAsset=PhysicsAsset'CHR_Playeranim_Master.Phy.CHR_Master_RAGDOLL2_Optimized'
		LightEnvironment = MyLightEnvironment
		HiddenGame=true
		HiddenEditor=true
	End Object
    Components.Add(LowerBodyMesh0)
    LowerBodyMesh=LowerBodyMesh0
}

