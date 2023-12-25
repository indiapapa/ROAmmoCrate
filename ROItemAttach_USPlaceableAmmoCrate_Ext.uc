//=============================================================================
// ROItemAttach_USPlaceableAmmoCrate
//=============================================================================
// US 3rd person Item attachment class for Placeable Ammo Crate
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games LTD
//=============================================================================

class ROItemAttach_USPlaceableAmmoCrate_Ext extends ROItemAttach_PlaceableAmmoCrate_Ext;

defaultproperties
{
	WeaponClass=class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'
	WeaponType=ROWT_Binocs

	ThirdPersonHandsAnim=Binoc_Handpose
	
	// Pickup staticmesh
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_VN_3rd_Master.Mesh.PunjiShovel_3rd_Master'
		PhysicsAsset=PhysicsAsset'WP_VN_3rd_Master.Phy_Bounds.PunjiShovel_3rd_Bounds_Physics'
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
