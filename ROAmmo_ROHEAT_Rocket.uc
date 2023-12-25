//=============================================================================
// ROAmmo_ROHEAT_Rocket
//=============================================================================
// Ammo properties for the 899mm x 85mm PG-7V HEAT Rocket used by the RPG-7
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// -
//=============================================================================
class ROAmmo_ROHEAT_Rocket extends ROAmmunition
	abstract;

DefaultProperties
{
	CompatibleWeaponClasses(0)=class'ROWeap_M72_RocketLauncher'

	InitialAmount=1
	Weight=2.2		// kg
	ClipsPerSlot=1
}
