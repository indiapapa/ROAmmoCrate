//=============================================================================
// ROVehicleFactory_M113_APC 
//=============================================================================
// Vehicle factory for the M113 APC
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class ROVehicleFactory_M41 extends ROVehicleFactory;

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_VN_M41.Mesh.M41_Rig_Master'
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	//Components.Remove(Sprite)

	Begin Object Name=CollisionCylinder
		CollisionHeight=+60.0
		CollisionRadius=+100.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	VehicleClass=class'ROVehicle_M41_Content'
	//EnemyVehicleClass=class'ROVehicleFactory_M41.ROVehicle_M41_Content'
	DrawScale=1.0
	
	
}

