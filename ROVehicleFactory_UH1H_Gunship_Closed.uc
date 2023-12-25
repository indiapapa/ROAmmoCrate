//=============================================================================
// ROVehicleFactory_UH1H_Gunship
//=============================================================================
// Vehicle factory for the UH-1H "Huey" Gunship Helicopter
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ROVehicleFactory_UH1H_Gunship_Closed extends ROVehicleFactory_AH1G;

defaultproperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_VN_AUS_Bushranger_doors.Mesh.Bushranger_Rig_Master'
		Translation=(X=0.0,Y=0.0,Z=0.0)
	End Object

	DrawScale=1.0

	VehicleClass=class'ROHeli_Gunship_Closed_Content' // Bushranger closed doors no pax
}

