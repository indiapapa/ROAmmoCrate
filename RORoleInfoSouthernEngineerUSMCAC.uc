//-----------------------------------------------------------
//
//-----------------------------------------------------------
class RORoleInfoSouthernEngineerUSMCAC extends RORoleInfoSouthernEngineer
	HideDropDown;

DefaultProperties
{
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
					PrimaryWeapons=(class'ROGame.ROWeap_M2_Carbine',class'ROGame.ROWeap_M1918_BAR',class'ROGame.ROWeap_M9_Flamethrower'),
					// Secondary Weapons
					DisableSecondaryForPrimary=(true, true, true, false),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_C4_Explosive',class'ROAmmoCrate.ROItem_USPlaceableAmmoCrate_Ext'),
					OtherItemsStartIndexForPrimary=(0, 0, 0, 0),
					NumOtherItemsForPrimary=(0, 0, 0, 255)
		)}
	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M2_Carbine',class'ROGame.ROWeap_M9_Flamethrower'),
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
}
