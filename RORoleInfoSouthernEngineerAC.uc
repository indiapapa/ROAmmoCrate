//=============================================================================
// RORoleInfoSouthernEngineer
//=============================================================================
// Default settings for the American Engineer role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class RORoleInfoSouthernEngineerAC extends RORoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Engineer
	ClassTier=3
	ClassIndex=`ROCI_ENGINEER
	//bCanCompleteMiniObjectives=true

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M2_Carbine',class'ROGame.ROWeap_M9_Flamethrower'),
					// Secondary Weapons
					DisableSecondaryForPrimary=(true, true, true, false),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
					OtherItemsStartIndexForPrimary=(0, 0, 0, 0),
					NumOtherItemsForPrimary=(0, 0, 0, 255)
		)}
	Items[RORIGM_Campaign_Early]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M9_Flamethrower'),
					// Secondary Weapons
					DisableSecondaryForPrimary=(true, true, false),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
					OtherItemsStartIndexForPrimary=(0, 0, 0),
					NumOtherItemsForPrimary=(0, 0, 255)
		)}
	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M9_Flamethrower'),
					// Secondary Weapons
					DisableSecondaryForPrimary=(true, true, false),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
					OtherItemsStartIndexForPrimary=(0, 0, 0),
					NumOtherItemsForPrimary=(0, 0, 255)
		)}
	Items[RORIGM_Campaign_Late]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M14_Rifle',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M9_Flamethrower'),
					// Secondary Weapons
					DisableSecondaryForPrimary=(true, true, true, false),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
					OtherItemsStartIndexForPrimary=(0, 0, 0, 0),
					NumOtherItemsForPrimary=(0, 0, 0, 255)
		)}

	// Secondary Weapons
	bAllowPistolsInRealism=true	// This will only apply to the flamethrower. Selecting another weapon will disable the pistol

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sapper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sapper'
}
