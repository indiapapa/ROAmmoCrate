//=============================================================================
// ROVehicleFactory_UH1H_Slick
//=============================================================================
// Vehicle factory for the US UH-1H "Huey Slick" Helicopter
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// -
//=============================================================================
class ROVehicleFactory_UH1H_Slick extends ROTransportVehicleFactory;

var		class<ROVehicle>	USSlickClass;
var		class<ROVehicle>	AusSlickClass;
var		class<ROVehicle>	ARVNSlickClass;
var		class<ROVehicle>	USMCSlickClass;

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
	}

	if( ROMapInfo(WorldInfo.GetMapInfo()) != none )
	{
		if( ROMapInfo(WorldInfo.GetMapInfo()).SouthernForce == SFOR_AusArmy )
			VehicleClass = AusSlickClass;

		else if( ROMapInfo(WorldInfo.GetMapInfo()).SouthernForce == SFOR_ARVN )
			VehicleClass = ARVNSlickClass;

		else if( ROMapInfo(WorldInfo.GetMapInfo()).SouthernForce == SFOR_USMC )
			VehicleClass = USMCSlickClass;
	}

	if( VehicleClass == none )
		VehicleClass = USSlickClass;
}

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_VN_US_UH1H_Slick.Mesh.Slick_Rig_Master'
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	Components.Remove(Sprite)

	Begin Object Name=CollisionCylinder
		CollisionHeight=+125.0
		CollisionRadius=+500.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	USSlickClass=class'ROHeli_UH1H_Slick_US_Content' 
	AusSlickClass=class'ROHeli_UH1H_Slick_Aus_Content'
	ARVNSlickClass=class'ROHeli_UH1H_Slick_ARVN_Content'
	USMCSlickClass=class'ROHeli_UH1H_Slick_USMC_Content'
	DrawScale=1.0

	bTransportHeloFactory=true
}

