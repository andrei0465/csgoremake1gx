#include <amxmodx>
#include <amxmisc>
#include <nvault>
#include <fakemeta>
#include <colorchat>
#include <hamsandwich>
#include <cstrike>
#include <updater>
#include <xs>
#include <unixtime>

#define PLUGIN "CSGO Remake 1Gx"
#define VERSION "v0.2-dev"
#define AUTHOR "Kuamquat"

#pragma compress 1
#pragma semicolon 1

new TimeStamp;

new g_Vault;

new bool:g_bLogged[33];
new bool:g_bSkinHasModelP[96];
//new bool:g_bSkinHasModelW[96];
new g_MsgSync;

new g_WarmUpSync;

new g_szCfgDir[48];
new g_szConfigFile[48];

new Array:g_aRankName;
new Array:g_aRankKills;

new g_szDefaultSkinModel[31][48];
new g_szDefaultPSkinModel[31][48];
//new g_szDefaultWSkinModel[31][48];

new Array:g_aSkinWeaponID;
new Array:g_aSkinName;
new Array:g_aSkinModel;
new Array:g_aSkinModelP;
//new Array:g_aSkinModelW;
new Array:g_aSkinType;
new Array:g_aSkinChance;
new Array:g_aSkinCostMin;

new Array:g_aDropSkin;
new Array:g_aCraftSkin;

new Array:g_aTombola;

new Array:g_aJackpotSkins;
new Array:g_aJackpotUsers;

new g_iRanksNum;
new g_iSkinsNum;

new g_iUserSelectedSkin[33][31];
new g_iUserSkins[33][96];
new g_iUserPoints[33];
new g_iUserDusts[33];
new g_iUserKeys[33];
new g_iUserCases[33];
new g_iUserKills[33];
new g_iUserRank[33];

new g_iDropSkinNum;
new g_iCraftSkinNum;

new g_szName[33][32];
new g_szUserPassword[33][16];
new g_szUserSavedPass[33][16];
new g_iUserPassFail[33];

new c_RegOpen;
new c_UpdatePlugin;

new fw_CUIC;
new HamHook:fw_PA[3];
new HamHook:fw_SA[3];
new HamHook:fw_ID[31];
new HamHook:fw_ICD[31];
new HamHook:fw_S1;
new HamHook:fw_S2;
new HamHook:fw_K1;
new HamHook:fw_K2;

new c_DropType;
new g_iDropType = 1;

new c_KeyPrice;
new g_iKeyPrice = 250;

new c_DropChance;
new g_iDropChance = 75;

new c_CraftCost;
new g_iCraftCost = 10;

new c_Suicide;

new g_iLastOpenCraft[33];

new c_ShowDropCraft;
new g_iShowDropCraft;

new g_Msg_SayText;
new g_Msg_DeathMsg;
new g_Msg_StatusIcon;

new g_iUserSellItem[33];
new g_iUserItemPrice[33];
new g_bUserSell[33];
new c_WaitForPlace;
new g_iWaitForPlace = 30;
new g_iLastPlace[33];
new c_KeyMinCost;
new g_iKeyMinCost = 100;
new c_CostMultiplier;
new g_iCostMultiplier = 20;
new c_CaseMinCost;
new g_iCaseMinCost = 100;

new g_iMenuType[33];
new c_DustForTransform;
new g_iDustForTransform = 1;
new c_ReturnPercent;
new g_iReturnPercent;

new g_iGiftTarget[33];
new g_iGiftItem[33];

new g_bTradeAccept[33];
new g_iTradeTarget[33];
new g_iTradeItem[33];
new g_bTradeActive[33];
new g_bTradeSecond[33];
new g_iTradeRequest[33];

new g_iRouletteCost;
new g_bRoulettePlay[33];

new g_iTombolaPlayers;
new g_iTombolaPrize;
new g_bUserPlay[33];
new g_iNextTombolaStart;
new c_TombolaCost;
new g_iTombolaCost = 50;
new c_TombolaTimer;
new g_iTombolaTimer = 120;
new g_bTombolaWork = 1;

new c_RouletteMin;
new g_iRouletteMin = 2;
new c_RouletteMax;
new g_iRouletteMax = 10;
new g_iUserBetPoints[33];

new bool:g_bJackpotWork;
new g_iUserJackpotItem[33];
new g_bUserPlayJackpot[33];
new g_iJackpotClose;
new c_JackpotTimer;

new g_iMaxPlayers;
new c_ShowHUD;

new g_iRoundNum;
new bool:g_bWarmUp;
new c_WarmUpDuration;
new g_iStartMoney;
new p_StartMoney;
new c_Competitive;
new g_iCompetitive;
new c_BestPoints;
new c_Respawn;
new c_RespawnDelay;
new g_iRespawnDelay;
new g_iTimer;
new p_NextMap;
new bool:g_bTeamSwap;
new p_Freezetime;
new g_iFreezetime;

new c_RankUpBonus;
new c_CmdAccess;
new c_OverrideMenu;

new bool:g_bBombExplode;
new bool:g_bBombDefused;
new g_iBombPlanter;
new g_iBombDefuser;

new g_iRoundKills[33];
new g_iDigit[33];
new g_iUserMVP[33];
new c_MVPMsgType;
new g_iMVPMsgType;
new g_iDealDamage[33];
new c_AMinPoints;
new g_iAMinPoints;
new c_AMaxPoints;
new g_iAMaxPoints;
new c_MVPMinPoints;
new g_iMVPMinPoints;
new c_MVPMaxPoints;
new g_iMVPMaxPoints;

new szMessage[128];

new c_RankModels;
new g_iRankModels;
new g_iRankEnt[33];
new g_iInfoTargetAlloc;

new c_PruneDays;
new g_iPruneDays = 30;

new c_HMinPoints;
new g_iHMinPoints;
new c_HMaxPoints;
new g_iHMaxPoints;
new c_KMinPoints;
new g_iKMinPoints;
new c_KMaxPoints;
new g_iKMaxPoints;
new c_HMinChance;
new g_iHMinChance;
new c_HMaxChance;
new g_iHMaxChance;
new c_KMinChance;
new g_iKMinChance;
new c_KMaxChance;
new g_iKMaxChance;
new g_iMostDamage[33];
new g_iDamage[33][33];

new bool:g_IsChangeAllowed[33];
new bool:ShortThrow;

new g_szRankModel[27] =
{
	"models/3dranks.mdl"
};

new g_szTWin[] =
{
	"misc/twingo.wav"
};
new g_szCTWin[] =
{
	"misc/ctwingo.wav"
};

new g_szNadeModels[3][] =
{
	"models/w_he_csgor.mdl",
	"models/w_fb_csgor.mdl",
	"models/w_sg_csgor.mdl"
};

new GrenadeName[3][] =
{
	"weapon_hegrenade",
	"weapon_flashbang",
	"weapon_smokegrenade"
};

new g_szWeaponEntName[31][] =
{
	"",
	"weapon_p228",
	"",
	"weapon_scout",
	"weapon_hegrenade",
	"weapon_xm1014",
	"weapon_c4",
	"weapon_mac10",
	"weapon_aug",
	"weapon_smokegrenade",
	"weapon_elite",
	"weapon_fiveseven",
	"weapon_ump45",
	"weapon_sg550",
	"weapon_galil",
	"weapon_famas",
	"weapon_usp",
	"weapon_glock18",
	"weapon_awp",
	"weapon_mp5navy",
	"weapon_m249",
	"weapon_m3",
	"weapon_m4a1",
	"weapon_tmp",
	"weapon_g3sg1",
	"weapon_flashbang",
	"weapon_deagle",
	"weapon_sg552",
	"weapon_ak47",
	"weapon_knife",
	"weapon_p90"
};

new g_iMaxBpAmmo[11] =
{
	0, 30, 90, 200, 90, 32, 100, 100, 35, 52, 120
};

new szSprite[11][] =
{
	"number_0",
	"number_1",
	"number_2",
	"number_3",
	"number_4",
	"number_5",
	"number_6",
	"number_7",
	"number_8",
	"number_9",
	"dmg_rad"
};

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	register_cvar("csgo_remake_version", "1Gx", 68, 0.00);
	set_cvar_string("csgo_remake_version", "1Gx");
	register_cvar("csgo_remake_author", "Nubo", 68, 0.00);
	set_cvar_string("csgo_remake_author", "Nubo");
	c_PruneDays = register_cvar("csgor_prunedays", "30", 0, 0.00);
	
	register_dictionary("csgoremake1gx.txt");
	g_Msg_SayText = get_user_msgid("SayText");
	g_Msg_DeathMsg = get_user_msgid("DeathMsg");
	g_Msg_StatusIcon = get_user_msgid("StatusIcon");
	register_message(g_Msg_SayText, "Message_SayText");
	register_message(g_Msg_DeathMsg, "Message_DeathMsg");
	register_clcmd("say", "Message_SayHandle");
	register_clcmd("say_team", "Message_SayHandleTeam");
	register_event("HLTV", "ev_NewRound", "a", "1=0", "2=0");
	register_logevent("logev_Restart_Round", 2, "1&Restart_Round");
	register_logevent("logev_Game_Commencing", 2, "1&Game_Commencing");
	register_event("SendAudio", "ev_RoundWon_T", "a", "2&%!MRAD_terwin");
	register_event("SendAudio", "ev_RoundWon_CT", "a", "2&%!MRAD_ctwin");
	new i;
	while (i < 3)
	{
		fw_PA[i] = RegisterHam(Ham_Weapon_PrimaryAttack, GrenadeName[i], "Ham_Grenade_PA", 1);
		fw_SA[i] = RegisterHam(Ham_Weapon_SecondaryAttack, GrenadeName[i], "Ham_Grenade_SA", 1);
		i++;
	}
	
	fw_CUIC = register_forward(122, "fw_FM_ClientUserInfoChanged", 0);
	g_iInfoTargetAlloc = engfunc(EngFunc_AllocString, "info_target");
	c_OverrideMenu = register_cvar("csgor_override_menu", "1", 0, 0.00);
	c_ShowHUD = register_cvar("csgor_show_hud", "1", 0, 0.00);
	c_HMinPoints = register_cvar("csgor_head_minpoints", "11", 0, 0.00);
	c_HMaxPoints = register_cvar("csgor_head_maxpoints", "15", 0, 0.00);
	c_KMinPoints = register_cvar("csgor_kill_minpoints", "6", 0, 0.00);
	c_KMaxPoints = register_cvar("csgor_kill_maxpoints", "10", 0, 0.00);
	c_HMinChance = register_cvar("csgor_head_minchance", "25", 0, 0.00);
	c_HMaxChance = register_cvar("csgor_head_maxchance", "100", 0, 0.00);
	c_KMinChance = register_cvar("csgor_kill_minchance", "0", 0, 0.00);
	c_KMaxChance = register_cvar("csgor_kill_maxchance", "100", 0, 0.00);
	c_AMinPoints = register_cvar("csgor_assist_minpoints", "3", 0, 0.00);
	c_AMaxPoints = register_cvar("csgor_assist_maxpoints", "5", 0, 0.00);
	c_MVPMinPoints = register_cvar("csgor_mvp_minpoints", "20", 0, 0.00);
	c_MVPMaxPoints = register_cvar("csgor_mvp_maxpoints", "30", 0, 0.00);
	c_MVPMsgType = register_cvar("csgor_mvp_msgtype", "0", 0, 0.00);
	c_TombolaCost = register_cvar("csgor_tombola_cost", "50", 0, 0.00);
	c_RegOpen = register_cvar("csgor_register_open", "1", 0, 0.00);
	c_UpdatePlugin = register_cvar("csgor_update_plugin", "0", 0, 0.00);
	c_BestPoints = register_cvar("csgor_best_points", "300", 0, 0.00);
	c_RankUpBonus = register_cvar("csgor_rangup_bonus", "kc|200", 0, 0.00);
	c_ReturnPercent = register_cvar("csgor_return_percent", "10", 0, 0.00);
	c_DropType = register_cvar("csgor_drop_type", "1", 0, 0.00);
	c_KeyPrice = register_cvar("csgor_key_price", "250", 0, 0.00);
	c_TombolaTimer = register_cvar("csgor_tombola_timer", "180", 0, 0.00);
	c_JackpotTimer = register_cvar("csgor_jackpot_timer", "120", 0, 0.00);
	c_Competitive = register_cvar("csgor_competitive_mode", "1", 0, 0.00);
	c_WarmUpDuration = register_cvar("csgor_warmup_duration", "60", 0, 0.00);
	c_ShowDropCraft = register_cvar("csgor_show_dropcraft", "1", 0, 0.00);
	c_RouletteMin = register_cvar("csgor_roulette_min", "2", 0, 0.00);
	c_RouletteMax = register_cvar("csgor_roulette_max", "8", 0, 0.00);
	c_CostMultiplier = register_cvar("csgor_item_cost_multiplier", "20", 0, 0.00);
	
	register_event("DeathMsg", "ev_DeathMsg", "a", "1>0");
	register_event("Damage", "ev_Damage", "b", "2!0", "3=0", "4!0");
	fw_S1 = RegisterHam(Ham_Spawn, "player", "Ham_Player_Spawn_Post", 1);
	fw_S2 = RegisterHam(Ham_Spawn, "player", "Ham_Player_Spawn_Pre", 0);
	fw_K1 = RegisterHam(Ham_Killed, "player", "Ham_Player_Killed_Post", 1);
	fw_K2 = RegisterHam(Ham_Killed, "player", "Ham_Player_Killed_Pre", 0);
	c_Respawn = register_cvar("csgor_respawn_enable", "0", 0, 0.00);
	c_RespawnDelay = register_cvar("csgor_respawn_delay", "3", 0, 0.00);
	c_DropChance = register_cvar("csgor_dropchance", "85", 0, 0.00);
	c_CraftCost = register_cvar("csgor_craft_cost", "10", 0, 0.00);
	c_CaseMinCost = register_cvar("csgor_case_min_cost", "100", 0, 0.00);
	c_KeyMinCost = register_cvar("csgor_key_min_cost", "100", 0, 0.00);
	c_WaitForPlace = register_cvar("csgor_wait_for_place", "30", 0, 0.00);
	c_DustForTransform = register_cvar("csgor_dust_for_transform", "1", 0, 0.00);
	c_Suicide = register_cvar("csgor_suicide", "1", 0, 0.00);
	if (0 < get_pcvar_num(c_Suicide))
	{
		register_forward(FM_ClientKill, "concmd_kill");
	}
	
	g_MsgSync = CreateHudSyncObj(0);
	g_WarmUpSync = CreateHudSyncObj(0);
	g_iMaxPlayers = get_maxplayers();
	
	new size = 31;
	i = 1;
	while (i < size)
	{
		if (g_szWeaponEntName[i][0])
		{
			fw_ID[i] = RegisterHam(Ham_Item_Deploy, g_szWeaponEntName[i], "Ham_Item_Deploy_Post", 1);
			fw_ICD[i] = RegisterHam(Ham_CS_Item_CanDrop, g_szWeaponEntName[i], "Ham_Item_Can_Drop", 0);
		}
		i++;
	}
	
	register_clcmd("say /reg", "clcmd_say_reg", -1, "", -1);
	register_clcmd("say /menu", "clcmd_say_menu", -1, "", -1);
	register_clcmd("say /skin", "clcmd_say_skin", -1, "", -1);
	register_clcmd("say /accept", "clcmd_say_accept", -1, "", -1);
	register_clcmd("say /deny", "clcmd_say_deny", -1, "", -1);
	if (0 < get_pcvar_num(c_OverrideMenu))
	{
		register_clcmd("chooseteam", "clcmd_chooseteam", -1, "", -1);
	}
	register_concmd("UserPassword", "concmd_password", -1, "", -1);
	register_concmd("ItemPrice", "concmd_itemprice", -1, "", -1);
	register_concmd("BetPoints", "concmd_betpoints", -1, "", -1);
	
	g_Vault = nvault_open("csgoremake1gx");
	if (g_Vault == -1)
	{
		set_fail_state("[CSGO Remake] Could not open file csgoremake1gx.vault .");
		return 0;
	}
	else
	{
		log_amx("[CSGO Remake] File csgoremake1gx.vault was successfully loaded.");
	}
	
	c_CmdAccess = register_cvar("csgor_commands_access", "a", 0, 0.00);
	new Flags[8];
	get_pcvar_string(c_CmdAccess, Flags, 7);
	new Access = read_flags(Flags);
	register_concmd("amx_givepoints", "concmd_givepoints", Access, "<Name> <Amount>", -1);
	register_concmd("amx_givecases", "concmd_givecases", Access, "<Name> <Amount>", -1);
	register_concmd("amx_givekeys", "concmd_givekeys", Access, "<Name> <Amount>", -1);
	register_concmd("amx_givedusts", "concmd_givedusts", Access, "<Name> <Amount>", -1);
	register_concmd("amx_setskins", "concmd_giveskins", Access, "<Name> <SkinID> <Amount>", -1);
	register_concmd("amx_setrank", "concmd_setrank", Access, "<Name> <Rank ID>", -1);
	register_concmd("amx_finddata", "concmd_finddata", Access, "<Name>", -1);
	register_concmd("amx_resetdata", "concmd_resetdata", Access, "<Name> <Mode>", -1);
	register_concmd("csgor_getinfo", "concmd_getinfo", Access, "<Type> <Index>", -1);
	
	p_Freezetime = get_cvar_pointer("mp_freezetime");
	p_StartMoney = get_cvar_pointer("mp_startmoney");
	
	_LicenseChecker();
	return 0;
}

