if (!isServer) exitWith {};

private["_wp","_wp2","_wp3"];

_logDetail = format ["[OCCUPATION:RandomSpawn]:: Starting Occupation Monitor @ %1",time];
[_logDetail] call SC_fnc_log;

_middle 		    = worldSize/2;			
_spawnCenter 	    = [_middle,_middle,0];		// Centre point for the map
_maxDistance 	    = _middle;			        // Max radius for the map

_maxAIcount 		= SC_maxAIcount;
_minFPS 			= SC_minFPS;
_useLaunchers 	    = DMS_ai_use_launchers;
_scaleAI			= SC_scaleAI;
_side               = "bandit"; 


// more than _scaleAI players on the server and the max AI count drops per additional player
_currentPlayerCount = count playableUnits;
if(_currentPlayerCount < SC_randomSpawnMinPlayers) exitWith
{ 
    if(SC_extendedLogging) then 
    { 
        _logDetail = format ["[OCCUPATION:RandomSpawn]:: Held off spawning random AI, not enough players online"]; 
        [_logDetail] call SC_fnc_log; 
    };
};
if(_currentPlayerCount > _scaleAI) then 
{
	_maxAIcount = _maxAIcount - (_currentPlayerCount - _scaleAI) ;
};

// Don't spawn additional AI if the server fps is below _minFPS
if(diag_fps < _minFPS) exitWith 
{ 
    if(SC_extendedLogging) then 
    { 
        _logDetail = format ["[OCCUPATION:RandomSpawn]:: Held off spawning more AI as the server FPS is only %1",diag_fps]; 
        [_logDetail] call SC_fnc_log; 
    };
};

_aiActive = { !isPlayer _x } count allunits;

if(_aiActive > _maxAIcount) exitWith 
{ 
    if(SC_extendedLogging) then 
    { 
        _logDetail = format ["[OCCUPATION:RandomSpawn]:: %1 active AI, so not spawning AI this time",_aiActive]; 
        [_logDetail] call SC_fnc_log;
    };
};

SC_suitablePlayers = [];
// Find a player to spawn AI near
{
    _okToSpawn = true;
    _player = _x;
    // Don't spawn AI if playable isn't a player
    if(!isPlayer _player) exitwith
    {
        _okToSpawn = false;
        if(SC_extendedLogging) then
        {
            _logDetail = format ["[OCCUPATION:RandomSpawn]:: %1 isn't a player",_player];
            [_logDetail] call SC_fnc_log;
        };
    };
    // Don't spawn AI if player isn't alive
    if(!alive _player) exitwith
    {
        _okToSpawn = false;
        if(SC_extendedLogging) then
        {
            _logDetail = format ["[OCCUPATION:RandomSpawn]:: %1 isn't alive",_player];
            [_logDetail] call SC_fnc_log;
        };
    };
    // Don't spawn additional AI if there are already AI in range
    _aiNear = count(_pos nearEntities ["O_recon_F", 150]);
    if(_aiNear > 0) exitwith
    {
        _okToSpawn = false;
        if(SC_extendedLogging) then
        {
            _logDetail = format ["[OCCUPATION:RandomSpawn]:: %1 already has %2 active AI in range",_player,_aiNear];
            [_logDetail] call SC_fnc_log;
        };
    };

    if(_okToSpawn) then
    {
        _aiCount = 2;
        _groupRadius = 150;
        _difficulty = "random";
        _side = SC_BanditSide;
        _spawnPosition = [ false, false ] call SC_fnc_findsafePos;

        // increase AI amount for players in range
        {
            {
                if (isPlayer _x) then
                {
                    _aiCount = _aiCount + 1;
                };
            } forEach (crew _x);
        } forEach (position _player nearEntities [["Exile_Unit_Player","LandVehicle", "Air", "Ship"], 100]);

        // Get the AI to shut the fuck up :)
        enableSentences false;
        enableRadio false;

        if(!SC_useWaypoints) then
        {
            DMS_ai_use_launchers = false;
            _group = [_spawnPosition, _aiCount, _difficulty, "random", "bandit"] call DMS_fnc_SpawnAIGroup;
            DMS_ai_use_launchers = _useLaunchers;

            {
                _unit = _x;
                [_unit] joinSilent grpNull;
                [_unit] joinSilent _group;
                _unitName = ["bandit"] call SC_fnc_selectName;
                if(!isNil "_unitName") then { _unit setName _unitName; };
                reload _unit;
                if(SC_debug) then
                {
                    _tag = createVehicle ["Sign_Arrow_Blue_F", position _unit, [], 0, "CAN_COLLIDE"];
                    _tag attachTo [_unit,[0,0,0.6],"Head"];
                };
            }foreach units _group;

            [_group, _pos, _groupRadius] call bis_fnc_taskPatrol;
            _group setBehaviour "COMBAT";
            _group setCombatMode "RED";
        }
        else
        {

            DMS_ai_use_launchers = false;
            _group = [_spawnPosition, _aiCount, _difficulty, "random", "bandit"] call DMS_fnc_SpawnAIGroup;
            DMS_ai_use_launchers = _useLaunchers;

            {
                _unit = _x;
                [_unit] joinSilent grpNull;
                [_unit] joinSilent _group;
                _unitName = ["bandit"] call SC_fnc_selectName;
                if(!isNil "_unitName") then { _unit setName _unitName; };
                if(SC_debug) then
                {
                    _tag = createVehicle ["Sign_Arrow_Blue_F", position _unit, [], 0, "CAN_COLLIDE"];
                    _tag attachTo [_unit,[0,0,0.6],"Head"];
                };
            }foreach units _group;

            [ _group,_pos,_difficulty,"COMBAT" ] call DMS_fnc_SetGroupBehavior;

            _buildings = _pos nearObjects ["house", _groupRadius];
            {
                _buildingPositions = [_x, 10] call BIS_fnc_buildingPositions;
                if(count _buildingPositions > 0) then
                {
                     _y = _x;

                    // Find Highest Point
                    _highest = [0,0,0];
                    {
                        if(_x select 2 > _highest select 2) then
                        {
                            _highest = _x;
                        };

                    } foreach _buildingPositions;
                    _spawnPosition = _highest;

                    _i = _buildingPositions find _spawnPosition;
                    _wp = _group addWaypoint [_spawnPosition, 0] ;
                    _wp setWaypointFormation "Column";
                    _wp setWaypointBehaviour "AWARE";
                    _wp setWaypointCombatMode "RED";
                    _wp setWaypointCompletionRadius 1;
                    _wp waypointAttachObject _y;
                    _wp setwaypointHousePosition _i;
                    _wp setWaypointType "SAD";

                };
            } foreach _buildings;
            if(count _buildings > 0 ) then
            {
                _wp setWaypointType "CYCLE";
            };
        };

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        _logDetail = format ["[OCCUPATION:RandomSpawn]:: Spawning %1 AI in at %2 to patrol",_aiCount,_spawnPosition];
        [_logDetail] call SC_fnc_log;

        if(SC_mapMarkers) then
        {
            _marker = createMarker [format ["%1", _foundBuilding],_pos];
            _marker setMarkerShape "Icon";
            _marker setMarkerSize [3,3];
            _marker setMarkerType "mil_dot";
            _marker setMarkerBrush "Solid";
            _marker setMarkerAlpha 0.5;
            _marker setMarkerColor "ColorRed";
            _marker setMarkerText "Occupied Military Area";
        };
        _okToSpawn = false;
    }
    
} forEach playableUnits;
