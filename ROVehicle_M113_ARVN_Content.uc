//=============================================================================
// ROVehicle_M113_ARN_Content
//=============================================================================
//
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
//
//=============================================================================
class ROVehicle_M113_ARVN_Content extends ROVehicle_M113_US_Content
	placeable;

DefaultProperties
{
	Begin Object Name=ROSVehicleMesh
		//SkeletalMesh=SkeletalMesh'VH_VN_M113_APC_D.Mesh.M113_Rig_Master'
		Materials(0)=MaterialInstanceConstant'VH_VN_M113_APC_D.Materials.MIC_ARVN_M113_Exterior'
	End Object

	DestroyedMaterial=MaterialInstanceConstant'VH_VN_M113.Materials.M_M113_DAM'

	// Driver
	SeatProxies(0)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head6_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_06_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=0,
		PositionIndex=1)}

	// Gunner
	SeatProxies(1)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head7_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_07_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=1,
		PositionIndex=1)}

	// Pax1
	SeatProxies(2)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head8_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_08_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		HeadgearSocket=helmet,
		SeatIndex=2,
		PositionIndex=0)}

	// Pax2
	SeatProxies(3)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head9_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_09_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		HeadgearSocket=helmet,
		SeatIndex=3,
		PositionIndex=0)}

	// Pax3
	SeatProxies(4)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head6_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_06_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		SeatIndex=4,
		PositionIndex=0)}

	// Pax4
	SeatProxies(5)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head7_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_07_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		SeatIndex=5,
		PositionIndex=0)}


}