public plugin_precache()
{
	precache_sound(g_szTWin);
	precache_sound(g_szCTWin);
	
	new i = 0;
	while (i < 3)
	{
		precache_model(g_szNadeModels[i]);
		i++;
	}
	new fp = fopen(g_szConfigFile, "rt");
	if (!fp)
	{
		set_fail_state("[CSGO Remake] Could not open file csgoremake1gx.ini .");
		return 0;
	}
	else
	{
		log_amx("[CSGO Remake] File csgoremake1gx.ini was successfully loaded.");
	}
	new buff[128];
	new section;
	new leftpart[48];
	new rightpart[48];
	new weaponid[4];
	new weaponname[32];
	new weaponmodel[48];
	new weaponP[48];
	//new weaponW[48];
	new weapontype[4];
	new weaponchance[8];
	new weaponcostmin[8];
	while (!feof(fp))
	{
		fgets(fp, buff, 127);
		if (!(!buff[0] || buff[0] == 59))
		{
			if (buff[0] == 91)
			{
				section += 1;
			}
			switch (section)
			{
				case 1:
				{
					if (buff[0] != 91)
					{
						parse(buff, leftpart, 47, rightpart, 47);
						ArrayPushString(g_aRankName, leftpart);
						ArrayPushCell(g_aRankKills, str_to_num(rightpart));
						g_iRanksNum += 1;
					}
				}
				case 2:
				{
					if (buff[0] != 91)
					{
						//parse(buff, leftpart, 47, rightpart, 47, weaponP, 47, weaponW, 47);
						parse(buff, leftpart, 47, rightpart, 47, weaponP, 47);
						new wid = str_to_num(leftpart);
						copy(g_szDefaultSkinModel[wid], 47, rightpart);
						copy(g_szDefaultPSkinModel[wid], 47, weaponP);
						if (strlen(rightpart) > 0 && file_exists(rightpart))
						{
							precache_model(rightpart);
						}
						else if (0 < strlen(rightpart) && !file_exists(rightpart))
						{
							new error[128];
							formatex(error, 127 + strlen(rightpart), "[CSGO Remake] You have a missing file ^"%s^" in the [DEFAULT] section of csgoremake1gx.ini .", rightpart);
							set_fail_state(error);
							return 0;
						}
						if (strlen(weaponP) > 0 && file_exists(weaponP))
						{
							precache_model(weaponP);
						}
						else if (0 < strlen(weaponP) && !file_exists(weaponP))
						{
							new error[128];
							formatex(error, 127 + strlen(weaponP), "[CSGO Remake] You have a missing file ^"%s^" in the [DEFAULT] section of csgoremake1gx.ini .", weaponP);
							set_fail_state(error);
							return 0;
						}
						//if (strlen(weaponW) > 0 && file_exists(weaponW))
						//{
						//	precache_model(weaponW);
						//}
						//else if (0 < strlen(weaponW) && !file_exists(weaponW))
						//{
						//	new error[128];
						//	formatex(error, 127 + strlen(weaponW), "[CSGO Remake] You have a missing file ^"%s^" in the [DEFAULT] section of csgoremake1gx.ini .", weaponW);
						//	set_fail_state(error);
						//	return 0;
						//}
					}
				}
				case 3:
				{
					if (buff[0] != 91)
					{
						//parse(buff, weaponid, 3, weaponname, 31, weaponmodel, 47, weaponP, 47, weaponW, 47, weapontype, 3, weaponchance, 7, weaponcostmin, 7);
						parse(buff, weaponid, 3, weaponname, 31, weaponmodel, 47, weaponP, 47, weapontype, 3, weaponchance, 7, weaponcostmin, 7);
						ArrayPushCell(g_aSkinWeaponID, str_to_num(weaponid));
						ArrayPushString(g_aSkinName, weaponname);
						ArrayPushString(g_aSkinModel, weaponmodel);
						ArrayPushString(g_aSkinModelP, weaponP);
						//ArrayPushString(g_aSkinModelW, weaponW);
						ArrayPushString(g_aSkinType, weapontype);
						ArrayPushCell(g_aSkinChance, str_to_num(weaponchance));
						ArrayPushCell(g_aSkinCostMin, str_to_num(weaponcostmin));
						if (0 < strlen(weaponmodel) && file_exists(weaponmodel))
						{
							precache_model(weaponmodel);
						}
						else if (0 < strlen(weaponmodel) && !file_exists(weaponmodel))
						{
							new error[128];
							formatex(error, 127 + strlen(weaponmodel), "[CSGO Remake] You have a missing file ^"%s^" in the [SKINS] section of csgoremake1gx.ini .", weaponmodel);
							set_fail_state(error);
							return 0;
						}
						if (0 < strlen(weaponP) && file_exists(weaponP))
						{
							g_bSkinHasModelP[g_iSkinsNum] = true;
							precache_model(weaponP);
						}
						else if (0 < strlen(weaponP) && !file_exists(weaponP))
						{
							new error[128];
							formatex(error, 127 + strlen(weaponP), "[CSGO Remake] You have a missing file ^"%s^" in the [SKINS] section of csgoremake1gx.ini .", weaponP);
							set_fail_state(error);
							return 0;
						}
						//if (0 < strlen(weaponW) && file_exists(weaponW))
						//{
						//	g_bSkinHasModelW[g_iSkinsNum] = true;
						//	precache_model(weaponW);
						//}
						//else if (0 < strlen(weaponW) && !file_exists(weaponW))
						//{
						//	new error[128];
						//	formatex(error, 127 + strlen(weaponW), "[CSGO Remake] You have a missing file ^"%s^" in the [SKINS] section of csgoremake1gx.ini .", weaponW);
						//	set_fail_state(error);
						//	return 0;
						//}
						switch (weapontype[0])
						{
							case 99:
							{
								ArrayPushCell(g_aCraftSkin, g_iSkinsNum);
								g_iCraftSkinNum += 1;
							}
							case 100:
							{
								ArrayPushCell(g_aDropSkin, g_iSkinsNum);
								g_iDropSkinNum += 1;
							}
							default:
							{
							}
						}
						g_iSkinsNum += 1;
					}
				}
				default:
				{
				}
			}
		}
	}
	fclose(fp);
	c_RankModels = register_cvar("csgor_3d_ranks", "1", 0, 0.00);
	g_iRankModels = get_pcvar_num(c_RankModels);
	if (0 < g_iRankModels)
	{
		precache_model(g_szRankModel);
	}
	return 0;
}

public plugin_cfg()
{
	new id;
	new wid;
	id = 1;
	while (id <= g_iMaxPlayers)
	{
		wid = 1;
		while (wid <= 30)
		{
			g_iUserSelectedSkin[id][wid] = -1;
			wid++;
		}
		id++;
	}
	server_cmd("exec %s/csgoremake1gx.cfg", g_szCfgDir);
	g_iTombolaTimer = get_pcvar_num(c_TombolaTimer);
	new Float:timer = float(g_iTombolaTimer);
	set_task(timer, "task_TombolaRun", 2000, "", 0, "b", 0);
	g_iNextTombolaStart = g_iTombolaTimer + get_systime(0);
	return 0;
}

public plugin_natives()
{
	get_configsdir(g_szCfgDir, 47);
	formatex(g_szConfigFile, 47, "%s/csgoremake1gx.ini", g_szCfgDir);
	if (!file_exists(g_szConfigFile))
	{
		return 0;
	}
	g_aRankName = ArrayCreate(32, 1);
	g_aRankKills = ArrayCreate(1, 1);
	g_aSkinWeaponID = ArrayCreate(1, 1);
	g_aSkinName = ArrayCreate(32, 1);
	g_aSkinModel = ArrayCreate(48, 1);
	g_aSkinModelP = ArrayCreate(48, 1);
	//g_aSkinModelW = ArrayCreate(48, 1);
	g_aSkinType = ArrayCreate(2, 1);
	g_aSkinChance = ArrayCreate(1, 1);
	g_aSkinCostMin = ArrayCreate(1, 1);
	g_aDropSkin = ArrayCreate(1, 1);
	g_aCraftSkin = ArrayCreate(1, 1);
	g_aTombola = ArrayCreate(1, 1);
	g_aJackpotSkins = ArrayCreate(1, 1);
	g_aJackpotUsers = ArrayCreate(1, 1);
	register_native("csgor_get_user_points", "native_get_user_points", 0);
	register_native("csgor_set_user_points", "native_set_user_points", 0);
	register_native("csgor_get_user_cases", "native_get_user_cases", 0);
	register_native("csgor_set_user_cases", "native_set_user_cases", 0);
	register_native("csgor_get_user_keys", "native_get_user_keys", 0);
	register_native("csgor_set_user_keys", "native_set_user_keys", 0);
	register_native("csgor_get_user_dusts", "native_get_user_dusts", 0);
	register_native("csgor_set_user_dusts", "native_set_user_dusts", 0);
	register_native("csgor_get_user_rank", "native_get_user_rank", 0);
	register_native("csgor_set_user_rank", "native_set_user_rank", 0);
	register_native("csgor_get_user_skins", "native_get_user_skins", 0);
	register_native("csgor_set_user_skins", "native_set_user_skins", 0);
	register_native("csgor_is_user_logged", "native_is_user_logged", 0);
	return 0;
}

public plugin_end()
{
	ArrayDestroy(g_aRankName);
	ArrayDestroy(g_aRankKills);
	ArrayDestroy(g_aSkinWeaponID);
	ArrayDestroy(g_aSkinName);
	ArrayDestroy(g_aSkinModel);
	ArrayDestroy(g_aSkinModelP);
	ArrayDestroy(g_aSkinType);
	ArrayDestroy(g_aSkinChance);
	ArrayDestroy(g_aSkinCostMin);
	ArrayDestroy(g_aDropSkin);
	ArrayDestroy(g_aCraftSkin);
	if (0 < g_iPruneDays)
	{
		nvault_prune(g_Vault, 0, get_systime(0) - g_iPruneDays * 86400);
	}
	nvault_close(g_Vault);
	DisableHamForward(fw_S1);
	DisableHamForward(fw_S2);
	DisableHamForward(fw_K1);
	DisableHamForward(fw_K2);
	unregister_forward(122, fw_CUIC, 0);
	return 0;
}

public client_putinserver(id)
{
	set_task(10.00, "task_Info", id + 7000, "", 0, "", 0);
	get_user_name(id, g_szName[id], 31);
	g_iRankModels = get_pcvar_num(c_RankModels);
	if (0 < g_iRankModels)
	{
		new eng = engfunc(21, g_iInfoTargetAlloc);
		g_iRankEnt[id] = eng;
		if (pev_valid(eng))
		{
			set_pev(eng, pev_movetype, 12);
			set_pev(eng, pev_aiment, id);
			engfunc(EngFunc_SetModel, eng, g_szRankModel);
		}
	}
	g_IsChangeAllowed[id] = false;
	g_iDigit[id] = 0;
	g_iMostDamage[id] = 0;
	g_szUserPassword[id] = "";
	g_szUserSavedPass[id] = "";
	g_iUserPassFail[id] = 0;
	g_bLogged[id] = false;
	g_iUserPoints[id] = 0;
	g_iUserDusts[id] = 0;
	g_iUserKeys[id] = 0;
	g_iUserCases[id] = 0;
	g_iUserKills[id] = 0;
	g_iUserRank[id] = 0;
	
	g_bUserSell[id] = 0;
	g_iUserSellItem[id] = -1;
	g_iLastPlace[id] = 0;
	
	g_iMenuType[id] = 0;
	
	g_iGiftTarget[id] = 0;
	g_iGiftItem[id] = -1;
	
	g_iTradeTarget[id] = 0;
	g_iTradeItem[id] = -1;
	g_bTradeActive[id] = 0;
	g_bTradeAccept[id] = 0;
	g_bTradeSecond[id] = 0;
	g_iTradeRequest[id] = 0;
	
	g_bUserPlay[id] = 0;
	g_iUserBetPoints[id] = 10;
	g_bRoulettePlay[id] = 0;
	g_iUserJackpotItem[id] = -1;
	g_bUserPlayJackpot[id] = 0;
	new wid = 1;
	while (wid <= 30)
	{
		g_iUserSelectedSkin[id][wid] = -1;
		wid++;
	}
	new sid;
	while (sid < 96)
	{
		g_iUserSkins[id][sid] = 0;
		sid++;
	}
	if(0 < get_pcvar_num(c_ShowHUD))
	{
		set_task(1.00, "task_HUD", id, "", 0, "b", 0);
	}
}

_LicenseChecker()
{
	TimeStamp = 1621036800;
	new iYear, iMonth, iDay, iHour, iMinute, iSecond, netaddress[64], left[64], right[64];
	if (get_systime() <= TimeStamp)
	{
		get_user_ip(0, netaddress, 63, 0);
		strtok(netaddress, left, 63, right, 63, ':', 0);
		//if (!equali(left, "127.0.0.1", 0))
		//{
		//	set_fail_state("[CSGO Remake] This IP is not licensed. Contact Kuamquat at kuamquat940@gmail.com to renew the license!");
		//	return 0;
		//}
		UnixToTime(TimeStamp, iYear, iMonth, iDay, iHour, iMinute, iSecond);
		log_amx("[CSGO Remake] This license is valid until %d.%d.%d .", iDay, iMonth, iYear);
		if (0 < get_pcvar_num(c_UpdatePlugin))
		{
			_UpdatePlugin();
		}
		_InfoPlugin();
	}
	else
	{
		UnixToTime(TimeStamp, iYear, iMonth, iDay, iHour, iMinute, iSecond);
		log_amx("[CSGO Remake] This license has expired at %d.%d.%d . Contact Kuamquat at kuamquat940@gmail.com to renew the license!", iDay, iMonth, iYear);
		return _Fail();
	}
	return 0;
}

_Fail()
{
	ArrayDestroy(g_aRankName);
	ArrayDestroy(g_aRankKills);
	ArrayDestroy(g_aSkinWeaponID);
	ArrayDestroy(g_aSkinName);
	ArrayDestroy(g_aSkinModel);
	ArrayDestroy(g_aSkinModelP);
	ArrayDestroy(g_aSkinType);
	ArrayDestroy(g_aSkinChance);
	ArrayDestroy(g_aSkinCostMin);
	ArrayDestroy(g_aDropSkin);
	ArrayDestroy(g_aCraftSkin);
	DisableHamForward(fw_S1);
	DisableHamForward(fw_S2);
	DisableHamForward(fw_K1);
	DisableHamForward(fw_K2);
	unregister_forward(122, fw_CUIC, 0);
	return 0;
}

public task_Info(task)
{
	new id = task - 7000;
	if (!is_user_connected(id))
	{
		return 0;
	}
	if (0 < id && 32 >= id)
	{
		client_print_color(id, id, "^4*^1 Joci ^4%s^1 v. ^3%s^1 creat de ^4%s", "CSGO Remake", "1Gx", "Nubo");
	}
	return 0;
}

_InfoPlugin()
{
	new grelease[33] = "playtest-20200529";
	new version[33] = "v0.2-dev";
	new author[128] = "https://www.github.com/kuamquat940";
	new uurl[128] = "https://www.github.com/kuamquat940/csgoremake/releases";
	server_print("");
	server_print("---------- CSGO REMAKE ----------");
	server_print("[*] Github release name: %s", grelease);
	server_print("[*] Version: %s", version);
	server_print("[*] Author: %s", author);
	server_print("[*] Update URL: %s", uurl);
	if (0 < get_pcvar_num(c_UpdatePlugin))
	{
		server_print("[*] Update notifications: ON");
	}
	else
	{
		server_print("[*] Update notifications: OFF");
	}
	server_print("---------------------------------");
	server_print("");
	return 0;
}

_UpdatePlugin()
{
}

public ev_NewRound()
{
	p_NextMap = get_cvar_pointer("amx_nextmap");
	arrayset(g_iRoundKills, 0, 33);
	arrayset(g_bRoulettePlay, 0, 33);
	g_iPruneDays = get_pcvar_num(c_PruneDays);
	g_iRespawnDelay = get_pcvar_num(c_RespawnDelay);
	g_iDropChance = get_pcvar_num(c_DropChance);
	g_iCraftCost = get_pcvar_num(c_CraftCost);
	g_iTombolaCost = get_pcvar_num(c_TombolaCost);
	g_iDropType = get_pcvar_num(c_DropType);
	g_iKeyPrice = get_pcvar_num(c_KeyPrice);
	g_iCaseMinCost = get_pcvar_num(c_CaseMinCost);
	g_iKeyMinCost = get_pcvar_num(c_KeyMinCost);
	g_iWaitForPlace = get_pcvar_num(c_WaitForPlace);
	g_iDustForTransform = get_pcvar_num(c_DustForTransform);
	g_iReturnPercent = get_pcvar_num(c_ReturnPercent);
	g_iHMinPoints = get_pcvar_num(c_HMinPoints);
	g_iHMaxPoints = get_pcvar_num(c_HMaxPoints);
	g_iKMinPoints = get_pcvar_num(c_KMinPoints);
	g_iKMaxPoints = get_pcvar_num(c_KMaxPoints);
	g_iHMinChance = get_pcvar_num(c_HMinChance);
	g_iHMaxChance = get_pcvar_num(c_HMaxChance);
	g_iKMinChance = get_pcvar_num(c_KMinChance);
	g_iKMaxChance = get_pcvar_num(c_KMaxChance);
	g_iAMinPoints = get_pcvar_num(c_AMinPoints);
	g_iAMaxPoints = get_pcvar_num(c_AMaxPoints);
	g_iMVPMinPoints = get_pcvar_num(c_MVPMinPoints);
	g_iMVPMaxPoints = get_pcvar_num(c_MVPMaxPoints);
	g_iMVPMsgType = get_pcvar_num(c_MVPMsgType);
	g_iShowDropCraft = get_pcvar_num(c_ShowDropCraft);
	g_iRouletteMin = get_pcvar_num(c_RouletteMin);
	g_iRouletteMax = get_pcvar_num(c_RouletteMax);
	g_iCostMultiplier = get_pcvar_num(c_CostMultiplier);
	g_iCompetitive = get_pcvar_num(c_Competitive);
	if (1 > g_iCompetitive)
	{
		return 0;
	}
	if (g_bWarmUp || 0 < get_pcvar_num(c_Respawn))
	{
		return 0;
	}
	if (2 > get_playersnum())
	{
		return 0;
	}
	if (!IsHalf() && !IsLastRound() && 0 < g_iRoundNum)
	{
		new szNextMap[32];
		get_pcvar_string(p_NextMap, szNextMap, 31);
		client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_COMPETITIVE_INFO", g_iRoundNum, szNextMap);
	}
	if (IsLastRound())
	{
		set_pcvar_num(p_Freezetime, 10);
		client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_MAP_END");
		_ShowBestPlayers();
		set_task(7.00, "task_Map_End", 0, "", 0, "", 0);
	}	
	if (IsHalf() && !g_bTeamSwap)
	{
		client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_HALF");
		_ShowBestPlayers();
		new Float:delay = 0.0;
		new i = 1;
		while (i <= g_iMaxPlayers)
		{
			if (0 < i && 32 >= i)
			{
				delay = 0.2 * i;
				set_task(delay, "task_Delayed_Swap", i + 8000, "", 0, "", 0);
			}
			i++;
		}
		server_cmd("exec %s/csgoremake1gx.cfg", g_szCfgDir);
		set_task(7.00, "task_Team_Swap", 0, "", 0, "", 0);
		g_iRoundNum = 15;
	}
	if (!g_bWarmUp || !IsHalf())
	{
		g_iRoundNum += 1;
	}
	return 0;
}

bool:IsHalf()
{
	if (!g_bTeamSwap && g_iRoundNum == 16)
	{
		return true;
	}
	return false;
}

bool:IsLastRound()
{
	if (g_bTeamSwap && g_iRoundNum == 31)
	{
		return true;
	}
	return false;
}

