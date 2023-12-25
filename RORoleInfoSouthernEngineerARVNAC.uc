//=============================================================================
// RORoleInfoSouthernEngineerARVN
//=============================================================================
// Default settings for the ARVN Engineer role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class RORoleInfoSouthernEngineerARVNAC extends RORoleInfoSouthernInfantry
	HideDropDown;

DefaultProperties
{
	RoleType=RORIT_Engineer
	ClassTier=3
	ClassIndex=`ROCI_ENGINEER
	//bCanCompleteMiniObjectives=true

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M1918_BAR',class'ROGame.ROWeap_M2_Carbine'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M61_GrenadeSingle',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
		)}
	Items[RORIGM_Campaign_Early]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M1918_BAR'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M61_GrenadeSingle',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
		)}
	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M1918_BAR',class'ROGame.ROWeap_M2_Carbine'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M61_GrenadeSingle',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
		)}
	Items[RORIGM_Campaign_Late]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M1918_BAR',class'ROGame.ROWeap_M16A1_AssaultRifle'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M61_GrenadeSingle',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
		)}

	// Secondary Weapons
	bAllowPistolsInRealism=false

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sapper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sapper'
}
