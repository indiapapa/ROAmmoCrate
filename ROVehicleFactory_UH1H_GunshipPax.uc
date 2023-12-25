//=============================================================================
// ROVehicleFactory_UH1H_Gunship Bushranger with passengers
//=============================================================================
// Vehicle factory for the UH-1H "Huey" Gunship Helicopter
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ROVehicleFactory_UH1H_GunshipPax extends ROTransportVehicleFactory;

var		class<ROVehicle>	USGunsClass;
var		class<ROVehicle>	AusGunsClass;
var		class<ROVehicle>	ARVNGunsClass;
var		class<ROVehicle>	CampaignAusVehicleClass;
var		class<ROVehicle>	CampaignNonAusVehicleClass;

simulated function PostBeginPlay()
{
	local ROGameInfo ROGI;

	super.PostBeginPlay();

	ROGI = ROGameInfo(WorldInfo.Game);

	if( ROGI != none && ROGI.bCampaignGame )
	{
		if( ROGI.bReverseRolesAndSpawns )
		{
			bDisableForCampaign = true;
			return;
		}

	if( WorldInfo.NetMode != NM_Standalone )
		VehicleClass = (ROGI.CurrentSouthernFaction == SFOR_AusArmy) ? CampaignAusVehicleClass : CampaignNonAusVehicleClass;

		if( ROGI.CampaignWarPhase == ROCWP_Early )
			bDisableForCampaign = true;
		else
			bDisableForCampaign = false;
	}
	else
		bDisableForCampaign = false;

	if( ROMapInfo(WorldInfo.GetMapInfo()) != none )
	{
		if( ROMapInfo(WorldInfo.GetMapInfo()).SouthernForce == SFOR_AusArmy )
			VehicleClass = AusGunsClass;
		else if( ROMapInfo(WorldInfo.GetMapInfo()).SouthernForce == SFOR_ARVN )
			VehicleClass = ARVNGunsClass;
	}

	if( VehicleClass == none )
		VehicleClass = USGunsClass;
}

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_VN_AUS_Bushranger_pax.Mesh.Gunz_Rig_Master'
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object
	
	//Components.Remove(Sprite)	

	Begin Object Name=CollisionCylinder
		CollisionHeight=+125.0
		CollisionRadius=+500.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object	

	USGunsClass=class'ROGameContent.ROHeli_AH1G_Content' // No UH-1B or C available
	AusGunsClass=class'ROHeli_UH1H_Gunspax_Aus_Content' // Bushranger with pax option, single M60s
	ARVNGunsClass=class'ROHeli_UH1H_ARVN_Guns_Content' // Gunship ARVN with pax, only gunpods and single M60s
	// For campaign
	CampaignNonAusVehicleClass=class'ROGameContent.ROHeli_AH1G_Content'
	CampaignAusVehicleClass=class'ROHeli_UH1H_Gunspax_Aus_Content'
	DrawScale=1.0
	bTransportHeloFactory=true
	
}