_ShowBestPlayers()
{
	new Pl[32];
	new n;
	new p;
	new i;
	new BestPlayer;
	new Frags;
	new BestFrags;
	new MVP;
	new BestMVP;
	new bonus = get_pcvar_num(c_BestPoints);
	get_players(Pl, n, "he", "TERRORIST");
	if (0 < n)
	{
		i = 0;
		while (i < n)
		{
			p = Pl[i];
			MVP = g_iUserMVP[p];
			if (MVP < 1 || MVP < BestMVP)
			{
			}
			else
			{
				Frags = get_user_frags(p);
				if (MVP > BestMVP)
				{
					BestPlayer = p;
					BestMVP = MVP;
					BestFrags = Frags;
				}
				else
				{
					if (Frags > BestFrags)
					{
						BestPlayer = p;
						BestFrags = Frags;
					}
				}
			}
			i++;
		}
	}
	if (BestPlayer && BestPlayer <= g_iMaxPlayers)
	{
		client_print_color(0, BestPlayer, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_BEST_T", g_szName[BestPlayer], BestMVP, bonus);
	}
	else
	{
		client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_ZERO_MVP", "Terrorist");
	}
	if (g_bLogged[BestPlayer])
	{
		g_iUserPoints[BestPlayer] += bonus;
	}
	get_players(Pl, n, "he", "CT");
	BestPlayer = 0;
	BestMVP = 0;
	BestFrags = 0;
	if (0 < n)
	{
		i = 0;
		while (i < n)
		{
			p = Pl[i];
			MVP = g_iUserMVP[p];
			if (MVP < 1 || MVP < BestMVP)
			{
			}
			else
			{
				Frags = get_user_frags(p);
				if (MVP > BestMVP)
				{
					BestPlayer = p;
					BestMVP = MVP;
					BestFrags = Frags;
				}
				else
				{
					if (Frags > BestFrags)
					{
						BestPlayer = p;
						BestFrags = Frags;
					}
				}
			}
			i++;
		}
	}
	if (BestPlayer && BestPlayer <= g_iMaxPlayers)
	{
		client_print_color(0, BestPlayer, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_BEST_CT", g_szName[BestPlayer], BestMVP, bonus);
	}
	else
	{
		client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_ZERO_MVP", "Counter-Terrorist");
	}
	if (g_bLogged[BestPlayer])
	{
		g_iUserPoints[BestPlayer] += bonus;
	}
	return 0;
}

public task_Delayed_Swap(task)
{
	new id = task + -8000;
	if (!(0 < id && 32 >= id || !is_user_connected(id)) || !is_user_connected(id))
	{
		return 0;
	}
	switch(cs_get_user_team(id))
	{
		case CS_TEAM_T:
		{
			cs_set_user_team(id, CS_TEAM_CT);
		}
		
		case CS_TEAM_CT:
		{
			cs_set_user_team(id, CS_TEAM_T);
		}
	}
	
	return 0;
}

public task_Team_Swap()
{
	g_bTeamSwap = true;
	set_pcvar_num(p_Freezetime, g_iFreezetime);
	client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_RESTART");
	server_cmd("sv_restart 1");
	return 0;
}

public task_Map_End()
{
	emessage_begin(MSG_ALL, SVC_INTERMISSION, {0,0,0}, 0);
	emessage_end();
	return 0;
}

public ev_RoundWon_T()
{
	client_cmd(0, "spk ^"%s^"", g_szTWin);
	new data[1];
	data[0] = 1;
	set_task(1.00, "task_Check_Conditions", 0, data, 1, "a", 1);
	if (IsHalf())
	{
		g_iFreezetime = get_pcvar_num(p_Freezetime);
		set_pcvar_num(p_Freezetime, 10);
	}
	return 0;
}

public ev_RoundWon_CT()
{
	client_cmd(0, "spk ^"%s^"", g_szCTWin);
	new data[1];
	data[0] = 2;
	set_task(0.00, "task_Check_Conditions", 0, data, 1, "a", 1);
	if (IsHalf())
	{
		g_iFreezetime = get_pcvar_num(p_Freezetime);
		set_pcvar_num(p_Freezetime, 10);
	}
	return 0;
}

public bomb_explode(id, id2)
{
	g_iBombPlanter = id;
	g_bBombExplode = true;
	return 0;
}

public bomb_defused(id)
{
	g_iBombDefuser = id;
	g_bBombDefused = true;
	return 0;
}

public task_Check_Conditions(data[])
{
	new team = data[0];
	switch (team)
	{
		case 1:
		{
			if (g_bBombExplode)
			{
				_ShowMVP(g_iBombPlanter, 1);
			}
			else
			{
				new top1 = _GetTopKiller(1);
				_ShowMVP(top1, 0);
			}
		}
		case 2:
		{
			if (g_bBombDefused)
			{
				_ShowMVP(g_iBombDefuser, 2);
			}
			else
			{
				new top1 = _GetTopKiller(2);
				_ShowMVP(top1, 0);
			}
		}
		default:
		{
		}
	}
	return 0;
}

_ShowMVP(id, event)
{
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		return 0;
	}
	if (event && 1 > g_iRoundKills[id] || 1 > g_iRoundKills[id])
	{
		return 0;
	}
	g_iUserMVP[id]++;
	switch (g_iMVPMsgType)
	{
		case 0:
		{
			switch (event)
			{
				case 0:
				{
					client_print_color(0, id, "^4%s^1 Round MVP: ^3%s^1 %L: ^4%d", "[CSGO Remake]", g_szName[id], -1, "CSGOR_MOST_KILL", g_iRoundKills[id]);
				}
				case 1:
				{
					client_print_color(0, id, "^4%s^1 Round MVP: ^3%s^1 %L", "[CSGO Remake]", g_szName[id], -1, "CSGOR_PLANTING");
				}
				case 2:
				{
					client_print_color(0, id, "^4%s^1 Round MVP: ^3%s^1 %L", "[CSGO Remake]", g_szName[id], -1, "CSGOR_DEFUSING");
				}
				default:
				{
				}
			}
		}
		case 1:
		{
			set_hudmessage(0, 255, 0, -1.00, 0.10, 0, 0.00, 5.00, 0.00, 0.00, -1);
			switch (event)
			{
				case 0:
				{
					show_hudmessage(0, "Round MVP : %s ^n%L (%d).", g_szName[id], -1, "CSGOR_MOST_KILL", g_iRoundKills[id]);
				}
				case 1:
				{
					show_hudmessage(0, "Round MVP : %s ^n%L", g_szName[id], -1, "CSGOR_PLANTING");
				}
				case 2:
				{
					show_hudmessage(0, "Round MVP : %s ^n%L", g_szName[id], -1, "CSGOR_DEFUSING");
				}
				default:
				{
				}
			}
		}
		default:
		{
		}
	}
	_GiveBonus(id, 1);
	return 0;
}

_GetTopKiller(team)
{
	new Pl[32];
	new n;
	switch(team)
	{
		case 1:
		{
			get_players(Pl, n, "h", "T");
		}
		case 2:
		{
			get_players(Pl, n, "h", "CT");
		}
	}
	new p;
	new pFrags;
	new pDamage;
	new tempF;
	new tempD;
	new tempID;
	new i;
	while (i < n)
	{
		p = Pl[i];
		pFrags = g_iRoundKills[p];
		if (!(pFrags < tempF))
		{
			pDamage = g_iDealDamage[p];
			if (pFrags > tempF || pDamage > tempD)
			{
				tempID = p;
				tempF = pFrags;
				tempD = pDamage;
			}
		}
		i++;
	}
	if (0 < tempF)
	{
		return tempID;
	}
	return 0;
}

_GiveBonus(id, type)
{
	if (!g_bLogged[id])
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_REGISTER");
		return 0;
	}
	new rpoints;
	switch (type)
	{
		case 0:
		{
			rpoints = random_num(g_iAMinPoints, g_iAMaxPoints);
		}
		case 1:
		{
			rpoints = random_num(g_iMVPMinPoints, g_iMVPMaxPoints);
		}
		default:
		{
			return 0;
		}
	}
	g_iUserPoints[id] += rpoints;
	_SaveData(id);
	set_hudmessage(255, 255, 255, -1.00, 0.25, 0, 6.00, 2.00, 0.00, 0.00, -1);
	show_hudmessage(id, "%L", id, "CSGOR_BONUS_POINTS", rpoints);
	return 0;
}

public logev_Restart_Round()
{
	remove_task(10000, 0);
	g_bJackpotWork = true;
	new timer = get_pcvar_num(c_JackpotTimer);
	set_task(float(timer), "task_Jackpot", 10000, "", 0, "b", 0);
	g_iJackpotClose = timer + get_systime(0);
	return 0;
}

public logev_Game_Commencing()
{
	g_bTeamSwap = false;
	g_iRoundNum = 0;
	if (1 > get_pcvar_num(c_Competitive))
	{
		return 0;
	}
	g_bWarmUp = true;
	g_iStartMoney = get_pcvar_num(p_StartMoney);
	set_pcvar_num(p_StartMoney, 16000);
	g_iTimer = get_pcvar_num(c_WarmUpDuration);
	set_task(1.00, "task_WarmUp_CD", 9000, "", 0, "b", 0);
	return 0;
}

public task_WarmUp_CD(task)
{
	if (0 < g_iTimer)
	{
		set_hudmessage(0, 255, 0, -1.00, 0.80, 0, 0.00, 1.10, 0.00, 0.00, -1);
		new second[64];
		if (1 < g_iTimer)
		{
			formatex(second, 63, "%L", 0, "CSGOR_TOMB_TEXT_SECONDS");
		}
		else
		{
			formatex(second, 63, "%L", 0, "CSGOR_TOMB_TEXT_SECOND");
		}
		ShowSyncHudMsg(0, g_WarmUpSync, "WarmUp: %d %s", g_iTimer, second);
	}
	else
	{
		g_iRoundNum = 1;
		g_bWarmUp = false;
		set_pcvar_num(p_StartMoney, g_iStartMoney);
		remove_task(task, 0);
		server_cmd("sv_restart 1");
	}
	g_iTimer -= 1;
	return 0;
}

public fw_FM_ClientUserInfoChanged(id)
{
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		return 0;
	}
	static szNewName[32];
	static szOldName[32];
	pev(id, 6, szOldName, 31);
	if (szOldName[0])
	{
		get_user_info(id, "name", szNewName, 31);
		if (!equal(szOldName, szNewName, 0) && !g_IsChangeAllowed[id])
		{
			set_user_info(id, "name", szOldName);
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_CANT_CHANGE_ACC");
			return 0;
		}
	}
	return 0;
}

public Ham_Player_Spawn_Pre(id)
{
	if (!is_user_connected(id) && !is_user_alive(id))
	{
		return 0;
	}
	new Float:flNextAttack = get_pdata_float(id, 83, 5, 5);
	set_pdata_float(id, 83, 0.00, 5, 5);
	new iPlayerItems = 368;
	new iWeapon = 0;
	while (iPlayerItems <= 369)
	{
		iWeapon = get_pdata_cbase(id, iPlayerItems, 5, 5);
		if (pev_valid(iWeapon))
		{
			set_pdata_int(iWeapon, 54, 1, 4, 5);
			ExecuteHamB(Ham_Item_PostFrame, iWeapon);
		}
		iPlayerItems++;
	}
	set_pdata_float(id, 83, flNextAttack, 5, 5);
	return 0;
}

public Ham_Player_Spawn_Post(id)
{
	if (!is_user_connected(id) && !is_user_alive(id))
	{
		return 0;
	}
	g_iRankModels = get_pcvar_num(c_RankModels);
	if (0 < g_iRankModels && g_bLogged[id])
	{
		_SetRankModels(id);
	}
	set_task(0.25, "task_SetIcon", id + 32, "", 0, "", 0);
	g_iMostDamage[id] = 0;
	new iAmmoIndex = 1;
	while (iAmmoIndex <= 10)
	{
		set_pdata_int(id, iAmmoIndex + 376, g_iMaxBpAmmo[iAmmoIndex], 5, 5);
		iAmmoIndex++;
	}
	return 0;
}

_SetRankModels(id)
{
	if (!g_bLogged[id])
	{
		return 0;
	}
	new rank = g_iUserRank[id];
	new ent = g_iRankEnt[id];
	if (pev_valid(ent))
	{
		set_pev(ent, pev_body, rank + 1);
	}
	return 0;
}

public task_SetIcon(task)
{
	new id = task + -32;
	if (0 < id && 32 >= id)
	{
		_SetKillsIcon(id, 1);
	}
	return 0;
}

_SetKillsIcon(id, reset)
{
	switch (reset)
	{
		case 0:
		{
			new num = g_iDigit[id];
			if (num > 10)
			{
				return 0;
			}
			num--;
			message_begin(MSG_ONE_UNRELIABLE, g_Msg_StatusIcon, {0,0,0}, id);
			write_byte(0);
			write_string(szSprite[num]);
			message_end();
			num++;
			message_begin(MSG_ONE_UNRELIABLE, g_Msg_StatusIcon, {0,0,0}, id);
			write_byte(1);
			if (num > 9)
			{
				write_string(szSprite[10]);
			}
			else
			{
				write_string(szSprite[num]);
			}
			write_byte(0);
			write_byte(200);
			write_byte(0);
			message_end();
		}
		case 1:
		{
			new num = g_iDigit[id];
			message_begin(MSG_ONE_UNRELIABLE, g_Msg_StatusIcon, {0,0,0}, id);
			write_byte(0);
			if (num > 9)
			{
				write_string(szSprite[10]);
			}
			else
			{
				write_string(szSprite[num]);
			}
			message_end();
			g_iDigit[id] = 0;
			message_begin(MSG_ONE_UNRELIABLE, g_Msg_StatusIcon, {0,0,0}, id);
			write_byte(1);
			write_string(szSprite[0]);
			write_byte(0);
			write_byte(200);
			write_byte(0);
			message_end();
		}
		default:
		{
		}
	}
	return 0;
}

public Ham_Player_Killed_Pre(id)
{
	new iActiveItem = get_pdata_cbase(id, 373, 5, 0);
	if (!pev_valid(iActiveItem))
	{
		return 0;
	}
	new imp = pev(iActiveItem, 82);
	if (0 < imp)
	{
		return 0;
	}
	new iId = get_pdata_int(iActiveItem, 43, 4, 0);
	if (1 << iId & 570425936)
	{
		return 0;
	}
	new skin = g_iUserSelectedSkin[id][iId];
	if (skin != -1)
	{
		set_pev(iActiveItem, 82, skin + 1);
	}
	return 0;
}

public Ham_Player_Killed_Post(id)
{
	if (g_bWarmUp)
	{
		set_task(1.00, "task_Respawn_Player", id + 6000, "", 0, "", 0);
		return 0;
	}
	if (0 < get_pcvar_num(c_Respawn))
	{
		set_hudmessage(0, 255, 0, -1.00, 0.60, 0, 0.00, 2.50, 0.00, 0.10, -1);
		new second[64];
		if (1 > g_iRespawnDelay)
		{
			formatex(second, 63, "%L", 0, "CSGOR_TOMB_TEXT_SECOND");
		}
		else
		{
			formatex(second, 63, "%L", 0, "CSGOR_TOMB_TEXT_SECONDS");
		}
		new temp[64];
		formatex(temp, 63, "%L", id, "CSGOR_RESPAWN_TEXT");
		ShowSyncHudMsg(id, g_MsgSync, "%s %d %s...", temp, g_iRespawnDelay, second);
		set_task(float(g_iRespawnDelay), "task_Respawn_Player", id + 6000, "", 0, "", 0);
	}
	return 0;
}

public task_Respawn_Player(task)
{
	new id = task + -6000;
	if (is_user_alive(id))
	{
		return 0;
	}
	switch(cs_get_user_team(id))
	{
		case CS_TEAM_SPECTATOR:
		{
			return 0;
		}
	}
	respawn_player_manually(id);
	return 0;
}

public respawn_player_manually(id)
{
	ExecuteHamB(Ham_CS_RoundRespawn, id);
	return 0;
}

public task_HUD(id)
{	
	if (g_bLogged[id] == true) {
		set_hudmessage(0, 255, 0, 0.02, 0.90, 0, 6.00, 1.10, 0.00, 0.00, -1);
		ShowSyncHudMsg(id, g_MsgSync, "%L", id, "CSGOR_HUD_INFO", g_iUserPoints[id], g_iUserKeys[id], g_iUserCases[id]);
	} else {
		set_hudmessage(255, 0, 0, 0.02, 0.90, 0, 6.00, 1.10, 0.00, 0.00, -1);
		ShowSyncHudMsg(id, g_MsgSync, "%L", id, "CSGOR_NOT_LOGGED");
	}
	return 0;
}

public clcmd_say_reg(id)
{
	if (g_bLogged[id] == true)
	{
		_ShowMainMenu(id);
		return 0;
	}
	else
	{
		_ShowRegMenu(id);
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_MUST_LOGIN");
		return 0;
	}
	return 0;
}

public clcmd_say_skin(id)
{
	if (g_bLogged[id] == true)
	{
		_ShowSkinMenu(id);
		return 0;
	}
	else
	{
		_ShowRegMenu(id);
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_MUST_LOGIN");
		return 0;
	}
	return 0;
}

public clcmd_say_menu(id)
{
	if (g_bLogged[id] == true)
	{
		_ShowMainMenu(id);
		return 0;
	}
	else
	{
		_ShowRegMenu(id);
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_MUST_LOGIN");
		return 0;
	}
	return 0;
}

public clcmd_chooseteam(id)
{
	clcmd_say_menu(id);
	return 1;
}

_LoadData(id)
{
	new Data[576];
	new Timestamp;
	if (nvault_lookup(g_Vault, g_szName[id], Data, 575, Timestamp) == 1)
	{
		new buffer[64];
		new userData[6][16];
		strtok(Data, g_szUserSavedPass[id], 32, Data, 575, 61, 0);
		strtok(Data, buffer, 63, Data, 575, 42, 0);
		new i = 0;
		while (i < 6)
		{
			strtok(buffer, userData[i], 32, buffer, 32, 44, 0);
			i++;
		}
		
		g_iUserPoints[id] = str_to_num(userData[0]);
		g_iUserDusts[id] = str_to_num(userData[1]);
		g_iUserKeys[id] = str_to_num(userData[2]);
		g_iUserCases[id] = str_to_num(userData[3]);
		g_iUserKills[id] = str_to_num(userData[4]);
		g_iUserRank[id] = str_to_num(userData[5]);

		new skinbuff[96];
		new temp[4];
		strtok(Data, Data, 575, skinbuff, 95, 35, 0);
		new j = 1;
		while (j <= 30 && skinbuff[0] && strtok(skinbuff, temp, 3, skinbuff, 95, 44, 0))
		{
			g_iUserSelectedSkin[id][j] = str_to_num(temp);
			j++;
		}
		new weaponData[8];
		j = 0;
		while (j < 96 && Data[0] && strtok(Data, weaponData, 7, Data, 575, 44, 0))
		{
			g_iUserSkins[id][j] = str_to_num(weaponData);
			j++;
		}
	}
	return 0;
}

_DisplayMenu(id, menu)
{
	set_pdata_int(id, 205, 0, 5, 0);
	menu_display(id, menu, 0);
	return 0;
}

bool:IsRegistered(id)
{
	new Data[576];
	new Timestamp;
	if (nvault_lookup(g_Vault, g_szName[id], Data, 575, Timestamp))
	{
		return true;
	}
	return false;
}

_MenuExit(menu)
{
	menu_destroy(menu);
	return 1;
}

_ShowRegMenu(id)
{
	if (1 > get_pcvar_num(c_RegOpen))
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_REG_CLOSED");
		return 0;
	}
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_REG_MENU");
	new menu = menu_create(temp, "reg_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	formatex(temp, 63, "\r%L \w%s", id, "CSGOR_REG_ACCOUNT", g_szName[id]);
	szItem[0] = 0;
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 63, "\r%L \w%s^n", id, "CSGOR_REG_PASSWORD", g_szUserPassword[id]);
	szItem[0] = 1;
	menu_additem(menu, temp, szItem, 0, -1);
	if (g_bLogged[id] == false)
	{
		if (IsRegistered(id)) {
			formatex(temp, 63, "\r%L", id, "CSGOR_REG_LOGIN");
			szItem[0] = 3;
			menu_additem(menu, temp, szItem, 0, -1);
		} else {
			formatex(temp, 63, "\r%L", id, "CSGOR_REG_REGISTER");
			szItem[0] = 4;
			menu_additem(menu, temp, szItem, 0, -1);
		}
	}
	_DisplayMenu(id, menu);
	return 0;
}

public reg_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	new pLen = strlen(g_szUserPassword[id]);
	switch (index)
	{
		case 0:
		{
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_CANT_CHANGE_ACC");
			_ShowRegMenu(id);
		}
		case 1:
		{
			if (g_bLogged[id] != true)
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_REG_INSERT_PASS", 6);
				client_cmd(id, "messagemode UserPassword");
			}
		}
		case 2:
		{
			g_bLogged[id] = false;
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_LOGOUT_SUCCESS");
		}
		case 3:
		{
			_LoadData(id);
			new spLen = strlen(g_szUserSavedPass[id]);
			if (strlen(g_szUserPassword[id]) <= 0) {
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_REG_INSERT_PASS", 6);
				client_cmd(id, "messagemode UserPassword");
				return 0;
			}
			if (!equal(g_szUserPassword[id], g_szUserSavedPass[id], spLen))
			{
				g_iUserPassFail[id]++;
				if (3 <= g_iUserPassFail[id])
				{
					new reason[32];
					formatex(reason, 31, "%L", id, "CSGOR_MAX_PASS_FAIL", 3);
					server_cmd("kick #%d ^"%s^"", get_user_userid(id), reason);
				}
				else
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_PASS_FAIL", g_iUserPassFail[id], 3);
					_ShowRegMenu(id);
				}
			}
			else
			{
				g_bLogged[id] = true;
				_ShowMainMenu(id);
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_LOGIN_SUCCESS");
			}
		}
		case 4:
		{
			if (pLen < 6)
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_REG_INSERT_PASS", 6);
				_ShowRegMenu(id);
				return _MenuExit(menu);
			}
			copy(g_szUserSavedPass[id], 15, g_szUserPassword[id]);
			_SaveData(id);
			_ShowRegMenu(id);
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_REG_SUCCESS", g_szUserSavedPass[id]);
		}
		default:
		{
		}
	}
	return _MenuExit(menu);
}

public concmd_password(id)
{
	if (g_bLogged[id] == true)
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_ALREADY_LOGIN");
		return 1;
	}
	new data[32];
	read_args(data, 31);
	remove_quotes(data);
	if (6 > strlen(data))
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_REG_INSERT_PASS", 6);
		client_cmd(id, "messagemode UserPassword");
		return 1;
	}
	copy(g_szUserPassword[id], 15, data);
	_ShowRegMenu(id);
	return 1;
}

_SaveData(id)
{
	new Data[576];
	new infobuff[64];
	new weapbuff[384];
	new skinbuff[96];
	formatex(infobuff, 63, "%s=%d,%d,%d,%d,%d,%d", g_szUserSavedPass[id], g_iUserPoints[id], g_iUserDusts[id], g_iUserKeys[id], g_iUserCases[id], g_iUserKills[id], g_iUserRank[id]);
	formatex(weapbuff, 383, "%d", g_iUserSkins[id]);
	new i = 1;
	while (i < 96)
	{
		format(weapbuff, 383, "%s,%d", weapbuff, g_iUserSkins[id][i]);
		i++;
	}
	formatex(skinbuff, 95, "%d", g_iUserSelectedSkin[id][1]);
	i = 2;
	while (i <= 30)
	{
		format(skinbuff, 95, "%s,%d", skinbuff, g_iUserSelectedSkin[id][i]);
		i++;
	}
	formatex(Data, 575, "%s*%s#%s", infobuff, weapbuff, skinbuff);
	nvault_set(g_Vault, g_szName[id], Data);
	return 0;
}

