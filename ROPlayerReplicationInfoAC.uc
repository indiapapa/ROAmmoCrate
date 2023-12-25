class ROPlayerReplicationInfoAC extends ROPlayerReplicationInfo;
/*
var byte	TeamTankArrayIndex;

replication
{
	// Things the server should send to the client.
	if ( bNetDirty && Role == Role_Authority )
		TeamTankArrayIndex;
}
*/
simulated event ReplicatedEvent(name VarName)
{
	local ROPlayerControllerAC ACPC;
	local string SquadLeaderName;
	local ROTeamInfo ROTI;
	local int i;

	if ( VarName == 'bReadyToPlay' )
	{
		foreach WorldInfo.LocalPlayerControllers(class'ROPlayerControllerAC', ACPC)
		{
			ACPC.ReadyStatusUpdated(self);
		}
	}
	else if ( VarName == 'bDead')
	{
		foreach WorldInfo.LocalPlayerControllers(class'ROPlayerControllerAC', ACPC)
		{
			ACPC.ChangeVivoxChannelsState(self, ACPC);
		}
	}
	else if ( VarName == 'SquadIndex' || VarName == 'RoleIndex')
	{
		if( VarName == 'RoleIndex' )
		{
			ACPC = ROPlayerControllerAC(Owner);
			if( RoleIndex == `ROLE_INDEX_SQUADLEADER )
			{
				bIsSquadLeader = true;
				if ( ACPC != none )
				{
					if ( Team.TeamIndex == `AXIS_TEAM_INDEX )
					{
						if ( (ROGameInfo(WorldInfo.Game) != none && !ROGameInfo(WorldInfo.Game).bDisableSpawnOnSquadLeader) ||
							 (ROGameReplicationInfo(WorldInfo.GRI) != none && !ROGameReplicationInfo(WorldInfo.GRI).bDisableSpawnOnSquadLeader) )
						{
							ACPC.AddTrackingHint(ROHTrig_TunnelTool);
						}
					}
					ACPC.AddTrackingHint(ROHTrig_MarkingArtillery);
				}
			}
			else
			{
				bIsSquadLeader = false;
				if ( ACPC != none )
				{
					ACPC.RemoveTrackingHint(ROHTrig_TunnelTool);
					ACPC.RemoveTrackingHint(ROHTrig_MarkingArtillery);
				}
			}
		}
		else
			UpdateSquadInfo();

		//`log("ReplicatedEvent" @ PlayerName @ self @ Team @ SquadIndex @ RoleIndex @ RoleInfo);

		foreach WorldInfo.LocalPlayerControllers(class'ROPlayerControllerAC', ACPC)
		{
			if( ACPC.CurrentUnitSelectScene != none )
			{
				ACPC.CurrentUnitSelectScene.SquadChanged();
			}

			if( ACPC.CurrentLobbyScene != none )
			{
				ACPC.CurrentLobbyScene.RequestUpdate();
			}


			// Updates 'Available Squads List'
			if ( ACPC.MyROHUD.OrdersWidget != none )
			{
				ACPC.MyROHUD.OrdersWidget.BuildUnitList();
				ACPC.MyROHUD.OrdersWidget.SelectedUnitChanged();
			}

			if( ACPC.PlayerReplicationInfo == self )
			{
				if( VarName == 'SquadIndex' && SquadIndex != `SQUAD_INDEX_NONE )
					ACPC.MyROHUD.ReInitializeSquadList();

				// Update command widgets
				if( bIsSquadLeader )
					ACPC.myROHUD.CreateSquadLeaderCommandWidgets();
				else
					ACPC.myROHUD.DestroyCommandWidgets();
			}
		}
	}
	else if( VarName == 'ClassIndex' )
	{
		UpdateRoleInfo();

		if( Collector != none )
			Collector.UpdateRole(PlayerID,RoleInfo==none?0:INT(RoleInfo.RoleType),RoleInfo.MyName,(Team==none)?-1:Team.TeamIndex);

		foreach WorldInfo.LocalPlayerControllers(class'ROPlayerControllerAC', ACPC)
		{
			ACPC.RoleInfoUpdated();
			ACPC.LastDisplayedClass = ClassIndex;
			ACPC.SaveConfig();

			if( ACPC.CurrentUnitSelectScene != none )
			{
				ACPC.CurrentUnitSelectScene.SquadChanged();
			}

			// This isn't necessary 99.9% of the time, but when a player switches from commander to squad leader, then dies,
			// the squad can replicate before the role does, which means the squad list is reinitialised against the wrong roleinfo.
			// This is just a quick and dirty handler for that.
			if( ACPC.PlayerReplicationInfo == self )
			{
				if( SquadIndex != `SQUAD_INDEX_NONE )
					ACPC.MyROHUD.ReInitializeSquadList();
			}
		}
	}
	else if ( VarName == 'HonorLevel' || VarName == 'ClassRank' )
	{
		UpdateSquadInfo();
		ApplyReceivedCharacterConfig();

		foreach WorldInfo.LocalPlayerControllers(class'ROPlayerControllerAC', ACPC)
		{
			ACPC.UpdateLobbyPlayer(self);
			if( ACPC.CurrentUnitSelectScene != none )
			{
				ACPC.CurrentUnitSelectScene.SquadChanged();
			}
		}
	}
	else if( VarName == 'InviteSquadIndex' )
	{
		foreach WorldInfo.LocalPlayerControllers(class'ROPlayerControllerAC', ACPC)
		{
			if( ACPC.CurrentUnitSelectScene != none )
			{
				ACPC.CurrentUnitSelectScene.UpdatePlayerLists();
			}
		}

		ACPC = ROPlayerControllerAC(Owner);

		if ( InviteSquadIndex != `SQUAD_INDEX_NONE )
		{
			ROTI = ROTeamInfo(Team);

			if( ROTI != none )
			{
				for( i=0; i<`MAX_PLAYERS_PER_TEAM; i++ )
				{
					if ( ROTI.TeamPRIArray[i] != none && ROTI.TeamPRIArray[i].SquadIndex == InviteSquadIndex && ROTI.TeamPRIArray[i].bIsSquadLeader )
					{
						SquadLeaderName = ROTI.TeamPRIArray[i].PlayerName;
						break;
					}
				}
			}

			if ( ACPC != None && ACPC.PlayerReplicationInfo == self && ROTeamInfo(Team) != none && Len(SquadLeaderName) > 0 )
			{
				if( ACPC.CurrentUnitSelectScene != none )
				{
					ACPC.CurrentUnitSelectScene.DisplaySquadInviteDialog(SquadLeaderName, ROTeamInfo(Team).SquadTitles[InviteSquadIndex]);
				}

				if( ACPC.myROHUD != none && ACPC.myROHUD.PromptBoxWidget != none )
				{
					ACPC.myROHUD.PromptBoxWidget.ReceiveSquadInviteInfo(ROTeamInfo(Team).SquadTitles[InviteSquadIndex], SquadLeaderName);
				}
			}
		}
		else
		{
			if ( ACPC != None && ACPC.PlayerReplicationInfo == self )
			{
				if( ACPC.CurrentUnitSelectScene != none )
				{
					ACPC.CurrentUnitSelectScene.SquadInviteDialog.SetVisibility(false);
				}

				if( ACPC.myROHUD != none && ACPC.myROHUD.PromptBoxWidget != none )
				{
					ACPC.myROHUD.PromptBoxWidget.ReceiveSquadInviteInfo("", "");
				}
			}
		}
	}
	else if ( VarName == 'SpawnSelection' )
	{
		foreach WorldInfo.LocalPlayerControllers(class'ROPlayerControllerAC', ACPC)
		{
			ACPC.SpawnInfoUpdated();
		}
	}
	else if ( VarName == 'VOIPStatus' )
	{
		// Update the VOIP HUD Widget
		foreach WorldInfo.LocalPlayerControllers(class'ROPlayerControllerAC', ACPC)
		{
			ACPC.VOIPEventTriggered(self, VOIPStatus > ROVOIPS_Silent);
		}
	}
	else if ( VarName == 'ReplicatedCharConfig' )
	{
		UnpackCharacterConfig();
	}
	else if ( VarName == 'FriendlyFireKillsThisRound' )
	{
		ACPC = ROPlayerControllerAC(Owner);

		if ( ACPC != none )
		{
			if ( FriendlyFireKillsThisRound == 3 )
			{
				ACPC.TriggerHint(ROHTrig_FriendlyFirePenalty);
			}
			else if ( FriendlyFireKillsThisRound > 0 )
			{
				ACPC.TriggerHint(ROHTrig_FriendlyFire);
			}
		}
	}
	else if ( VarName == 'TeamHelicopterSeatIndex' || VarName == 'TeamTransportSeatIndex' )
	{
		ACPC = ROPlayerControllerAC(Owner);

		if ( ACPC != none )
		{
			ACPC.HintTriggerCheckHeliSeats();
		}
	}
	else if( VarName == 'NumKickVotes' || VarName == 'NumRoleVotes' )
	{
		foreach WorldInfo.LocalPlayerControllers(class'ROPlayerControllerAC', ACPC)
		{
			ACPC.UpdateVoteMenuLists();
		}
	}
	else
	{
		if ( VarName == 'Team' )
		{
			UpdateSquadInfo();
			UpdateRoleInfo();

			if(Collector != none)
				Collector.UpdateRole(PlayerID,RoleInfo==none?0:INT(RoleInfo.RoleType),RoleInfo.MyName,(Team==none)?-1:Team.TeamIndex);

			//`log("ReplicatedEvent" @ PlayerName @ self @ Team @ SquadIndex @ RoleIndex @ RoleInfo);

			// Update objectives for new team (used by HUD)
			ACPC = ROPlayerControllerAC(Owner);
			if ( ACPC != None && ACPC.PlayerReplicationInfo == self )
			{
				ACPC.ForceUpdateMapWidget();
			}

			foreach WorldInfo.LocalPlayerControllers(class'ROPlayerControllerAC', ACPC)
			{
				ACPC.RoleInfoUpdated();

				if( ACPC.CurrentUnitSelectScene != none )
				{
					ACPC.CurrentUnitSelectScene.SquadChanged();
				}
			}
		}
		else if ( VarName == 'Score' || VarName == 'MatchScore' )
		{
			ACPC = ROPlayerControllerAC(Owner);
			if ( ACPC != None && ACPC.PlayerReplicationInfo == self )
			{
				ACPC.ScoreUpdated(Score + MatchScore);
			}
		}
		else if ( VarName == 'PlayerName' )
		{
			self.ServerNotifyNameChange();
		}

		Super.ReplicatedEvent(VarName);
	}
}

