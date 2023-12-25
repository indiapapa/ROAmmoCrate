//=============================================================================
// RORoleInfoSouthernPointman
//=============================================================================
// Default settings for the American Pointman role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class RORoleInfoSouthernPointmanAC extends RORoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Scout
	ClassTier=2
	ClassIndex=`ROCI_SCOUT // 1

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_XM177E1_Carbine',class'ROGame.ROWeap_M2_Carbine'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M8_Smoke',class'ROGame.ROWeap_M18_Claymore'),
		)}
	Items[RORIGM_Campaign_Early]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M2_Carbine'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M8_Smoke',class'ROGame.ROWeap_M18_Claymore'),
		)}
	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M2_Carbine',class'ROGame.ROWeap_XM177E1_Carbine'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M8_Smoke',class'ROGame.ROWeap_M18_Claymore'),
		)}
	Items[RORIGM_Campaign_Late]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_XM177E1_Carbine_Late'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M8_Smoke',class'ROGame.ROWeap_M18_Claymore'),
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_scout'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_scout'
}