_ShowMainMenu(id)
{
	new temp[96];
	formatex(temp, 95, "\r%s \w%L^n%L", "[CSGO Remake]", id, "CSGOR_MAIN_MENU", id, "CSGOR_MM_INFO", g_iUserPoints[id], g_iUserKills[id]);
	new menu = menu_create(temp, "main_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	formatex(temp, 95, "\w%L", id, "CSGOR_MM_SKINS");
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 95, "\w%L", id, "CSGOR_MM_OPEN_CRAFT");
	menu_additem(menu, temp, szItem, 0, -1);
	if (g_bUserSell[id])
	{
		new szSell[32];
		_GetItemName(g_iUserSellItem[id], szSell, 31);
		formatex(temp, 95, "\w%L", id, "CSGOR_MM_MARKET_SELL", szSell);
	}
	else
	{
		formatex(temp, 95, "\w%L", id, "CSGOR_MM_MARKET");
	}
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 95, "\w%L", id, "CSGOR_MM_DUSTBIN");
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 95, "\w%L", id, "CSGOR_MM_GIFT");
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 95, "\w%L", id, "CSGOR_MM_TRADE");
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 95, "\w%L", id, "CSGOR_MM_GAMES");
	menu_additem(menu, temp, szItem, 0, -1);
	new userRank = g_iUserRank[id];
	new szRank[32];
	ArrayGetString(g_aRankName, userRank, szRank, 31);
	if (g_iRanksNum + -1 > userRank)
	{
		new nextRank = ArrayGetCell(g_aRankKills, userRank + 1) - g_iUserKills[id];
		formatex(temp, 95, "\w%L^n%L", id, "CSGOR_MM_RANK", szRank, id, "CSGOR_MM_NEXT_KILLS", nextRank);
	}
	else
	{
		formatex(temp, 95, "\w%L^n%L", id, "CSGOR_MM_RANK", szRank, id, "CSGOR_MM_MAX_KILLS");
	}
	menu_addtext(menu, temp, 0);
	_DisplayMenu(id, menu);
	return 0;
}

_GetItemName(item, temp[], len)
{
	switch (item)
	{
		case -12:
		{
			formatex(temp, len, "%L", -1, "CSGOR_ITEM_KEY");
		}
		case -11:
		{
			formatex(temp, len, "%L", -1, "CSGOR_ITEM_CASE");
		}
		default:
		{
			ArrayGetString(g_aSkinName, item, temp, len);
		}
	}
	return 0;
}

public main_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		return _MenuExit(menu);
	}
	switch (item)
	{
		case 0:
		{
			_ShowSkinMenu(id);
		}
		case 1:
		{
			_ShowOpenCaseCraftMenu(id);
		}
		case 2:
		{
			_ShowMarketMenu(id);
		}
		case 3:
		{
			_ShowDustbinMenu(id);
		}
		case 4:
		{
			_ShowGiftMenu(id);
		}
		case 5:
		{
			_ShowTradeMenu(id);
		}
		case 6:
		{
			_ShowGamesMenu(id);
		}
		default:
		{
		}
	}
	return _MenuExit(menu);
}

_ShowSkinMenu(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_SKIN_MENU");
	new menu = menu_create(temp, "skin_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new bool:hasSkins;
	new num;
	new skinName[48];
	new skintype[4];
	new wid;
	new apply;
	new craft;
	new i = 0;
	while (i < g_iSkinsNum)
	{
		num = g_iUserSkins[id][i];
		if (num > 0)
		{
			ArrayGetString(g_aSkinName, i, skinName, 47);
			ArrayGetString(g_aSkinType, i, skintype, 3);
			if (equali(skintype, "d", 3))
			{
				craft = 0;
			}
			else
			{
				craft = 1;
			}
			wid = ArrayGetCell(g_aSkinWeaponID, i);
			if (i == g_iUserSelectedSkin[id][wid])
			{
				apply = 1;
			}
			else
			{
				apply = 0;
			}
			new crafted[64];
			new applied[64];
			
			switch (craft)
			{
				case 1:
				{
					crafted = "*";
				}
				
				default:
				{
					crafted = "";
				}
			}
			
			switch (apply)
			{
				case 1:
				{
					applied = "#";
				}
				
				default:
				{
					applied = "";
				}
			}
			formatex(temp, 63, "\r%s \y%s\w| \y%L \r%s", skinName, crafted, id, "CSGOR_SM_PIECES", num, applied);
			szItem[0] = i;
			menu_additem(menu, temp, szItem, 0, -1);
			hasSkins = true;
		}
		i++;
	}
	if (!hasSkins)
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_SM_NO_SKINS");
		szItem[0] = -10;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

public skin_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowMainMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	switch (index)
	{
		case -10:
		{
			_ShowMainMenu(id);
		}
		default:
		{
			new wid = ArrayGetCell(g_aSkinWeaponID, index);
			new bool:SameSkin;
			if (index == g_iUserSelectedSkin[id][wid])
			{
				SameSkin = true;
			}
			new sName[32];
			ArrayGetString(g_aSkinName, index, sName, 31);
			if (!SameSkin)
			{
				g_iUserSelectedSkin[id][wid] = index;
				_SaveData(id);
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_SELECT_SKIN", sName);
			}
			else
			{
				g_iUserSelectedSkin[id][wid] = -1;
				_SaveData(id);
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DESELECT_SKIN", sName);
			}
			_ShowSkinMenu(id);
		}
	}
	return _MenuExit(menu);
}

public Ham_Grenade_PA(ent)
{
	if (!(pev_valid(ent) == 2))
	{
		return 0;
	}
	get_pdata_cbase(ent, 41, 4, 5);
	ShortThrow = false;
	return 0;
}

public Ham_Grenade_SA(ent)
{
	if (!(pev_valid(ent) == 2))
	{
		return 0;
	}
	get_pdata_cbase(ent, 41, 4, 5);
	ExecuteHamB(Ham_Weapon_PrimaryAttack, ent);
	ShortThrow = true;
	return 0;
}

public grenade_throw(id, ent, csw)
{
	if (!(pev_valid(ent)) || !(0 < id && 32 >= id || !is_user_connected(id)))
	{
		return 0;
	}
	switch (csw)
	{
		case 4:
		{
			engfunc(EngFunc_SetModel, ent, g_szNadeModels[0]);
		}
		case 9:
		{
			engfunc(EngFunc_SetModel, ent, g_szNadeModels[2]);
		}
		case 25:
		{
			engfunc(EngFunc_SetModel, ent, g_szNadeModels[1]);
		}
		default:
		{
		}
	}
	if (csw == 25)
	{
		set_pev(ent, pev_dmgtime, get_gametime() + 1.00);
	}
	if (!ShortThrow)
	{
		return 0;
	}
	new Float:grenadeVelocity[3];
	pev(ent, pev_velocity, grenadeVelocity);
	xs_vec_mul_scalar(grenadeVelocity, 0.5, grenadeVelocity);
	set_pev(ent, pev_velocity, grenadeVelocity);
	return 0;
}

public Ham_Item_Deploy_Post(weapon_ent)
{
	new owner = fm_cs_get_weapon_ent_owner(weapon_ent);
	if (!is_user_alive(owner))
	{
		return 0;
	}
	new weaponid = cs_get_weapon_id(weapon_ent);
	new userskin = g_iUserSelectedSkin[owner][weaponid];
	if (userskin != -1)
	{
		if (1 > g_iUserSkins[owner][userskin])
		{
			g_iUserSelectedSkin[owner][weaponid] = -1;
			userskin = -1;
		}
	}
	new imp = pev(weapon_ent, 82);
	new model[48];
	if (0 < imp)
	{
		ArrayGetString(g_aSkinModel, imp + -1, model, 47);
		set_pev(owner, pev_viewmodel2, model);
		if (g_bSkinHasModelP[imp + -1])
		{
			ArrayGetString(g_aSkinModelP, imp + -1, model, 47);
			set_pev(owner, pev_weaponmodel2, model);
		}
	}
	else
	{
		if (userskin != -1 && g_bLogged[owner] == true)
		{
			ArrayGetString(g_aSkinModel, userskin, model, 47);
			set_pev(owner, pev_viewmodel2, model);
			if (g_bSkinHasModelP[userskin])
			{
				ArrayGetString(g_aSkinModelP, userskin, model, 47);
				set_pev(owner, pev_weaponmodel2, model);
			}
		}
		if (g_szDefaultSkinModel[weaponid][0] && userskin == -1)
		{
			set_pev(owner, pev_viewmodel2, g_szDefaultSkinModel[weaponid]);
			if (0 < strlen(g_szDefaultPSkinModel[weaponid][0]))
			{
				set_pev(owner, pev_weaponmodel2, g_szDefaultPSkinModel[weaponid]);
			}
		}
	}
	return 0;
}

fm_cs_get_weapon_ent_owner(ent)
{
	if (pev_valid(ent) != 2)
	{
		return -1;
	}
	return get_pdata_cbase(ent, 41, 4, 5);
}

public Ham_Item_Can_Drop(ent)
{
	if (pev_valid(ent) != 2)
	{
		return 0;
	}
	new weapon = get_pdata_int(ent, 43, 4, 5);
	if (weapon < 1 || weapon > 30)
	{
		return 0;
	}
	if (1 << weapon & 570425936)
	{
		return 0;
	}
	new imp = pev(ent, 82);
	if (0 < imp)
	{
		return 0;
	}
	new id = get_pdata_cbase(ent, 41, 4, 5);
	if (!is_user_connected(id))
	{
		return 0;
	}
	new skin = g_iUserSelectedSkin[id][weapon];
	if (skin != -1)
	{
		set_pev(ent, 82, skin + 1);
	}
	return 0;
}

_ShowOpenCaseCraftMenu(id)
{
	new temp[96];
	formatex(temp, 95, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_OC_CRAFT_MENU");
	new menu = menu_create(temp, "oc_craft_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	formatex(temp, 95, "\w%L^n%L^n", id, "CSGOR_OCC_OPENCASE", id, "CSGOR_OCC_OPEN_ITEMS", g_iUserCases[id], g_iUserKeys[id]);
	szItem[0] = 0;
	menu_additem(menu, temp, szItem, 0, -1);
	if (0 < g_iDropType)
	{
		formatex(temp, 95, "\r%L^n\w%L^n", id, "CSGOR_OCC_BUY_KEY", id, "CSGOR_MR_PRICE", g_iKeyPrice);
		szItem[0] = 2;
		menu_additem(menu, temp, szItem, 0, -1);
		formatex(temp, 95, "\r%L \w| %L^n", id, "CSGOR_OCC_SELL_KEY", id, "CSGOR_RECEIVE_POINTS", g_iKeyPrice / 2);
		szItem[0] = 3;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	formatex(temp, 95, "\w%L^n%L", id, "CSGOR_OCC_CRAFT", id, "CSGOR_OCC_CRAFT_ITEMS", g_iUserDusts[id], g_iCraftCost);
	szItem[0] = 1;
	menu_additem(menu, temp, szItem, 0, -1);
	_DisplayMenu(id, menu);
	return 0;
}

public oc_craft_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowMainMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	switch (index)
	{
		case 0:
		{
			if (g_iUserCases[id] < 1 || g_iUserKeys[id] < 1)
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_OPEN_NOT_ENOUGH");
				_ShowOpenCaseCraftMenu(id);
			}
			else
			{
				if (get_systime(0) < g_iLastOpenCraft[id] + 5)
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DONT_SPAM", 5);
					_ShowOpenCaseCraftMenu(id);
					return 0;
				}
				_OpenCase(id);
			}
		}
		case 1:
		{
			if (g_iCraftCost > g_iUserDusts[id])
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_CRAFT_NOT_ENOUGH", g_iCraftCost - g_iUserDusts[id]);
				_ShowOpenCaseCraftMenu(id);
			}
			else
			{
				if (get_systime(0) < g_iLastOpenCraft[id] + 5)
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DONT_SPAM", 5);
					_ShowOpenCaseCraftMenu(id);
					return 0;
				}
				_CraftSkin(id);
			}
		}
		case 2:
		{
			if (g_iKeyPrice > g_iUserPoints[id])
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_NOT_ENOUGH_POINTS", g_iKeyPrice - g_iUserPoints[id]);
				_ShowOpenCaseCraftMenu(id);
			}
			else
			{
				g_iUserPoints[id] -= g_iKeyPrice;
				g_iUserKeys[id]++;
				_SaveData(id);
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_BUY_KEY");
				_ShowOpenCaseCraftMenu(id);
			}
		}
		case 3:
		{
			if (1 > g_iUserKeys[id])
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_NONE_KEYS");
				_ShowOpenCaseCraftMenu(id);
			}
			else
			{
				g_iUserPoints[id] += g_iKeyPrice / 2;
				g_iUserKeys[id]--;
				_SaveData(id);
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_SELL_KEY");
				_ShowOpenCaseCraftMenu(id);
			}
		}
		default:
		{
		}
	}
	return _MenuExit(menu);
}

_OpenCase(id)
{
	new timer;
	new bool:succes;
	new rSkin;
	new rChance;
	new skinID;
	new wChance;
	new run;
	do {
		rSkin = random_num(0, g_iDropSkinNum + -1);
		rChance = random_num(1, 100);
		if (0 >= g_iDropSkinNum)
		{
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_NO_DROP_SKINS");
			_ShowOpenCaseCraftMenu(id);
			return 0;
		}
		skinID = ArrayGetCell(g_aDropSkin, rSkin);
		wChance = ArrayGetCell(g_aSkinChance, skinID);
		if (rChance >= wChance)
		{
			succes = true;
		}
		timer++;
		if (!(timer < 5 && !succes))
		{
			if (succes)
			{
				new Skin[32];
				ArrayGetString(g_aSkinName, skinID, Skin, 31);
				g_iUserSkins[id][skinID]++;
				g_iUserCases[id]--;
				g_iUserKeys[id]--;
				_SaveData(id);
				if (0 < g_iShowDropCraft)
				{
					client_print_color(0, id, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_DROP_SUCCESS_ALL", g_szName[id], Skin, 100 - wChance);
				}
				else
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DROP_SUCCESS", Skin, 100 - wChance);
				}
				g_iLastOpenCraft[id] = get_systime(0);
				_ShowOpenCaseCraftMenu(id);
			}
			else
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DROP_FAIL");
				_ShowOpenCaseCraftMenu(id);
			}
			return 0;
		}
	} while (run);
	if (succes)
	{
		new Skin[32];
		ArrayGetString(g_aSkinName, skinID, Skin, 31);
		g_iUserSkins[id][skinID]++;
		g_iUserCases[id]--;
		g_iUserKeys[id]--;
		_SaveData(id);
		if (0 < g_iShowDropCraft)
		{
			client_print_color(0, id, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_DROP_SUCCESS_ALL", g_szName[id], Skin, 100 - wChance);
		}
		else
		{
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DROP_SUCCESS", Skin, 100 - wChance);
		}
		g_iLastOpenCraft[id] = get_systime(0);
		_ShowOpenCaseCraftMenu(id);
	}
	else
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DROP_FAIL");
		_ShowOpenCaseCraftMenu(id);
	}
	return 0;
}

_CraftSkin(id)
{
	new timer;
	new bool:succes;
	new rSkin;
	new rChance;
	new skinID;
	new wChance;
	new run;
	do {
		rSkin = random_num(0, g_iCraftSkinNum + -1);
		rChance = random_num(1, 100);
		if (0 >= g_iCraftSkinNum)
		{
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_NO_CRAFT_SKINS");
			_ShowOpenCaseCraftMenu(id);
			return 0;
		}
		skinID = ArrayGetCell(g_aCraftSkin, rSkin);
		wChance = ArrayGetCell(g_aSkinChance, skinID);
		if (rChance >= wChance)
		{
			succes = true;
		}
		timer++;
		if (!(timer < 5 && !succes))
		{
			if (succes)
			{
				new Skin[32];
				ArrayGetString(g_aSkinName, skinID, Skin, 31);
				g_iUserSkins[id][skinID]++;
				g_iUserDusts[id] -= g_iCraftCost;
				_SaveData(id);
				if (0 < g_iShowDropCraft)
				{
					client_print_color(0, id, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_CRAFT_SUCCESS_ALL", g_szName[id], Skin, 100 - wChance);
				}
				else
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_CRAFT_SUCCESS", Skin, 100 - wChance);
				}
				g_iLastOpenCraft[id] = get_systime(0);
				_ShowOpenCaseCraftMenu(id);
			}
			else
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_CRAFT_FAIL");
				_ShowOpenCaseCraftMenu(id);
			}
			return 0;
		}
	} while (run);
	if (succes)
	{
		new Skin[32];
		ArrayGetString(g_aSkinName, skinID, Skin, 31);
		g_iUserSkins[id][skinID]++;
		g_iUserDusts[id] -= g_iCraftCost;
		if (0 < g_iShowDropCraft)
		{
			client_print_color(0, id, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_CRAFT_SUCCESS_ALL", g_szName[id], Skin, 100 - wChance);
		}
		else
		{
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_CRAFT_SUCCESS", Skin, 100 - wChance);
		}
		_SaveData(id);
		g_iLastOpenCraft[id] = get_systime(0);
		_ShowOpenCaseCraftMenu(id);
	}
	else
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_CRAFT_FAIL");
		_ShowOpenCaseCraftMenu(id);
	}
	return 0;
}

