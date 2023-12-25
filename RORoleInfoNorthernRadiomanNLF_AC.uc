//=============================================================================
// RORoleInfoNorthernRadiomanNLF
//=============================================================================
// default settings for the Vietnamese Radioman role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class RORoleInfoNorthernRadiomanNLF_AC extends RORoleInfoNorthernRadiomanAC
	HideDropDown;

DefaultProperties
{
	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_SKS_Rifle',class'ROGame.ROWeap_MN9130_Rifle',class'ROGame.ROWeap_IZH43_Shotgun',class'ROGame.ROWeap_MP40_SMG'),
		)}
	Items[RORIGM_Campaign_Early]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_MP40_SMG',class'ROGame.ROWeap_MN9130_Rifle'),
		)}
	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_AK47_AssaultRifle_NLF',class'ROGame.ROWeap_MP40_SMG',class'ROGame.ROWeap_MN9130_Rifle'),
		)}
	Items[RORIGM_Campaign_Late]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_AK47_AssaultRifle',class'ROGame.ROWeap_MP40_SMG',class'ROGame.ROWeap_MN9130_Rifle',class'ROGame.ROWeap_Mat49_SMG'),
		)}
}
