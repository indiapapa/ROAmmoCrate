
class ROTeamInfo_Ext extends ROTeamInfo;

/*
var	ROVehicleTank_Ext		TeamTankArray[`MAX_TRANSPORTS_PER_TEAM];			// Server Only: list of spawned team transports
var	byte			TeamTankRep[`MAX_TRANSPORTS_PER_TEAM];				// Replicated array of bytes indicating whether a transport is alive or not
var	vector			TeamTankLocationArray[`MAX_TRANSPORTS_PER_TEAM];	// Replicated Team Transport Locations(Updated periodically from server, overridden locally if Pawn is relevant)

enum VNTankType
{
	VNT_None,	// allow initial values to be recognized
	VNT_M41,	//1
	VNT_T54,	//2
	VNT_M48,
	VNT_T34 
};


replication
{
	if ( IsTeamReplicationViewer(TeamIndex) )
		TeamTankArray;
}*/


function byte GetHeliType(ROVehicleHelicopter ROVH)
{
	if(ROVH.IsA('ROHeli_UH1H'))
	{
		return VNHT_Huey;
	}
	else if(ROVH.IsA('ROHeli_UH1H_Slick'))
	{
		return VNHT_Huey;
	}
	else if(ROVH.IsA('ROHeli_OH6'))
	{
		return VNHT_Loach;
	}
	else if(ROVH.IsA('ROHeli_AH1G'))
	{
		return VNHT_Cobra;
	}
	else // CFR-942 - Gunship. -Nate
	{
		return VNHT_Gunship;
	}
}



/*function byte GetTankType(ROVehicleTank_Ext ROT)
{
	if(ROT.IsA('ROVehicle_T54'))
	{
		return VNT_T54;
	}
	else if(ROT.IsA('ROVehicle_M41'))
	{
		return VNT_M41;
	}
	else // CFR-942 - Gunship. -Nate
	{
		return VNT_T34;
	}
}

function AddTankToTeam(ROVehicleTank_Ext ROT)
{
	local int i, OpenIndex;
	
	OpenIndex = -1;
	`Log("Trying to add tank");
	for ( i = 0; i < `MAX_TRANSPORTS_PER_TEAM; i++ )
	{
		if ( OpenIndex == -1 && TeamTransportArray[i] == none )
		{
			OpenIndex = i;
		}
		else if ( TeamTransportArray[i] == ROT )
		{
			OpenIndex = -1;
			break;
		}
	}

	if ( OpenIndex != -1 )
	{
		TeamTransportArray[OpenIndex] = ROT;
		TeamTransportRep[OpenIndex] = 2; // GetTankType(ROT);
		ROT.TransportArrayIndex = OpenIndex;
		`Log("Tank added");
	}
}

function RemoveTankFromTeam(ROVehicleTank_Ext ROT)
{
	local int i;
	`log("Removing tank");
	for ( i = 0; i < `MAX_TRANSPORTS_PER_TEAM; i++ )
	{
		if ( TeamTransportArray[i] == ROT )
		{
			TeamTransportArray[i] = none;
			TeamTransportRep[i] = 255;
			`Log("Tank removed");
			break;
		}
	}
}

function UpdatePlayerLocations()
{
	local Controller temp;
	local int i;

	for ( i = 0; i < `MAX_PLAYERS_PER_TEAM; i++ )
	{
		if( TeamPRIArray[i] != none && !TeamPRIArray[i].bDead )
		{
			temp = Controller(TeamPRIArray[i].Owner);

			if ( temp != none && temp.Pawn != none )
			{
				SetTeamLocationEntry(i, temp.Pawn.Location.X, temp.Pawn.Location.Y, temp.Pawn.Location.Z);
				// Save the data to get this location index later
				EnemySpotterLocationInfos[i].EnemySpotter = TeamPRIArray[i];
				EnemySpotterLocationInfos[i].SpotterLocationArrayIndex = i;
			}
		}
	}

	UpdateTransportLocations();
	UpdateHelicopterLocations();
	//UpdateTankLocations();
}
function UpdateTankLocations()
{
	local int i;

	for ( i = 0; i < `MAX_TRANSPORTS_PER_TEAM; i++ )
	{
		if( TeamTankArray[i] != none )
		{
			TeamTankLocationArray[i].X = TeamTankArray[i].Location.X;
			TeamTankLocationArray[i].Y = TeamTankArray[i].Location.Y;
			TeamTankLocationArray[i].Z = TeamTankArray[i].Location.Z;
		}
	}
}*/

defaultproperties
{
}
