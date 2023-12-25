class ROHUDWidgetHelicopterInfo_Ext extends ROHUDWidgetHelicopterInfo;

enum EROHelicopterTextures
{
	ROVH_Vehicle,
	ROVH_Engine,
	ROVH_MainRotor,
	ROVH_TailRotor,
	ROVH_LeftSkid,
	ROVH_RightSkid,
	ROVH_TailBoom,
	ROVH_Seat0,
	ROVH_Seat1,
	ROVH_Seat2,
	ROVH_Seat3,
	ROVH_Seat4,
	ROVH_Seat5,
	ROVH_Seat6,
	ROVH_Seat7,
	ROVH_Seat8,
	ROVH_PlayerView,
	ROVH_HitAngleIndicator,
	ROVH_AmmoTexture,
	ROVH_AmmoTypeLabel_1,
	ROVH_AmmoTypeLabel_2,
	ROVH_AmmoCountLabel_1,
	ROVH_AmmoCountLabel_2,
	ROVH_SafeExitTexture,
};

function Initialize(PlayerController HUDPlayerOwner)
{
	local int i;

	for ( i = ROVH_Seat1; i <= ROVH_Seat8; i++ )
	{
  		HUDComponents[i] = new class'ROHUDWidgetComponent';
  		HUDComponents[i].X = HUDComponents[ROVH_Seat0].X;
		HUDComponents[i].Y = HUDComponents[ROVH_Seat0].Y;
		HUDComponents[i].Width = HUDComponents[ROVH_Seat0].Width;
		HUDComponents[i].Height = HUDComponents[ROVH_Seat0].Height;
		HUDComponents[i].TexWidth = HUDComponents[ROVH_Seat0].TexWidth;
		HUDComponents[i].TexHeight = HUDComponents[ROVH_Seat0].TexHeight;
		HUDComponents[i].Tex = HUDComponents[ROVH_Seat0].Tex;
		HUDComponents[i].SortPriority = HUDComponents[ROVH_Seat0].SortPriority;
		HUDComponents[i].bVisible = false;
	}

	HUDComponents[ROVH_AmmoCountLabel_1].Text = AmmoCount1String;
	HUDComponents[ROVH_AmmoTypeLabel_1].Text = AmmoType1String;
	HUDComponents[ROVH_AmmoCountLabel_2].Text = AmmoCount2String;
	HUDComponents[ROVH_AmmoTypeLabel_2].Text = AmmoType2String;

	super.Initialize(HUDPlayerOwner);
}

