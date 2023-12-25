//=============================================================================
// ROHeli_OH6_Aus_Content
//=============================================================================
// Content for the OH-6 Cayuse "Loach" Light Observation Helicopter, Australian paintjob
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ROHeli_OH6_Ext_Aus_Content extends ROHeli_OH6_Ext_Content;

DefaultProperties
{
	Begin Object Name=ROSVehicleMesh
		//SkeletalMesh=SkeletalMesh'VH_VN_US_OH6.Mesh.US_OH6_Rig_Master'
		Materials(4)=MaterialInstanceConstant'VH_VN_AUS_OH6.Materials.M_AUS_OH6'
	End Object

	DestroyedMaterial=MaterialInstanceConstant'VH_VN_AUS_OH6.Materials.M_AUS_OH6_WRECK'

	// Pilot
	SeatProxies(0)={(
		TunicMeshType=SkeletalMesh'CHR_VN_AUS.Mesh.AUS_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_AUS_Headgear.PilotMesh.AUS_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head2_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_02_Pilot_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_AUS.Materials.M_AUS_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=0,
		PositionIndex=0,
		bExposedToRain=true)}

	// Copilot
	SeatProxies(1)={(
		TunicMeshType=SkeletalMesh'CHR_VN_AUS.Mesh.AUS_Tunic_Pilot_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_AUS_Headgear.PilotMesh.AUS_Headgear_Pilot_Base_Up',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head5_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_05_Pilot_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_AUS.Materials.M_AUS_Tunic_Pilot_A_INST',
		HeadgearSocket=helmet,
		SeatIndex=1,
		PositionIndex=0,
		bExposedToRain=true)}

	// Rear Passenger
	SeatProxies(2)={(
		TunicMeshType=SkeletalMesh'CHR_VN_AUS.Mesh.AUS_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_AUS_Headgear.Mesh.AUS_Headgear_GiggleDown',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_US_Heads.Mesh.US_Head3_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_US_Heads.Materials.M_US_Head_03_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_AUS.Materials.M_AUS_Tunic_Long_INST',
		SeatIndex=2,
		PositionIndex=0,
		bExposedToRain=true)}
}
