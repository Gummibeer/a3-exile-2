if (!isServer) exitWith {};

_logDetail = format['[OCCUPATION:Convoy] Started'];
[_logDetail] call SC_fnc_log;

// set the default side for bandit AI
_side               = "military";

// more than _scaleAI players on the server and the max AI count drops per additional player
_currentPlayerCount = count playableUnits;
_maxAIcount 		= SC_maxAIcount;

if(_currentPlayerCount > SC_scaleAI) then 
{
	_maxAIcount = _maxAIcount - (_currentPlayerCount - SC_scaleAI) ;
};

// Don't spawn additional AI if the server fps is below _minFPS
if(diag_fps < SC_minFPS) exitWith 
{ 
    _logDetail = format ["[OCCUPATION:Convoy]:: Held off spawning more AI as the server FPS is only %1",diag_fps];
    [_logDetail] call SC_fnc_log; 
};
_aiActive = { !isPlayer _x } count allunits;
if((_aiActive > _maxAIcount) && !SC_occupyVehicleIgnoreCount) exitWith 
{ 
    _logDetail = format ["[OCCUPATION:Convoy]:: %1 active AI, so not spawning AI this time",_aiActive];
    [_logDetail] call SC_fnc_log; 
};

if(SC_liveConvoys >= SC_maxNumberofConvoys) exitWith
{
    if(SC_extendedLogging) then 
    { 
        _logDetail = format['[OCCUPATION:Convoy] End check %1 currently active (max %2) @ %3',SC_liveConvoys,SC_maxNumberofConvoys,time];
        [_logDetail] call SC_fnc_log;
    };   
};

_convoysToSpawn = (SC_maxNumberofConvoys - SC_liveConvoys);

if(SC_extendedLogging) then 
{ 
	if(_convoysToSpawn > 0) then
	{ 
		_logDetail = format['[OCCUPATION:Convoy] Started %2 currently active (max %3) spawning %1 extra convoy(s) @ %4',_convoysToSpawn,SC_liveConvoys,SC_maxNumberofConvoys,time];
		[_logDetail] call SC_fnc_log;
	}
	else
	{
		_logDetail = format['[OCCUPATION:Convoy] Started %2 currently active (max %3) @ %4',_convoysToSpawn,SC_liveConvoys,SC_maxNumberofConvoys,time];
		[_logDetail] call SC_fnc_log;
	};
	
};

_middle = worldSize/2;
_spawnCenter = [_middle,_middle,0];
_maxDistance = _middle;

