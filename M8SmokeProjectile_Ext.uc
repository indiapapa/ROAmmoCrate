//=============================================================================
// M18SmokeProjectilePurple
//=============================================================================
// M18 Purple Coloured Signal Smoke Grenade Projectile
// This smoke grenade marks artillery targets if used by the appropriate class
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class M8SmokeProjectile_Ext extends ROSmokeGrenadeProjectile;

simulated function DoExplode()
{
	super.DoExplode();
	//MarkArtyTarget();
}

simulated function MarkArtyTarget()
{
	local ROPlayerReplicationInfo ROPRI;
	local ROPlayerController ROPC;
	local ROAIController ROAIC;

	if( InstigatorController == none )
	{
		return;
	}

	ROPC = ROPlayerController(InstigatorController);
	ROPRI = ROPlayerReplicationInfo(ROPC.PlayerReplicationInfo);

	if( ROPC != none && ROPRI != none && ROPC.GetTeamNum() == `ALLIES_TEAM_INDEX )
	{
		// Commander marks arty directly
		if ( ROPRI.RoleInfo.bIsTeamLeader )
		{
			ROPC.AttemptServerSaveArtilleryRequestPosition(Location, 128 + `MAX_SQUADS);

			// CLBIT-5980
			ROPC.ClientSetArtyMarkStatusBits(0);
		}

		// SL sends a request
		if ( ROPRI.bIsSquadLeader || ROPC.bIsBotCommander )
		{
			ROPC.AttemptServerSaveArtilleryRequestPosition(Location, 128 + ROPRI.SquadIndex);

			// CLBIT-5980
			ROPC.ClientSetArtyMarkStatusBits(0);
		}
	}
	else if (Role == ROLE_Authority)
	{
		ROAIC = ROAIController(InstigatorController);
		ROPRI = ROPlayerReplicationInfo(ROAIC.PlayerReplicationInfo);
		if (ROAIC != none && ROPRI != none)
		{
			ROAIC.AISaveSaveArtilleryRequestPosition(Location, ROPRI.SquadIndex);
		}
	}
}

defaultproperties
{
	TossZ=180
	UnderhandTossZ=150
	AccelRate = 1.0

	//ProjExplosionTemplate=ParticleSystem'FX_VN_Smoke.FX_VN_SignalSmoke_Purple'
	ExplosionDecal=None
 	Damage=0
	DamageRadius=0
	MomentumTransfer=0
	bCollideWorld=true
	Speed=1000//800
	MinSpeed=650
	MaxSpeed=1200//1000
	MinTossSpeed=400
	MaxTossSpeed=600
	bUpdateSimulatedPosition=true
	Bounces=5
	ExplosionSound=AkEvent'WW_WEP_M8_Smoke.Play_EXP_M8_Ignite'
	AmbientSound=AkEvent'WW_WEP_M8_Smoke.Play_EXP_M8_Smoke_Release'
	bWaitForEffects=false
	bRotationFollowsVelocity=false
	MyDamageType=class'RODmgType_M8Smoke'
	bAlwaysRelevant=true
	RemoteRole=ROLE_SimulatedProxy

	//DestroyTimer=30.0
	LifeSpan=35.0 // 5 second fuse + 20 second smoke emit + 10 second disperse time
	SmokeSoundTime=20.0

	Begin Object Name=CollisionCylinder
		CollisionRadius=2
		CollisionHeight=2
		AlwaysLoadOnClient=True
		AlwaysLoadOnServer=True
	End Object
	//Components.Add(CollisionCylinder)

	Begin Object Name=ThowableMeshComponent
		SkeletalMesh=SkeletalMesh'WP_VN_3rd_Projectile.Mesh.M8Smoke_Projectile'
		PhysicsAsset=PhysicsAsset'WP_VN_3rd_Projectile.Phy.M8Smoke_Projectile_3rd_Physics'
	End Object

	Begin Object name=SmokePSC
		Template=ParticleSystem'FX_VN_Smoke.FX_Wep_A_Smoke_Grenade'//ParticleSystem'FX_VN_Smoke.FX_VN_SignalSmoke_Purple_new'
	End Object
}

