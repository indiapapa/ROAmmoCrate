//=============================================================================
// RORoleInfoSouthernRifleman
//=============================================================================
// Default settings for the American Rifleman role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class RORoleInfoSouthernRiflemanAC extends RORoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Rifleman
	ClassTier=1
	ClassIndex=`ROCI_RIFLEMAN // 0

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M16A1_AssaultRifle',class'ROGame.ROWeap_M14_Rifle'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M61_Grenade'),
		)}
	Items[RORIGM_Campaign_Early]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M16A1_AssaultRifle',class'ROGame.ROWeap_M14_Rifle'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M61_Grenade'),
		)}
	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M16A1_AssaultRifle'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M61_Grenade'),
		)}
	Items[RORIGM_Campaign_Late]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M16A1_AssaultRifle'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M61_Grenade'),
		)}

	bAllowPistolsInRealism=false

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_grunt'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_grunt'
}
