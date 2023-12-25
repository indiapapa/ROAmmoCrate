//=============================================================================
// ROPlaceableAmmoResupply
//=============================================================================
// A volume to resupply volume placed by players
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Callum Coombes @ Antimatter Games
//=============================================================================

class ROPlaceableAmmoResupply_Ext extends ROPlaceableAmmoResupply;

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy

	PhysicalAmmoCrateClass=class'ROGame.ROVCPlaceableAmmoResupplyCrate'

	bCollideActors=true
	CollisionType=COLLIDE_TouchAll
	bProjTarget=true
	bWorldGeometry=false
	bCollideWorld=false

	bStatic=false
	bNoDelete=false
	bHidden=false

	UpdateTime=60.0	// Try to keep this the same as ROWeapon.MagResupplyCooldown for best results

	RemainingResupplyPoints=15
	PointAccum=0
}
