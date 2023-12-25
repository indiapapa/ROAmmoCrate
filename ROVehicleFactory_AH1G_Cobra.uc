//=============================================================================
// ROVehicleFactory_HueyCobra
//=============================================================================
// Vehicle factory for the US AH-1G "Cobra" Gunship Helicopter
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ROVehicleFactory_AH1G_Cobra extends ROTransportVehicleFactory;

var		class<ROVehicle>	BushrangerClass;
var		class<ROVehicle>	USCobraClass;
var		class<ROVehicle>	USMCCobraClass;

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
			{
			VehicleClass = (ROGI.CurrentSouthernFaction == SFOR_AusArmy) ? BushrangerClass : USCobraClass;
			if (VehicleClass != BushrangerClass)
				
			}
			
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
			VehicleClass = BushrangerClass;

		else if( ROMapInfo(WorldInfo.GetMapInfo()).SouthernForce == SFOR_ARVN )
			VehicleClass = USCobraClass;

		else if( ROMapInfo(WorldInfo.GetMapInfo()).SouthernForce == SFOR_USMC )
			VehicleClass = USMCCobraClass;
	}

	if( VehicleClass == none )
		VehicleClass = USCobraClass;
	
}

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_VN_US_AH1G.Mesh.US_AH1G_Rig_Master'
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	Components.Remove(Sprite)

	Begin Object Name=CollisionCylinder
		CollisionHeight=+125.0
		CollisionRadius=+500.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	DrawScale=1.0
	
	
	// For campaign
	USCobraClass=class'ROGameContent.ROHeli_AH1G_Content'
	BushrangerClass=class'ROGameContent.ROHeli_UH1H_Gunship_Content'
	USMCCobraClass=class'ROHeli_AH1G_USMC_Content'
}
