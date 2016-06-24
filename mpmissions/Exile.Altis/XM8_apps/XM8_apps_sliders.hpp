class CfgXM8 {
	//This slide use IDCs from 104140 to 104156
	class sideApps {
		controlID = 104140;
		title = "XM8 Apps";
		onLoadScript = "";
	};
	//This slide use IDCs from 960050 to 960140
	class repairMate {
		controlID = 960050;
		title = "Repair Mate";
		onLoadScript = "XM8_apps\apps\XM8_repairMate\scripts\XM8_repairMate_repairMate_onLoad.sqf"; //FULL PATH FROM MISSION ROOT
	};
};