function UpdateWidget()
{
	local int i, HUDComponentIndex;
	local vector HeloAxis, ComponentPosition, ViewLocation;
	local rotator ViewRotation;
	local bool bIsPilot;
	local bool bIsFreeLooking, bOutOfBounds;

	if ( PlayerOwner == none || PlayerOwner.Pawn == none || !PlayerOwner.myROHUD.bShowVehicleHUD )
	{
		bVisible = false;
		return;
	}
	else
	{
		bVisible = true;
	}

	if ( ROVehicle(PlayerOwner.Pawn) != none )
	{
		MyVehicle = ROVehicleHelicopter(PlayerOwner.Pawn);
		if (MyVehicle != none)
		{
			bIsPilot = true;
			bIsFreeLooking = PlayerOwner.bFreeLooking;
			bOutOfBounds = MyVehicle.VolumeEnterCountBoundary > 0;
		}
	}
	else if ( ROWeaponPawn(PlayerOwner.Pawn) != none )
	{
		MyVehicle = ROVehicleHelicopter(ROWeaponPawn(PlayerOwner.Pawn).MyVehicle);
		bOutOfBounds = ROWeaponPawn(PlayerOwner.Pawn).VolumeEnterCountBoundary > 0;
		bVisible = true;
	}
	else
	{
		//hide widget if not in a helicopter
		bVisible = false;
		return;
	}
	if (MyVehicle == none )
	{
		bVisible = false;
		return;
	}
	else
	{
		bVisible = true;
	}

	HandleHUDOnDemandFadeOut(ROVH_HitAngleIndicator, LastHitFadeTime);

	if ( MyVehicle != none )
	{
		HeloAxis.X = HUDComponents[ROVH_Vehicle].Width / 2;
		HeloAxis.Y = HeloAxis.X;

		UpdateTexturePositions();

		if ( HUDComponents[ROVH_Vehicle].Tex != MyVehicle.HUDBodyTexture )
		{
			HUDComponents[ROVH_Vehicle].Tex = MyVehicle.HUDBodyTexture;
		}

		if ( HUDComponents[ROVH_MainRotor].Tex != MyVehicle.HUDMainRotorTexture )
		{
			HUDComponents[ROVH_MainRotor].Tex = MyVehicle.HUDMainRotorTexture;
		}

		if ( HUDComponents[ROVH_TailRotor].Tex != MyVehicle.HUDTailRotorTexture )
		{
			HUDComponents[ROVH_TailRotor].Tex = MyVehicle.HUDTailRotorTexture;
		}

		if ( HUDComponents[ROVH_LeftSkid].Tex != MyVehicle.HUDLeftSkidTexture )
		{
			HUDComponents[ROVH_LeftSkid].Tex = MyVehicle.HUDLeftSkidTexture;
		}

		if ( HUDComponents[ROVH_RightSkid].Tex != MyVehicle.HUDRightSkidTexture )
		{
			HUDComponents[ROVH_RightSkid].Tex = MyVehicle.HUDRightSkidTexture;
		}

		if ( HUDComponents[ROVH_TailBoom].Tex != MyVehicle.HUDTailBoomTexture )
		{
			HUDComponents[ROVH_TailBoom].Tex = MyVehicle.HUDTailBoomTexture;
		}

		HUDComponentIndex = ROVH_Seat0;

		for ( i = 0; i < MyVehicle.SeatProxies.Length; i++ )
		{
			ComponentPosition = MyVehicle.SeatTextureOffsets[i].PositionOffSet;

			HUDComponents[HUDComponentIndex].bVisible = true;
			HUDComponents[HUDComponentIndex].CurX = HeloAxis.X * HUDComponents[0].ScaleY + ((ComponentPosition.X * HUDComponents[0].ScaleY) - (HUDComponents[HUDComponentIndex].CurWidth / 2));
			HUDComponents[HUDComponentIndex].CurY = HeloAxis.Y * HUDComponents[0].ScaleY + ((ComponentPosition.Y * HUDComponents[0].ScaleY) - (HUDComponents[HUDComponentIndex].CurHeight / 2));

			if ( MyVehicle.Seats.Length > MyVehicle.SeatProxies[i].SeatIndex && !MyVehicle.Seats[MyVehicle.SeatProxies[i].SeatIndex].bNonEnterable
					&& ((MyVehicle.Seats[MyVehicle.SeatProxies[i].SeatIndex].SeatPawn != none
				&& MyVehicle.Seats[MyVehicle.SeatProxies[i].SeatIndex].SeatPawn.Driver != none
				&& !MyVehicle.Seats[MyVehicle.SeatProxies[i].SeatIndex].SeatPawn.bDeleteMe
				&& MyVehicle.Seats[MyVehicle.SeatProxies[i].SeatIndex].SeatPositions[MyVehicle.SeatPositionIndex(MyVehicle.SeatProxies[i].SeatIndex,, true)].SeatProxyIndex == i )
				|| MyVehicle.SeatbDriving(MyVehicle.SeatProxies[i].SeatIndex,,true)) )
			{
				HUDComponents[HUDComponentIndex].DrawColor = MakeColor(0,255,0,128);
				HUDComponents[HUDComponentIndex].Tex = HUDComponents[ROVH_Seat0].default.Tex;

				if ( MyVehicle.Seats[MyVehicle.SeatProxies[i].SeatIndex].SeatPawn == PlayerOwner.Pawn )
				{
					HUDComponents[ROVH_PlayerView].CurX = (HUDComponents[HUDComponentIndex].CurX + ((HUDComponents[HUDComponentIndex].CurWidth / 2)) - HUDComponents[ROVH_PlayerView].CurWidth / 2);
					HUDComponents[ROVH_PlayerView].CurY = (HUDComponents[HUDComponentIndex].CurY + ((HUDComponents[HUDComponentIndex].CurHeight / 2)) - HUDComponents[ROVH_PlayerView].CurHeight / 2);

					PlayerOwner.GetPlayerViewPoint(ViewLocation, ViewRotation);

					// ViewRotation -= MyVehicle.Rotation; need unaltered ViewRotation below

					HUDComponents[ROVH_PlayerView].Rotation.Yaw = (ViewRotation - MyVehicle.Rotation).Yaw;

					MySeatIndex = i;
				}
			}
			else
			{
				HUDComponents[HUDComponentIndex].DrawColor = MakeColor(255,255,255,255);

				if ( MyVehicle.SeatProxies[i].Health <= 0 )
				{
					HUDComponents[HUDComponentIndex].Tex = DeathIcon;
				}
				else
				{
					HUDComponents[HUDComponentIndex].Tex = HUDComponents[ROVH_Seat0].default.Tex;
				}
			}

			HUDComponentIndex++;
		}

		// Weapons
		if ( ROVehicle(PlayerOwner.Pawn) != none )
		{
			HUDComponents[ROVH_AmmoTexture].bVisible = false;
			HUDComponents[ROVH_AmmoTypeLabel_1].bVisible = false;
			HUDComponents[ROVH_AmmoTypeLabel_2].bVisible = false;
			HUDComponents[ROVH_AmmoCountLabel_1].bVisible = false;
			HUDComponents[ROVH_AmmoCountLabel_2].bVisible = false;

			if ( ROVehicle(PlayerOwner.Pawn).Seats[0].Gun != none )
			{
				if( ROVehicle(PlayerOwner.Pawn).Seats[0].Gun.IsA('ROHelicopterWeapon') )
				{
					UpdateAmmoDisplay();
				}
			}
		}
		else if ( ROWeaponPawn(PlayerOwner.Pawn) != none )
		{
			HUDComponents[ROVH_AmmoTexture].bVisible = false;
			HUDComponents[ROVH_AmmoTypeLabel_1].bVisible = false;
			HUDComponents[ROVH_AmmoTypeLabel_2].bVisible = false;
			HUDComponents[ROVH_AmmoCountLabel_1].bVisible = false;
			HUDComponents[ROVH_AmmoCountLabel_2].bVisible = false;

			if ( ROWeaponPawn(PlayerOwner.Pawn).MyVehicleWeapon != none )
			{
				if( ROWeaponPawn(PlayerOwner.Pawn).MyVehicleWeapon.IsA('ROHelicopterWeapon') )
				{
					UpdateAmmoDisplay();
				}
			}
			else
			{
				HUDComponents[ROVH_AmmoTexture].bVisible = false;
				HUDComponents[ROVH_AmmoTypeLabel_1].bVisible = false;
				HUDComponents[ROVH_AmmoTypeLabel_2].bVisible = false;
				HUDComponents[ROVH_AmmoCountLabel_1].bVisible = false;
				HUDComponents[ROVH_AmmoCountLabel_2].bVisible = false;
			}
		}
		else
		{
			HUDComponents[ROVH_AmmoTexture].bVisible = false;
			HUDComponents[ROVH_AmmoTypeLabel_1].bVisible = false;
			HUDComponents[ROVH_AmmoTypeLabel_2].bVisible = false;
			HUDComponents[ROVH_AmmoCountLabel_1].bVisible = false;
			HUDComponents[ROVH_AmmoCountLabel_2].bVisible = false;
		}

		// Safe exit indicator
		if( ( bIsPilot && !bIsFreeLooking && MyVehicle.SafeToExit() ) || MyVehicle.IsSafeExitVector(ViewLocation, ViewRotation) )
		{
			HUDComponents[ROVH_SafeExitTexture].bVisible = true;

			if( bOutOfBounds )
				HUDComponents[ROVH_SafeExitTexture].Tex = SafeExitOOBIcon;
			else
				HUDComponents[ROVH_SafeExitTexture].Tex = SafeExitIcon;
		}
		else
		{
			HUDComponents[ROVH_SafeExitTexture].bVisible = false;
		}

		UpdateDamageIndicators();
	}

	super.UpdateWidget();
}