_ShowMarketMenu(id)
{
	new temp[96];
	formatex(temp, 95, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_MARKET_MENU");
	new menu = menu_create(temp, "market_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new szSkin[48];
	if (!_IsGoodItem(g_iUserSellItem[id]))
	{
		formatex(temp, 95, "\y%L", id, "CSGOR_MR_SELECT_ITEM");
	}
	else
	{
		_GetItemName(g_iUserSellItem[id], szSkin, 47);
		formatex(temp, 95, "\w%L^n\w%L", id, "CSGOR_MR_SELL_ITEM", szSkin, id, "CSGOR_MR_PRICE", g_iUserItemPrice[id]);
	}
	szItem[0] = 33;
	menu_additem(menu, temp, szItem, 0, -1);
	if (g_bUserSell[id])
	{
		formatex(temp, 95, "\r%L^n", id, "CSGOR_MR_CANCEL_SELL");
		szItem[0] = 35;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	else
	{
		formatex(temp, 95, "\r%L^n", id, "CSGOR_MR_START_SELL");
		szItem[0] = 34;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	new Pl[32];
	new n;
	new p;
	get_players(Pl, n, "h", "");
	if (n)
	{
		new items;
		new sType[4];
		new bool:craft;
		new i;
		while (i < n)
		{
			p = Pl[i];
			if (g_bLogged[p] == true)
			{
				if (!(p == id))
				{
					if (g_bUserSell[p])
					{
						new index = g_iUserSellItem[p];
						_GetItemName(index, szSkin, 47);
						if (_IsItemSkin(index))
						{
							ArrayGetString(g_aSkinType, index, sType, 3);
						}
						else
						{
							formatex(sType, 3, "d");
						}
						if (equali(sType, "c", 0))
						{
							craft = true;
						}
						else
						{
							craft = false;
						}
						new crafted[64];
						if (craft)
						{
							crafted = "*";
						}
						else
						{
							crafted = "";
						}
						formatex(temp, 95, "\w%s | \r%s \y%s\w| \y%d %L", g_szName[p], szSkin, crafted, g_iUserItemPrice[p], id, "CSGOR_POINTS");
						szItem[0] = p;
						menu_additem(menu, temp, szItem, 0, -1);
						items++;
					}
				}
			}
			i++;
		}
		if (!items)
		{
			formatex(temp, 95, "\r%L", id, "CSGOR_NOBODY_SELL");
			szItem[0] = -10;
			menu_additem(menu, temp, szItem, 0, -1);
		}
	}
	_DisplayMenu(id, menu);
	return 0;
}

bool:_IsItemSkin(item)
{
	if (0 <= item < g_iSkinsNum)
	{
		return true;
	}
	return false;
}

bool:_IsGoodItem(item)
{
	if (0 <= item < g_iSkinsNum || item == -11 || item == -12)
	{
		return true;
	}
	return false;
}

public market_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowMainMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	switch (index)
	{
		case -10:
		{
			_ShowMarketMenu(id);
		}
		case 33:
		{
			if (g_bUserSell[id])
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_MUST_CANCEL");
				_ShowMarketMenu(id);
			}
			else
			{
				_ShowItems(id);
			}
		}
		case 34:
		{
			if (!_UserHasItem(id, g_iUserSellItem[id]))
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_MUST_SELECT");
				_ShowMarketMenu(id);
			}
			else
			{
				if (g_iWaitForPlace > get_systime(0) - g_iLastPlace[id])
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_MUST_WAIT", g_iLastPlace[id] - get_systime(0));
				}
				if (1 > g_iUserItemPrice[id])
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_IM_SET_PRICE");
					_ShowMarketMenu(id);
				}
				new wPriceMin;
				new wPriceMax;
				_CalcItemPrice(g_iUserSellItem[id], wPriceMin, wPriceMax);
				if (!(wPriceMin <= g_iUserItemPrice[id] <= wPriceMax))
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_ITEM_MIN_MAX_COST", wPriceMin, wPriceMax);
					_ShowMarketMenu(id);
					return _MenuExit(menu);
				}
				g_bUserSell[id] = 1;
				g_iLastPlace[id] = get_systime(0);
				new Item[32];
				_GetItemName(g_iUserSellItem[id], Item, 31);
				client_print_color(0, id, "^4%s %L", "[CSGO Remake]", id, "CSGOR_SELL_ANNOUNCE", g_szName[id], Item, g_iUserItemPrice[id]);
			}
		}
		case 35:
		{
			g_bUserSell[id] = 0;
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_CANCEL_SELL");
			_ShowMarketMenu(id);
		}
		default:
		{
			new tItem = g_iUserSellItem[index];
			new price = g_iUserItemPrice[index];
			if (!g_bLogged[index] || !(0 < index && 32 >= index))
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_INVALID_SELLER");
				g_bUserSell[index] = 0;
				_ShowMarketMenu(id);
			}
			else
			{
				if (!_UserHasItem(index, tItem))
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DONT_HAVE_ITEM");
					g_bUserSell[index] = 0;
					g_iUserSellItem[index] = -1;
					_ShowMarketMenu(id);
				}
				if (price > g_iUserPoints[id])
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_NOT_ENOUGH_POINTS", price - g_iUserPoints[id]);
					_ShowMarketMenu(id);
					return 0;
				}
				new szItem[32];
				_GetItemName(g_iUserSellItem[index], szItem, 31);
				switch (tItem)
				{
					case -12:
					{
						g_iUserKeys[id]++;
						g_iUserKeys[index]--;
						g_iUserPoints[id] -= price;
						g_iUserPoints[index] += price;
						_SaveData(id);
						client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_X_BUY_Y", g_szName[id], szItem, g_szName[index]);
					}
					case -11:
					{
						g_iUserCases[id]++;
						g_iUserCases[index]--;
						g_iUserPoints[id] -= price;
						g_iUserPoints[index] += price;
						_SaveData(id);
						client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_X_BUY_Y", g_szName[id], szItem, g_szName[index]);
					}
					default:
					{
						g_iUserSkins[id][tItem]++;
						g_iUserSkins[index][tItem]--;
						g_iUserPoints[id] -= price;
						_SaveData(id);
						client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_X_BUY_Y", g_szName[id], szItem, g_szName[index]);
					}
				}
				g_iUserSellItem[index] = -1;
				g_bUserSell[index] = 0;
				g_iUserItemPrice[index] = 0;
				_ShowMainMenu(id);
			}
		}
	}
	return _MenuExit(menu);
}

_ShowItems(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_ITEM_MENU");
	new menu = menu_create(temp, "item_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new total;
	if (0 < g_iUserCases[id])
	{
		formatex(temp, 63, "\r%L \w| \y%L", id, "CSGOR_ITEM_CASE", id, "CSGOR_SM_PIECES", g_iUserCases[id]);
		szItem[0] = -11;
		menu_additem(menu, temp, szItem, 0, -1);
		total++;
	}
	if (g_iUserKeys[id] > 0 && g_iDropType < 1)
	{
		formatex(temp, 63, "\r%L \w| \y%L", id, "CSGOR_ITEM_KEY", id, "CSGOR_SM_PIECES", g_iUserKeys[id]);
		szItem[0] = -12;
		menu_additem(menu, temp, szItem, 0, -1);
		total++;
	}
	new szSkin[32];
	new num;
	new type[2];
	new i;
	while (i < g_iSkinsNum)
	{
		num = g_iUserSkins[id][i];
		if (0 < num)
		{
			ArrayGetString(g_aSkinName, i, szSkin, 31);
			ArrayGetString(g_aSkinType, i, type, 1);
			new applied[64];
			switch (type[0])
			{
				case 99:
				{
					applied = "#";
				}
				
				default:
				{
					applied = "";
				}
			}
			formatex(temp, 63, "\r%s \w| \y%L \r%s", szSkin, id, "CSGOR_SM_PIECES", num, applied);
			szItem[0] = i;
			menu_additem(menu, temp, szItem, 0, -1);
			total++;
		}
		i++;
	}
	if (!total)
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_NO_ITEMS");
		szItem[0] = -10;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

public item_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowMarketMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	if (index == -10)
	{
		_ShowMarketMenu(id);
		return _MenuExit(menu);
	}
	g_iUserSellItem[id] = index;
	new szItem[32];
	_GetItemName(index, szItem, 31);
	client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_IM_SELECT", szItem);
	client_cmd(id, "messagemode ItemPrice");
	client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_IM_SET_PRICE");
	return _MenuExit(menu);
}

public concmd_itemprice(id)
{
	new item = g_iUserSellItem[id];
	if (!_IsGoodItem(item))
	{
		return 1;
	}
	new data[16];
	read_args(data, 15);
	remove_quotes(data);
	new uPrice;
	new wPriceMin;
	new wPriceMax;
	uPrice = str_to_num(data);
	_CalcItemPrice(item, wPriceMin, wPriceMax);
	if (uPrice < wPriceMin || uPrice > wPriceMax)
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_ITEM_MIN_MAX_COST", wPriceMin, wPriceMax);
		client_cmd(id, "messagemode ItemPrice");
		return 1;
	}
	g_iUserItemPrice[id] = uPrice;
	_ShowMarketMenu(id);
	return 1;
}

bool:_UserHasItem(id, item)
{
	if (!_IsGoodItem(item))
	{
		return false;
	}
	switch (item)
	{
		case -12:
		{
			if (0 < g_iUserKeys[id])
			{
				return true;
			}
		}
		case -11:
		{
			if (0 < g_iUserCases[id])
			{
				return true;
			}
		}
		default:
		{
			if (0 < g_iUserSkins[id][item])
			{
				return true;
			}
		}
	}
	return false;
}

_CalcItemPrice(item, &min, &max)
{
	switch (item)
	{
		case -12:
		{
			min = g_iKeyMinCost;
			max = g_iCostMultiplier * g_iKeyMinCost;
		}
		case -11:
		{
			min = g_iCaseMinCost;
			max = g_iCostMultiplier * g_iCaseMinCost;
		}
		default:
		{
			min = ArrayGetCell(g_aSkinCostMin, item);
			new i = min;
			max = i * 2;
		}
	}
	return 0;
}

_ShowDustbinMenu(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_DB_MENU");
	new menu = menu_create(temp, "dustbin_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	formatex(temp, 63, "\y%L\n", id, "CSGOR_DB_TRANSFORM");
	szItem[0] = 1;
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 63, "\r%L", id, "CSGOR_DB_DESTROY");
	szItem[0] = 2;
	menu_additem(menu, temp, szItem, 0, -1);
	_DisplayMenu(id, menu);
	return 0;
}

public dustbin_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowMainMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	g_iMenuType[id] = index;
	_ShowSkins(id);
	return _MenuExit(menu);
}

_ShowSkins(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_SKINS");
	new menu = menu_create(temp, "db_skins_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new szSkin[32];
	new num;
	new type[2];
	new total;
	new i;
	while (i < g_iSkinsNum)
	{
		num = g_iUserSkins[id][i];
		if (0 < num)
		{
			ArrayGetString(g_aSkinName, i, szSkin, 31);
			ArrayGetString(g_aSkinType, i, type, 1);
			new applied[64];
			switch (type[0])
			{
				case 99:
				{
					applied = "#";
				}
				
				default:
				{
					applied = "";
				}
			}
			formatex(temp, 63, "\r%s \w| \y%L \r%s", szSkin, id, "CSGOR_SM_PIECES", num, applied);
			szItem[0] = i;
			menu_additem(menu, temp, szItem, 0, -1);
			total++;
		}
		i++;
	}
	if (!total)
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_SM_NO_SKINS");
		szItem[0] = -10;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

public db_skins_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowDustbinMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	if (index == -10)
	{
		_ShowMainMenu(id);
		return _MenuExit(menu);
	}
	switch (g_iMenuType[id])
	{
		case 1:
		{
			g_iUserSkins[id][index]--;
			g_iUserDusts[id] += g_iDustForTransform;
			new Skin[32];
			ArrayGetString(g_aSkinName, index, Skin, 31);
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRANSFORM", g_iDustForTransform, Skin);
			_SaveData(id);
		}
		case 2:
		{
			g_iUserSkins[id][index]--;
			new Skin[32];
			ArrayGetString(g_aSkinName, index, Skin, 31);
			new sPrice = ArrayGetCell(g_aSkinCostMin, index);
			new rest = sPrice / g_iReturnPercent;
			g_iUserPoints[id] += rest;
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DESTORY", Skin, rest);
			_SaveData(id);
		}
		default:
		{
		}
	}
	g_iMenuType[id] = 0;
	_ShowDustbinMenu(id);
	return _MenuExit(menu);
}

_ShowGiftMenu(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_GIFT_MENU");
	new menu = menu_create(temp, "gift_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new bool:HasTarget;
	new bool:HasItem;
	new target = g_iGiftTarget[id];
	if (target)
	{
		formatex(temp, 63, "\w%L", id, "CSGOR_GM_TARGET", g_szName[target]);
		szItem[0] = 0;
		menu_additem(menu, temp, szItem, 0, -1);
		HasTarget = true;
	}
	else
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_GM_SELECT_TARGET");
		szItem[0] = 0;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	if (!_IsGoodItem(g_iGiftItem[id]))
	{
		formatex(temp, 63, "\r%L^n", id, "CSGOR_GM_SELECT_ITEM");
		szItem[0] = 1;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	else
	{
		new Item[32];
		_GetItemName(g_iGiftItem[id], Item, 31);
		formatex(temp, 63, "\w%L^n", id, "CSGOR_GM_ITEM", Item);
		szItem[0] = 1;
		menu_additem(menu, temp, szItem, 0, -1);
		HasItem = true;
	}
	if (HasTarget && HasItem)
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_GM_SEND");
		szItem[0] = 2;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

public gift_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowMainMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	switch (index)
	{
		case 0:
		{
			_SelectTarget(id);
		}
		case 1:
		{
			_SelectItem(id);
		}
		case 2:
		{
			new target = g_iGiftTarget[id];
			new _item = g_iGiftItem[id];
			if (g_bLogged[target] != true || !(0 < target && 32 >= target))
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_INVALID_TARGET");
				g_iGiftTarget[id] = 0;
				_ShowGiftMenu(id);
			}
			else
			{
				if (!_UserHasItem(id, _item))
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_NOT_ENOUGH_ITEMS");
					g_iGiftItem[id] = -1;
					_ShowGiftMenu(id);
				}
				new gift[16];
				switch (_item)
				{
					case -12:
					{
						g_iUserKeys[id]--;
						g_iUserKeys[target]++;
						formatex(gift, 15, "%L", id, "CSGOR_ITEM_KEY");
						client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_SEND_GIFT", gift, g_szName[target]);
						client_print_color(target, target, "^4%s^1 %L", "[CSGO Remake]", target, "CSGOR_RECIEVE_GIFT", g_szName[id], gift);
					}
					case -11:
					{
						g_iUserCases[id]--;
						g_iUserCases[target]++;
						formatex(gift, 15, "%L", id, "CSGOR_ITEM_CASE");
						client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_SEND_GIFT", gift, g_szName[target]);
						client_print_color(target, target, "^4%s^1 %L", "[CSGO Remake]", target, "CSGOR_RECIEVE_GIFT", g_szName[id], gift);
					}
					default:
					{
						g_iUserSkins[id][_item]--;
						g_iUserSkins[target][_item]++;
						new Skin[32];
						_GetItemName(g_iGiftItem[id], Skin, 31);
						client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_SEND_GIFT", Skin, g_szName[target]);
						client_print_color(target, target, "^4%s^1 %L", "[CSGO Remake]", target, "CSGOR_RECIEVE_GIFT", g_szName[id], Skin);
					}
				}
				g_iGiftTarget[id] = 0;
				g_iGiftItem[id] = -1;
				_ShowMainMenu(id);
			}
		}
		default:
		{
		}
	}
	return _MenuExit(menu);
}

_SelectTarget(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \y%L", "[CSGO Remake]", id, "CSGOR_GM_SELECT_TARGET");
	new menu = menu_create(temp, "st_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new Pl[32];
	new n;
	new p;
	get_players(Pl, n, "h", "");
	new total;
	if (n)
	{
		new i;
		while (i < n)
		{
			p = Pl[i];
			if (g_bLogged[p])
			{
				if (!(p == id))
				{
					szItem[0] = p;
					menu_additem(menu, g_szName[p], szItem, 0, -1);
					total++;
				}
			}
			i++;
		}
	}
	if (!total)
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_ST_NO_PLAYERS");
		szItem[0] = -10;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

public st_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowGiftMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	new name[32];
	menu_item_getinfo(menu, item, dummy, itemdata, 1, name, 31, dummy);
	index = itemdata[0];
	switch (index)
	{
		case -10:
		{
			_ShowMainMenu(id);
		}
		default:
		{
			g_iGiftTarget[id] = index;
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_YOUR_TARGET", name);
			_ShowGiftMenu(id);
		}
	}
	return _MenuExit(menu);
}

_SelectItem(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_ITEM_MENU");
	new menu = menu_create(temp, "si_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new total;
	if (0 < g_iUserCases[id])
	{
		formatex(temp, 63, "\r%L \w| \y%L", id, "CSGOR_ITEM_CASE", id, "CSGOR_SM_PIECES", g_iUserCases[id]);
		szItem[0] = -11;
		menu_additem(menu, temp, szItem, 0, -1);
		total++;
	}
	if (0 < g_iUserKeys[id])
	{
		formatex(temp, 63, "\r%L \w| \y%L", id, "CSGOR_ITEM_KEY", id, "CSGOR_SM_PIECES", g_iUserKeys[id]);
		szItem[0] = -12;
		menu_additem(menu, temp, szItem, 0, -1);
		total++;
	}
	new szSkin[32];
	new num;
	new type[2];
	new i;
	while (i < g_iSkinsNum)
	{
		num = g_iUserSkins[id][i];
		if (0 < num)
		{
			ArrayGetString(g_aSkinName, i, szSkin, 31);
			ArrayGetString(g_aSkinType, i, type, 1);
			switch (type[0])
			{
				case 99:
				{
					formatex(temp, 63, "\r%s \w| \y%L \r#", szSkin, id, "CSGOR_SM_PIECES", num);
				}
				
				default:
				{
					formatex(temp, 63, "\r%s \w| \y%L \r", szSkin, id, "CSGOR_SM_PIECES", num);
				}
			}
			szItem[0] = i;
			menu_additem(menu, temp, szItem, 0, -1);
			total++;
		}
		i++;
	}
	if (!total)
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_NO_ITEMS");
		szItem[0] = -10;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

public si_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowGiftMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	switch (index)
	{
		case -10:
		{
			_ShowMainMenu(id);
		}
		default:
		{
			if (index == g_iUserSellItem[id] && g_bUserSell[id])
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_INVALID_GIFT");
				_SelectItem(id);
			}
			else
			{
				g_iGiftItem[id] = index;
				new szItem[32];
				_GetItemName(index, szItem, 31);
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_YOUR_GIFT", szItem);
				_ShowGiftMenu(id);
			}
		}
	}
	return _MenuExit(menu);
}

public Message_SayText(msgId, msgDest, msgEnt)
{
	return PLUGIN_HANDLED;
}

public Message_SayHandle(id)
{
	if (is_user_connected(id) && g_bLogged[id])
	{
		read_argv(1, szMessage, 127);
		for (new j = 1; j <= get_maxplayers(); j++)
		{
			if (j == 0 || equali(g_szName[id], "") || equali(szMessage, ""))
			{
				return 0;
			}
			new szRank[32];
			ArrayGetString(g_aRankName, g_iUserRank[id], szRank, 31);
			if (!is_user_alive(id) && cs_get_user_team(id) != CS_TEAM_SPECTATOR)
			{
				new temp[128];
				formatex(temp, 127, "^1*DEAD* ^4[%s] ^3%s ^1: %s", szRank, g_szName[id], szMessage);
				if (is_user_connected(j))
				{
					send_message(temp, id, j);
				}
			}
			if (is_user_alive(id))
			{
				new temp[128];
				formatex(temp, 127, "^4[%s] ^3%s ^1: %s", szRank, g_szName[id], szMessage);
				if (is_user_connected(j))
				{
					send_message(temp, id, j);
				}
			}
			if (!is_user_alive(id) && cs_get_user_team(id) == CS_TEAM_SPECTATOR)
			{
				new temp[128];
				formatex(temp, 127, "^1*SPEC* ^4[%s] ^3%s ^1: %s", szRank, g_szName[id], szMessage);
				if (is_user_connected(j))
				{
					send_message(temp, id, j);
				}
			}
		}
		return 0;
	}
	else if (is_user_connected(id) && !g_bLogged[id])
	{
		read_argv(1, szMessage, 127);
		for (new j = 1; j <= get_maxplayers(); j++)
		{
			if (j == 0 || equali(g_szName[id], "") || equali(szMessage, ""))
			{
				return 0;
			}
			if (!is_user_alive(id) && cs_get_user_team(id) != CS_TEAM_SPECTATOR)
			{
				new temp[128];
				formatex(temp, 127, "^1*DEAD* ^3%s ^1: %s", g_szName[id], szMessage);
				if (is_user_connected(j))
				{
					send_message(temp, id, j);
				}
			}
			if (is_user_alive(id))
			{
				new temp[128];
				formatex(temp, 127, "^3%s ^1: %s", g_szName[id], szMessage);
				if (is_user_connected(j))
				{
					send_message(temp, id, j);
				}
			}
			if (!is_user_alive(id) && cs_get_user_team(id) == CS_TEAM_SPECTATOR)
			{
				new temp[128];
				formatex(temp, 127, "^1*SPEC* ^3%s ^1: %s", g_szName[id], szMessage);
				if (is_user_connected(j))
				{
					send_message(temp, id, j);
				}
			}
		}
		return 0;
	}
	return 0;
}

public Message_SayHandleTeam(id)
{
	if (is_user_connected(id) && g_bLogged[id])
	{
		read_argv(1, szMessage, 127);
		for (new j = 1; j <= get_maxplayers(); j++)
		{
			if (j == 0 || equali(g_szName[id], "") || equali(szMessage, ""))
			{
				return 0;
			}
			new szRank[32];
			ArrayGetString(g_aRankName, g_iUserRank[id], szRank, 31);
			if (!is_user_alive(id) && is_user_connected(j) && cs_get_user_team(j) == cs_get_user_team(id))
			{
				new temp[128];
				if (cs_get_user_team(id) == CS_TEAM_T)
				{
					formatex(temp, 127, "^1*DEAD* (Terrorist) ^4[%s] ^3%s ^1: %s", szRank, g_szName[id], szMessage);
				}
				if (cs_get_user_team(id) == CS_TEAM_CT)
				{
					formatex(temp, 127, "^1*DEAD* (Counter-Terrorist) ^4[%s] ^3%s ^1: %s", szRank, g_szName[id], szMessage);
				}
				send_message(temp, id, j);
			}
			if (is_user_alive(id) && is_user_connected(j) && cs_get_user_team(j) == cs_get_user_team(id))
			{
				new temp[128];
				if (cs_get_user_team(id) == CS_TEAM_T)
				{
					formatex(temp, 127, "^1(Terrorist) ^4[%s] ^3%s ^1: %s", szRank, g_szName[id], szMessage);
				}
				if (cs_get_user_team(id) == CS_TEAM_CT)
				{
					formatex(temp, 127, "^1(Counter-Terrorist) ^4[%s] ^3%s ^1: %s", szRank, g_szName[id], szMessage);
				}
				send_message(temp, id, j);
			}
		}
		return 0;
	}
	else if (is_user_connected(id) && !g_bLogged[id])
	{
		read_argv(1, szMessage, 127);
		for (new j = 1; j <= get_maxplayers(); j++)
		{
			if (j == 0 || equali(g_szName[id], "") || equali(szMessage, ""))
			{
				return 0;
			}
			if (!is_user_alive(id) && is_user_connected(j) && cs_get_user_team(j) == cs_get_user_team(id))
			{
				new temp[128];
				if (cs_get_user_team(id) == CS_TEAM_T)
				{
					formatex(temp, 127, "^1*DEAD* (Terrorist) ^3%s ^1: %s", g_szName[id], szMessage);
				}
				if (cs_get_user_team(id) == CS_TEAM_CT)
				{
					formatex(temp, 127, "^1*DEAD* (Counter-Terrorist) ^3%s ^1: %s", g_szName[id], szMessage);
				}
				send_message(temp, id, j);
			}
			if (is_user_alive(id) && is_user_connected(j) && cs_get_user_team(j) == cs_get_user_team(id))
			{
				new temp[128];
				if (cs_get_user_team(id) == CS_TEAM_T)
				{
					formatex(temp, 127, "^1(Terrorist) ^3%s ^1: %s", g_szName[id], szMessage);
				}
				if (cs_get_user_team(id) == CS_TEAM_CT)
				{
					formatex(temp, 127, "^1(Counter-Terrorist) ^3%s ^1: %s", g_szName[id], szMessage);
				}
				send_message(temp, id, j);
			}
		}
		return 0;
	}
	return 0;
}

send_message(message[], id, i)
{
	if (!is_user_connected(i))
	{
		return 0;
	}
	message_begin(MSG_ONE, g_Msg_SayText, {0,0,0}, i);
	write_byte(id);
	write_string(message);
	message_end();
	return 0;
}

_ShowTradeMenu(id)
{
	if (g_bTradeAccept[id])
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_INFO2");
		return 0;
	}
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_TRADE_MENU");
	new menu = menu_create(temp, "trade_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new bool:HasTarget;
	new bool:HasItem;
	new target = g_iTradeTarget[id];
	if (target)
	{
		formatex(temp, 63, "\w%L", id, "CSGOR_GM_TARGET", g_szName[target]);
		szItem[0] = 0;
		menu_additem(menu, temp, szItem, 0, -1);
		HasTarget = true;
	}
	else
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_GM_SELECT_TARGET");
		szItem[0] = 0;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	if (!_IsGoodItem(g_iTradeItem[id]))
	{
		formatex(temp, 63, "\r%L^n", id, "CSGOR_GM_SELECT_ITEM");
		szItem[0] = 1;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	else
	{
		new Item[32];
		_GetItemName(g_iTradeItem[id], Item, 31);
		formatex(temp, 63, "\w%L^n", id, "CSGOR_GM_ITEM", Item);
		szItem[0] = 1;
		menu_additem(menu, temp, szItem, 0, -1);
		HasItem = true;
	}
	if (HasTarget && HasItem && !g_bTradeActive[id])
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_GM_SEND");
		szItem[0] = 2;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	if (g_bTradeActive[id] || g_bTradeSecond[id])
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_TRADE_CANCEL");
		szItem[0] = 3;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

public trade_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		if (g_bTradeSecond[id])
		{
			clcmd_say_deny(id);
		}
		_ShowMainMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	switch (index)
	{
		case 0:
		{
			if (g_bTradeActive[id] || g_bTradeSecond[id])
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_LOCKED");
				_ShowTradeMenu(id);
			}
			else
			{
				_SelectTradeTarget(id);
			}
		}
		case 1:
		{
			if (g_bTradeActive[id])
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_LOCKED");
				_ShowTradeMenu(id);
			}
			else
			{
				_SelectTradeItem(id);
			}
		}
		case 2:
		{
			new target = g_iTradeTarget[id];
			new _item = g_iTradeItem[id];
			if (!g_bLogged[target] || !(0 < target && 32 >= target))
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_INVALID_TARGET");
				_ResetTradeData(id);
				_ShowTradeMenu(id);
			}
			else
			{
				if (!_UserHasItem(id, _item))
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_NOT_ENOUGH_ITEMS");
					g_iTradeItem[id] = -1;
					_ShowTradeMenu(id);
				}
				if (g_bTradeSecond[id] && !_UserHasItem(target, g_iTradeItem[target]))
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_FAIL");
					client_print_color(target, target, "^4%s^1 %L", "[CSGO Remake]", target, "CSGOR_TRADE_FAIL");
					_ResetTradeData(id);
					_ResetTradeData(target);
					_ShowTradeMenu(id);
				}
				g_bTradeActive[id] = 1;
				g_iTradeRequest[target] = id;
				new szItem[32];
				_GetItemName(g_iTradeItem[id], szItem, 31);
				if (!g_bTradeSecond[id])
				{
					client_print_color(target, target, "^4%s^1 %L", "[CSGO Remake]", target, "CSGOR_TRADE_INFO1", g_szName[id], szItem);
					client_print_color(target, target, "^4%s^1 %L", "[CSGO Remake]", target, "CSGOR_TRADE_INFO2");
				}
				else
				{
					new yItem[32];
					_GetItemName(g_iTradeItem[target], yItem, 31);
					client_print_color(target, target, "^4%s %L", "[CSGO Remake]", target, "CSGOR_TRADE_INFO3", g_szName[id], szItem, yItem);
					client_print_color(target, target, "^4%s^1 %L", "[CSGO Remake]", target, "CSGOR_TRADE_INFO2");
					g_bTradeAccept[target] = 1;
				}
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_SEND", g_szName[target]);
			}
		}
		case 3:
		{
			if (g_bTradeSecond[id])
			{
				clcmd_say_deny(id);
			}
			else
			{
				_ResetTradeData(id);
			}
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_CANCELED");
			_ShowTradeMenu(id);
		}
		default:
		{
		}
	}
	return _MenuExit(menu);
}

