//=============================================================================
// ROItem_USPlaceableAmmoCrate
//=============================================================================
// A US version of the placeable Ammo Crate.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games LTD
//============================================================================

class ROItem_USPlaceableAmmoCrate_Ext extends ROItem_PlaceableAmmoCrate_Ext;

DefaultProperties
{
	WeaponContentClass(0)="ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext_Content"
	RoleSelectionImage(0)=Texture2D'VN_UI_Textures_Four.WeaponTex.US_Crate'
	ClassConstructorProxy=class'ROUSAmmoCreateConstructorProxy'
	// Ammo
	AmmoClass=class'ROAmmo_Placeable_AmmoCrate'
	InvIndex=`ROII_Placeable_Ammo
	ROTM_PlacingMessage=ROTMSG_PlaceAmmoCrate
	AmmoCrateClass=class'ROUSPlaceableAmmoResupply_Ext'
	PhysicalAmmoCrateClass=class'ROGame.ROUSPlaceableAmmoResupplyCrate'
}