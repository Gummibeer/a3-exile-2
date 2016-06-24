#include "CfgPatches.hpp"

class CfgVemfReloadedOverrides
{
	debugMode = 1; // Overrides CfgVemfReloaded >> debugMode
	maxGlobalMissions = 5; // Overrides CfgVemfReloaded >> maxGlobalMissions
	minServerFPS = 5; // Overrides CfgVemfReloaded >> minServerFPS


	class DynamicLocationInvasion
	{
		 markCrateOnMap = 0;
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
};