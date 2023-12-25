//=============================================================================
// ROHeli_AH1G_Content
//=============================================================================
// Content for the AH-1G Cobra Gunship Helicopter
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ROHeli_AH1G_USMC_Content extends ROHeli_AH1G_Content
	placeable;

DefaultProperties
{
	// ------------------------------- mesh --------------------------------------------------------------

	Begin Object Name=ROSVehicleMesh
		//SkeletalMesh=SkeletalMesh'VH_VN_US_AH1G.Mesh.US_AH1G_Rig_Master'
		Materials(3)=MaterialInstanceConstant'VH_VN_US_AH1G_USMC.Materials.M_AH1G_USMC_Mic'
	End Object
	DestroyedMaterial=MaterialInstanceConstant'VH_VN_US_AH1G_USMC.Materials.M_AH1G_USMC_WRECK'
	// Pilot
	SeatProxies(0)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head3_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_03_Pilot_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=0,
		PositionIndex=0)}

	// Copilot
	SeatProxies(1)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head3_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Pilot_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=1,
		PositionIndex=0)}

	
}