_SelectTradeTarget(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \y%L", "[CSGO Remake]", id, "CSGOR_GM_SELECT_TARGET");
	new menu = menu_create(temp, "tst_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new Pl[32];
	new n;
	new p;
	get_players(Pl, n, "h", "");
	new total;
	if (n)
	{
		new i;
		while (i < n)
		{
			p = Pl[i];
			if (g_bLogged[p])
			{
				if (!(p == id))
				{
					szItem[0] = p;
					menu_additem(menu, g_szName[p], szItem, 0, -1);
					total++;
				}
			}
			i++;
		}
	}
	if (!total)
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_ST_NO_PLAYERS");
		szItem[0] = -10;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

public tst_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowTradeMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	new name[32];
	menu_item_getinfo(menu, item, dummy, itemdata, 1, name, 31, dummy);
	index = itemdata[0];
	switch (index)
	{
		case -10:
		{
			_ShowMainMenu(id);
		}
		default:
		{
			if (g_iTradeRequest[index])
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TARGET_TRADE_ACTIVE", name);
			}
			else
			{
				g_iTradeTarget[id] = index;
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_YOUR_TARGET", name);
			}
			_ShowTradeMenu(id);
		}
	}
	return _MenuExit(menu);
}

_SelectTradeItem(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_ITEM_MENU");
	new menu = menu_create(temp, "tsi_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new total;
	if (0 < g_iUserCases[id])
	{
		formatex(temp, 63, "\r%L \w| \y%L", id, "CSGOR_ITEM_CASE", id, "CSGOR_SM_PIECES", g_iUserCases[id]);
		szItem[0] = -11;
		menu_additem(menu, temp, szItem, 0, -1);
		total++;
	}
	if (0 < g_iUserKeys[id])
	{
		formatex(temp, 63, "\r%L \w| \y%L", id, "CSGOR_ITEM_KEY", id, "CSGOR_SM_PIECES", g_iUserKeys[id]);
		szItem[0] = -12;
		menu_additem(menu, temp, szItem, 0, -1);
		total++;
	}
	new szSkin[32];
	new num;
	new type[2];
	new i;
	while (i < g_iSkinsNum)
	{
		num = g_iUserSkins[id][i];
		if (0 < num)
		{
			ArrayGetString(g_aSkinName, i, szSkin, 31);
			ArrayGetString(g_aSkinType, i, type, 1);
			new applied[64];
			switch (type[0])
			{
				case 99:
				{
					applied = "#";
				}
				
				default:
				{
					applied = "";
				}
			}
			formatex(temp, 63, "\r%s \w| \y%L \r%s", szSkin, id, "CSGOR_SM_PIECES", num, applied);
			szItem[0] = i;
			menu_additem(menu, temp, szItem, 0, -1);
			total++;
		}
		i++;
	}
	if (!total)
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_NO_ITEMS");
		szItem[0] = -10;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

public tsi_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowTradeMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	switch (index)
	{
		case -10:
		{
			_ShowTradeMenu(id);
		}
		default:
		{
			if (index == g_iUserSellItem[id] && g_bUserSell[id])
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_INVALID_ITEM");
				_SelectTradeItem(id);
			}
			else
			{
				g_iTradeItem[id] = index;
				new szItem[32];
				_GetItemName(index, szItem, 31);
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_ITEM", szItem);
				_ShowTradeMenu(id);
			}
		}
	}
	return _MenuExit(menu);
}

_ResetTradeData(id)
{
	g_bTradeActive[id] = 0;
	g_bTradeSecond[id] = 0;
	g_bTradeAccept[id] = 0;
	g_iTradeTarget[id] = 0;
	g_iTradeItem[id] = -1;
	g_iTradeRequest[id] = 0;
	return 0;
}

public clcmd_say_accept(id)
{
	new sender = g_iTradeRequest[id];
	if (1 > sender || 32 < sender)
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DONT_HAVE_REQ");
		return 1;
	}
	if (!g_bLogged[sender] || !(0 < sender && 32 >= sender))
	{
		_ResetTradeData(id);
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_INVALID_SENDER");
		return 1;
	}
	if (!g_bTradeActive[sender] && id == g_iTradeTarget[sender])
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_IS_CANCELED");
		_ResetTradeData(id);
		return 1;
	}
	if (g_bTradeAccept[id])
	{
		new sItem = g_iTradeItem[sender];
		new tItem = g_iTradeItem[id];
		if (!_UserHasItem(id, tItem) || !_UserHasItem(sender, sItem))
		{
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_FAIL2");
			client_print_color(sender, sender, "^4%s^1 %L", "[CSGO Remake]", sender, "CSGOR_TRADE_FAIL2");
			_ResetTradeData(id);
			_ResetTradeData(sender);
			return 1;
		}
		switch (sItem)
		{
			case -12:
			{
				g_iUserKeys[id]++;
				g_iUserKeys[sender]--;
			}
			case -11:
			{
				g_iUserCases[id]++;
				g_iUserCases[sender]--;
			}
			default:
			{
				g_iUserSkins[id][sItem]++;
				g_iUserSkins[sender][sItem]--;
			}
		}
		switch (tItem)
		{
			case -12:
			{
				g_iUserKeys[id]--;
				g_iUserKeys[sender]++;
			}
			case -11:
			{
				g_iUserCases[id]--;
				g_iUserCases[sender]++;
			}
			default:
			{
				g_iUserSkins[id][tItem]--;
				g_iUserSkins[sender][tItem]++;
			}
		}
		new sItemsz[32];
		new tItemsz[32];
		_GetItemName(tItem, tItemsz, 31);
		_GetItemName(sItem, sItemsz, 31);
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_SUCCESS", tItemsz, sItemsz);
		client_print_color(sender, sender, "^4%s^1 %L", "[CSGO Remake]", sender, "CSGOR_TRADE_SUCCESS", sItemsz, tItemsz);
		_ResetTradeData(id);
		_ResetTradeData(sender);
	}
	else
	{
		if (!g_bTradeSecond[id])
		{
			g_iTradeTarget[id] = sender;
			g_iTradeItem[id] = -1;
			g_bTradeSecond[id] = 1;
			_ShowTradeMenu(id);
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_SELECT_ITEM");
		}
	}
	return 1;
}

public clcmd_say_deny(id)
{
	new sender = g_iTradeRequest[id];
	if (sender < 1 || sender > 32)
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_DONT_HAVE_REQ");
		return 1;
	}
	if (!g_bLogged[sender] || !(0 < sender && 32 >= sender))
	{
		_ResetTradeData(id);
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_INVALID_SENDER");
		return 1;
	}
	if (!g_bTradeActive[sender] && id == g_iTradeTarget[sender])
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TRADE_IS_CANCELED");
		_ResetTradeData(id);
		return 1;
	}
	_ResetTradeData(id);
	_ResetTradeData(sender);
	client_print_color(sender, sender, "^4%s^1 %L", "[CSGO Remake]", sender, "CSGOR_TARGET_REFUSE_TRADE", g_szName[id]);
	client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_YOU_REFUSE_TRADE", g_szName[sender]);
	return 1;
}

_ShowGamesMenu(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_GAMES_MENU");
	new menu = menu_create(temp, "games_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	formatex(temp, 63, "\w%L", id, "CSGOR_MM_TOMBOLA", g_iTombolaCost);
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 63, "\w%L", id, "CSGOR_GAME_ROULETTE", g_iRouletteCost);
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 63, "\w%L", id, "CSGOR_GAME_JACKPOT");
	menu_additem(menu, temp, szItem, 0, -1);
	_DisplayMenu(id, menu);
	return 0;
}

public games_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowMainMenu(id);
		return _MenuExit(menu);
	}
	switch (item)
	{
		case 0:
		{
			_ShowTombolaMenu(id);
		}
		case 1:
		{
			new points = g_iUserPoints[id];
			if (points < g_iRouletteCost)
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_NOT_ENOUGH_POINTS", g_iRouletteCost - points);
				_ShowGamesMenu(id);
			}
			else
			{
				if (g_bRoulettePlay[id])
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_ROULETTE_NEXT");
					_ShowGamesMenu(id);
				}
				else
				{
					_ShowRouletteMenu(id);
				}
			}
		}
		case 2:
		{
			if (g_bJackpotWork)
			{
				_ShowJackpotMenu(id);
			}
			else
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_JP_CLOSED", get_pcvar_num(c_JackpotTimer));
			}
		}
		default:
		{
		}
	}
	return _MenuExit(menu);
}

_ShowTombolaMenu(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_TOMBOLA_MENU");
	new menu = menu_create(temp, "tombola_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new Timer[32];
	_FormatTime(Timer, 31, g_iNextTombolaStart);
	formatex(temp, 63, "\w%L", id, "CSGOR_TOMB_TIMER", Timer);
	szItem[0] = 0;
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 63, "\w%L", id, "CSGOR_TOMB_PLAYERS", g_iTombolaPlayers);
	szItem[0] = 0;
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 63, "\w%L^n", id, "CSGOR_TOMB_PRIZE", g_iTombolaPrize);
	szItem[0] = 0;
	menu_additem(menu, temp, szItem, 0, -1);
	if (g_bUserPlay[id])
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_TOMB_ALREADY_PLAY");
		szItem[0] = 0;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	else
	{
		formatex(temp, 63, "\r%L^n\w%L", id, "CSGOR_TOMB_PLAY", id, "CSGOR_TOMB_COST", g_iTombolaCost);
		szItem[0] = 1;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

_FormatTime(timer[], len, nextevent)
{
	new seconds = nextevent - get_systime(0);
	new minutes;
	while (seconds >= 60)
	{
		seconds += -60;
		minutes++;
	}
	new bool:add_before;
	new temp[32];
	if (seconds)
	{
		new second[64];
		if (seconds == 1)
		{
			formatex(second, 63, "%L", 0, "CSGOR_TOMB_TEXT_SECOND");
		}
		else
		{
			formatex(second, 63, "%L", 0, "CSGOR_TOMB_TEXT_SECONDS");
		}
		formatex(temp, 31, "%i %s", seconds, second);
		add_before = true;
	}
	if (minutes)
	{
		if (add_before)
		{
			new minute[64];
			if (minutes == 1)
			{
				formatex(minute, 63, "%L", 0, "CSGOR_TOMB_TEXT_MINUTE");
			}
			else
			{
				formatex(minute, 63, "%L", 0, "CSGOR_TOMB_TEXT_MINUTES");
			}
			format(temp, 31, "%i %s, %s", minutes, minute, temp);
		}
		else
		{
			new minute[64];
			if (minutes == 1)
			{
				formatex(minute, 63, "%L", 0, "CSGOR_TOMB_TEXT_MINUTE");
			}
			else
			{
				formatex(minute, 63, "%L", 0, "CSGOR_TOMB_TEXT_MINUTES");
			}
			formatex(temp, 31, "%i %s", minutes, minute);
			add_before = true;
		}
	}
	if (add_before)
	{
		formatex(timer, len, "%s", temp);
	}
	return 0;
}

public tombola_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowGamesMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	switch (index)
	{
		case 0:
		{
			_ShowTombolaMenu(id);
		}
		case 1:
		{
			new uPoints = g_iUserPoints[id];
			if (!g_bTombolaWork)
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_TOMB_NOT_WORK");
			}
			else
			{
				if (uPoints < g_iTombolaCost)
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_NOT_ENOUGH_POINTS", g_iTombolaCost - uPoints);
					_ShowTombolaMenu(id);
					return 0;
				}
				g_iUserPoints[id] -= g_iTombolaCost;
				g_iTombolaPrize = g_iTombolaCost + g_iTombolaPrize;
				g_bUserPlay[id] = 1;
				ArrayPushCell(g_aTombola, id);
				g_iTombolaPlayers += 1;
				_SaveData(id);
				client_print_color(0, id, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_TOMB_ANNOUNCE", g_szName[id]);
				_ShowTombolaMenu(id);
			}
		}
		default:
		{
		}
	}
	return _MenuExit(menu);
}

public task_TombolaRun(task)
{
	if (1 > g_iTombolaPlayers)
	{
		client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_TOMB_FAIL_REG");
	}
	else
	{
		if (2 > g_iTombolaPlayers)
		{
			client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_TOMB_FAIL_NUM");
		}
		new id;
		new size = ArraySize(g_aTombola);
		new bool:succes;
		new random;
		new run;
		do {
			random = random_num(0, size + -1);
			id = ArrayGetCell(g_aTombola, random);
			if (0 < id && 32 >= id || !is_user_connected(id))
			{
				succes = true;
				if (2 > g_iTombolaPlayers)
				{
					g_iUserPoints[id] += g_iTombolaCost;
					_SaveData(id);
				}
				else
				{
					g_iUserPoints[id] += g_iTombolaPrize;
					_SaveData(id);
					new Name[32];
					get_user_name(id, Name, 31);
					client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_TOMB_WINNER", Name, g_iTombolaPrize);
				}
			}
			else
			{
				ArrayDeleteItem(g_aTombola, random);
				size--;
			}
			if (!succes && size > 0)
			{
			}
		} while (run);
	}
	arrayset(g_bUserPlay, 0, 33);
	g_iTombolaPlayers = 0;
	g_iTombolaPrize = 0;
	ArrayClear(g_aTombola);
	g_iNextTombolaStart = g_iTombolaTimer + get_systime(0);
	new Timer[32];
	_FormatTime(Timer, 31, g_iNextTombolaStart);
	client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_TOMB_NEXT", Timer);
	return 0;
}

_ShowRouletteMenu(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_ROULETTE_MENU");
	new menu = menu_create(temp, "roulette_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	formatex(temp, 63, "\w%L", id, "CSGOR_ROU_UNDER", g_iRouletteMin);
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 63, "\w%L", id, "CSGOR_ROU_OVER", g_iRouletteMin);
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 63, "\w%L\n", id, "CSGOR_ROU_BETWEEN", g_iRouletteMax);
	menu_additem(menu, temp, szItem, 0, -1);
	formatex(temp, 63, "\r%L", id, "CSGOR_ROU_BET", g_iUserBetPoints[id]);
	menu_additem(menu, temp, szItem, 0, -1);
	_DisplayMenu(id, menu);
	return 0;
}

