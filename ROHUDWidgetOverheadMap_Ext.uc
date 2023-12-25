class ROHUDWidgetOverheadMap_Ext extends ROHUDWidgetOverheadMap;

//const	ROOMT_FriendlyTankStart		= 570;

var	Texture2D		EnemyTankSpottedIcon;	// Icon texture representing Enemy Tank 

/*
function Initialize(PlayerController HUDPlayerOwner)
{

	local int i, HUDComponentIndex;
	Super.Initialize(HUDPlayerOwner);
	
	if ( HUDComponents[ROOMT_FriendlyTankStart] != none )
	{
		// Friendly Tank icons
		for ( i = 1; i < `MAX_TRANSPORTS_PER_TEAM; i++ )
		{
			HUDComponentIndex = ROOMT_FriendlyTankStart + i;

			HUDComponents[HUDComponentIndex] = new class'ROHUDWidgetComponent';
			HUDComponents[HUDComponentIndex].X = HUDComponents[ROOMT_FriendlyTankStart].X;
			HUDComponents[HUDComponentIndex].Y = HUDComponents[ROOMT_FriendlyTankStart].Y;
			HUDComponents[HUDComponentIndex].Width = HUDComponents[ROOMT_FriendlyTankStart].Width;
			HUDComponents[HUDComponentIndex].Height = HUDComponents[ROOMT_FriendlyTankStart].Height;
			HUDComponents[HUDComponentIndex].TexWidth = HUDComponents[ROOMT_FriendlyTankStart].TexWidth;
			HUDComponents[HUDComponentIndex].TexHeight = HUDComponents[ROOMT_FriendlyTankStart].TexHeight;

			HUDComponents[HUDComponentIndex].Tex = HUDComponents[ROOMT_FriendlyTankStart].Tex;
			HUDComponents[HUDComponentIndex].DrawColor = HUDComponents[ROOMT_FriendlyTankStart].DrawColor;
			HUDComponents[HUDComponentIndex].bFadedOut = true;
			HUDComponents[HUDComponentIndex].FadeOutTime = HUDComponents[ROOMT_FriendlyTankStart].FadeOutTime;
			HUDComponents[HUDComponentIndex].SortPriority = HUDComponents[ROOMT_FriendlyTankStart].SortPriority;
			HUDComponents[HUDComponentIndex].bVisible = false;
			//`log(self$"::"$GetFuncName()$" - ROVH ="@ROVH);
			//`log("Index= "$HUDComponentIndex$);
			//`log("Unhiding proxy for seat"@SeatProxies[i].SeatIndex@"as health is"@SeatProxies[i].Health);
		}
	}
	
	
}
function UpdateWidget()
{
	local ROPlayerReplicationInfo ROPRI;
	local ROTeamInfo_Ext Team;

	super.UpdateWidget();

	if ( PlayerOwner != none )
	{

		ROPRI = ROPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);

		if ( ROPRI != none )
		{
			Team = ROTeamInfo_Ext(ROPRI.Team);
		}
	}
	UpdateFriendlyTankIcons(Team,ROPRI);

}
function UpdateFriendlyTankIcons(ROTeamInfo Team, ROPlayerReplicationInfo ROPRI)
{
	local int i, ComponentIndex;
	local ROVehicleTank_Ext MyTank;

	if ( HUDComponents[ROOMT_FriendlyTankStart] != none )
	{	
		
	// Loop through all friendly Tanks
	ComponentIndex = ROOMT_FriendlyTankStart;
	for ( i = 0; i < `MAX_TRANSPORTS_PER_TEAM; i++ )
		{
			if ( Team != none)
			{	
				//`log("Trying to load icon",,'ROHUDWidgetOverheadMap_Ext');
				if (Team.TeamTransportRep[i] == 1)
				{
					//`log("Its a M113",,'ROHUDWidgetOverheadMap_Ext');
					HUDComponents[ComponentIndex].bVisible = false;
				}
				else if ( Team.TeamTransportLocationArray[i].X > MinVisibleWorldX 
					&& Team.TeamTransportLocationArray[i].X < MaxVisibleWorldX 
					&& Team.TeamTransportLocationArray[i].Y > MinVisibleWorldY 
					&& Team.TeamTransportLocationArray[i].Y < MaxVisibleWorldY )
				{
					MyTank = none;

					if( ROVehicleTank_Ext(PlayerOwner.Pawn) != none )
					{
						MyTank = ROVehicleTank_Ext(PlayerOwner.Pawn);
					}
					//else if( ROTankWeaponPawn(PlayerOwner.Pawn) != none && ROTankWeaponPawn(PlayerOwner.Pawn).MyVehicle != none )
					//{
					//	MyTank = ROVehicleTank_Ext(ROTankWeaponPawn(PlayerOwner.Pawn).MyVehicle);
					//}
					// if player in the tank, enlarge icon
					if( MyTank != none && MyTank.TransportArrayIndex == i )
					{
						if ( CurrentZoom < 1.75f )
						{
							HUDComponents[ComponentIndex].CurWidth = PlayerSizeUnzoomed * TransportSize * HUDComponents[ComponentIndex].ScaleX; // MyTransportSize
							HUDComponents[ComponentIndex].CurHeight = PlayerSizeUnzoomed * TransportSize * HUDComponents[ComponentIndex].ScaleY; // MyTransportSize
						}
						else
						{
							HUDComponents[ComponentIndex].CurWidth = PlayerSizeZoomed * TransportSize * HUDComponents[ComponentIndex].ScaleX; // MyTransportSize
							HUDComponents[ComponentIndex].CurHeight = PlayerSizeZoomed * TransportSize * HUDComponents[ComponentIndex].ScaleY; // MyTransportSize
						}

						HUDComponents[ComponentIndex].DrawColor = SquadDrawColor;
					}
					else
					{
						if ( CurrentZoom < 1.75f )
						{
							HUDComponents[ComponentIndex].CurWidth = PlayerSizeUnzoomed * TransportSize * HUDComponents[ComponentIndex].ScaleX;
							HUDComponents[ComponentIndex].CurHeight = PlayerSizeUnzoomed * TransportSize * HUDComponents[ComponentIndex].ScaleY;
						}
						else
						{
							HUDComponents[ComponentIndex].CurWidth = PlayerSizeZoomed * TransportSize * HUDComponents[ComponentIndex].ScaleX;
							HUDComponents[ComponentIndex].CurHeight = PlayerSizeZoomed * TransportSize * HUDComponents[ComponentIndex].ScaleY;
						}

						HUDComponents[ComponentIndex].DrawColor = class'HUD'.default.WhiteColor;
					}
					HUDComponents[ComponentIndex].SetScreenLocation(HUDComponents[ROOMT_Map].X + ((Team.TeamTransportLocationArray[i].Y - MinVisibleWorldY) * (HUDComponents[ROOMT_Map].Width / (MaxVisibleWorldY - MinVisibleWorldY)) - (HUDComponents[ComponentIndex].CurWidth / 2.0)),
																	HUDComponents[ROOMT_Map].Y - ((Team.TeamTransportLocationArray[i].X - MaxVisibleWorldX) * (HUDComponents[ROOMT_Map].Height / (MaxVisibleWorldX - MinVisibleWorldX)) + (HUDComponents[ComponentIndex].CurHeight / 2.0)));
					HUDComponents[ComponentIndex].bVisible = true;
				}
				else
				{
				 	HUDComponents[ComponentIndex].bVisible = false;
				}
			}
			else
			{
				//`log("Failed to load tank icon",,'ROHUDWidgetOverheadMap_Ext');
				HUDComponents[ComponentIndex].bVisible = false;
			}

		ComponentIndex++;
		}
	}
}
	if ( HUDComponents[ROOMT_FriendlyTankStart] != none )
	{	
		
		// Loop through all friendly Tanks
		ComponentIndex = ROOMT_FriendlyTankStart;
		for ( i = 0; i < `MAX_TRANSPORTS_PER_TEAM; i++ )
		{
			if ( Team != none && Team.TeamTankArray[i].IsA('ROVehicle_M41'))
			{
				if (Team.TeamTankRep[i] != 1)
				{
					HUDComponents[ComponentIndex].bVisible = false;
				}
				else if ( Team.TeamTankLocationArray[i].X > MinVisibleWorldX && Team.TeamTankLocationArray[i].X < MaxVisibleWorldX &&
					 Team.TeamTankLocationArray[i].Y > MinVisibleWorldY && Team.TeamTankLocationArray[i].Y < MaxVisibleWorldY )
				{
					MyTank = none;

					if( ROVehicleTank_Ext(PlayerOwner.Pawn) != none )
					{
						MyTank = ROVehicleTank_Ext(PlayerOwner.Pawn);
					}
					//else if( ROTankWeaponPawn(PlayerOwner.Pawn) != none && ROTankWeaponPawn(PlayerOwner.Pawn).MyVehicle != none )
					//{
					//	MyTank = ROVehicleTank_Ext(ROTankWeaponPawn(PlayerOwner.Pawn).MyVehicle);
					//}
					// if player in the tank, enlarge icon
					if( MyTank!= none && MyTank.TankArrayIndex == i )
					{
						if ( CurrentZoom < 1.75f )
						{
							HUDComponents[ComponentIndex].CurWidth = PlayerSizeUnzoomed * TransportSize * HUDComponents[ComponentIndex].ScaleX; // MyTransportSize
							HUDComponents[ComponentIndex].CurHeight = PlayerSizeUnzoomed * TransportSize * HUDComponents[ComponentIndex].ScaleY; // MyTransportSize
						}
						else
						{
							HUDComponents[ComponentIndex].CurWidth = PlayerSizeZoomed * TransportSize * HUDComponents[ComponentIndex].ScaleX; // MyTransportSize
							HUDComponents[ComponentIndex].CurHeight = PlayerSizeZoomed * TransportSize * HUDComponents[ComponentIndex].ScaleY; // MyTransportSize
						}

						HUDComponents[ComponentIndex].DrawColor = SquadDrawColor;
					}
					else
					{
						if ( CurrentZoom < 1.75f )
						{
							HUDComponents[ComponentIndex].CurWidth = PlayerSizeUnzoomed * TransportSize * HUDComponents[ComponentIndex].ScaleX;
							HUDComponents[ComponentIndex].CurHeight = PlayerSizeUnzoomed * TransportSize * HUDComponents[ComponentIndex].ScaleY;
						}
						else
						{
							HUDComponents[ComponentIndex].CurWidth = PlayerSizeZoomed * TransportSize * HUDComponents[ComponentIndex].ScaleX;
							HUDComponents[ComponentIndex].CurHeight = PlayerSizeZoomed * TransportSize * HUDComponents[ComponentIndex].ScaleY;
						}

						HUDComponents[ComponentIndex].DrawColor = class'HUD'.default.WhiteColor;
					}
					HUDComponents[ComponentIndex].SetScreenLocation(HUDComponents[ROOMT_Map].X + ((Team.TeamTankLocationArray[i].Y - MinVisibleWorldY) * (HUDComponents[ROOMT_Map].Width / (MaxVisibleWorldY - MinVisibleWorldY)) - (HUDComponents[ComponentIndex].CurWidth / 2.0)),
																	HUDComponents[ROOMT_Map].Y - ((Team.TeamTankLocationArray[i].X - MaxVisibleWorldX) * (HUDComponents[ROOMT_Map].Height / (MaxVisibleWorldX - MinVisibleWorldX)) + (HUDComponents[ComponentIndex].CurHeight / 2.0)));
					HUDComponents[ComponentIndex].bVisible = true;
				}
				else
				{
				 	HUDComponents[ComponentIndex].bVisible = false;
				}
			}
			else
			{
				HUDComponents[ComponentIndex].bVisible = false;
			}

			ComponentIndex++;
		}
	}

*/		
			
defaultproperties
{
	/*Begin Object Class=ROHUDWidgetComponent Name=FriendlyTankTexture
		X=252
		Y=272
		Width=24
		Height=24
		TexWidth=64
		TexHeight=64
		Tex=Texture2D'VN_UI_Textures.OverheadMap.ui_overheadmap_icons_friendly_tank'
		DrawColor=(R=255,G=255,B=255,A=255)
		bFadedOut=true
		bVisible=false
		FadeOutTime=0.25
		SortPriority=DSP_High
	End Object
	HUDComponents(ROOMT_FriendlyTankStart)=FriendlyTankTexture*/
}
