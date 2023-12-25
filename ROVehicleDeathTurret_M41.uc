//=============================================================================
// ROVehicleDeathTurret_T3476
//=============================================================================
// RO Gore system - Blown off turret for T34 76 Tank
//=============================================================================
// RO: Heroes of Stalingrad Source
// Copyright (C) 2007-2010 Tripwire Interactive LLC
// - Sakib Saikia
//=============================================================================
class ROVehicleDeathTurret_M41 extends ROVehicleDeathPiece;

DefaultProperties
{
	GibMeshesData[0]={(TheStaticMesh=StaticMesh'VH_VN_M41.Mesh.M41_Turret',
		TheSkelMesh=SkeletalMesh'VH_VN_M41.Mesh.M41_Turret_Destroyed_Master',
		ThePhysAsset=PhysicsAsset'VH_VN_M41.Phys.M41_Turret_Destroyed_Physics',
		DrawScale=1.0f,
		bUseSecondaryGibMeshMITV=FALSE)}
}
