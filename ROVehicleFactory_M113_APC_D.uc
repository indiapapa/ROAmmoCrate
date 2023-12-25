//=============================================================================
// ROVehicleFactory_M113_APC 
//=============================================================================
// Vehicle factory for the M113 APC
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class ROVehicleFactory_M113_APC_D extends ROTransportVehicleFactory;

var		class<ROVehicle>	USM113Class;
var		class<ROVehicle>	AUSM113Class;
var		class<ROVehicle>	ARVNM113Class;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if( ROMapInfo(WorldInfo.GetMapInfo()) != none )
	{
		if( ROMapInfo(WorldInfo.GetMapInfo()).SouthernForce == SFOR_AusArmy )
			VehicleClass = AUSM113Class;
		else if( ROMapInfo(WorldInfo.GetMapInfo()).SouthernForce == SFOR_ARVN )
			VehicleClass = ARVNM113Class;
	}

	if( VehicleClass == none )
		VehicleClass = USM113Class;
}

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_VN_M113_APC_D.Mesh.M113_Rig_Master'
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	//Components.Remove(Sprite)

	Begin Object Name=CollisionCylinder
		CollisionHeight=+60.0
		CollisionRadius=+260.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	USM113Class=class'ROVehicle_M113_US_Content' //ROVehicleFactory_M113_APC_D
	AUSM113Class=class'ROVehicle_M113_US_Content'
	ARVNM113Class=class'ROVehicle_M113_ARVN_Content'
	EnemyVehicleClass=class'ROVehicle_M113_US_Content'
	DrawScale=1.0
	bTransportHeloFactory=false
}

