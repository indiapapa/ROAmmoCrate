//=============================================================================
// RORoleInfoNorthernSapperNLF
//=============================================================================
// Default settings for the Vietnamese Sapper role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class RORoleInfoNorthernSapperNLF_AC extends RORoleInfoNorthernSapperAC
	HideDropDown;

DefaultProperties
{
	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_PPSH41_SMG',class'ROGame.ROWeap_MP40_SMG',class'ROGame.ROWeap_MAS49_Rifle_Grenade'),
					OtherItems=(class'ROGame.ROWeap_MD82_Mine',class'ROGame.ROWeap_Fougasse_Mine'),
					OtherItemsStartIndexForPrimary=(0, 1, 0),
					NumOtherItemsForPrimary=(1, 1, 255),
		)}
	Items[RORIGM_Campaign_Early]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_PPSH41_SMG',class'ROGame.ROWeap_MP40_SMG',class'ROGame.ROWeap_M1918_BAR',class'ROGame.ROWeap_MAS49_Rifle_Grenade'),
					OtherItems=(class'ROGame.ROWeap_MD82_Mine',class'ROGame.ROWeap_Fougasse_Mine'),
					OtherItemsStartIndexForPrimary=(0, 1, 0, 0),
					NumOtherItemsForPrimary=(1, 1, 1, 255),
		)}
	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_PPSH41_SMG',class'ROGame.ROWeap_MP40_SMG',class'ROGame.ROWeap_MAS49_Rifle_Grenade'),
					OtherItems=(class'ROGame.ROWeap_MD82_Mine',class'ROGame.ROWeap_Fougasse_Mine'),
					OtherItemsStartIndexForPrimary=(0, 1, 0),
					NumOtherItemsForPrimary=(1, 1, 255),
		)}
	Items[RORIGM_Campaign_Late]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_AK47_AssaultRifle',class'ROGame.ROWeap_PPSH41_SMG',class'ROGame.ROWeap_MP40_SMG',class'ROGame.ROWeap_MAS49_Rifle_Grenade'),
					OtherItems=(class'ROGame.ROWeap_MD82_Mine',class'ROGame.ROWeap_Fougasse_Mine'),
					OtherItemsStartIndexForPrimary=(0, 0, 1, 0),
					NumOtherItemsForPrimary=(1, 1, 1, 255),
		)}
}
