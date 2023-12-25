//=============================================================================
// ROHeli_UH1H_USMC_Slick_Content
//=============================================================================
// Content for the UH-1H Iroquois "Huey Slick" Transport Helicopter, Australian paintjob
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ROHeli_UH1H_Slick_USMC_Content extends ROHeli_UH1H_Slick_US_Content
	placeable;

DefaultProperties
{
	Begin Object Name=ROSVehicleMesh
		//SkeletalMesh=SkeletalMesh'VH_VN_US_UH1H_Slick.Mesh.US_UH1H_Rig_Master'
		Materials(0)=MaterialInstanceConstant'VH_VN_US_UH1H_Slick.Materials.M_USMC_UH1H_Huey'
	End Object
	DestroyedMaterial=MaterialInstanceConstant'VH_VN_US_UH1H_Slick.Materials.M_USMC_Huey_UH1H_WRECK'
		// Pilot
	SeatProxies(0)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head2_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_02_Pilot_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=0,
		PositionIndex=0,
		bExposedToRain=false)}

	// Copilot
	SeatProxies(1)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head3_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_03_Pilot_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=1,
		PositionIndex=0,
		bExposedToRain=false)}

	// Crew Chief
	SeatProxies(2)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head1_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Pilot_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=2,
		PositionIndex=0,
		bExposedToRain=true)}

	// Door Gunner
	SeatProxies(3)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head2_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_02_Pilot_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=3,
		PositionIndex=0,
		bExposedToRain=true)}

	// Passenger 1
	SeatProxies(4)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head3_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_USMC_Tunic_Long_INST',
		SeatIndex=4,
		PositionIndex=0,
		bExposedToRain=false)}

	// Passenger 2
	SeatProxies(5)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head3_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_USMC_Tunic_Long_INST',
		SeatIndex=5,
		PositionIndex=0,
		bExposedToRain=false)}

	// Passenger 3
	SeatProxies(6)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head3_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_USMC_Tunic_Long_INST',
		SeatIndex=6,
		PositionIndex=0,
		bExposedToRain=false)}

	// Passenger 4
	SeatProxies(7)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head3_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_USMC_Tunic_Long_INST',
		SeatIndex=7,
		PositionIndex=0,
		bExposedToRain=false)}
	//Passenger 5
	SeatProxies(8)={(
		TunicMeshType=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_US_Headgear.Mesh.US_headgear_var1',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head3_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_01_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_USMC_Tunic_Long_INST',
		SeatIndex=8,
		PositionIndex=0,
		bExposedToRain=false)}

}