/**
 * Sets steam app Ids and the player's unique net id on the server.
 */
simulated function SetUniqueId(UniqueNetId PlayerUniqueId)
{
	local ROPlayerControllerAC ACPC;
	local ROPlayerController OtherPC;
	local bool bIsThisPlayerToxic;

	Super.SetUniqueId(PlayerUniqueId);

	self.SteamId64 = class'ROSteamUtils'.static.UniqueIdToSteamId64(PlayerUniqueId);

	ACPC = ROPlayerControllerAC(Owner);
	if ( ACPC != none )
	{
	    // @fixme: temporarily moved to ClientInitialize for non-standalone
		if ( WorldInfo.NetMode == NM_StandAlone )
		{
		    ClientInitializeUnlocks();
		}
		else if( WorldInfo.NetMode == NM_DedicatedServer )
		{
			bIsThisPlayerToxic = ROGameInfo(WorldInfo.Game).IsToxicPlayer(PlayerUniqueId);
			//`log(self $ ".SetUniqueId " $ SteamId64 $ " bIsThisPlayerToxic=" $ bIsThisPlayerToxic);
			foreach WorldInfo.AllControllers(class'ROPlayerController', OtherPC)
			{
				if (OtherPC != ACPC)
				{
					//`log("OtherPC=" $ OtherPC $ "  UniqueId=" $ class'ROSteamUtils'.static.UniqueIdToSteamId64(OtherPC.PlayerReplicationInfo.UniqueId) $ "  IsToxic=" $ ROGameInfo(WorldInfo.Game).IsToxicPlayer(OtherPC.PlayerReplicationInfo.UniqueId));
					if (bIsThisPlayerToxic)
					{
						// Use GameplayMutePlayer instead ServerMutePlayer to allow toxic player hear other people voice
						OtherPC.GameplayMutePlayer(PlayerUniqueId);
					}
					if (ROGameInfo(WorldInfo.Game).IsToxicPlayer(OtherPC.PlayerReplicationInfo.UniqueId))
					{
						// Use GameplayMutePlayer instead ServerMutePlayer to allow toxic player hear other people voice
						ACPC.GameplayMutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
					}
				}
			}
		}
	}
}

