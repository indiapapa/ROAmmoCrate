//=============================================================================
// RODmgType_RPG7Rocket
//=============================================================================
// Damage Type for the RPG-7 Rocket Launcher
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class RODmgType_M72Rocket extends RODamageType_CannonShell;

/**
* Whether the player should be gored up. Returns the type of gore to apply if true
* @param Damage Damage caused by the last hit
* @param ApplyGoreType is the type of gore to be applied to the pawn
* @param InstigatedBy whoever caused this check
* @return whether or not we should apply gore due to damage
*/
static function bool ShouldApplyGore(int DamageAmount, out GoreType ApplyGoreType, optional int DistFromKillerSq = 999999)
{
	if( Default.bCanObliterate )
	{
		if( DamageAmount > Default.GoreDamageAmount[GT_Obliteration] )
		{
			ApplyGoreType = FRand() < 0.33 ? GT_Obliteration : GT_UberGore;
			return true;
		}
	}

	return super.ShouldApplyGore(DamageAmount, ApplyGoreType, DistFromKillerSq);
}

DefaultProperties
{
	bLocationalHit=false
	WeaponShortName="M72LAW"
	// Boost vehicle damage here so that it doesn't hurt humans as bad
	VehicleDamageScaling=1.0
	AirVehicleDamageScaling=1.0
	KDamageImpulse=450.000000
	KDeathVel=100
	KDeathUpKick=100
	RadialDamageImpulse=250.000000

	bExtraMomentumZ=true
	bCanObliterate=true
	bCanUberGore=true
	bCanDismember=true

	// vaporize with direct hit
	GoreDamageAmount[0]=146
	GoreDamageAmount[1]=135
	GoreDamageAmount[2]=125
	GoreDamageAmount[3]=115
	GoreDamageAmount[4]=100
}
