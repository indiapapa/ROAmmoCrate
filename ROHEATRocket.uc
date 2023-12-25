//=============================================================================
// PG7VRocket
//=============================================================================
// PG7V Rocket for the RPG-7 Rocket Launcher
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ROHEATRocket extends RORocketProjectile;

defaultproperties
{
	bProjectileIsHEAT=True
	bExplodeOnDeflect=True

	BallisticCoefficient=0.15
	ProjExplosionTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_RPG_impactblast'
	WaterExplosionTemplate=ParticleSystem'FX_VN_Impacts.Water.FX_VN_70mm_Water'
	NonPenetrationExplosionTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_RPG_explosion'
	PenetrationExplosionTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_RPG_exitblast'
	// vehicle penetration
	ProjPenetrateTemplate=ParticleSystem'FX_VN_Weapons.Explosions.FX_VN_RPG_explosion'
 	ImpactDamage=600
	Damage=150
	DamageRadius=200	// NOTE: This is the exterior damage radius when a rocket penetrates
	PenetrationDamage=300
	PenetrationDamageRadius=500 // This is the interior damage radius when a rocket penetrates and the exterior damage radius when a rocket does NOT penetrate
	MomentumTransfer=50000
	bCollideWorld=true
	Speed=5750		// 115m/s
	MaxSpeed=14750	// 295m/s
	bUpdateSimulatedPosition=true
	ExplosionSound=AkEvent'WW_WEP_RPG.Play_WEP_RPG_Explode'
	PenetrationSound=none //SoundCue'AUD_EXP_AntiTank_German.Discharge.AntiTank_German_Discharge_Cue'
	bRotationFollowsVelocity=true
	MyDamageType=class'RODmgType_M72Rocket'
	ImpactDamageType=class'RODmgType_M72RocketImpact'
	GeneralDamageType=class'RODmgType_M72RocketGeneral'

	AmbientSound=AkEvent'WW_WEP_RPG.Play_WEP_RPG_Projectile_Loop'


	FueledFlightTime=1.5
	InitialAccelerationTime=0.75//0.25
	GradualSpreadMultiplier=2000//600
	SpreadStartDelay=0.35//0
	RocketIgnitionTime=0.11 // seconds after launch when rocket ignites
	Lifespan=4.5

	ShakeScale=5.0//2.3
	//MaxSuppressBlurDuration=12.0 //4.25
	//SuppressBlurScalar=1.4
	//SuppressAnimationScalar=0.6
	//ExplodeExposureScale=0.3//0.45

	Begin Object Name=CollisionCylinder
		CollisionRadius=4
		CollisionHeight=4
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bIsCharacterLightEnvironment=true
	End Object
	Components.Add(MyLightEnvironment)

	Begin Object Class=StaticMeshComponent Name=ProjectileMesh
		StaticMesh=StaticMesh'WP_VN_3rd_Projectile.Mesh.RPG_Projectile_FinsOut'
		MaxDrawDistance=5000
		CollideActors=true
		CastShadow=false
		LightEnvironment=MyLightEnvironment
		BlockActors=false
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockRigidBody=true
		Scale=1
	End Object
	Components.Add(ProjectileMesh)

	DecalHeight=200
	DecalWidth=200
}
