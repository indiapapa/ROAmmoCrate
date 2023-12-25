//=============================================================================
// RORoleInfoNorthernSapper
//=============================================================================
// Default settings for the Vietnamese Sapper role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class RORoleInfoNorthernSapperAC extends RORoleInfoNorthernInfantry;

defaultproperties
{
	RoleType=RORIT_Engineer
	ClassTier=3
	ClassIndex=`ROCI_ENGINEER // 4
//	bCanCompleteMiniObjectives=true

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_SKS_Rifle',class'ROGame.ROWeap_K50M_SMG',class'ROGame.ROWeap_MAT49_SMG'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_MD82_Mine', class'ROAmmoCrate.ROWeap_VietSatchel_Ext'),
		)}
	Items[RORIGM_Campaign_Early]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_PPSH41_SMG',class'ROGame.ROWeap_MAT49_SMG'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_MD82_Mine'),
		)}
	Items[RORIGM_Campaign_Mid]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_AK47_AssaultRifle',class'ROGame.ROWeap_K50M_SMG',class'ROGame.ROWeap_MAT49_SMG'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_MD82_Mine', class'ROAmmoCrate.ROWeap_VietSatchel_Ext'),
		)}
	Items[RORIGM_Campaign_Late]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_AK47_AssaultRifle',class'ROGame.ROWeap_K50M_SMG',class'ROGame.ROWeap_MAT49_SMG'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_MD82_Mine', class'ROAmmoCrate.ROWeap_VietSatchel_Ext'),
		)}

	bAllowPistolsInRealism=false

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sapper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sapper'
}