// @hack: UserHasLicenseForApp is not working reliably online, so for now control unlocks on the client
simulated function ClientInitialize(Controller C)
{
	local ROPlayerControllerAC ACPC;
	local bool bNewOwner;

	// why does this get called so many times?
	bNewOwner = (Owner != C);
	Super.ClientInitialize(C);

	if (bNewOwner)
	{
		self.UsedNames.Length = 0;
	}

	ACPC = ROPlayerControllerAC(C);

	if ( bNewOwner && ACPC != None && LocalPlayer(ACPC.Player) != None )
	{
	    ClientInitializeUnlocks();
	}
	PawnHandlerClass = class'ROPawnHandler_Ext';
	//PawnHandlerClass = class<ROGameInfo>(WorldInfo.GetGameClass()).default.PawnHandlerClass;
}


function bool SelectRoleByClass(Controller C, class<RORoleInfo> RoleInfoClass, optional out WeaponSelectionInfo WeaponSelection, optional out byte NewSquadIndex, optional out byte NewClassIndex, optional class<ROVehicle> TankSelection)
{
	local RORoleInfo NewRoleInfo;
	local array<RORoleCount> Roles;
	local array<RORolesTaken> RolesTaken;
	local ROMapInfo ROMI;
	local ROGameReplicationInfo ROGRI;
	local ROTeamInfo ROTI;
	local bool bSuccess, bUnlimitedRoles, bRoleAvailable;
	local ROPlayerControllerAC ACPC;
	local ROAIController ROBot;
	local Controller BootedBot;
	local int i, DesiredRoleIndex;
	local byte OldSquadIndex;

	ROMI = ROMapInfo(WorldInfo.GetMapInfo());
	DesiredRoleIndex = -1;
	// We don't want to change squad index unless we're changing to/from a special "squadless" class, so store out initial Squad first
	NewSquadIndex = SquadIndex;
	OldSquadIndex = SquadIndex;

	ROPlayerControllerAC(C).ReplaceRoles();
      	ROPlayerControllerAC(C).ReplaceInventoryManager();
	
	if( C == none )
		return false;

	`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass" @ Team @ RoleInfoClass @ WeaponSelection.PrimaryWeaponIndex @ WeaponSelection.SecondaryWeaponIndex @ ROMI @ Team);

	if ( ROMI != none && Team != none )
	{
		ACPC = ROPlayerControllerAC(C);
		ROGRI = ROGameReplicationInfo(WorldInfo.GRI);

		if( ACPC == none )
			ROBot = ROAIController(C);

		bUnlimitedRoles = class<ROGameInfo>(WorldInfo.GRI.GameClass).default.bUnlimitedRoles;

		`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass" @ ACPC @ ROGRI @ "bUnlimitedRoles="$bUnlimitedRoles @ "ClassIndex="$ClassIndex);

		// Let's check if there is an empty role available.
		// We don't want to kick players out of their role if we have available spots.
		if ( ACPC != none || ROBot != none )
		{
			if ( Team.TeamIndex == `AXIS_TEAM_INDEX )
			{
				Roles = ROMI.NorthernRoles;
				RolesTaken = ROMI.NorthernRolesTaken;
			}
			else
			{
				Roles = ROMI.SouthernRoles;
				RolesTaken = ROMI.SouthernRolesTaken;
			}

			for ( i = 0; i < Roles.Length; i++ )
			{
				`LogRoles("Role:"@Roles[i].RoleInfoClass.default.MyName$", ClassIndex="$Roles[i].RoleInfoClass.default.ClassIndex$", TakenByHumans="$RolesTaken[i].TakenByHumans$", Count:"$Roles[i].Count);
				if( Roles[i].RoleInfoClass.default.ClassIndex == RoleInfoClass.default.ClassIndex && (bUnlimitedRoles || RolesTaken[i].TakenByHumans < Roles[i].Count || ClassIndex == Roles[i].RoleInfoClass.default.ClassIndex) )
				{
					bRoleAvailable = true;
					DesiredRoleIndex = i;
					`LogRoles("Desired Role Is Available! DesiredRoleIndex:"@DesiredRoleIndex);

					ROTI = ROTeamInfo(Team);

					if( RolesTaken[i].TotalTaken >= Roles[i].Count && ROTI != none )
					{
						for( i=0; i<`MAX_PLAYERS_PER_TEAM; i++ )
						{
							if( ROTI.TeamPRIArray[i] != none && ROTI.TeamPRIArray[i].bBot && ROTI.TeamPRIArray[i].ClassIndex == RoleInfoClass.default.ClassIndex )
							{
								BootedBot = Controller(ROTI.TeamPRIArray[i].Owner);
								break;
							}
						}
					}

					break;
				}
			}
		}

		if ( Team.TeamIndex == `AXIS_TEAM_INDEX )
		{
			`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - using Northern Team");
			if ( !bUnlimitedRoles && RoleInfoClass.default.bIsTeamLeader )
			{
				`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - wants Commander");
				if ( ACPC != none )
				{
					if ( ROMI.NorthernTeamLeader.Owner == none || ROMI.NorthernTeamLeader.Owner == ACPC || AIController(ROMI.NorthernTeamLeader.Owner) != none ||
						 !ROMI.OwnerHasRole(ROMI.NorthernTeamLeader.Owner, Team.TeamIndex, `SQUAD_INDEX_TEAMLEADER, 0, WorldInfo) )
					{
						BootedBot = AIController(ROMI.NorthernTeamLeader.Owner);
						ROMI.NorthernTeamLeader.Owner = ACPC;

						NewSquadIndex = `SQUAD_INDEX_TEAMLEADER;

						// We've successfully become the Team Leader
						ROTeamInfo(Team).bHasTeamLeader = true;
						bSuccess = true;
						`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - took role" @ BootedBot @ ROMI.NorthernTeamLeader.Owner);
					}
				}
				else if ( ROMI.NorthernTeamLeader.Owner == none )
				{
					ROMI.NorthernTeamLeader.Owner = C;
					NewSquadIndex = `SQUAD_INDEX_TEAMLEADER;
					// We've successfully become the Team Leader
					ROTeamInfo(Team).bHasTeamLeader = true;
					bSuccess = true;
				}

				`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - using ROMI.NorthernTeamLeader.RoleInfo");
				if ( bSuccess ) NewRoleInfo = ROMI.NorthernTeamLeader.RoleInfo;
			}
			else
			{
				Roles = ROMI.NorthernRoles;
			}
		}
		else
		{
			`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - using Southern Team");
			if ( !bUnlimitedRoles && RoleInfoClass.default.bIsTeamLeader )
			{
				`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - wants Commander");
				if ( ACPC != none )
				{
					if ( ROMI.SouthernTeamLeader.Owner == none || ROMI.SouthernTeamLeader.Owner == ACPC || AIController(ROMI.SouthernTeamLeader.Owner) != none ||
						 !ROMI.OwnerHasRole(ROMI.SouthernTeamLeader.Owner, Team.TeamIndex, `SQUAD_INDEX_TEAMLEADER, 0, WorldInfo) )
					{
						BootedBot = AIController(ROMI.SouthernTeamLeader.Owner);
						ROMI.SouthernTeamLeader.Owner = ACPC;

						NewSquadIndex = `SQUAD_INDEX_TEAMLEADER;
						// We've successfully become the Team Leader
						ROTeamInfo(Team).bHasTeamLeader = true;
						bSuccess = true;
						`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - took role" @ BootedBot @ ROMI.SouthernTeamLeader.Owner);
					}
				}
				else if ( ROMI.SouthernTeamLeader.Owner == none )
				{
					ROMI.SouthernTeamLeader.Owner = C;

					NewSquadIndex = `SQUAD_INDEX_TEAMLEADER;
					// We've successfully become the Team Leader
					ROTeamInfo(Team).bHasTeamLeader = true;
					bSuccess = true;
				}

				`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - using ROMI.SouthernTeamLeader.RoleInfo");
				if ( bSuccess ) NewRoleInfo = ROMI.SouthernTeamLeader.RoleInfo;
			}
			else
			{
				Roles = ROMI.SouthernRoles;
			}
		}

		// If we're the TL, set the class index here and skip the extra stuff later
		if( bSuccess )
		{
			NewClassIndex = NewRoleInfo.ClassIndex;

			// Force the player out of their old squad if they had one
			if( Squad != none && RoleIndex < `MAX_ROLES_PER_SQUAD )
			{
				Squad.LeaveSquad(ACPC, RoleIndex);
			}
		}
		// Otherwise if we chose a non-TL class...
		else if ( DesiredRoleIndex > -1 && (bUnlimitedRoles || bRoleAvailable) )
		{
			NewRoleInfo = new RoleInfoClass;
			// if we're now a pilot, force us into a pilot's only squad
			if( NewRoleInfo != none && NewRoleInfo.bIsPilot )
			{
				if( Squad != none )
					Squad.LeaveSquad(ACPC, RoleIndex);

				NewSquadIndex = `SQUAD_INDEX_PILOT;
			}
			// If we're changing away from TL or pilot, clear our squad index
			else if( NewSquadIndex == `SQUAD_INDEX_TEAMLEADER || NewSquadIndex == `SQUAD_INDEX_PILOT )
			{
				NewSquadIndex = `SQUAD_INDEX_NONE;
			}

			`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - Unlimited Roles");
		}

		if ( NewRoleInfo != none && !bSuccess )
		{
			NewClassIndex = NewRoleInfo.ClassIndex;
			bSuccess = true;

			`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - Success" @ NewSquadIndex @ NewClassIndex);
		}
	}

	if ( bSuccess )
	{
		`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - Success = true");

		// If we selected a different role, clear out the old one
		if ( !bUnlimitedRoles && ClassIndex != NewClassIndex )
		{
			`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - clearing old role");
			ClearRole(C);
		}

		// Save last class if we're playing offline or are a listen server
		if( ClassIndex != NewClassIndex && ACPC != none && ACPC.IsLocalPlayerController() )
		{
			ACPC.LastDisplayedClass = NewClassIndex;
			ACPC.SaveConfig();
		}

		// Replicate the Role Info to all clients
		RoleInfo = NewRoleInfo;
		ClassIndex = NewClassIndex;

		if( OldSquadIndex != NewSquadIndex )
		{
			SquadIndex = NewSquadIndex;

			if( NewSquadIndex > `MAX_SQUADS )
			{
				if( ACPC != none )
					ACPC.ClearPurpleSmokeMarker();
			}

   			if( NewSquadIndex == `SQUAD_INDEX_NONE )
			{
				if( ACPC != none )
					ACPC.AutoSelectSquad();
			}
		}

		// Update the class count for our new class
		if ( Team.TeamIndex == `AXIS_TEAM_INDEX )
		{
			UpdateClassCount(`AXIS_TEAM_INDEX, DesiredRoleIndex);
		}
		else
		{
			UpdateClassCount(`ALLIES_TEAM_INDEX, DesiredRoleIndex);
		}

		// Update the roleinfo in our squad (if we have one)
		if( Squad != none && RoleIndex < `MAX_ROLES_PER_SQUAD )
		{
			Squad.SquadMembers[RoleIndex].RoleInfo = RoleInfo;
		}

		//ClassRank = ROPlayerControllerAC(C).StatsWrite.ClassRanks[RoleInfo.ClassIndex];
		ClassRank = 0;

		`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - NewValues" @ Squad @ SquadIndex @ RoleIndex @ ClassIndex @ ClassRank @ NewRoleInfo);

		// Update our local client if we're playing in solo
		if ( WorldInfo.NetMode != NM_DedicatedServer )
		{
			ReplicatedEvent('SquadIndex');
		}

		// If the controller is a bot, randomise their weapon
		if (AIController(C) != None)
		{
			WeaponSelection.PrimaryWeaponIndex = ChooseRandomPrimaryWeapon(RoleInfo, C, WeaponSelection.PrimaryWeaponIndex);
			WeaponSelection.SecondaryWeaponIndex = ChooseRandomSecondaryWeapon(RoleInfo, C, WeaponSelection.SecondaryWeaponIndex);
		}

		// Clamp weapon index within allowed bounds
		IsWeaponIndexValid(RoleInfo, ROPlayerControllerAC(C), WeaponSelection.PrimaryWeaponIndex, WeaponSelection.SecondaryWeaponIndex);

		// Store weapon selections
		RoleInfo.SetActiveWeaponLoadout(WeaponSelection);

		`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - NewWeapons" @ Squad @ WeaponSelection.PrimaryWeaponIndex @ WeaponSelection.SecondaryWeaponIndex);

		// Have the bot pick a new role
		if( ROAIController(BootedBot) != none )
		{
			// Kick the bot if there's no available role for it to take
			if( ROAIController(BootedBot).ChooseRole() )
			{
				if ( BootedBot.Pawn != none )
				{
					BootedBot.Pawn.Suicide();
				}
			}
			else
				BootedBot.Destroy();
		}

		// Fill in the SRI Array(Team Leaders only)
		if ( RoleInfo.bIsTeamLeader )
		{
			if ( ACPC != none )
			{
				if ( Team.TeamIndex == `AXIS_TEAM_INDEX )
				{
					for ( i = 0; i < ROMI.NorthernSquads.Length; i++ )
					{
						ACPC.SRIArray[i] = ROMI.NorthernSquads[i].SRI;
					}
				}
				else
				{
					for ( i = 0; i < ROMI.SouthernSquads.Length; i++ )
					{
						ACPC.SRIArray[i] = ROMI.SouthernSquads[i].SRI;
					}
				}
			}
		}
		else
		{
			if ( ACPC != none )
			{
				// Make sure their SRI array is empty
				for ( i = 0; i < `MAX_SQUADS; i++ )
				{
					ACPC.SRIArray[i] = none;
				}
			}
		}

		if( ROGameInfo(WorldInfo.Game).bRoundHasBegun && bDead )
		{
			`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - setting SpawnSelection = 0");
			SpawnSelection = 0;
		}
		else
		{
			`LogRoles(C.PlayerReplicationInfo.PlayerName @ "SelectRoleByClass - setting SpawnSelection = 128");
			SpawnSelection = 128;
		}

		if ( Collector != none )
		{
			Collector.UpdateRole(PlayerID,RoleInfo==none?0:INT(RoleInfo.RoleType),RoleInfo.MyName,(Team==none)?-1:Team.TeamIndex);
		}
	}

	// For bots, there's nowhere else appropriate to run this, as
	if( bBot )
	{
		if( PawnHandlerClass == none )
			PawnHandlerClass = class<ROGameInfo>(WorldInfo.GetGameClass()).default.PawnHandlerClass;
		ClientSetCustomCharConfig();
	}

	return bSuccess;
}

defaultproperties
{
	//TeamTankArrayIndex=255	
	PawnHandlerClass=class'ROPawnHandler_Ext'
}
