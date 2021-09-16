// ===========================================================
//        Simple AdBlock for CS:GO Workshop maps - v1.0
//
// Can be manually run with:
//
//       script_execute adblock.nut
//
// Requires a CFG entry point otherwise:
//
//  - listenserver.cfg doesn't always work
//  - gamemode_*.cfg ones can sometimes work
//  - aim_bots didn't want any of those
//
//
// https://github.com/ZooLSmith/CSGO-map-adblock
// ===========================================================

if (!("SendToConsole" in this)) // SERVERSIDE ONLY
	return
	
if (this.rawin("ab_adKiller") && (ab_adKiller != null && ab_adKiller.IsValid()))
{
	printl("[AdBlock] Aborted, I'm already running!")
	return
}

::ab_mapname <- split(GetMapName(), "/")
ab_mapname = ab_mapname[ab_mapname.len()-1]

if( ab_mapname == "aim_botz" )
{
	::ab_runTime <- Time()
	::ab_adTime <- 20
	::ab_killAds <- function()
	{
		EntFire("ad.*", "Kill")
		SendToConsole("r_screenoverlay NoAdsOkThanks")
	
		if( Time() > ab_runTime+ab_adTime )
			EntFireByHandle(ab_adKiller, "Kill", "", 0, null, null)
	}

	::ab_adKiller <- Entities.CreateByClassname("logic_timer");
	ab_adKiller.__KeyValueFromString("targetname", "ab_adKiller");
	EntFireByHandle(ab_adKiller, "AddOutput", "RefireTime 0.01", 0, null, null);
	EntFireByHandle(ab_adKiller, "AddOutput", "classname info_target", 0, null, null);
	EntFireByHandle(ab_adKiller, "AddOutput", "OnTimer worldspawn:RunScriptCode:ab_killAds():0:-1", 0, null, null);
	EntFireByHandle(ab_adKiller, "Enable", "", 0.1, null, null);
}