function UpdateTexturePositions()
{
	if ( MyVehicle != none )
	{
		HUDComponents[ROVH_Engine].CurX = MyVehicle.EngineTextureOffset.PositionOffSet.X * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_Engine].CurY = MyVehicle.EngineTextureOffset.PositionOffSet.Y * HUDComponents[0].ScaleY;
		HUDComponents[ROVH_Engine].CurWidth = MyVehicle.EngineTextureOffset.MySizeX * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_Engine].CurHeight = MyVehicle.EngineTextureOffset.MySizeY * HUDComponents[0].ScaleY;

		HUDComponents[ROVH_MainRotor].CurX = MyVehicle.MainRotorTextureOffset.PositionOffSet.X * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_MainRotor].CurY = MyVehicle.MainRotorTextureOffset.PositionOffSet.Y * HUDComponents[0].ScaleY;
		HUDComponents[ROVH_MainRotor].CurWidth = MyVehicle.MainRotorTextureOffset.MySizeX * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_MainRotor].CurHeight = MyVehicle.MainRotorTextureOffset.MySizeY * HUDComponents[0].ScaleY;

		HUDComponents[ROVH_TailRotor].CurX = MyVehicle.TailRotorTextureOffset.PositionOffSet.X * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_TailRotor].CurY = MyVehicle.TailRotorTextureOffset.PositionOffSet.Y * HUDComponents[0].ScaleY;
		HUDComponents[ROVH_TailRotor].CurWidth = MyVehicle.TailRotorTextureOffset.MySizeX * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_TailRotor].CurHeight = MyVehicle.TailRotorTextureOffset.MySizeY * HUDComponents[0].ScaleY;

		HUDComponents[ROVH_LeftSkid].CurX = MyVehicle.LeftSkidTextureOffset.PositionOffSet.X * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_LeftSkid].CurY = MyVehicle.LeftSkidTextureOffset.PositionOffSet.Y * HUDComponents[0].ScaleY;
		HUDComponents[ROVH_LeftSkid].CurWidth = MyVehicle.LeftSkidTextureOffset.MySizeX * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_LeftSkid].CurHeight = MyVehicle.LeftSkidTextureOffset.MySizeY * HUDComponents[0].ScaleY;

		HUDComponents[ROVH_RightSkid].CurX = MyVehicle.RightSkidTextureOffset.PositionOffSet.X * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_RightSkid].CurY = MyVehicle.RightSkidTextureOffset.PositionOffSet.Y * HUDComponents[0].ScaleY;
		HUDComponents[ROVH_RightSkid].CurWidth = MyVehicle.RightSkidTextureOffset.MySizeX * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_RightSkid].CurHeight = MyVehicle.RightSkidTextureOffset.MySizeY * HUDComponents[0].ScaleY;

		HUDComponents[ROVH_TailBoom].CurX = MyVehicle.TailBoomTextureOffset.PositionOffSet.X * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_TailBoom].CurY = MyVehicle.TailBoomTextureOffset.PositionOffSet.Y * HUDComponents[0].ScaleY;
		HUDComponents[ROVH_TailBoom].CurWidth = MyVehicle.TailBoomTextureOffset.MySizeX * HUDComponents[0].ScaleX;
		HUDComponents[ROVH_TailBoom].CurHeight = MyVehicle.TailBoomTextureOffset.MySizeY * HUDComponents[0].ScaleY;
	}
}

