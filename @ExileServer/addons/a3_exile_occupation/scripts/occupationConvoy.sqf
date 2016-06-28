if (!isServer) exitWith {};

_logDetail = format['[OCCUPATION:Convoy] Started'];
[_logDetail] call SC_fnc_log;

// set the default side for bandit AI
_side               = "bandit"; 

if(SC_occupyVehicleSurvivors) then 
{   
    if(!isNil "DMS_Enable_RankChange") then { DMS_Enable_RankChange = true;  };
};

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
            _side = "survivor";
        };
        if(_side == "survivor") then
        {
            _vehicleClass = SC_ConvoyVehicleClassesSurvivor call BIS_fnc_selectRandom;
        } else {
            _vehicleClass = SC_ConvoyVehicleClassesBandit call BIS_fnc_selectRandom;
        };
        _vehiclesToSpawn = 1 max (random SC_maxVehiclesPerConvoy);
        _vehiclesSpawned = 0;
        for "_k" from 1 to _vehiclesToSpawn do
        {
            private["_group"];
            _spawnLocation = [] call SC_fnc_findConvoyPos;
            diag_log format["[OCCUPATION:Convoy] found position %1",_spawnLocation];
            if(_side == "survivor") then
            {
                _group = createGroup SC_SurvivorSide;
            } else {
                _group = createGroup SC_BanditSide;
            };
            _group setVariable ["DMS_AllowFreezing",false,true];
            _group setVariable ["DMS_LockLocality",nil];
            _group setVariable ["DMS_SpawnedGroup",true];
            _group setVariable ["DMS_Group_Side", _side];

            _vehicle = createVehicle [_vehicleClass, _spawnLocation, [], 0, "NONE"];

            if(!isNull _vehicle) then
            {
                _group addVehicle _vehicle;

                _vehicle setVariable["vehPos",_spawnLocation,true];
                _vehicle setVariable["vehClass",_VehicleClassToUse,true];
                _vehicle setVariable ["SC_vehicleSpawnLocation", _spawnLocation,true];
                _vehicle setFuel 1;
                _vehicle engineOn true;

                if(SC_occupyVehiclesLocked) then
                {
                    _vehicle lock 2;
                    _vehicle setVehicleLock "LOCKED";
                    _vehicle setVariable ["ExileIsLocked", 1, true];
                }
                else
                {
                    _vehicle lock 0;
                    _vehicle setVehicleLock "UNLOCKED";
                    _vehicle setVariable ["ExileIsLocked", 0, true];
                };

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
                }forEach units _group;

                // ToDo: set Waypoint to drive to the airfield
                // ToDo: remove taskPatrol
                [_group, _spawnLocation, 2000] call bis_fnc_taskPatrol;
                _group setBehaviour "SAFE";
                _group setCombatMode "RED";
                sleep 0.2;

                clearMagazineCargoGlobal _vehicle;
                clearWeaponCargoGlobal _vehicle;
                clearItemCargoGlobal _vehicle;

                if(_side == "survivor") then
                {
                    _convoyType = ["food", "material", "firstaid", "trash"] call BIS_fnc_selectRandom;
                }
                else
                {
                    _convoyType = ["weapon", "ammunition", "medical", "explosives"] call BIS_fnc_selectRandom;
                };

                // ToDo
                switch (_convoyType) do
                {
                    case "food":
                    {
                        _vehicle addItemCargoGlobal ["Exile_Item_PlasticBottleFreshWater", 1 + (random 20)];
                        _vehicle addItemCargoGlobal ["Exile_Item_EMRE", 1 + (random 20)];
                    };
                    case "material":
                    {

                    };
                    case "trash":
                    {

                    };
                    case "firstaid":
                    {

                    };
                    case "medical":
                    {
                        __vehicle addItemCargoGlobal ["Exile_Item_InstaDoc", (random 10)];
                    };
                    case "weapon":
                    {

                    };
                    case "ammunition":
                    {

                    };
                    case "explosives":
                    {
                        _vehicle addMagazineCargoGlobal ["HandGrenade", (random 2)];
                    };
                };

                // Add weapons with ammo to the vehicle
                _possibleWeapons =
                [
                    "arifle_MXM_Black_F",
                    "arifle_MXM_F",
                    "arifle_MX_SW_Black_F",
                    "arifle_MX_SW_F",
                    "LMG_Mk200_F",
                    "LMG_Zafir_F"
                ];
                _amountOfWeapons = 1 + (random 3);

                for "_i" from 1 to _amountOfWeapons do
                {
                    _weaponToAdd = _possibleWeapons call BIS_fnc_selectRandom;
                    _vehicle addWeaponCargoGlobal [_weaponToAdd,1];

                    _magazinesToAdd = getArray (configFile >> "CfgWeapons" >> _weaponToAdd >> "magazines");
                    _vehicle addMagazineCargoGlobal [(_magazinesToAdd select 0),round random 3];
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