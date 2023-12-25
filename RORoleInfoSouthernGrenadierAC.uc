//=============================================================================
// RORoleInfoSouthernGrenadier
//=============================================================================
// Default settings for the American Grenadier role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class RORoleInfoSouthernGrenadierAC extends RORoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Support
	ClassTier=2
	ClassIndex=`ROCI_HEAVY // 5

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M79_GrenadeLauncher',class'ROGame.ROWeap_M2_Carbine',class'ROGame.ROWeap_M16A1_AssaultRifle'),
					// secondary items:
					SecondaryWeapons=(class'ROAmmoCrate.ROWeap_M72_RocketLauncher'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_M61_GrenadeSingle'),
					OtherItemsStartIndexForPrimary=(0, 0,0),
					NumOtherItemsForPrimary=(0, 0,0),
		)}
	Items[RORIGM_Campaign_Early]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M79_GrenadeLauncher',class'ROGame.ROWeap_M2_Carbine'),
					//
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_M61_GrenadeSingle'),
					OtherItemsStartIndexForPrimary=(0, 0,0),
					NumOtherItemsForPrimary=(0, 0,0),
		)}
	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M79_GrenadeLauncher',class'ROGame.ROWeap_M16A1_AssaultRifle'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_M61_GrenadeSingle'),
					OtherItemsStartIndexForPrimary=(0, 0,0),
					NumOtherItemsForPrimary=(0, 0,0),
		)}
	Items[RORIGM_Campaign_Late]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M79_GrenadeLauncher',class'ROGame.ROWeap_M16A1_AssaultRifle_Late'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_M61_GrenadeSingle'),
					OtherItemsStartIndexForPrimary=(0, 0,0),
					NumOtherItemsForPrimary=(0, 0,0),
		)}


	// Secondary Weapons
	bAllowPistolsInRealism=true

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_grenadier'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_grenadier'
}
