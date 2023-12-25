class ROPawnHandler_Ext extends ROPawnHandler;

var array<SkeletalMesh> ARVN_LowerBodies;
var array<SkeletalMesh> US_LowerBodies;
var array<SkeletalMesh> USMC_LowerBodies;
var array<SkeletalMesh> AUS_LowerBodies;

var array<SkeletalMesh> USMC_HueLowerBodies;


var array<SkeletalMesh> VC_LowerBodies;
var array<SkeletalMesh> NVA_LowerBodies;

var array<SkeletalMesh> AUS_PilotLowerBodies;
var array<SkeletalMesh> ARVN_PilotLowerBodies;
var array<SkeletalMesh> US_PilotLowerBodies;

static function SkeletalMesh GetLowerBody(int Team,int ArmyIndex,int TunicMeshID,byte bPilot)
{

	local SkeletalMesh ChosenMesh;

	//local WorldInfo WorldInfo;



	//WorldInfo=class'Engine'.static.GetCurrentWorldInfo();

	if( Team == `AXIS_TEAM_INDEX )
	{
		if( ArmyIndex == NFOR_NVA )
			
			{	
			ChosenMesh=default.NVA_LowerBodies[TunicMeshID]; 
			}
			else
			{
			ChosenMesh=default.VC_LowerBodies[TunicMeshID];		
			}
	}	
	else
	{
		// Pilot
		if( bPilot > 0 )
		{
			if( ArmyIndex == SFOR_AusArmy )
			{
			ChosenMesh=default.AUS_PilotLowerBodies[TunicMeshID]; 
			}
			else if( ArmyIndex == SFOR_ARVN )
			{
			ChosenMesh=default.ARVN_PilotLowerBodies[TunicMeshID];
			}
			else if( ArmyIndex == SFOR_USMC )
			{
			ChosenMesh=default.US_PilotLowerBodies[TunicMeshID]; 
			}
			else
			{
			ChosenMesh=default.US_PilotLowerBodies[TunicMeshID]; 
			}
		}
		else
		{
			if( ArmyIndex == SFOR_AusArmy )
			{
			ChosenMesh=default.AUS_LowerBodies[TunicMeshID];
			}
			else if( ArmyIndex == SFOR_ARVN )
			{
			ChosenMesh=default.ARVN_LowerBodies[TunicMeshID];
			}
			else if( ArmyIndex == SFOR_USMC )
			{
			ChosenMesh=default.USMC_LowerBodies[TunicMeshID];
			}
			else
			{
			ChosenMesh=default.US_LowerBodies[TunicMeshID];
			}
		
		}
	}
	return ChosenMesh;


}

defaultproperties
{
	ARVN_LowerBodies(0)=SkeletalMesh'CHR_VN_ARVN.Mesh.ARVN_Tunic_Long_Mesh'
	USMC_LowerBodies(0)=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Long_Mesh'
	AUS_LowerBodies(0)=SkeletalMesh'CHR_VN_AUS.Mesh.AUS_Tunic_Long_Mesh'
	US_LowerBodies(0)=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Rolled_Mesh'
	AUS_PilotLowerBodies(0)=SkeletalMesh'CHR_VN_AUS.Mesh.AUS_Tunic_Pilot_Mesh'
	US_PilotLowerBodies(0)=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh'
	ARVN_PilotLowerBodies(0)=SkeletalMesh'CHR_VN_US_Army.Mesh.US_Tunic_Pilot_Mesh'
	VC_LowerBodies(0)=SkeletalMesh'CHR_VN_Vietcong.Mesh.VC_Tunic_Long_Mesh'
	NVA_LowerBodies(0)=SkeletalMesh'CHR_VN_NVA.Mesh.NVA_Tunic_Long_Mesh'


}
