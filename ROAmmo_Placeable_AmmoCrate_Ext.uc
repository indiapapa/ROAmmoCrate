//=============================================================================
// ROAmmo_Placeable_AmmoCrate
//=============================================================================
// Ammo properties for the prototype placeable Ammo Crate
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Callum Coombes @ Antimatter Games LTD
//=============================================================================
class ROAmmo_Placeable_AmmoCrate_Ext extends ROAmmunition
	abstract;

defaultproperties
{
	CompatibleWeaponClasses(1)=class'ROAmmoCrate.ROItem_PlaceableAmmoCrate_Ext'

	InitialAmount=1
	Weight=0.1//2.5
	ClipsPerSlot=1
}