function UpdateDamageIndicators()
{
	if ( MyVehicle == none )
	{
		return;
	}

	// Rotors
	if ( MyVehicle.bMainRotorDestroyed )
	{
		HUDComponents[ROVH_MainRotor].bVisible = true;
		HUDComponents[ROVH_MainRotor].DrawColor = DestroyedColor;
	}
	else if ( MyVehicle.bMainRotorDamaged )
	{
		HUDComponents[ROVH_MainRotor].bVisible = true;
		HUDComponents[ROVH_MainRotor].DrawColor = DamagedColor;
	}
	else if ( HUDComponents[ROVH_MainRotor].bVisible )
	{
		HUDComponents[ROVH_MainRotor].bVisible = false;
		HUDComponents[ROVH_MainRotor].DrawColor = NeutralColor;
	}

	if ( MyVehicle.bTailRotorDestroyed )
	{
		HUDComponents[ROVH_TailRotor].bVisible = true;
		HUDComponents[ROVH_TailRotor].DrawColor = DestroyedColor;
	}
	else if ( MyVehicle.bTailRotorDamaged )
	{
		HUDComponents[ROVH_TailRotor].bVisible = true;
		HUDComponents[ROVH_TailRotor].DrawColor = DamagedColor;
	}
	else if ( HUDComponents[ROVH_TailRotor].bVisible )
	{
		HUDComponents[ROVH_TailRotor].bVisible = false;
		HUDComponents[ROVH_TailRotor].DrawColor = NeutralColor;
	}

	if ( MyVehicle.bEngineDestroyed )
	{
		HUDComponents[ROVH_Engine].bVisible = true;
		HUDComponents[ROVH_Engine].DrawColor = DestroyedColor;
	}
	else if ( MyVehicle.bEngineDamaged )
	{
		HUDComponents[ROVH_Engine].bVisible = true;
		HUDComponents[ROVH_Engine].DrawColor = DamagedColor;
	}
	else if ( HUDComponents[ROVH_Engine].bVisible )
	{
		HUDComponents[ROVH_Engine].bVisible = false;
		HUDComponents[ROVH_Engine].DrawColor = NeutralColor;
	}

	if ( MyVehicle.bBrokeLeftSkid )
	{
		HUDComponents[ROVH_LeftSkid].bVisible = true;
		HUDComponents[ROVH_LeftSkid].DrawColor = DestroyedColor;
	}
	else if ( HUDComponents[ROVH_LeftSkid].bVisible )
	{
		HUDComponents[ROVH_LeftSkid].bVisible = false;
		HUDComponents[ROVH_LeftSkid].DrawColor = NeutralColor;
	}

	if ( MyVehicle.bBrokeRightSkid )
	{
		HUDComponents[ROVH_RightSkid].bVisible = true;
		HUDComponents[ROVH_RightSkid].DrawColor = DestroyedColor;
	}
	else if ( HUDComponents[ROVH_RightSkid].bVisible )
	{
		HUDComponents[ROVH_RightSkid].bVisible = false;
		HUDComponents[ROVH_RightSkid].DrawColor = NeutralColor;
	}

	if ( MyVehicle.bTailBoomDestroyed )
	{
		HUDComponents[ROVH_TailBoom].bVisible = true;
		HUDComponents[ROVH_TailBoom].DrawColor = DestroyedColor;
	}
	else if ( HUDComponents[ROVH_TailBoom].bVisible )
	{
		HUDComponents[ROVH_TailBoom].bVisible = false;
		HUDComponents[ROVH_TailBoom].DrawColor = NeutralColor;
	}
}