public roulette_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowGamesMenu(id);
		return _MenuExit(menu);
	}
	if (0 <= item <= 2)
	{
		if (g_iUserBetPoints[id] <= g_iUserPoints[id])
		{
			g_iUserPoints[id] -= g_iUserBetPoints[id];
		}
		else
		{
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_NOT_ENOUGH_POINTS", g_iUserBetPoints[id] - g_iUserPoints[id]);
			return _MenuExit(menu);
		}
	}
	new chance = random_num(1, 100);
	switch (item)
	{
		case 0:
		{
			if (chance < 48)
			{
				_RouletteWin(id, g_iRouletteMin, 0);
			}
			else
			{
				_RouletteLoose(id, chance);
			}
		}
		case 1:
		{
			if (chance > 53)
			{
				_RouletteWin(id, g_iRouletteMin, 0);
			}
			else
			{
				_RouletteLoose(id, chance);
			}
		}
		case 2:
		{
			if (48 <= chance <= 53)
			{
				_RouletteWin(id, g_iRouletteMax, 1);
			}
			else
			{
				_RouletteLoose(id, chance);
			}
		}
		case 3:
		{
			client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_INSERT_BET");
			client_cmd(id, "messagemode BetPoints");
		}
		default:
		{
		}
	}
	return _MenuExit(menu);
}

_RouletteWin(id, multi, announce)
{
	new num = multi * g_iUserBetPoints[id];
	g_iUserPoints[id] += num;
	g_bRoulettePlay[id] = 1;
	if (0 < announce)
	{
		client_print_color(0, id, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_ROULETTE_WIN", g_szName[id], g_iUserBetPoints[id]);
	}
	else
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_ROULETTE_WIN_ONE", g_iUserBetPoints[id]);
	}
	_SaveData(id);
	client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_ROULETTE_NEXT");
	return 0;
}

_RouletteLoose(id, num)
{
	client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_ROULETTE_LOOSE", num);
	_ShowGamesMenu(id);
	return 0;
}

public concmd_betpoints(id)
{
	new data[16];
	read_args(data, 15);
	remove_quotes(data);
	new Amount = str_to_num(data);
	if (Amount < 10 || Amount > 1000)
	{
		client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_BET_MIN_MAX", 10, 1000);
		client_cmd(id, "messagemode BetPoints");
		return 1;
	}
	g_iUserBetPoints[id] = Amount;
	_ShowRouletteMenu(id);
	return 1;
}

_ShowJackpotMenu(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_JACKPOT_MENU");
	new menu = menu_create(temp, "jackpot_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	if (!_IsGoodItem(g_iUserJackpotItem[id]))
	{
		formatex(temp, 63, "\w%L", id, "CSGOR_SKINS");
		szItem[0] = 1;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	else
	{
		new Item[32];
		_GetItemName(g_iUserJackpotItem[id], Item, 31);
		formatex(temp, 63, "\w%L", id, "CSGOR_JP_ITEM", Item);
		szItem[0] = 1;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	if (g_bUserPlayJackpot[id])
	{
		formatex(temp, 63, "\r%L^n", id, "CSGOR_JP_ALREADY_PLAY");
		szItem[0] = 0;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	else
	{
		formatex(temp, 63, "\r%L^n", id, "CSGOR_JP_PLAY");
		szItem[0] = 2;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	new Timer[32];
	_FormatTime(Timer, 31, g_iJackpotClose);
	formatex(temp, 63, "\w%L", id, "CSGOR_TOMB_TIMER", Timer);
	szItem[0] = 0;
	menu_additem(menu, temp, szItem, 0, -1);
	_DisplayMenu(id, menu);
	return 0;
}

public jackpot_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowGamesMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	if (!g_bJackpotWork)
	{
		_ShowGamesMenu(id);
		return _MenuExit(menu);
	}
	switch (index)
	{
		case 0:
		{
			_ShowJackpotMenu(id);
		}
		case 1:
		{
			if (g_bUserPlayJackpot[id])
			{
				_ShowJackpotMenu(id);
			}
			else
			{
				_SelectJackpotSkin(id);
			}
		}
		case 2:
		{
			new skin = g_iUserJackpotItem[id];
			if (!_IsGoodItem(skin))
			{
				client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_SKINS");
				_ShowJackpotMenu(id);
			}
			else
			{
				if (!_UserHasItem(id, skin))
				{
					client_print_color(id, id, "^4%s^1 %L", "[CSGO Remake]", id, "CSGOR_NOT_ENOUGH_ITEMS");
					g_iUserJackpotItem[id] = -1;
				}
				g_bUserPlayJackpot[id] = 1;
				g_iUserSkins[id][skin]--;
				ArrayPushCell(g_aJackpotSkins, skin);
				ArrayPushCell(g_aJackpotUsers, id);
				new szItem[32];
				_GetItemName(skin, szItem, 31);
				client_print_color(0, 0, "^4%s %L", "[CSGO Remake]", -1, "CSGOR_JP_JOIN", g_szName[id], szItem);
			}
		}
		default:
		{
		}
	}
	return _MenuExit(menu);
}

_SelectJackpotSkin(id)
{
	new temp[64];
	formatex(temp, 63, "\r%s \w%L", "[CSGO Remake]", id, "CSGOR_SKINS");
	new menu = menu_create(temp, "jp_skins_menu_handler", 0);
	new szItem[2];
	szItem[1] = 0;
	new szSkin[32];
	new num;
	new type[2];
	new total;
	new i;
	while (i < g_iSkinsNum)
	{
		num = g_iUserSkins[id][i];
		if (0 < num)
		{
			ArrayGetString(g_aSkinName, i, szSkin, 31);
			ArrayGetString(g_aSkinType, i, type, 1);
			new applied[64];
			switch (type[0])
			{
				case 99:
				{
					applied = "#";
				}
				
				default:
				{
					applied = "";
				}
			}
			formatex(temp, 63, "\r%s \w| \y%L \r%s", szSkin, id, "CSGOR_SM_PIECES", num, applied);
			szItem[0] = i;
			menu_additem(menu, temp, szItem, 0, -1);
			total++;
		}
		i++;
	}
	if (!total)
	{
		formatex(temp, 63, "\r%L", id, "CSGOR_SM_NO_SKINS");
		szItem[0] = -10;
		menu_additem(menu, temp, szItem, 0, -1);
	}
	_DisplayMenu(id, menu);
	return 0;
}

public jp_skins_menu_handler(id, menu, item)
{
	if (item == -3)
	{
		_ShowJackpotMenu(id);
		return _MenuExit(menu);
	}
	new itemdata[2];
	new dummy;
	new index;
	menu_item_getinfo(menu, item, dummy, itemdata, 1, {0}, 0, dummy);
	index = itemdata[0];
	if (index == -10)
	{
		_ShowGamesMenu(id);
		return _MenuExit(menu);
	}
	g_iUserJackpotItem[id] = index;
	_ShowJackpotMenu(id);
	return _MenuExit(menu);
}

public task_Jackpot(task)
{
	if (!g_bJackpotWork)
	{
		return 0;
	}
	new id;
	new size = ArraySize(g_aJackpotUsers);
	if (1 > size)
	{
		client_print_color(0, 0, "^4%s %L", "[CSGO Remake]", -1, "CSGOR_JP_NO_ONE");
		_ClearJackpot();
		return 0;
	}
	if (2 > size)
	{
		client_print_color(0, 0, "^4%s %L", "[CSGO Remake]", -1, "CSGOR_JP_ONLY_ONE");
		new id;
		new k;
		id = ArrayGetCell(g_aJackpotUsers, 0);
		if (0 < id && 32 >= id || !is_user_connected(id))
		{
			k = ArrayGetCell(g_aJackpotSkins, 0);
			g_iUserSkins[id][k]++;
		}
		_ClearJackpot();
		return 0;
	}
	new bool:succes;
	new random;
	new run;
	do {
		random = random_num(0, size + -1);
		id = ArrayGetCell(g_aJackpotUsers, random);
		if (0 < id && 32 >= id || !is_user_connected(id))
		{
			succes = true;
			new i;
			new j;
			new k;
			i = ArraySize(g_aJackpotSkins);
			j = 0;
			while (j < i)
			{
				k = ArrayGetCell(g_aJackpotSkins, j);
				g_iUserSkins[id][k]++;
				j++;
			}
			_SaveData(id);
			client_print_color(0, 0, "^4%s %L", "[CSGO Remake]", -1, "CSGOR_JP_WINNER", g_szName[id]);
		}
		else
		{
			ArrayDeleteItem(g_aJackpotUsers, random);
			size--;
		}
		if (!(!succes && size > 0))
		{
			_ClearJackpot();
			return 0;
		}
	} while (run);
	_ClearJackpot();
	return 0;
}

_ClearJackpot()
{
	ArrayClear(g_aJackpotSkins);
	ArrayClear(g_aJackpotUsers);
	arrayset(g_bUserPlayJackpot, 0, 33);
	g_bJackpotWork = false;
	client_print_color(0, 0, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_JP_NEXT");
	return 0;
}

public ev_DeathMsg()
{
	new killer = read_data(1);
	new victim = read_data(2);
	new head = read_data(3);
	new szWeapon[24];
	read_data(4, szWeapon, 23);
	if (victim == killer)
	{
		return 0;
	}
	new assist = g_iMostDamage[victim];
	if (is_user_connected(assist) && assist != killer && cs_get_user_team(assist) == cs_get_user_team(killer))
	{
		_GiveBonus(assist, 0);
		new kName[32];
		new szName1[32];
		new szName2[32];
		new iName1Len = strlen(g_szName[killer]);
		new iName2Len = strlen(g_szName[assist]);
		if (iName1Len < 14)
		{
			formatex(szName1, iName1Len, "%s", g_szName[killer]);
			formatex(szName2, 28 - iName1Len, "%s", g_szName[assist]);
		}
		else
		{
			if (iName2Len < 14)
			{
				formatex(szName1, 28 - iName2Len, "%s", g_szName[killer]);
				formatex(szName2, iName2Len, "%s", g_szName[assist]);
			}
			formatex(szName1, 13, "%s", g_szName[killer]);
			formatex(szName2, 13, "%s", g_szName[assist]);
		}
		formatex(kName, 31, "%s + %s", szName1, szName2);
		set_msg_block(g_Msg_SayText, 1);
		g_IsChangeAllowed[killer] = true;
		set_user_info(killer, "name", kName);
		new szWeaponLong[24];
		if (equali(szWeapon, "grenade", 0))
		{
			formatex(szWeaponLong, 23, "%s", "weapon_hegrenade");
		}
		else
		{
			formatex(szWeaponLong, 23, "weapon_%s", szWeapon);
		}
		new args[4];
		args[0] = killer;
		args[1] = victim;
		args[2] = head;
		args[3] = get_weaponid(szWeaponLong);
		set_task(0.10, "task_Send_DeathMsg", killer + 3000, args, 4, "", 0);
	}
	else
	{
		_Send_DeathMsg(killer, victim, head, szWeapon);
	}
	if (equal(szWeapon, "knife", 0))
	{
		cs_set_user_money(killer, min(cs_get_user_money(killer) + 1000, 16000), 1);
		client_print_color(0, killer, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_KNIFE_KILL", g_szName[killer], 1000);
	}
	g_iDigit[killer]++;
	_SetKillsIcon(killer, 0);
	g_iRoundKills[killer]++;
	if (!g_bLogged[killer])
	{
		client_print_color(killer, killer, "^4%s^1 %L", "[CSGO Remake]", killer, "CSGOR_REGISTER");
		return 0;
	}
	g_iUserKills[killer]++;
	_SaveData(killer);
	new bool:levelup;
	if (g_iRanksNum + -1 > g_iUserRank[killer])
	{
		if (ArrayGetCell(g_aRankKills, g_iUserRank[killer] + 1) <= g_iUserKills[killer] < ArrayGetCell(g_aRankKills, g_iUserRank[killer] + 2))
		{
			g_iUserRank[killer]++;
			_SaveData(killer);
			levelup = true;
			new szRank[32];
			ArrayGetString(g_aRankName, g_iUserRank[killer], szRank, 31);
			client_print_color(0, killer, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_LEVELUP_ALL", g_szName[killer], szRank);
		}
	}
	new rpoints;
	new rchance;
	if (head)
	{
		rpoints = random_num(g_iHMinPoints, g_iHMaxPoints);
		rchance = random_num(g_iHMinChance, g_iHMaxChance);
	}
	else
	{
		rpoints = random_num(g_iKMinPoints, g_iKMaxPoints);
		rchance = random_num(g_iKMinChance, g_iKMaxChance);
	}
	g_iUserPoints[killer] += rpoints;
	_SaveData(killer);
	set_hudmessage(255, 255, 255, -1.00, 0.20, 0, 6.00, 2.00, 0.00, 0.00, -1);
	show_hudmessage(killer, "%L", killer, "CSGOR_REWARD_POINTS", rpoints);
	if (rchance > g_iDropChance)
	{
		new r;
		if (0 < g_iDropType)
		{
			r = 1;
		}
		else
		{
			r = random_num(1, 2);
		}
		switch (r)
		{
			case 1:
			{
				g_iUserCases[killer]++;
				_SaveData(killer);
				if (0 < g_iDropType)
				{
					client_print_color(killer, killer, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_REWARD_CASE2");
				}
				else
				{
					client_print_color(killer, killer, "^4%s^1 %L", "[CSGO Remake]", -1, "CSGOR_REWARD_CASE");
				}
			}
			case 2:
			{
				g_iUserKeys[killer]++;
				_SaveData(killer);
				client_print_color(killer, killer, "^4%s %L", "[CSGO Remake]", -1, "CSGOR_REWARD_KEY");
			}
			default:
			{
			}
		}
	}
	if (levelup)
	{
		new szBonus[16];
		get_pcvar_string(c_RankUpBonus, szBonus, 15);
		new keys;
		new cases;
		new points;
		new i;
		while (szBonus[i] != 124 && 16 > i)
		{
			switch (szBonus[i])
			{
				case 99:
				{
					cases++;
				}
				case 107:
				{
					keys++;
				}
				default:
				{
				}
			}
			i++;
		}
		new temp[8];
		strtok(szBonus, temp, 7, szBonus, 15, 124, 0);
		if (szBonus[0])
		{
			points = str_to_num(szBonus);
		}
		if (0 < keys)
		{
			g_iUserKeys[killer] += keys;
		}
		if (0 < cases)
		{
			g_iUserCases[killer] += cases;
		}
		if (0 < points)
		{
			g_iUserPoints[killer] += points;
		}
		_SaveData(killer);
		client_print_color(killer, killer, "^4%s^1 %L", "[CSGO Remake]", killer, "CSGOR_RANKUP_BONUS", keys, cases, points);
	}
	return 0;
}

public ev_Damage(id)
{
	if (!(id && id <= g_iMaxPlayers))
	{
		return 0;
	}
	static att;
	att = get_user_attacker(id);
	if (!(0 < att && att <= g_iMaxPlayers))
	{
		return 0;
	}
	static damage;
	damage = read_data(2);
	g_iDealDamage[att] += damage;
	g_iDamage[id][att] += damage;
	new topDamager = g_iMostDamage[id];
	if (g_iDamage[id][topDamager] < g_iDamage[id][att])
	{
		g_iMostDamage[id] = att;
	}
	return 0;
}

public task_Send_DeathMsg(arg[], task)
{
	new killer = task + -3000;
	new victim = arg[1];
	new head = arg[2];
	new weapon = arg[3];
	new szWeapon[24];
	get_weaponname(weapon, szWeapon, 23);
	if (weapon == 4)
	{
		replace(szWeapon, 23, "weapon_he", "");
	}
	else
	{
		replace(szWeapon, 23, "weapon_", "");
	}
	_Send_DeathMsg(killer, victim, head, szWeapon);
	set_msg_block(g_Msg_SayText, 1);
	set_user_info(killer, "name", g_szName[killer]);
	set_task(0.10, "task_Reset_AmxMode", killer + 4000, "", 0, "", 0);
	return 0;
}

_Send_DeathMsg(killer, victim, hs, weapon[])
{
	message_begin(MSG_ALL, g_Msg_DeathMsg, {0,0,0}, 0);
	write_byte(killer);
	write_byte(victim);
	write_byte(hs);
	write_string(weapon);
	message_end();
	return 0;
}

public Message_DeathMsg(msgId, msgDest, msgEnt)
{
	return 1;
}

public task_Reset_AmxMode(task)
{
	new id = task - 4000;
	g_IsChangeAllowed[id] = false;
	return 0;
}

public concmd_givepoints(id, level, cid)
{
	if (!cmd_access(id, level, cid, 3, false))
	{
		return 1;
	}
	new arg1[32];
	new arg2[16];
	read_argv(1, arg1, 31);
	read_argv(2, arg2, 15);
	new target;
	if (arg1[0] == 64)
	{
		_GiveToAll(id, arg1, arg2, 0);
		return 1;
	}
	target = cmd_target(id, arg1, 3);
	if (!target)
	{
		console_print(id, "%s %L", "[CSGO Remake]", id, "CSGOR_T_NOT_FOUND", arg1);
		return 1;
	}
	new amount = str_to_num(arg2);
	if (0 > amount)
	{
		g_iUserPoints[target] += amount;
		if (0 > g_iUserPoints[target])
		{
			g_iUserPoints[target] = 0;
		}
		console_print(id, "%s %L %L", "[CSGO Remake]", id, "CSGOR_SUBSTRACT", arg1, amount, id, "CSGOR_POINTS");
		client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_SUB_YOU", g_szName[id], amount, target, "CSGOR_POINTS");
	}
	else
	{
		if (0 < amount)
		{
			g_iUserPoints[target] += amount;
			console_print(id, "[CSGO Remake] You gave %s %d points", arg1, amount);
			client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_ADD_YOU", g_szName[id], amount, target, "CSGOR_POINTS");
		}
		return 1;
	}
	_SaveData(target);
	return 1;
}

public concmd_givecases(id, level, cid)
{
	if (!cmd_access(id, level, cid, 3, false))
	{
		return 1;
	}
	new arg1[32];
	new arg2[16];
	read_argv(1, arg1, 31);
	read_argv(2, arg2, 15);
	new target;
	if (arg1[0] == 64)
	{
		_GiveToAll(id, arg1, arg2, 1);
		return 1;
	}
	target = cmd_target(id, arg1, 3);
	if (!target)
	{
		console_print(id, "%s %L", "[CSGO Remake]", id, "CSGOR_T_NOT_FOUND", arg1);
		return 1;
	}
	new amount = str_to_num(arg2);
	if (0 > amount)
	{
		g_iUserCases[target] -= amount;
		if (0 > g_iUserCases[target])
		{
			g_iUserCases[target] = 0;
		}
		console_print(id, "%s %L %L", "[CSGO Remake]", id, "CSGOR_SUBSTRACT", arg1, amount, id, "CSGOR_CASES");
		client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_SUB_YOU", g_szName[id], amount, target, "CSGOR_CASES");
	}
	else
	{
		if (0 < amount)
		{
			g_iUserCases[target] += amount;
			console_print(id, "%s %L %L", "[CSGO Remake]", id, "CSGOR_ADD", arg1, amount, id, "CSGOR_CASES");
			client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_ADD_YOU", g_szName[id], amount, target, "CSGOR_CASES");
		}
		return 1;
	}
	_SaveData(target);
	return 1;
}

public concmd_givekeys(id, level, cid)
{
	if (!cmd_access(id, level, cid, 3, false))
	{
		return 1;
	}
	new arg1[32];
	new arg2[16];
	read_argv(1, arg1, 31);
	read_argv(2, arg2, 15);
	new target;
	if (arg1[0] == 64)
	{
		_GiveToAll(id, arg1, arg2, 2);
		return 1;
	}
	target = cmd_target(id, arg1, 3);
	if (!target)
	{
		console_print(id, "%s %L", "[CSGO Remake]", id, "CSGOR_T_NOT_FOUND", arg1);
		return 1;
	}
	new amount = str_to_num(arg2);
	if (0 > amount)
	{
		g_iUserKeys[target] -= amount;
		if (0 > g_iUserKeys[target])
		{
			g_iUserKeys[target] = 0;
		}
		console_print(id, "%s %L %L", "[CSGO Remake]", id, "CSGOR_SUBSTRACT", arg1, amount, id, "CSGOR_KEYS");
		client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_SUB_YOU", g_szName[id], amount, target, "CSGOR_KEYS");
	}
	else
	{
		if (0 < amount)
		{
			g_iUserKeys[target] += amount;
			console_print(id, "%s %L %L", "[CSGO Remake]", id, "CSGOR_ADD", arg1, amount, id, "CSGOR_KEYS");
			client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_ADD_YOU", g_szName[id], amount, target, "CSGOR_KEYS");
		}
		return 1;
	}
	_SaveData(target);
	return 1;
}

public concmd_givedusts(id, level, cid)
{
	if (!cmd_access(id, level, cid, 3, false))
	{
		return 1;
	}
	new arg1[32];
	new arg2[16];
	read_argv(1, arg1, 31);
	read_argv(2, arg2, 15);
	new target;
	if (arg1[0] == 64)
	{
		_GiveToAll(id, arg1, arg2, 3);
		return 1;
	}
	target = cmd_target(id, arg1, 3);
	if (!target)
	{
		console_print(id, "%s %L", "[CSGO Remake]", id, "CSGOR_T_NOT_FOUND", arg1);
		return 1;
	}
	new amount = str_to_num(arg2);
	if (0 > amount)
	{
		g_iUserDusts[target] -= amount;
		if (0 > g_iUserDusts[target])
		{
			g_iUserDusts[target] = 0;
		}
		console_print(id, "%s %L %L", "[CSGO Remake]", id, "CSGOR_SUBSTRACT", arg1, amount, id, "CSGOR_DUSTS");
		client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_SUB_YOU", g_szName[id], amount, target, "CSGOR_DUSTS");
	}
	else
	{
		if (0 < amount)
		{
			g_iUserDusts[target] += amount;
			console_print(id, "%s %L %L", "[CSGO Remake]", id, "CSGOR_ADD", arg1, amount, id, "CSGOR_DUSTS");
			client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_ADD_YOU", g_szName[id], amount, target, "CSGOR_DUSTS");
		}
		return 1;
	}
	_SaveData(target);
	return 1;
}

_GiveToAll(id, arg1[], arg2[], type)
{
	new Pl[32];
	new n;
	new target;
	new amount = str_to_num(arg2);
	if (amount)
	{
		switch (arg1[1])
		{
			case 65, 97:
			{
				get_players(Pl, n, "h", "");
			}
			case 67, 99:
			{
				get_players(Pl, n, "eh", "CT");
			}
			case 84, 116:
			{
				get_players(Pl, n, "eh", "TERRORIST");
			}
			default:
			{
			}
		}
		if (n)
		{
			switch (type)
			{
				case 0:
				{
					new i;
					while (i < n)
					{
						target = Pl[i];
						if (g_bLogged[target])
						{
							if (0 > amount)
							{
								g_iUserPoints[target] -= amount;
								if (0 > g_iUserPoints[target])
								{
									g_iUserPoints[target] = 0;
								}
								client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_SUB_YOU", g_szName[id], amount, target, "CSGOR_POINTS");
							}
							else
							{
								g_iUserPoints[target] += amount;
								client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_ADD_YOU", g_szName[id], amount, target, "CSGOR_POINTS");
							}
						}
						i++;
					}
					new temp[64];
					if (0 < amount)
					{
						if (amount == 1)
						{
							formatex(temp, 63, "You gave 1 point to players !", id);
						}
						else
						{
							formatex(temp, 63, "You gave %d points to players !", amount);
						}
						console_print(id, "%s %s", "[CSGO Remake]", temp);
					}
					else
					{
						if (amount == -1)
						{
							formatex(temp, 63, "You got 1 point from players !", id);
						}
						else
						{
							formatex(temp, 63, "You got %d points from players !", amount *= -1);
						}
						console_print(id, "%s %s", "[CSGO Remake]", temp);
					}
				}
				case 1:
				{
					new i;
					while (i < n)
					{
						target = Pl[i];
						if (g_bLogged[target])
						{
							if (0 > amount)
							{
								g_iUserCases[target] -= amount;
								if (0 > g_iUserCases[target])
								{
									g_iUserCases[target] = 0;
								}
								client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_SUB_YOU", g_szName[id], amount, target, "CSGOR_CASES");
							}
							else
							{
								g_iUserCases[target] += amount;
								client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_ADD_YOU", g_szName[id], amount, target, "CSGOR_CASES");
							}
						}
						i++;
					}
					new temp[64];
					if (0 < amount)
					{
						if (amount == 1)
						{
							formatex(temp, 63, "You gave 1 case to players !", id);
						}
						else
						{
							formatex(temp, 63, "You gave %d cases to players !", amount);
						}
						console_print(id, "%s %s", "[CSGO Remake]", temp);
					}
					else
					{
						if (amount == -1)
						{
							formatex(temp, 63, "You got 1 case from players !", id);
						}
						else
						{
							formatex(temp, 63, "You got %d cases from players !", amount *= -1);
						}
						console_print(id, "%s %s", "[CSGO Remake]", temp);
					}
				}
				case 2:
				{
					new i;
					while (i < n)
					{
						target = Pl[i];
						if (g_bLogged[target])
						{
							if (0 > amount)
							{
								g_iUserKeys[target] -= amount;
								if (0 > g_iUserKeys[target])
								{
									g_iUserKeys[target] = 0;
								}
								client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_SUB_YOU", g_szName[id], amount, target, "CSGOR_KEYS");
							}
							else
							{
								g_iUserKeys[target] += amount;
								client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_ADD_YOU", g_szName[id], amount, target, "CSGOR_KEYS");
							}
						}
						i++;
					}
					new temp[64];
					if (0 < amount)
					{
						if (amount == 1)
						{
							formatex(temp, 63, "You gave 1 key to players !", id);
						}
						else
						{
							formatex(temp, 63, "You gave %d keys to players !", amount);
						}
						console_print(id, "%s %s", "[CSGO Remake]", temp);
					}
					else
					{
						if (amount == -1)
						{
							formatex(temp, 63, "You got 1 key from players !", id);
						}
						else
						{
							formatex(temp, 63, "You got %d keys from players !", amount *= -1);
						}
						console_print(id, "%s %s", "[CSGO Remake]", temp);
					}
				}
				case 3:
				{
					new i;
					while (i < n)
					{
						target = Pl[i];
						if (g_bLogged[target])
						{
							if (0 > amount)
							{
								g_iUserDusts[target] -= amount;
								if (0 > g_iUserDusts[target])
								{
									g_iUserDusts[target] = 0;
								}
								client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_SUB_YOU", g_szName[id], amount, target, "CSGOR_DUSTS");
							}
							else
							{
								g_iUserDusts[target] += amount;
								client_print_color(target, id, "^4%s^1 %L %L", "[CSGO Remake]", target, "CSGOR_ADMIN_ADD_YOU", g_szName[id], amount, target, "CSGOR_DUSTS");
							}
						}
						i++;
					}
					new temp[64];
					if (0 < amount)
					{
						if (amount == 1)
						{
							formatex(temp, 63, "You gave 1 dust to players !", id);
						}
						else
						{
							formatex(temp, 63, "You gave %d dusts to players !", amount);
						}
						console_print(id, "%s %s", "[CSGO Remake]", temp);
					}
					else
					{
						if (amount == -1)
						{
							formatex(temp, 63, "You got 1 dust from players !", id);
						}
						else
						{
							formatex(temp, 63, "You got %d dusts from players !", amount *= -1);
						}
						console_print(id, "%s %s", "[CSGO Remake]", temp);
					}
				}
				default:
				{
				}
			}
		}
		else
		{
			console_print(id, "%s No players found in the chosen category: %s", "[CSGO Remake]", arg1);
		}
		return 0;
	}
	console_print(id, "%s <Amount> It must not be 0 (zero)!", "[CSGO Remake]");
	return 0;
}

public concmd_setrank(id, level, cid)
{
	if (!cmd_access(id, level, cid, 3, false))
	{
		return 1;
	}
	new arg1[32];
	new arg2[8];
	read_argv(1, arg1, 31);
	read_argv(2, arg2, 7);
	new target = cmd_target(id, arg1, 3);
	if (!target)
	{
		console_print(id, "%s %L", "[CSGO Remake]", id, "CSGOR_T_NOT_FOUND", arg1);
		return 1;
	}
	new rank = str_to_num(arg2);
	if (rank < 0 || rank >= g_iRanksNum)
	{
		console_print(id, "%s %L", "[CSGO Remake]", id, "CSGOR_INVALID_RANKID", g_iRanksNum + -1);
		return 1;
	}
	g_iUserRank[target] = rank;
	if (rank)
	{
		g_iUserKills[target] = ArrayGetCell(g_aRankKills, rank + -1);
	}
	else
	{
		g_iUserKills[target] = 0;
	}
	_SaveData(target);
	new szRank[32];
	ArrayGetString(g_aRankName, g_iUserRank[target], szRank, 31);
	console_print(id, "%s %L", "[CSGO Remake]", id, "CSGOR_SET_RANK", arg1, szRank);
	client_print_color(target, id, "^4%s^1 %L", "[CSGO Remake]", target, "CSGOR_ADMIN_SET_RANK", g_szName[id], szRank);
	return 1;
}

public concmd_giveskins(id, level, cid)
{
	if (!cmd_access(id, level, cid, 4, false))
	{
		return 1;
	}
	new arg1[32];
	new arg2[8];
	new arg3[16];
	read_argv(1, arg1, 31);
	read_argv(2, arg2, 7);
	read_argv(3, arg3, 15);
	new target = cmd_target(id, arg1, 3);
	if (!target)
	{
		console_print(id, "%s %L", "[CSGO Remake]", id, "CSGOR_T_NOT_FOUND", arg1);
		return 1;
	}
	new skin = str_to_num(arg2);
	if (skin < 0 || skin >= g_iSkinsNum)
	{
		console_print(id, "%s %L", "[CSGO Remake]", id, "CSGOR_INVALID_SKINID", g_iSkinsNum + -1);
		return 1;
	}
	new amount = str_to_num(arg3);
	new szSkin[32];
	ArrayGetString(g_aSkinName, skin, szSkin, 31);
	if (0 > amount)
	{
		g_iUserSkins[target][skin] -= amount;
		if (0 > g_iUserSkins[target][skin])
		{
			g_iUserSkins[target][skin] = 0;
		}
		console_print(id, "%s %L x %s", "[CSGO Remake]", id, "CSGOR_SUBSTRACT", arg1, amount, szSkin);
		client_print_color(target, id, "^4%s^1 %L x ^3%s", "[CSGO Remake]", target, "CSGOR_ADMIN_SUB_YOU", g_szName[id], amount, szSkin);
	}
	else
	{
		if (0 < amount)
		{
			g_iUserSkins[target][skin] += amount;
			console_print(id, "%s %L x %s", "[CSGO Remake]", id, "CSGOR_ADD", arg1, amount, szSkin);
			client_print_color(target, id, "^4%s^1 %L x ^3%s", "[CSGO Remake]", target, "CSGOR_ADMIN_ADD_YOU", g_szName[id], amount, szSkin);
		}
		return 1;
	}
	_SaveData(target);
	return 1;
}

public native_get_user_points(iPluginID, iParamNum)
{
	if (iParamNum != 1)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID)");
		return -1;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return -1;
	}
	return g_iUserPoints[id];
}

public native_set_user_points(iPluginID, iParamNum)
{
	if (iParamNum != 2)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID, Amount)");
		return 0;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return 0;
	}
	new amount = get_param(2);
	if (0 > amount)
	{
		log_error(10, "[CSGO Remake] Invalid amount value (%d)", amount);
		return 0;
	}
	g_iUserPoints[id] = amount;
	_SaveData(id);
	return 1;
}

public native_get_user_cases(iPluginID, iParamNum)
{
	if (iParamNum != 1)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID)");
		return -1;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return -1;
	}
	return g_iUserCases[id];
}

public native_set_user_cases(iPluginID, iParamNum)
{
	if (iParamNum != 2)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID, Amount)");
		return 0;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return 0;
	}
	new amount = get_param(2);
	if (0 > amount)
	{
		log_error(10, "[CSGO Remake] Invalid amount value (%d)", amount);
		return 0;
	}
	g_iUserCases[id] = amount;
	_SaveData(id);
	return 1;
}

