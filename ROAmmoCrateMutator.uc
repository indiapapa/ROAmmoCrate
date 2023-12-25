class ROAmmoCrateMutator extends ROMutator
    config(ROAmmoCrate_config);

var class<HUD> ROACHUDType;
var ROPlayerControllerAC ACPC;
//var RORoleInfoClasses ccVC, ccNVA, ccUS, ccARVN, ccAUS;

function PreBeginPlay()
{
    `log("AmmoCrateMutator init",,'ROAmmoCrateMutator');
    super.PreBeginPlay();
    ROGameInfo(WorldInfo.Game).PlayerControllerClass = class'ROPlayerControllerAC';
    ROGameInfo(WorldInfo.Game).PlayerReplicationInfoClass = class'ROPlayerReplicationInfoAC';
    ROGameInfo(WorldInfo.Game).DefaultPawnClass=class'ROPawn_Ext';
    ROGameInfo(WorldInfo.Game).PawnHandlerClass=class'ROPawnHandler_Ext';
    //ROGameInfo(WorldInfo.Game).TeamInfoClass=class'ROTeamInfo_Ext';
    OverrideGameInfo();
}

simulated function OverrideGameInfo()
{
    local ROGameInfo ROGI;
    ROGI = ROGameInfo(WorldInfo.Game);

    if (ROGI.HUDType != ROACHUDType)
    {
        ROGI.HUDType = ROACHUDType;
        ROGameInfoTerritories(ROGI).HUDType = ROACHUDType;
    }
    `log("Game info overridden",,'ROAmmoCrateMutator');
 
}

function PostBeginPlay()
{
    ReplacePawns();
}

function NotifyLogin(Controller NewPlayer)
{

    ACPC = ROPlayerControllerAC(NewPlayer);

    if (ACPC == None)
    {
        `log("Error replacing roles");
        return;
    }

    ACPC.ReplaceRoles();
    ACPC.ClientReplaceRoles();
    ACPC.ReplaceInventoryManager();
    ACPC.ClientReplaceInventoryManager();

    super.NotifyLogin(NewPlayer);
}

simulated function ModifyPlayer(Pawn Other)
{
    super.ModifyPlayer(Other);
    ReplacePawns();
}

simulated function ModifyPreLogin(string Options, string Address, out string ErrorMessage)
{
    ReplacePawns();
}

simulated function ReplacePawns()
{
	    ROGameInfo(WorldInfo.Game).SouthRoleFlamerContentClass="ROAmmoCrate.ROSouthPawnFlamer_Ext";
            ROGameInfo(WorldInfo.Game).SouthRolePilotContentClass="ROAmmoCrate.ROSouthPawnPilot_Ext";
	    ROGameInfo(WorldInfo.Game).NorthRoleContentClasses.LevelContentClasses[0]= "ROAmmoCrate.RONorthPawn_Ext";
	    ROGameInfo(WorldInfo.Game).SouthRoleContentClasses.LevelContentClasses[0] = "ROAmmoCrate.ROSouthPawn_Ext";

    		`log("Pawns replaced");
}



defaultproperties
{
	ROACHUDType=class'ROAmmoCrate.ROHUD_Ext'
	SouthRoleFlamerContentClass=class'ROAmmoCrate.ROSouthPawnFlamer_Ext'
	SouthRolePilotContentClass=class'ROAmmoCrate.ROSouthPawnPilot_Ext'


}