function UpdateAmmoDisplay()
{
	local ROHelicopterWeapon ROHW;
	local int AmmoTypesVisible;
	local float AmmoPct;

	if( ROVehicle(PlayerOwner.Pawn) != none )
		ROHW = ROHelicopterWeapon(ROVehicle(PlayerOwner.Pawn).Seats[0].Gun);
	else if( ROWeaponPawn(PlayerOwner.Pawn) != none )
		ROHW = ROHelicopterWeapon(ROWeaponPawn(PlayerOwner.Pawn).MyVehicleWeapon);

	if ( ROHW == none || !ROHW.bShowAmmoCount )
		return;

	// First time?
	if ( !HUDComponents[ROVH_AmmoTexture].bVisible )
	{
		if ( MyVehicle != none && HUDComponents[ROVH_AmmoTexture].Tex != MyVehicle.HUDAmmoTextures[MySeatIndex] )
		{
			HUDComponents[ROVH_AmmoTexture].Tex = MyVehicle.HUDAmmoTextures[MySeatIndex];
		}

		HUDComponents[ROVH_AmmoTexture].bVisible = true;
		HUDComponents[ROVH_AmmoCountLabel_1].bVisible = true;
		HUDComponents[ROVH_AmmoTypeLabel_1].bVisible = true;

		if( ROHW.FiringStatesArray[1] != '' )
		{
			HUDComponents[ROVH_AmmoCountLabel_2].bVisible = true;
			HUDComponents[ROVH_AmmoTypeLabel_2].bVisible = true;
			//HUDComponents[ROVH_AmmoTypeLabel_2].DrawColor = MakeColor(255, 255, 255, 255);
		}
		else
		{
			HUDComponents[ROVH_AmmoCountLabel_2].bVisible = false;
			HUDComponents[ROVH_AmmoTypeLabel_2].bVisible = false;
			//HUDComponents[ROVH_AmmoTypeLabel_2].DrawColor = MakeColor(255, 255, 255, 255);
		}
	}

	AmmoTypesVisible = 0;

	// re-order ammo types
	if ( HUDComponents[ROVH_AmmoTypeLabel_1].bVisible )
	{
		HUDComponents[ROVH_AmmoTypeLabel_1].Text = GetAmmoText(ROHW, AmmoTypesVisible);

		if( ROHW.bShowAmmoAsPercentage )
		{
			AmmoPct = ROHW.GetHeloAmmoPct(AmmoTypesVisible++) * 100;
			HUDComponents[ROVH_AmmoCountLabel_1].Text = Left( string(AmmoPct), InStr(string(AmmoPct), ".") + 2 ) $ "%";
		}
		else
			HUDComponents[ROVH_AmmoCountLabel_1].Text = string( ROHW.GetHeloAmmoCount(AmmoTypesVisible++) );
	}
	if ( HUDComponents[ROVH_AmmoTypeLabel_2].bVisible )
	{
		HUDComponents[ROVH_AmmoTypeLabel_2].Text = GetAmmoText(ROHW, AmmoTypesVisible);

		if( ROHW.bShowAmmoAsPercentage )
		{
			AmmoPct = ROHW.GetHeloAmmoPct(AmmoTypesVisible++) * 100;
			HUDComponents[ROVH_AmmoCountLabel_2].Text = Left( string(AmmoPct), InStr(string(AmmoPct), ".") + 2 ) $ "%";
		}
		else
			HUDComponents[ROVH_AmmoCountLabel_2].Text = string( ROHW.GetHeloAmmoCount(AmmoTypesVisible++) );
	}
}

