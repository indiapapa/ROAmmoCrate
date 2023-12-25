//=============================================================================
// ROVehicleFactory_T54 
//=============================================================================
// Vehicle factory for the T54
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - n
//=============================================================================
class ROVehicleFactory_T54 extends ROVehicleFactory;

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_VN_NVA_T54.Mesh.T54_Rig_Master'
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	//Components.Remove(Sprite)

	Begin Object Name=CollisionCylinder
		CollisionHeight=+60.0
		CollisionRadius=+150.0
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	
	VehicleClass=class'ROVehicle_T54_Content' //ROVehicleFactory_T54
	//EnemyVehicleClass=class'ROVehicleFactory_T54.ROVehicle_T54_Content'
	DrawScale=1.0
	
	
}