if(_convoysToSpawn >= 1) then
{
	_useLaunchers = DMS_ai_use_launchers;
 	for "_j" from 1 to _convoysToSpawn do
	{
	    // decide which side to spawn
        _sideToSpawn = random 100;
        if(_sideToSpawn <= 50) then
        {
            _side = "security";
        };
        _vehicleClass = "Exile_Car_Hunter";
        if(_side == "security") then
        {
            _vehicleClass = SC_ConvoyVehicleClassesSecurity call BIS_fnc_selectRandom;
        } else {
            _vehicleClass = SC_ConvoyVehicleClassesMilitary call BIS_fnc_selectRandom;
        };
        _vehiclesToSpawn = 1 max (random SC_maxVehiclesPerConvoy);
        _vehiclesSpawned = 0;
        for "_k" from 1 to _vehiclesToSpawn do
        {
            private["_group"];
            _spawnLocation = [] call SC_fnc_findConvoyPos;
            diag_log format["[OCCUPATION:Convoy] found position %1",_spawnLocation];
            _group = createGroup SC_BanditSide;
            _group setVariable ["DMS_AllowFreezing",false,true];
            _group setVariable ["DMS_LockLocality",nil];
            _group setVariable ["DMS_SpawnedGroup",true];
            _group setVariable ["DMS_Group_Side", _side];

            _vehicle = createVehicle [_vehicleClass, _spawnLocation, [], 0, "NONE"];

            if(!isNull _vehicle) then
            {
                _group addVehicle _vehicle;

                _vehicle setVariable["vehPos",_spawnLocation,true];
                _vehicle setVariable["vehClass",_vehicleClass,true];
                _vehicle setVariable ["SC_vehicleSpawnLocation", _spawnLocation,true];
                _vehicle setFuel 1;
                _vehicle engineOn true;
                _vehicle lock 0;
                _vehicle setVehicleLock "UNLOCKED";
                _vehicle setVariable ["ExileIsLocked", 0, true];
                _vehicle setSpeedMode "LIMITED";
                _vehicle limitSpeed 60;
                _vehicle action ["LightOn", _vehicle];
                _vehicle addEventHandler ["getin", "_this call SC_fnc_getIn;"];
                _vehicle addEventHandler ["getout", "_this call SC_fnc_getOut;"];
                _vehicle addMPEventHandler ["mpkilled", "_this call SC_fnc_vehicleDestroyed;"];
                _vehicle addMPEventHandler ["mphit", "_this call SC_fnc_hitLand;"];

                // Calculate the number of seats in the vehicle and fill the required amount
                _vehicleRoles = (typeOf _vehicle) call bis_fnc_vehicleRoles;
                {
                    _unitPlaced = false;
                    _vehicleRole = _x select 0;
                    _vehicleSeat = _x select 1;
                    if(_vehicleRole == "Driver") then
                    {
                        _loadOut = [_side] call SC_fnc_selectGear;
                        _unit = [_group,_spawnLocation,"custom","random",_side,"Vehicle",_loadOut] call DMS_fnc_SpawnAISoldier;
                        _unit disableAI "FSM";
                        _unit disableAI "MOVE";
                        [_side,_unit] call SC_fnc_addMarker;
                        _unit removeAllMPEventHandlers  "mphit";
                        _unit removeAllMPEventHandlers  "mpkilled";
                        _unit disableAI "TARGET";
                        _unit disableAI "AUTOTARGET";
                        _unit disableAI "AUTOCOMBAT";
                        _unit disableAI "COVER";
                        _unit disableAI "SUPPRESSION";
                        _unit assignAsDriver _vehicle;
                        _unit moveInDriver _vehicle;
                        _unit setVariable ["DMS_AssignedVeh",_vehicle];
                        _unit setVariable ["SC_drivenVehicle", _vehicle,true];
                        _unit addMPEventHandler ["mpkilled", "_this call SC_fnc_driverKilled;"];
                        _vehicle setVariable ["SC_assignedDriver", _unit,true];

                    };
                    if(_vehicleRole == "Turret") then
                    {
                        _loadOut = [_side] call SC_fnc_selectGear;
                        _unit = [_group,_spawnLocation,"custom","random",_side,"Vehicle",_loadOut] call DMS_fnc_SpawnAISoldier;
                        [_side,_unit] call SC_fnc_addMarker;
                        _unit moveInTurret [_vehicle, _vehicleSeat];
                        _unit setVariable ["DMS_AssignedVeh",_vehicle];
                        _unit addMPEventHandler ["mpkilled", "_this call SC_fnc_unitMPKilled;"];
                        _unitPlaced = true;
                    };
                    if(_vehicleRole == "CARGO") then
                    {
                        _loadOut = [_side] call SC_fnc_selectGear;
                        _unit = [_group,_spawnLocation,"custom","random",_side,"Vehicle",_loadOut] call DMS_fnc_SpawnAISoldier;
                        [_side,_unit] call SC_fnc_addMarker;
                        _unit assignAsCargo _vehicle;
                        _unit moveInCargo _vehicle;
                        _unit setVariable ["DMS_AssignedVeh",_vehicle];
                        _unit addMPEventHandler ["mpkilled", "_this call SC_fnc_unitMPKilled;"];
                        _unitPlaced = true;
                    };
                    if(SC_extendedLogging && _unitPlaced) then
                    {
                        _logDetail = format['[OCCUPATION:Convoy] %1 %2 added to vehicle %3',_side,_vehicleRole,_vehicle];
                        [_logDetail] call SC_fnc_log;
                    };
                } forEach _vehicleRoles;

                // Get the AI to shut the fuck up :)
                enableSentences false;
                enableRadio false;

                _logDetail = format['[OCCUPATION:Convoy] %3 vehicle %1 spawned @ %2',_vehicleClass,_spawnLocation,_side];
                [_logDetail] call SC_fnc_log;
                sleep 2;

                {
                    _unit = _x;
                    _unit enableAI "FSM";
                    _unit enableAI "MOVE";
                    reload _unit;
                    _unitName = [_side] call SC_fnc_selectName;
                    if(!isNil "_unitName") then { _unit setName _unitName; };
                } forEach units _group;

                _waypoint = _group addWaypoint [[14601,16799,0], 0];
                _waypoint setWaypointType "MOVE";
                _waypoint setWaypointSpeed "LIMITED";
                _waypoint setWaypointBehaviour "AWARE";
                _waypoint setWaypointCombatMode "RED";
                _waypoint setWaypointFormation "COLUMN";
                sleep 0.2;

                clearMagazineCargoGlobal _vehicle;
                clearWeaponCargoGlobal _vehicle;
                clearItemCargoGlobal _vehicle;

                _convoyType = "food";
                if(_side == "security") then
                {
                    _convoyType = ["food", "material", "firstaid", "tools", "clothes"] call BIS_fnc_selectRandom;
                }
                else
                {
                    _convoyType = ["weapon", "ammunition", "attachments", "medical", "explosives", "uniforms"] call BIS_fnc_selectRandom;
                };

                switch (_convoyType) do
                {
                    // security
                    case "food":
                    {
                        _vehicle addItemCargoGlobal ["Exile_Item_PlasticBottleFreshWater", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_Energydrink", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_PlasticBottleCoffee", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_PowerDrink", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_Beer", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_MountainDupe", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_EMRE", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_Cheathas", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_Noodles", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_BBQSandwich", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_Moobar", (random 10)];
                    };
                    case "material":
                    {
                        _vehicle addItemCargoGlobal ["Exile_Item_Rope", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_DuctTape", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_ExtensionCord", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_FuelCanisterEmpty", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_JunkMetal", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_LightBulb", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_MetalBoard", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_MetalHedgehogKit", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_CamoTentKit", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_MetalPole", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_MetalScrews", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_MetalWire", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_Cement", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_Sand", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_CarWheel", (random 10)];
                        _vehicle addItemCargoGlobal ["Exile_Item_SafeKit", (random 2)];
                        _vehicle addItemCargoGlobal ["Exile_Item_CodeLock", (random 2)];
                        _vehicle addItemCargoGlobal ["Exile_Item_Laptop", (random 2)];
                        _vehicle addItemCargoGlobal ["Exile_Item_BaseCameraKit", (random 2)];
                        _vehicle addItemCargoGlobal ["Exile_Item_ToiletPaper", (random 2)];
                    };
                    case "tools":
                    {
                        __vehicle addItemCargoGlobal ["Exile_Item_Matches", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_CookingPot", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Melee_Axe", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_CanOpener", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Handsaw", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Pliers", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Grinder", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Foolbox", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_CordlessScrewdriver", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_FireExtinguisher", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Hammer", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_OilCanister", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Screwdriver", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Shovel", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Wrench", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_SleepingMat", (random 5)];
                        __vehicle addItemCargoGlobal ["Exile_Item_ZipTie", (random 5)];
                    };
                    case "firstaid":
                    {
                        __vehicle addItemCargoGlobal ["Exile_Item_Bandage", (random 50)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Heatpack", (random 50)];
                        _vehicle addItemCargoGlobal ["Exile_Item_PlasticBottleFreshWater", (random 5)];
                        _vehicle addItemCargoGlobal ["Exile_Item_EMRE", (random 5)];
                    };
                    case "clothes":
                    {
                        __vehicle addItemCargoGlobal ["U_C_Journalist", (random 20)];
                        __vehicle addItemCargoGlobal ["U_C_Poloshirt_blue", (random 20)];
                        __vehicle addItemCargoGlobal ["U_C_Poloshirt_burgundy", (random 20)];
                        __vehicle addItemCargoGlobal ["U_C_Poloshirt_salmon", (random 20)];
                        __vehicle addItemCargoGlobal ["U_C_Poloshirt_stripped", (random 20)];
                        __vehicle addItemCargoGlobal ["U_C_Poloshirt_tricolour", (random 20)];
                        __vehicle addItemCargoGlobal ["U_C_Poor_1", (random 20)];
                        __vehicle addItemCargoGlobal ["U_C_Poor_2", (random 20)];
                        __vehicle addItemCargoGlobal ["U_C_Poor_shorts_1", (random 20)];
                        __vehicle addItemCargoGlobal ["U_C_Scientist", (random 20)];
                        __vehicle addItemCargoGlobal ["U_OrestesBody", (random 20)];
                        __vehicle addItemCargoGlobal ["U_Rangemaster", (random 20)];
                        __vehicle addItemCargoGlobal ["U_NikosAgedBody", (random 20)];
                        __vehicle addItemCargoGlobal ["U_NikosBody", (random 20)];
                        __vehicle addItemCargoGlobal ["U_Competitor", (random 20)];
                    };
                    // military
                    case "medical":
                    {
                        __vehicle addItemCargoGlobal ["Exile_Item_Bandage", (random 25)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Heatpack", (random 25)];
                        __vehicle addItemCargoGlobal ["Exile_Item_InstaDoc", (random 25)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Vishpirin", (random 25)];
                        __vehicle addItemCargoGlobal ["Exile_Item_Defibrillator", (random 2)];
                    };
                    case "weapon":
                    {
                        _vehicle addWeaponCargoGlobal ["hgun_Pistol_heavy_01_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["hgun_Pistol_heavy_02_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["LMG_Zafir_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["LMG_Mk200_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["arifle_Katiba_C_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["arifle_MXM_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["arifle_MXC_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["arifle_MX_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["srifle_DMR_01_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["srifle_DMR_02_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["srifle_DMR_03_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["srifle_DMR_04_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["srifle_DMR_05_blk_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["srifle_DMR_06_camo_F", (random 3)];
                        _vehicle addWeaponCargoGlobal ["MMG_01_hex_F", (random 3)];
                    };
                    case "ammunition":
                    {
                        _vehicle addMagazineCargoGlobal ["100Rnd_65x39_caseless_mag_Tracer", (random 10)];
                        _vehicle addMagazineCargoGlobal ["10Rnd_127x54_Mag", (random 10)];
                        _vehicle addMagazineCargoGlobal ["10Rnd_762x54_Mag", (random 10)];
                        _vehicle addMagazineCargoGlobal ["10Rnd_93x64_DMR_05_Mag", (random 10)];
                        _vehicle addMagazineCargoGlobal ["11Rnd_45ACP_Mag", (random 10)];
                        _vehicle addMagazineCargoGlobal ["150Rnd_762x54_Box_Tracer", (random 10)];
                        _vehicle addMagazineCargoGlobal ["200Rnd_65x39_cased_Box_Tracer", (random 10)];
                        _vehicle addMagazineCargoGlobal ["30Rnd_45ACP_Mag_SMG_01_Tracer_Green", (random 10)];
                        _vehicle addMagazineCargoGlobal ["30Rnd_556x45_Stanag_Tracer_Green", (random 10)];
                        _vehicle addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag_Tracer", (random 10)];
                    };
                    case "attachments":
                    {
                        _vehicle addItemCargoGlobal ["acc_flashlight", (random 5)];
                        _vehicle addItemCargoGlobal ["acc_pointer_IR", (random 5)];
                        _vehicle addItemCargoGlobal ["bipod_01_F_blk", (random 5)];
                        _vehicle addItemCargoGlobal ["bipod_01_F_mtp", (random 5)];
                        _vehicle addItemCargoGlobal ["bipod_01_F_snd", (random 5)];
                        _vehicle addItemCargoGlobal ["bipod_02_F_blk", (random 5)];
                        _vehicle addItemCargoGlobal ["bipod_02_F_hex", (random 5)];
                        _vehicle addItemCargoGlobal ["bipod_02_F_tan", (random 5)];
                        _vehicle addItemCargoGlobal ["bipod_03_F_blk", (random 5)];
                        _vehicle addItemCargoGlobal ["bipod_03_F_oli", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_338_black", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_338_green", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_338_sand", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_93mmg", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_93mmg_tan", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_acp", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_B", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_H", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_H_MG", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_H_SW", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_L", (random 5)];
                        _vehicle addItemCargoGlobal ["muzzle_snds_M", (random 5)];
                        _vehicle addItemCargoGlobal ["optic_Aco", (random 5)];
                        _vehicle addItemCargoGlobal ["optic_AMS", (random 5)];
                        _vehicle addItemCargoGlobal ["optic_Arco", (random 5)];
                        _vehicle addItemCargoGlobal ["optic_DMS", (random 5)];
                        _vehicle addItemCargoGlobal ["optic_Hamr", (random 5)];
                        _vehicle addItemCargoGlobal ["optic_Holosight", (random 5)];
                        _vehicle addItemCargoGlobal ["optic_LRPS", (random 5)];
                        _vehicle addItemCargoGlobal ["optic_MRCO", (random 5)];
                        _vehicle addItemCargoGlobal ["optic_NVS", (random 5)];
                        _vehicle addItemCargoGlobal ["optic_Nightstalker", (random 1)];
                        _vehicle addItemCargoGlobal ["optic_Yorris", (random 5)];
                    };
                    case "uniforms":
                    {
                        __vehicle addItemCargoGlobal ["U_B_CombatUniform_mcam", (random 20)];
                        __vehicle addItemCargoGlobal ["U_B_CombatUniform_mcam_tshirt", (random 20)];
                        __vehicle addItemCargoGlobal ["U_B_CombatUniform_mcam_vest", (random 20)];
                        __vehicle addItemCargoGlobal ["U_B_CombatUniform_mcam_worn", (random 20)];
                        __vehicle addItemCargoGlobal ["U_B_CTRG_1", (random 20)];
                        __vehicle addItemCargoGlobal ["U_B_CTRG_2", (random 20)];
                        __vehicle addItemCargoGlobal ["U_B_CTRG_3", (random 20)];
                        __vehicle addItemCargoGlobal ["U_I_CombatUniform", (random 20)];
                        __vehicle addItemCargoGlobal ["U_I_CombatUniform_shortsleeve", (random 20)];
                        __vehicle addItemCargoGlobal ["U_I_CombatUniform_tshirt", (random 20)];
                        __vehicle addItemCargoGlobal ["U_I_OfficerUniform", (random 20)];
                        __vehicle addItemCargoGlobal ["U_O_CombatUniform_ocamo", (random 20)];
                        __vehicle addItemCargoGlobal ["U_O_CombatUniform_oucamo", (random 20)];
                        __vehicle addItemCargoGlobal ["U_O_OfficerUniform_ocamo", (random 20)];
                        __vehicle addItemCargoGlobal ["U_B_SpecopsUniform_sgg", (random 20)];
                        __vehicle addItemCargoGlobal ["U_O_SpecopsUniform_blk", (random 20)];
                        __vehicle addItemCargoGlobal ["U_O_SpecopsUniform_ocamo", (random 20)];
                        __vehicle addItemCargoGlobal ["U_I_G_Story_Protagonist_F", (random 20)];
                        __vehicle addItemCargoGlobal ["Exile_Uniform_Woodland", (random 20)];
                    };
                    case "explosives":
                    {
                        _vehicle addMagazineCargoGlobal ["HandGrenade", (random 2)];
                        _vehicle addMagazineCargoGlobal ["MiniGrenade", (random 2)];
                        _vehicle addMagazineCargoGlobal ["B_IR_Grenade", (random 2)];
                        _vehicle addMagazineCargoGlobal ["O_IR_Grenade", (random 2)];
                        _vehicle addMagazineCargoGlobal ["I_IR_Grenade", (random 2)];
                        _vehicle addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell", (random 2)];
                        _vehicle addMagazineCargoGlobal ["3Rnd_HE_Grenade_shell", (random 2)];
                        _vehicle addMagazineCargoGlobal ["APERSBoundingMine_Range_Mag", (random 2)];
                        _vehicle addMagazineCargoGlobal ["APERSMine_Range_Mag", (random 2)];
                        _vehicle addMagazineCargoGlobal ["APERSTripMine_Wire_Mag", (random 2)];
                        _vehicle addMagazineCargoGlobal ["ClaymoreDirectionalMine_Remote_Mag", (random 2)];
                        _vehicle addMagazineCargoGlobal ["DemoCharge_Remote_Mag", (random 2)];
                        _vehicle addMagazineCargoGlobal ["IEDLandBig_Remote_Mag", (random 2)];
                        _vehicle addMagazineCargoGlobal ["IEDLandSmall_Remote_Mag", (random 2)];
                        _vehicle addMagazineCargoGlobal ["IEDUrbanBig_Remote_Mag", (random 2)];
                        _vehicle addMagazineCargoGlobal ["IEDUrbanSmall_Remote_Mag", (random 2)];
                        _vehicle addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", (random 2)];
                        _vehicle addMagazineCargoGlobal ["SLAMDirectionalMine_Wire_Mag", (random 2)];
                    };
                };

                _vehiclesSpawned = _vehiclesSpawned + 1;
            }
            else
            {
                _logDetail = format['[OCCUPATION:Convoy] vehicle %1 failed to spawn (check classname is correct)',_vehicleClass];
                [_logDetail] call SC_fnc_log;
            };
        };
        if(_vehiclesSpawned > 0) then {
            SC_liveConvoys = SC_liveConvoys + 1;
        };
	};
};

_logDetail = format['[OCCUPATION:Convoy] End check %1 currently active (max %2) @ %3',SC_liveConvoys,SC_maxNumberofConvoys,time];
[_logDetail] call SC_fnc_log;