/** Returns the name of the selected ammo type for the HUD */
function string GetAmmoText(ROHelicopterWeapon ROHW, int AmmoIndex)
{
	//return class<RORocketProjectile>(RocketPods.MainGunProjectiles[ProjectileIndex]).default.AmmoTypeShortName;
	return ROHW.AmmoDisplayNames[AmmoIndex];
}

function ShowVehicleHit(int HitRotation)
{
	HUDComponents[ROVH_HitAngleIndicator].Rotation.Yaw = HitRotation;
	HandleHUDOnDemandFadeIn(ROVH_HitAngleIndicator, LastHitFadeTime);
}

// Hide all seat icons. Called when entering a new vehicle
function ResetSeatVisibility()
{
	local int i;

	for ( i = ROVH_Seat1; i <= ROVH_Seat8; i++ )
	{
		HUDComponents[i].bVisible = false;
	}
}

function HandleCanvasSizeChange(Canvas HUDCanvas, float ScaleX, float ScaleY)
{
	super.HandleCanvasSizeChange(HUDCanvas, ScaleY, ScaleY);
}

defaultproperties
{
	X=0.0
	Y=-140.0

	DeathIcon=Texture2D'ui_textures.OverheadMap.ui_overheadmap_icons_death'
	SafeExitIcon=Texture2D'VN_UI_Textures.HUD.Vehicles.UI_HUD_Helo_SafeExit'
	SafeExitOOBIcon=Texture2D'VN_UI_Textures.HUD.Vehicles.UI_HUD_Helo_SafeExit_OOB'

	DamagedColor=(R=239,G=187,B=8,A=255)
	DestroyedColor=(R=200,G=60,B=0,A=255)
	NeutralColor=(R=255,G=255,B=255,A=255)

	FadeOutDelay=0.25

	/*********************************************************************************************
	* HUD Components
	********************************************************************************************* */
	Begin Object Class=ROHUDWidgetComponent Name=VehicleTexture
		X=0
		Y=0
		Width=140
		Height=140
		TexWidth=256
		TexHeight=256
		Tex=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_body'
		bVisible=true
		SortPriority=DSP_AboveNormal
		FadeOutTime=0.25
	End Object
	HUDComponents(ROVH_Vehicle)=VehicleTexture

	Begin Object Class=ROHUDWidgetComponent Name=Engine
		X=0
		Y=0
		Width=32
		Height=32
		TexWidth=64
		TexHeight=64
		Tex=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_engine'
		bVisible=false
		SortPriority=DSP_High
		FadeOutTime=0.25
	End Object
	HUDComponents(ROVH_Engine)=Engine

	Begin Object Class=ROHUDWidgetComponent Name=MainRotor
		X=0
		Y=0
		Width=140
		Height=140
		TexWidth=256
		TexHeight=256
		Tex=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_mainrotor'
		bVisible=false
		SortPriority=DSP_High
		FadeOutTime=0.25
	End Object
	HUDComponents(ROVH_MainRotor)=MainRotor

	Begin Object Class=ROHUDWidgetComponent Name=TailRotor
		X=0
		Y=0
		Width=8
		Height=32
		TexWidth=16
		TexHeight=64
		Tex=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_tailrotor'
		bVisible=false
		SortPriority=DSP_High
		FadeOutTime=0.25
	End Object
	HUDComponents(ROVH_TailRotor)=TailRotor

	Begin Object Class=ROHUDWidgetComponent Name=LeftSkid
		X=0
		Y=0
		Width=8
		Height=32
		TexWidth=32
		TexHeight=128
		Tex=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_leftskid'
		bVisible=false
		SortPriority=DSP_High
		FadeOutTime=0.25
	End Object
	HUDComponents(ROVH_LeftSkid)=LeftSkid

	Begin Object Class=ROHUDWidgetComponent Name=RightSkid
		X=0
		Y=0
		Width=8
		Height=32
		TexWidth=32
		TexHeight=128
		Tex=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_rightskid'
		bVisible=false
		SortPriority=DSP_High
		FadeOutTime=0.25
	End Object
	HUDComponents(ROVH_RightSkid)=RightSkid

	Begin Object Class=ROHUDWidgetComponent Name=TailBoom
		X=0
		Y=0
		Width=140
		Height=140
		TexWidth=256
		TexHeight=256
		Tex=Texture2D'VN_UI_Textures.HUD.Vehicles.ui_hud_helo_uh1h_tailboom'
		bVisible=false
		SortPriority=DSP_High
		FadeOutTime=0.25
	End Object
	HUDComponents(ROVH_TailBoom)=TailBoom

	Begin Object Class=ROHUDWidgetComponent Name=Seat0Texture
		X=0
		Y=0
		Width=12
		Height=12
		TexWidth=64
		TexHeight=64
		Tex=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_position'
		bVisible=true
		SortPriority=DSP_Highest
		FadeOutTime=0.25
	End Object
	HUDComponents(ROVH_Seat0)=Seat0Texture

	Begin Object Class=ROHUDWidgetComponent Name=PlayerViewTexture
		X=0
		Y=0
		Width=48
		Height=48
		TexWidth=64
		TexHeight=64
		SortPriority=DSP_Highest
		Tex=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_viewdirection'
		DrawColor=(R=32,G=192,B=32)
		FadeOutTime=0.25
	End Object
	HUDComponents(ROVH_PlayerView)=PlayerViewTexture

	Begin Object Class=ROHUDWidgetComponent Name=HitAngleTexture
		X=0
		Y=0
		Width=140
		Height=140
		TexWidth=256
		TexHeight=256
		Tex=Texture2D'ui_textures.HUD.Vehicles.ui_hud_tank_damage_hit_direction'
		FadeOutTime=0.25
		bFadedOut=true
		SortPriority=DSP_Highest
	End Object
	HUDComponents(ROVH_HitAngleIndicator)=HitAngleTexture

	Begin Object Class=ROHUDWidgetComponent Name=AmmoTex
		X=18
		Y=0
		Width=140
		Height=140
		TexWidth=256
		TexHeight=256
		Tex=Texture2D'VN_UI_Textures.HUD.Vehicles.UI_HUD_Helo_Ammo_OH6_Pilot'
		FadeOutTime=0.25
		bVisible=false
		SortPriority=DSP_AboveNormal
	End Object
	HUDComponents(ROVH_AmmoTexture)=AmmoTex

	Begin Object Class=ROHUDWidgetComponent Name=AmmoCountLabel_1
		X=125
		Y=53
		TextFont=Font'VN_UI_Fonts.Font_VN_Clean'
		TextScale=0.28
		DrawColor=(R=255,G=255,B=255,A=255)
		bDropShadow=true
		DropShadowOffset=(X=1,Y=1)
		FadeOutTime=0.25
		TextAlignment=ROHTA_LEFT
		bVisible=false
		SortPriority=DSP_AboveNormal
	End Object
	HUDComponents(ROVH_AmmoCountLabel_1)=AmmoCountLabel_1

	Begin Object Class=ROHUDWidgetComponent Name=AmmoCountLabel_2
		X=125
		Y=74
		TextFont=Font'VN_UI_Fonts.Font_VN_Clean'
		TextScale=0.28
		DrawColor=(R=255,G=255,B=255,A=255)
		bDropShadow=true
		DropShadowOffset=(X=1,Y=1)
		FadeOutTime=0.25
		TextAlignment=ROHTA_LEFT
		bVisible=false
		SortPriority=DSP_AboveNormal
	End Object
	HUDComponents(ROVH_AmmoCountLabel_2)=AmmoCountLabel_2

	Begin Object Class=ROHUDWidgetComponent Name=AmmoTypeLabel_1
		X=170
		Y=53
		TextFont=Font'VN_UI_Fonts.Font_VN_Clean'
		TextScale=0.28
		DrawColor=(R=255,G=255,B=255,A=255)
		bDropShadow=true
		DropShadowOffset=(X=1,Y=1)
		FadeOutTime=0.25
		TextAlignment=ROHTA_LEFT
		bVisible=false
		SortPriority=DSP_AboveNormal
	End Object
	HUDComponents(ROVH_AmmoTypeLabel_1)=AmmoTypeLabel_1

	Begin Object Class=ROHUDWidgetComponent Name=AmmoTypeLabel_2
		X=170
		Y=74
		TextFont=Font'VN_UI_Fonts.Font_VN_Clean'
		TextScale=0.28
		DrawColor=(R=255,G=255,B=255,A=255)
		bDropShadow=true
		DropShadowOffset=(X=1,Y=1)
		FadeOutTime=0.25
		TextAlignment=ROHTA_LEFT
		bVisible=false
		SortPriority=DSP_AboveNormal
	End Object
	HUDComponents(ROVH_AmmoTypeLabel_2)=AmmoTypeLabel_2

	Begin Object Class=ROHUDWidgetComponent Name=SafeExitTex
		X=210
		Y=50
		Width=64
		Height=64
		TexWidth=128
		TexHeight=128
		Tex=Texture2D'VN_UI_Textures.HUD.Vehicles.UI_HUD_Helo_SafeExit'
		FadeOutTime=0.25
		bVisible=false
		SortPriority=DSP_AboveNormal
	End Object
	HUDComponents(ROVH_SafeExitTexture)=SafeExitTex
}
