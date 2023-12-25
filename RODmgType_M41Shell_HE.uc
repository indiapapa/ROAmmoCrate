//=============================================================================
// RODmgType_M41Shell_HE
//=============================================================================
// Damage type for M41 HE Shell Explosions
//=============================================================================
// RO2: Heroes of Stalingrad Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class RODmgType_M41Shell_HE extends RODamageType_CannonShell_HE
	abstract;

defaultproperties
{
	WeaponShortName="M41 Cannon"
	VehicleDamageScaling=0.15
	RadialDamageImpulse=2000
}