public native_get_user_keys(iPluginID, iParamNum)
{
	if (iParamNum != 1)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID)");
		return -1;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return -1;
	}
	return g_iUserKeys[id];
}

public native_set_user_keys(iPluginID, iParamNum)
{
	if (iParamNum != 2)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID, Amount)");
		return 0;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return 0;
	}
	new amount = get_param(2);
	if (0 > amount)
	{
		log_error(10, "[CSGO Remake] Invalid amount value (%d)", amount);
		return 0;
	}
	g_iUserKeys[id] = amount;
	_SaveData(id);
	return 1;
}

public native_get_user_dusts(iPluginID, iParamNum)
{
	if (iParamNum != 1)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID)");
		return -1;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return -1;
	}
	return g_iUserDusts[id];
}

public native_set_user_dusts(iPluginID, iParamNum)
{
	if (iParamNum != 2)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID, Amount)");
		return 0;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return 0;
	}
	new amount = get_param(2);
	if (0 > amount)
	{
		log_error(10, "[CSGO Remake] Invalid amount value (%d)", amount);
		return 0;
	}
	g_iUserDusts[id] = amount;
	_SaveData(id);
	return 1;
}

public native_get_user_rank(iPluginID, iParamNum)
{
	if (iParamNum != 3)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID, Output, Len)");
		return -1;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return -1;
	}
	new rank = g_iUserRank[id];
	new szRank[32];
	ArrayGetString(g_aRankName, rank, szRank, 31);
	new len = get_param(3);
	set_string(2, szRank, len);
	return rank;
}

public native_set_user_rank(iPluginID, iParamNum)
{
	if (iParamNum != 2)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID, RankID)");
		return 0;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return 0;
	}
	new rank = get_param(2);
	if (rank < 0 || rank >= g_iRanksNum)
	{
		log_error(10, "[CSGO Remake] Invalid RankID (%d)", rank);
		return 0;
	}
	g_iUserRank[id] = rank;
	g_iUserKills[id] = ArrayGetCell(g_aRankKills, rank + -1);
	_SaveData(id);
	return 1;
}

public native_get_user_skins(iPluginID, iParamNum)
{
	if (iParamNum != 2)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID, SkinID)");
		return -1;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return -1;
	}
	new skin = get_param(2);
	if (skin < 0 || skin >= g_iSkinsNum)
	{
		log_error(10, "[CSGO Remake] Invalid SkinID (%d)", skin);
		return -1;
	}
	new amount = g_iUserSkins[id][skin];
	return amount;
}

public native_set_user_skins(iPluginID, iParamNum)
{
	if (iParamNum != 3)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID, SkinID, Amount)");
		return 0;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return 0;
	}
	new skin = get_param(2);
	if (skin < 0 || skin >= g_iSkinsNum)
	{
		log_error(10, "[CSGO Remake] Invalid SkinID (%d)", skin);
		return 0;
	}
	new amount = get_param(3);
	if (0 > amount)
	{
		log_error(10, "[CSGO Remake] Invalid amount value (%d)", amount);
		return 0;
	}
	g_iUserSkins[id][skin] = amount;
	_SaveData(id);
	return 1;
}

public native_is_user_logged(iPluginID, iParamNum)
{
	if (iParamNum != 1)
	{
		log_error(10, "[CSGO Remake] Invalid param num ! Valid: (PlayerID)");
		return 0;
	}
	new id = get_param(1);
	if (!(0 < id && 32 >= id || !is_user_connected(id)))
	{
		log_error(10, "[CSGO Remake] Player is not connected (%d)", id);
		return 0;
	}
	return g_bLogged[id];
}

public concmd_finddata(id, level, cid)
{
	if (!cmd_access(id, level, cid, 2, false))
	{
		return 1;
	}
	new arg1[32];
	read_argv(1, arg1, 31);
	if (g_Vault == -1)
	{
		console_print(id, "%s Reading from vault has failed !", "[CSGO Remake]");
		return 1;
	}
	new Data[64];
	new Timestamp;
	if (nvault_lookup(g_Vault, arg1, Data, 63, Timestamp))
	{
		new userData[6][16];
		new password[16];
		new buffer[48];
		strtok(Data, password, 15, Data, 63, 61, 0);
		strtok(Data, buffer, 47, Data, 63, 42, 0);
		new i;
		while (i < 6)
		{
			strtok(buffer, userData[i], 15, buffer, 47, 44, 0);
			i++;
		}
		new rank = str_to_num(userData[5]);
		new szRank[32];
		ArrayGetString(g_aRankName, rank, szRank, 31);
		console_print(id, "[CSGO Remake]", arg1, password);
		console_print(id, "%s Points: %s | Rank: %s", "[CSGO Remake]", userData[0], szRank);
		console_print(id, "%s Keys: %s | Cases: %s", "[CSGO Remake]", userData[2], userData[3]);
		console_print(id, "%s Dusts: %s | Kills: %s", "[CSGO Remake]", userData[1], userData[4]);
	}
	else
	{
		console_print(id, "%s The account was not found: %s", "[CSGO Remake]", arg1);
	}
	return 1;
}

public concmd_resetdata(id, level, cid)
{
	if (!cmd_access(id, level, cid, 3, false))
	{
		return 1;
	}
	new arg1[32];
	new arg2[4];
	read_argv(1, arg1, 31);
	read_argv(2, arg2, 3);
	new type = str_to_num(arg2);
	if (g_Vault == -1)
	{
		console_print(id, "%s Reading from vault has failed !", "[CSGO Remake]");
		return 1;
	}
	new Data[512];
	new Timestamp;
	if (nvault_lookup(g_Vault, arg1, Data, 511, Timestamp))
	{
		if (0 < type)
		{
			nvault_remove(g_Vault, arg1);
			console_print(id, "%s The account has been removed: %s", "[CSGO Remake]", arg1);
			return 1;
		}
		new infobuff[64];
		new weapbuff[320];
		new skinbuff[96];
		new password[16];
		strtok(Data, password, 15, Data, 511, 61, 0);
		formatex(infobuff, 63, "%s=%d,%d,%d,%d,%d,%d", password, 0, 0, 0, 0, 0, 0);
		formatex(weapbuff, 319, "%d", 0);
		new i = 1;
		while (i < 96)
		{
			format(weapbuff, 319, "%s,%d", weapbuff, 0);
			i++;
		}
		formatex(skinbuff, 95, "%d", -1);
		i = 2;
		while (i <= 30)
		{
			format(skinbuff, 95, "%s,%d", skinbuff, -1);
			i++;
		}
		formatex(Data, 511, "%s*%s#%s", infobuff, weapbuff, skinbuff);
		nvault_set(g_Vault, arg1, Data);
		console_print(id, "%s The account has been reseted: %s", "[CSGO Remake]", arg1);
	}
	else
	{
		console_print(id, "%s The account was not found: %s", "[CSGO Remake]", arg1);
	}
	return 1;
}

public concmd_getinfo(id, level, cid)
{
	if (!cmd_access(id, level, cid, 3, false))
	{
		return 1;
	}
	new arg1[8];
	new arg2[8];
	read_argv(1, arg1, 7);
	read_argv(2, arg2, 7);
	new num = str_to_num(arg2);
	switch (arg1[0])
	{
		case 82, 114:
		{
			if (num < 0 || num >= g_iRanksNum)
			{
				console_print(id, "%s Wrong index. Please choose a number between 0 and %d.", "[CSGO Remake]", g_iRanksNum + -1);
			}
			else
			{
				new Name[32];
				ArrayGetString(g_aRankName, num, Name, 31);
				new Kills = ArrayGetCell(g_aRankKills, num);
				console_print(id, "%s Information about RANK with index: %d", "[CSGO Remake]", num);
				console_print(id, "%s Name: %s | Required kills: %d", "[CSGO Remake]", Name, Kills);
			}
		}
		case 83, 115:
		{
			if (num < 0 || num >= g_iSkinsNum)
			{
				console_print(id, "%s Wrong index. Please choose a number between 0 and %d.", "[CSGO Remake]", g_iSkinsNum + -1);
			}
			else
			{
				new Name[32];
				ArrayGetString(g_aSkinName, num, Name, 31);
				new Type[8];
				ArrayGetString(g_aSkinType, num, Type, 7);
				console_print(id, "%s Information about SKIN with index: %d", "[CSGO Remake]", num);
				switch (Type[0])
				{
					case 100:
					{
						console_print(id, "%s Name: %s | Type: drop", "[CSGO Remake]", Name);
					}
					
					default:
					{
						console_print(id, "%s Name: %s | Type: craft", "[CSGO Remake]", Name);
					}
				}
			}
		}
		default:
		{
			console_print(id, "%s Wrong index. Please choose R or S.", "[CSGO Remake]");
		}
	}
	return 1;
}

public concmd_kill(id)
{
	console_print(id, "You can't commit suicide.");
	return FMRES_SUPERCEDE;
}