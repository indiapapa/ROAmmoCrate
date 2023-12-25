//=============================================================================
// ROSouthPawnPilot
//=============================================================================
// VN player character for the Southern forces pilot
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2016 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ROSouthPawnPilot_Ext extends ROSouthPawn_Ext;

DefaultProperties
{
	bIsPilot=true

	// Meshes
	TunicMesh=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh'
	FieldgearMesh=SkeletalMesh'CHR_VN_US_Army.GearMesh.US_Gear_Pilot'
	// Single-variant mesh
	PawnMesh_SV=SkeletalMesh'CHR_VN_US_Army.Mesh_Low.US_Tunic_Pilot_Low_Mesh'
	// First person arms mesh
	ArmsOnlyMeshFP=SkeletalMesh'CHR_VN_1stP_Hands_Master.Mesh.VN_1stP_US_Pilot_Mesh'
	HeadgearMesh=SkeletalMesh'CHR_VN_US_Headgear.PilotMesh.US_Headgear_Pilot_Base_Up'

	// Third person sockets
	HeadgearAttachSocket=helmet

	// MIC(s)
	BodyMICTemplate=MaterialInstanceConstant'CHR_VN_US_Army.Materials.M_US_Tunic_Pilot_A_INST'
	HeadgearMICTemplate=MaterialInstanceConstant'CHR_VN_US_Headgear.Materials.M_US_Headgear_Pilot_INST'

	Begin Object name=ThirdPersonHeadgear0
		PhysicsAsset=PhysicsAsset'CHR_VN_Playeranim_Master.Phys.Headgear_Physics_Pilot'
	EndObject
}
