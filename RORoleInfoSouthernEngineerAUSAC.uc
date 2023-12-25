//=============================================================================
// RORoleInfoSouthernEngineerAUS
//=============================================================================
// Default settings for the Australian Engineer role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class RORoleInfoSouthernEngineerAUSAC extends RORoleInfoSouthernInfantryAus
	hidedropdown;

DefaultProperties
{
	RoleType=RORIT_Engineer
	ClassTier=3
	ClassIndex=`ROCI_ENGINEER
	//bCanCompleteMiniObjectives=true

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_F1_SMG',class'ROGame.ROWeap_M9_Flamethrower'),
					DisableSecondaryForPrimary=(true,false),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M61_Grenade',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
					OtherItemsStartIndexForPrimary=(0,0),
					NumOtherItemsForPrimary=(0,255),
	)}

	Items[RORIGM_Campaign_Early]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M9_Flamethrower'),
					DisableSecondaryForPrimary=(false),
	)}

	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_F1_SMG',class'ROGame.ROWeap_M9_Flamethrower'),
					DisableSecondaryForPrimary=(true,false),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M61_Grenade',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
					OtherItemsStartIndexForPrimary=(0,0),
					NumOtherItemsForPrimary=(0,255),
	)}

	Items[RORIGM_Campaign_Late]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_F1_SMG',class'ROGame.ROWeap_M9_Flamethrower'),
					DisableSecondaryForPrimary=(true,false),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M61_Grenade',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
					OtherItemsStartIndexForPrimary=(0,0),
					NumOtherItemsForPrimary=(0,255),
	)}

	// Secondary Weapons
	bAllowPistolsInRealism=true	// This will only apply to the flamethrower. Selecting another weapon will disable the pistol

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sapper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sapper'
}
