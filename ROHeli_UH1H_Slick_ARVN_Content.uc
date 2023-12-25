//=============================================================================
// ROHeli_UH1H_ARVN_Slick_Content
//=============================================================================
// Content for the UH-1H Iroquois "Huey Slick" Transport Helicopter, ARVN paintjob
//=============================================================================
// DirtyGrandpa
//=============================================================================
class ROHeli_UH1H_Slick_ARVN_Content extends ROHeli_UH1H_Slick_US_Content
	placeable;

DefaultProperties
{
	Begin Object Name=ROSVehicleMesh
		//SkeletalMesh=SkeletalMesh'VH_VN_US_UH1H.Mesh.US_UH1H_Rig_Master'
		Materials(0)=MaterialInstanceConstant'VH_VN_ARVN_UH1H.Materials.M_ARVN_UH1H_Huey'
	End Object

	DestroyedMaterial=MaterialInstanceConstant'VH_VN_ARVN_UH1H.Materials.M_ARVN_Huey_WRECK'

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
	SeatProxies(8)={(
		TunicMeshType=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh',
		HeadGearMeshType=SkeletalMesh'CHR_VN_ARVN_Headgear.Mesh.ARVN_Headgear_M1Cover',
		HeadAndArmsMeshType=SkeletalMesh'CHR_VN_ARVN_Heads.Mesh.ARVN_Head9_Mesh',
		HeadphonesMeshType=none,
		HeadAndArmsMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN_Heads.Materials.M_ARVN_Head_09_Long_INST',
		BodyMICTemplate=MaterialInstanceConstant'CHR_VN_ARVN.Materials.M_ARVN_Tunic_Long_INST',
		SeatIndex=8,
		PositionIndex=0,
		bExposedToRain=false)}

}
