//-----------------------------------------------------------
//
//-----------------------------------------------------------
class RORoleInfoSouthernGrenadierUSMCAC extends RORoleInfoSouthernGrenadierAC;

DefaultProperties
{
	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M79_GrenadeLauncher',class'ROGame.ROWeap_M16A1_AssaultRifle',class'ROGame.ROWeap_M2_Carbine'),
					SecondaryWeapons=(class'ROAmmoCrate.ROWeap_M72_RocketLauncher'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_M61_GrenadeSingle'),
					OtherItemsStartIndexForPrimary=(0,0,0),
					NumOtherItemsForPrimary=(0, 0,0),
		)}
}
