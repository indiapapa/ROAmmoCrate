//=============================================================================
// ROHWeap_OH6_PurpleSmoke
//=============================================================================
// Purple Smoke Grenades dropped by the Loach's observer. A dropped grenade marks
// an artillery target used by the Commander.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2015 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ROHWeap_OH6_Smoke extends ROHelicopterWeapon
	abstract
	HideDropDown;

// Since we're not throwing this grenade from a proper grenade weapon class, make sure we set the fuse timer on the projectile
simulated function Projectile ProjectileFire()
{
	local Projectile NewProj;

	NewProj = super.ProjectileFire();

	if( NewProj != none && ROThrowableExplosiveProjectile(NewProj) != none )
		ROThrowableExplosiveProjectile(NewProj).FuseLength = 4.5;

	return NewProj;
}

// This is one of those rare occasions we want to use the camera location instead
simulated function bool ShouldFireFromMuzzleLocation()
{
	return false;
}

DefaultProperties
{
	WeaponContentClass(0)="ROAmmoCrate.ROHWeap_OH6_Smoke_Content"
	SeatIndex=2

	// MAIN FIREMODE
	FiringStatesArray(0)=none//WeaponFiring
	WeaponFireTypes(0)=EWFT_Projectile
	WeaponProjectiles(0)=none//class'M8SmokeProjectile_Ext'
	FireInterval(0)=+2.0
	FireCameraAnim(0)=none
	Spread(0)=0.01
	AmmoDisplayNames(0)="SMOKE"

	// AI
	AILongDistanceScale=1.25
	AIMediumDistanceScale=1.1
	AISpreadScale=200.0
	AISpreadNoSeeScale=2.0
	AISpreadNMEStillScale=0.5
	AISpreadNMESprintScale=1.5

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'M8SmokeProjectile_Ext'
	FireInterval(ALTERNATE_FIREMODE)=+2.0
	FireCameraAnim(ALTERNATE_FIREMODE)=none
	Spread(ALTERNATE_FIREMODE)=0.01
	//AmmoDisplayNames(ALTERNATE_FIREMODE)="SMOKE"

	FireTriggerTags=(OH6Smoke)
	AltFireTriggerTags=(OH6Smoke)

	VehicleClass=class'ROHeli_OH6_Ext'

	
	bShowAmmoAsPercentage=false
	

	// Ammo
	MaxAmmoCount=5
	AltAmmoCount=5
	MaxAltAmmoCount=5

	PenetrationDepth=0
	MaxPenetrationTests=0
	MaxNumPenetrations=0
}
