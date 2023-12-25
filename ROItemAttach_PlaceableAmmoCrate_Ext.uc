//=============================================================================
// ROItemAttach_PlaceableAmmoCrate
//=============================================================================
// 3rd person Item attachment class for Placeable Ammo Crate
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Callum Coombes @ Antimatter Games LTD
//=============================================================================

class ROItemAttach_PlaceableAmmoCrate_Ext extends ROItemAttachPlaceable;

defaultproperties
{
	WeaponClass=class'ROAmmoCrate.ROItem_PlaceableAmmoCrate_Ext'
	WeaponType=ROWT_Binocs

	ThirdPersonHandsAnim=Binoc_Handpose
	
	// Pickup staticmesh
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_VN_3rd_Master.Mesh.PunjiShovel_3rd_Master'// SkeletalMesh'ENV_VN_VC_Supply.Meshes.Crates.SK_Crate_02_Closed'
		PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy_Bounds.PunjiShovel_3rd_Bounds_Physics'// PhysicsAsset'ENV_VN_VC_Supply.Meshes.Crates.SK_Crate_02_Closed_Physics'
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true//false
		BlockRigidBody=true
		bHasPhysicsAssetInstance=false
		bUpdateKinematicBonesFromAnimation=false
		PhysicsWeight=1.0
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
		bSkipAllUpdateWhenPhysicsAsleep=TRUE
		bSyncActorLocationToRootRigidBody=true
	End Object
}
