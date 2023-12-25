//=============================================================================
// ROVehicleFactory_OH6
//=============================================================================
// Vehicle factory for the US OH-6 "Loach" Helicopter
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ROVehicleFactory_OH6_Ext extends ROTransportVehicleFactory;

var		class<ROVehicle>	USLoachClass;
var		class<ROVehicle>	AusLoachClass;

simulated function PostBeginPlay()
{
	local ROGameInfo ROGI;

	super.PostBeginPlay();

	ROGI = ROGameInfo(WorldInfo.Game);

	if( ROGI != none && ROGI.bCampaignGame )
	{
		if( ROGI.bReverseRolesAndSpawns || ROGI.CampaignWarPhase == ROCWP_Early )
		{
			bDisableForCampaign = true;
			return;
		}
		else
			bDisableForCampaign = false;
	}

	if( ROMapInfo(WorldInfo.GetMapInfo()) != none && ROMapInfo(WorldInfo.GetMapInfo()).SouthernForce == SFOR_AusArmy )
		VehicleClass = AusLoachClass;
	else
		VehicleClass = USLoachClass;
}

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_VN_US_OH6.Mesh.US_OH6_Rig_Master'
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	Components.Remove(Sprite)

	Begin Object Name=CollisionCylinder
		CollisionHeight=+100.0
		CollisionRadius=+400.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	USLoachClass=class'ROHeli_OH6_Ext_Content'
	AusLoachClass=class'ROHeli_OH6_Ext_Aus_Content'
	//EnemyVehicleClass=class'ROGameContent.ROVehicle_UC_Content'
	DrawScale=1.0

	bTransportHeloFactory=true
}

