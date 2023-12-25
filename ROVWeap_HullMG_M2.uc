//=============================================================================
// ROVWeap_APC_HullMG
//=============================================================================
// Content for M113 APC Hull MG weapon class
//=============================================================================
// Red Orchestra: Heroes Of Stalingrad Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery
//=============================================================================

class ROVWeap_HullMG_M2 extends ROVWeap_Transport_HullMG
	abstract
	HideDropDown;

var	bool					bShowAmmoCount;				// For HUD. Whether to display remaining ammo for this weapon
var	bool					bShowAmmoAsPercentage;		// For the HUD. If true, will show remaining ammo as a percentage rather than an exact number
var array<string>			AmmoDisplayNames;			// Short display name for the HUD to identify ammo types. Should be set to something simple enough to not need localisation!

defaultproperties
{
	//WeaponContentClass(0)="ROGameContent.ROVWeap_APC_HullMG_Content"
	WeaponContentClass(0)="ROAmmoCrate.ROVWeap_HullMG_M2_Content" 
	SeatIndex=1
	PlayerIronSightFOV=55 // No real zoom


	// MAIN FIREMODE
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Projectile
	WeaponProjectiles(0)=class'M2Bullet'
	FireInterval(0)=+0.12
	FireCameraAnim(0)=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
	Spread(0)=0.00025
	

	// AI
	AILongDistanceScale=1.25
	AIMediumDistanceScale=1.1
	AISpreadScale=200.0
	AISpreadNoSeeScale=2.0
	AISpreadNMEStillScale=0.5
	AISpreadNMESprintScale=1.5

	// ALT FIREMODE
	FiringStatesArray(ALTERNATE_FIREMODE)=WeaponSingleFiring
	WeaponFireTypes(ALTERNATE_FIREMODE)=EWFT_Projectile
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'M2Bullet'
	FireInterval(ALTERNATE_FIREMODE)=+0.075D
	FireCameraAnim(ALTERNATE_FIREMODE)=CameraAnim'1stperson_Cameras.Anim.Camera_MG34_Shoot'
	Spread(ALTERNATE_FIREMODE)=0.0007

	

	FireTriggerTags=(HTHullMG)
	AltFireTriggerTags=(HTHullMG)

	VehicleClass=class'ROVehicle_M113_APC_D'

	// Tracers
	TracerClass=class'M2BulletTracer'
	TracerFrequency=5

//	bRecommendSplashDamage=true
//	bInstantHit=false
//
//	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
//		Samples(0)=(LeftAmplitude=50,RightAmplitude=80,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.200)
//	End Object
//	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

	// Ammo
	AmmoClass=class'ROAmmo_127x99_M2Belt_APC'
	MaxAmmoCount=550
	bUsesMagazines=true
	InitialNumPrimaryMags=1
	AmmoDisplayNames(0)="M2HMG"
	bShowAmmoCount=true
	// Shell eject FX
	ShellEjectSocket=MG_ShellEject
	ShellEjectPSCTemplate=ParticleSystem'VH_VN_M113_APC_D.ShellEjects.FX_Wep_ShellEject_USA_M2'

	PenetrationDepth=23.5
	MaxPenetrationTests=3
	MaxNumPenetrations=2
}
