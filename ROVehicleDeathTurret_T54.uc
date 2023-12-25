//=============================================================================
// ROVehicleDeathTurret_T3476
//=============================================================================
// RO Gore system - Blown off turret for T34 76 Tank
//=============================================================================
// RO: Heroes of Stalingrad Source
// Copyright (C) 2007-2010 Tripwire Interactive LLC
// - Sakib Saikia
//=============================================================================
class ROVehicleDeathTurret_T54 extends ROVehicleDeathPiece;

DefaultProperties
{
	GibMeshesData[0]={(TheStaticMesh=StaticMesh'VH_VN_NVA_T54.Mesh.T54_Turret',
		TheSkelMesh=SkeletalMesh'VH_VN_NVA_T54.Mesh.T54_Turret_Destroyed_Master',
		ThePhysAsset=PhysicsAsset'VH_VN_NVA_T54.Phys.T54_Turret_Destroyed_Master_Physics',
		DrawScale=1.0f,
		bUseSecondaryGibMeshMITV=FALSE)}
}
