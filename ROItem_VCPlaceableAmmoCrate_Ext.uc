//=============================================================================
// ROItem_VCPlaceableAmmoCrate
//=============================================================================
// A VC version of the placeable Ammo Crate.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games LTD
//============================================================================

class ROItem_VCPlaceableAmmoCrate_Ext extends ROItem_PlaceableAmmoCrate_Ext;

DefaultProperties
{
	WeaponContentClass(0)="ROAmmoCrate.ROItem_VCPlaceableAmmoCrate_Ext_Content"
	RoleSelectionImage(0)=Texture2D'VN_UI_Textures_Four.WeaponTex.VC_Crate'
	ClassConstructorProxy=class'ROVCAmmoCreateConstructorProxy'
	// Ammo
	AmmoClass=class'ROAmmo_Placeable_AmmoCrate'
	InvIndex=`ROII_Placeable_Ammo
	ROTM_PlacingMessage=ROTMSG_PlaceAmmoCrate
	AmmoCrateClass=class'ROVCPlaceableAmmoResupply_Ext'
	PhysicalAmmoCrateClass=class'ROGame.ROVCPlaceableAmmoResupplyCrate'
}