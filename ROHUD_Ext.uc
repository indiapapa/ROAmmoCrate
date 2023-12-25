
class ROHUD_Ext extends ROHUD;

/*
event PostRender()
{
	local ROCanvas ROCanvas;
	local ROTeamInfo_Ext PlayerOwnerTeam;
	local ROPlayerReplicationInfo ROPRI;
	local ROVehicle ROV;
	local Pawn P;
	local int i;
	local float XL, YL, YPos, AdjSizeX, OffsetX;

	// Set up delta time
	RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;

	// If the Canvas Size has changed
	if ( !bInitialized ||
		 SizeX != Canvas.SizeX || SizeY != Canvas.SizeY ||
		 (LocalPlayer(PlayerOwner.Player) != none && LocalPlayer(PlayerOwner.Player).Outer.GameViewport.IsFullScreenViewport() != bFullscreen) ||
		 (LocalPlayer(PlayerOwner.Player) != none && LocalPlayer(PlayerOwner.Player).Outer.GameViewport.IsDeviceLost() != bDeviceLost) )
	{
		// Pre calculate most common variables
		PreCalcValues();

		// Check for Eyefinity/nVidia Surround and adjust canvas width accordingly
		if( SizeX / SizeY > 2.34 ) // 2.33* is 21:9
			AdjSizeX = CalcSingleMonitorWidth();
		else
			AdjSizeX = Canvas.SizeX;

		OffsetX = (Canvas.SizeX - AdjSizeX) / 2;

		bFullscreen = (LocalPlayer(PlayerOwner.Player) != none ? LocalPlayer(PlayerOwner.Player).Outer.GameViewport.IsFullScreenViewport() : false);
		bDeviceLost = (LocalPlayer(PlayerOwner.Player) != none ? LocalPlayer(PlayerOwner.Player).Outer.GameViewport.IsDeviceLost() : false);

		ROCanvas = ROCanvas(Canvas);

		ROCanvas.StartX = OffsetX + (AdjSizeX * ROCanvas.LeftEdgePercentage);
		ROCanvas.StartY = Canvas.SizeY * ROCanvas.TopEdgePercentage;
		ROCanvas.CroppedSizeX = OffsetX + (AdjSizeX * ROCanvas.RightEdgePercentage);
		ROCanvas.CroppedSizeY = Canvas.SizeY * ROCanvas.BottomEdgePercentage;

		bRefreshHUDWidgets = true;
	}

	if( WorldInfo.Game != none && WorldInfo.Game.GetGameType() == ROGT_Default )
	{
		bInitialized = true;
		return;
	}

	if ( bRefreshHUDWidgets )
	{
		bRefreshHUDWidgets = false;
		ROCanvas = ROCanvas(Canvas);

		// Loop through our List of HUD Widgets
		for ( i = 0; i < HUDWidgetList.Length; i++ )
		{
			// This check is put in here so it doesn't require another loop
			if ( !bInitialized )
			{
				HUDWidgetList[i].Initialize(PlayerOwner);
			}

			// Let the Widgets know the Canvas Size has changed
			HUDWidgetList[i].HandleCanvasSizeChange(Canvas, (ROCanvas.CroppedSizeX - ROCanvas.StartX) / 1024.0, (ROCanvas.CroppedSizeY - ROCanvas.StartY) / 768.0);

			// This exists to rebuild the kill messages upon a canvas resize, by not including it, the components of the kill message will be squished together
			if (ROHUDWidgetKillMessages(HUDWidgetList[i]) != none)
			{
				ROHUDWidgetKillMessages(HUDWidgetList[i]).NewKillMessage();
			}
		}

		if ( !bInitialized )
		{
			EnemySpottedReticle.Initialize();

			// Once we have run this once with a bunch of widgets, we've Initialized all widgets
			if ( HUDWidgetList.Length > 10 )
			{
				bInitialized = true;
			}
		}

		EnemySpottedReticle.SetScale((ROCanvas.CroppedSizeX - ROCanvas.StartX) / 1024.0, (ROCanvas.CroppedSizeX - ROCanvas.StartX) / 1024.0);
		EnemySpottedReticle.SetScreenLocation(((ROCanvas.CroppedSizeX - ROCanvas.StartX) / 2.0) + ROCanvas.StartX - EnemySpottedReticle.CurWidth / 2.0, (ROCanvas.CroppedSizeY - ROCanvas.StartY) / 2.0 - EnemySpottedReticle.CurHeight / 2.0, true, true);
	}

	// Code copied in from the superclass because we need this functionality - Ramm
	DrawHud();

	// Draw any debug text in real-time
	PlayerOwner.DrawDebugTextList(Canvas, RenderDelta);

	if ( bShowDebugInfo )
	{
		Canvas.Font = class'Engine'.Static.GetTinyFont();
		Canvas.DrawColor = ConsoleColor;
		Canvas.StrLen("X", XL, YL);
		YPos = 0;
		PlayerOwner.ViewTarget.DisplayDebug(self, YL, YPos);

		if ( ShouldDisplayDebug('AI') && Pawn(PlayerOwner.ViewTarget) != None )
		{
			DrawRoute(Pawn(PlayerOwner.ViewTarget));
		}
	}


	if ( bShowHud )
	{
		// Draw the crosshair for casual mode
		if( bDrawCrosshair )
		{
			DrawCrosshair();
		}

		// Update Player Locations for all Replication Pawns to allow the Compass, Overhead Map, and Tactical Widgets to appear smoother
		i = PlayerOwner.GetTeamNum();
		if ( i >= 0 && i < 2 )
		{
			PlayerOwnerTeam = ROTeamInfo_Ext(WorldInfo.GRI.Teams[i]);
			if ( PlayerOwnerTeam != none )
			{
				ROPRI = ROPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);

				foreach WorldInfo.AllPawns(class'Pawn', P)
				{
					if ( P.GetTeamNum() == PlayerOwnerTeam.TeamIndex && ROPlayerReplicationInfo(P.PlayerReplicationInfo) != none )
					{
						i = ROPlayerReplicationInfo(P.PlayerReplicationInfo).TeamPRIArrayIndex;

						if( i < `MAX_PLAYERS_PER_TEAM && PlayerOwnerTeam.TeamPRIArray[i] != none )
						{
							if ( ROPRI != none && ROPlayerController(PlayerOwner).SRI != none && PlayerOwnerTeam.TeamPRIArray[i].RoleInfo != none &&
								 PlayerOwnerTeam.TeamPRIArray[i].SquadIndex == ROPRI.SquadIndex && PlayerOwnerTeam.TeamPRIArray[i].bIsSquadLeader )
							{
								ROPlayerController(PlayerOwner).SRI.SquadLeaderLocation = P.Location;
							}
						}

						if(ROWeaponPawn(P) != none && ROWeaponPawn(P).MyVehicle != none)
						{
							ROV = ROWeaponPawn(P).MyVehicle;

							PlayerOwnerTeam.SetTeamLocationEntry(i, ROV.Location.X, ROV.Location.Y, ROV.Location.Z);

							// Transports aren't permanently linked to roles, so are handled separately
							if( ROVehicleTransport(ROV) != none )
							{
								PlayerOwnerTeam.TeamTransportLocationArray[ROVehicleTransport(ROV).TransportArrayIndex].X = ROV.Location.X;
								PlayerOwnerTeam.TeamTransportLocationArray[ROVehicleTransport(ROV).TransportArrayIndex].Y = ROV.Location.Y;
							}
							// Same for helicopters
							else if( ROVehicleHelicopter(ROV) != none )
							{
								PlayerOwnerTeam.TeamHelicopterLocationArray[ROVehicleHelicopter(ROV).HelicopterArrayIndex].X = ROV.Location.X;
								PlayerOwnerTeam.TeamHelicopterLocationArray[ROVehicleHelicopter(ROV).HelicopterArrayIndex].Y = ROV.Location.Y;
							} // same for tanks
							else if( ROVehicleTank_Ext(ROV) != none )
							{
								PlayerOwnerTeam.TeamTransportLocationArray[ROVehicleTank_Ext(ROV).TransportArrayIndex].X = ROV.Location.X;
								PlayerOwnerTeam.TeamTransportLocationArray[ROVehicleTank_Ext(ROV).TransportArrayIndex].Y = ROV.Location.Y;
							}
							else if( ROVehicleTank_Ext(ROV) != none )
							{
								PlayerOwnerTeam.TeamTankLocationArray[ROVehicleTank_Ext(ROV).TankArrayIndex].X = ROV.Location.X;
								PlayerOwnerTeam.TeamTankLocationArray[ROVehicleTank_Ext(ROV).TankArrayIndex].Y = ROV.Location.Y;
							}
						}
						else
						{
							PlayerOwnerTeam.SetTeamLocationEntry(i, P.Location.X, P.Location.Y, P.Location.Z);

							// Transports aren't permanently linked to roles, so are handled separately
							if( ROVehicleTransport(P) != none )
							{
								PlayerOwnerTeam.TeamTransportLocationArray[ROVehicleTransport(P).TransportArrayIndex].X = P.Location.X;
								PlayerOwnerTeam.TeamTransportLocationArray[ROVehicleTransport(P).TransportArrayIndex].Y = P.Location.Y;
							}
							// Same for helicopters
							else if( ROVehicleHelicopter(P) != none )
							{
								PlayerOwnerTeam.TeamHelicopterLocationArray[ROVehicleHelicopter(P).HelicopterArrayIndex].X = P.Location.X;
								PlayerOwnerTeam.TeamHelicopterLocationArray[ROVehicleHelicopter(P).HelicopterArrayIndex].Y = P.Location.Y;
							}
							else if( ROVehicleTank_Ext(P) != none )
							{
								PlayerOwnerTeam.TeamTransportLocationArray[ROVehicleTank_Ext(P).TransportArrayIndex].X = P.Location.X;
								PlayerOwnerTeam.TeamTransportLocationArray[ROVehicleTank_Ext(P).TransportArrayIndex].Y = P.Location.Y;
							}
							
							else if( ROVehicleTank_Ext(P) != none )
							{
								PlayerOwnerTeam.TeamTankLocationArray[ROVehicleTank_Ext(P).TankArrayIndex].X = P.Location.X;
								PlayerOwnerTeam.TeamTankLocationArray[ROVehicleTank_Ext(P).TankArrayIndex].Y = P.Location.Y;
							}
						}
						// Sturt, 12/05/15 - I don't know what this was doing. Seems like it was meant to only update the playerowner, but instead was
						// doing the first friendly pawn only, which was rarely the player. Removed for now, but if we want to make it just the player
						// then we should add an extra check besides simply "my team" and "has a PRI".
						//break;
					}
				}
			}
		}

		// Render all of the HUD Widgets
		for ( i = 0; i < HUDWidgetList.Length; i++ )
		{
			HUDWidgetList[i].UpdateWidget();
			HUDWidgetList[i].RenderWidget(Canvas);
		}

		// Offset the chat widget if required
		if( MessagesChatWidget != none && (HelicopterInfoWidget != none || VehicleInfoWidget != none) )
		{
			MessagesChatWidget.UpdateChatVertPosition(HelicopterInfoWidget.bVisible || VehicleInfoWidget.bVisible);
		}

		if( MessagesPickupsWidget != none && HelicopterInstrumentWidget != none )
		{
			MessagesPickupsWidget.UpdateVertPosition(HelicopterInstrumentWidget.bVisible);
		}

		if( MessagesReloadWidget != none && HelicopterInstrumentWidget != none )
		{
			MessagesReloadWidget.UpdateVertPosition(HelicopterInstrumentWidget.bVisible);
		}

		DisplayConsoleMessages();
		DisplayLocalMessages();
		DisplayKismetMessages();
		// End code copied in from teh superclass

		// Let the vehicle handle drawing its own special hud stuff
		// TODO: Maybe cache the vehicle so we don't have to cast every tick - Ramm
		if( ROVehicleBase(PlayerOwner.Pawn) != none )
		{
			ROVehicleBase(PlayerOwner.Pawn).DisplayHud(self, Canvas);
		}
	}
	else // Watermark always shows
	{
		if ( WatermarkWidget != none )
		{
			WatermarkWidget.UpdateWidget();
			WatermarkWidget.RenderWidget(Canvas);
		}
	}

	// If the player has a Bad Connection
	if ( bShowBadConnectionAlert )
	{
		// Show the Alert ontop of the rest of the HUD
		DisplayBadConnectionAlert();
	}

	if ( bShowHud && (OverheadMapWidget == none || !OverheadMapWidget.IsVisible()) && (ScoreboardWidget == none || !ScoreboardWidget.IsVisible()) )
	{
		if(WorldWidget != none)
		{
			if(PlayerOwner.Pawn != none)
			{
				CurrentIronSightAlpha = (PlayerOwner.Pawn.bIronSights) ? WorldWidget.default.IronSightAlpha : 255;
			}
			else
			{
				CurrentIronSightAlpha = 255;
			}
		}
		DrawPlayerNames(Canvas);
	}

	if ( bShowEnemySpottedReticle )
	{
		EnemySpottedReticle.Update(WorldInfo.TimeSeconds);
		EnemySpottedReticle.Render(Canvas, 0, 0);
	}

	LastHUDRenderTime = WorldInfo.TimeSeconds;
}
*/
defaultproperties
{
	DefaultHelicopterInfoWidget=class'ROHUDWidgetHelicopterInfo_Ext'
	DefaultOverheadMapWidget=class'ROHUDWidgetOverheadMap_Ext'
	WeaponUVs(68)=(WeaponClass=ROItem_PlaceableAmmoCrate_Ext,WeaponTexture=Texture2D'VN_UI_Textures.HUD.Ammo.UI_HUD_Ammo_DSHK',KillMessageTexture=none,KillMessageWidth=128,KillMessageHeight=64)
	WeaponUVs(69)=(WeaponClass=ROWeap_M72_RocketLauncher,WeaponTexture=Texture2D'WP_VN_USA_M72.HUD.UI_HUD_WeaponSelect_M72',KillMessageTexture=Texture2D'WP_VN_USA_M72.HUD.UI_Kill_Icon_M72',KillMessageWidth=128,KillMessageHeight=64)
	WeaponUVs(70)=(WeaponClass=ROWeap_VietSatchel_Ext,WeaponTexture=Texture2D'WP_VN_VC_Satchel_Ext.HUD.ui_hud_weaponselect_satchel_sov',KillMessageTexture=Texture2D'WP_VN_VC_Satchel_Ext.HUD.ui_kill_icon_SatchelSov',KillMessageWidth=64,KillMessageHeight=64)
	AmmoUVs(61)=(AmmoClass=ROAmmo_Placeable_AmmoCrate_Ext,MagTexture=Texture2D'VN_UI_Textures.HUD.Ammo.UI_HUD_Ammo_DSHK')
	AmmoUVs(66)=(AmmoClass=ROAmmo_ROHEAT_Rocket,MagTexture=Texture2D'VN_UI_Textures.HUD.Ammo.UI_HUD_Ammo_RPG')
	AmmoUVs(67)=(AmmoClass=ZMAmmo_127x99_M2Belt_APC,MagTexture=Texture2D'VN_UI_Textures.HUD.Ammo.UI_HUD_Ammo_DSHK')
}
