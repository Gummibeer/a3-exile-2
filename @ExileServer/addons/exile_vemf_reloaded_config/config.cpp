#include "CfgPatches.hpp"

class CfgVemfReloadedOverrides
{
	debugMode = 1; // Overrides CfgVemfReloaded >> debugMode
	maxGlobalMissions = 10; // Overrides CfgVemfReloaded >> maxGlobalMissions
	minServerFPS = 5; // Overrides CfgVemfReloaded >> minServerFPS
	missionList[] = {"DynamicLocationInvasion","BaseAttack","PlayerAttack"}; // Each entry should represent an .sqf file in the missions folder

	class DynamicLocationInvasion
	{
		markCrateOnMap = 0; // Enable/disable loot crate marker on map called "Loot"
		parachuteCrate[] = {1, 500}; // default: {disabled, 250 meters} | use 1 as first number to enable crate parachute spawn
		groupCount[] = {2,6}; // In format: {minimum, maximum}; VEMF will pick a random number between min and max. If you want the same amount always, use same numbers for minimum and maximum.
		groupUnits[] = {4,8}; // How much units in each group. Works the same like groupCount
		heliPatrol[] = {1, {
			"Exile_Chopper_Hummingbird_Green",
			"Exile_Chopper_Orca_BlackCustom",
			"Exile_Chopper_Mohawk_FIA",
			"Exile_Chopper_Huron_Black",
			"Exile_Chopper_Hellcat_Green",
			"Exile_Chopper_Huey_Armed_Green",
			"Exile_Chopper_Taru_Transport_Black"
		}}; // Enable/disable heli patrol at mission location and set the types of heli(s)
		heliLocked = 0; // Enable/disable heli lock to prevent/allow players from flying it
		maxInvasions = 5; // Max amount of active uncompleted invasions allowed at the same time
	}

	class aiCleanUp
	{
		removeLaunchers = 1;
	}

	class policeConfig
	{
		backpacks[] = {
			"BWA3_AssaultPack_Fleck","BWA3_Kitbag_Fleck","BWA3_Kitbag_Fleck_Medic","BWA3_TacticalPack_Fleck","BWA3_TacticalPack_Fleck_Medic","BWA3_FieldPack_Fleck","BWA3_Carryall_Fleck","BWA3_PatrolPack_Fleck",
			"BWA3_AssaultPack_Tropen","BWA3_Kitbag_Tropen","BWA3_Kitbag_Tropen_Medic","BWA3_TacticalPack_Tropen","BWA3_TacticalPack_Tropen_Medic","BWA3_FieldPack_Tropen","BWA3_Carryall_Tropen","BWA3_PatrolPack_Tropen"
		};
		headGear[] = {
			"BWA3_OpsCore_Fleck","BWA3_OpsCore_Fleck_Patch","BWA3_OpsCore_Fleck_Camera","BWA3_CrewmanKSK_Fleck","BWA3_CrewmanKSK_Fleck_Headset","BWA3_MICH_Fleck","BWA3_M92_Fleck","BWA3_Booniehat_Fleck",
			"BWA3_OpsCore_Tropen","BWA3_OpsCore_Tropen_Patch","BWA3_OpsCore_Tropen_Camera","BWA3_CrewmanKSK_Tropen","BWA3_CrewmanKSK_Tropen_Headset","BWA3_MICH_Tropen","BWA3_M92_Tropen","BWA3_Booniehat_Tropen",
			"BWA3_OpsCore_Schwarz","BWA3_OpsCore_Schwarz_Camera","BWA3_CrewmanKSK_Schwarz","BWA3_CrewmanKSK_Schwarz_Headset","BWA3_Knighthelm",
			"BWA3_Beret_PzGren","BWA3_Beret_Pz","BWA3_Beret_PzAufkl","BWA3_Beret_Jaeger","BWA3_Beret_Falli","BWA3_Beret_HFlieger","BWA3_Beret_Wach_Gruen","BWA3_Beret_Wach_Blau"
		};
		pistols[] = {
			"BWA3_P8","BWA3_MP7"
		};
		rifles[] = {
			"BWA3_G36","BWA3_G36K","BWA3_G36_AG","BWA3_G36K_AG","BWA3_G36_LMG","BWA3_G28_Standard","BWA3_G28_Assault","BWA3_G27","BWA3_G27_Tan","BWA3_G27_AG","BWA3_G27_Tan_AG","BWA3_MG4","BWA3_MG5","BWA3_MG5_Tan","BWA3_G82"
		};
		uniforms[] = {
			"BWA3_Uniform_idz_Fleck","BWA3_Uniform2_idz_Fleck","BWA3_Uniform3_idz_Fleck","BWA3_Uniform_Ghillie_idz_Fleck","BWA3_Uniform_Fleck","BWA3_Uniform2_Fleck","BWA3_Uniform_Ghillie_Fleck","BWA3_Uniform_Crew_Fleck",
			"BWA3_Uniform_idz_Tropen","BWA3_Uniform2_idz_Tropen","BWA3_Uniform3_idz_Tropen","BWA3_Uniform_Ghillie_idz_Tropen","BWA3_Uniform_Tropen","BWA3_Uniform2_Tropen","BWA3_Uniform_Ghillie_Tropen","BWA3_Uniform_Crew_Tropen",
			"BWA3_Uniform_Helipilot"
	   };
		vests[] = {
			"BWA3_Vest_Fleck","BWA3_Vest_Rifleman1_Fleck","BWA3_Vest_Autorifleman_Fleck","BWA3_Vest_Grenadier_Fleck","BWA3_Vest_Medic_Fleck","BWA3_Vest_Marksman_Fleck","BWA3_Vest_Leader_Fleck",
            "BWA3_Vest_Tropen","BWA3_Vest_Rifleman1_Tropen","BWA3_Vest_Autorifleman_Tropen","BWA3_Vest_Grenadier_Tropen","BWA3_Vest_Medic_Tropen","BWA3_Vest_Marksman_Tropen","BWA3_Vest_Leader_Tropen"
		};
	};

	class BaseAttack // WORK IN PROGRESS!!
	{ // BaseAttack (mission) settings
		aiLaunchers = 0; // Allow/disallow AI to have rocket launchers
		aiMode = 1; // 0 = "military" | 1 = Police | 2 = S.W.A.T.
		aiSetup[] = {2,6}; // format: {amountOfGroups,unitsInEachGroup};
		hasLauncherChance = 0; // In percentage. How big the chance that each AI gets a launcher
		maxAttacks = 5; // Maximum amount of active attacks at the same time | can not be turned off
		/*
			NOTES:
			1) every territory flag can only be attacked once every restart
			2) only players within a certain range of the attacked territory can see the mission announcement
			3) as a "punishment" for killing AI, players do NOT get any respect increase/decrease for killing AI
		*/
	};

	class PlayerAttack : BaseAttack {} // just copy the settings for the PlayerAttack mission
};