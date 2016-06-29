/*
   Author: IT07

   Description:
   A simple mission for VEMFr that sends a chopper to a player's territory and paradrops all units inside
*/

VEMFrMissionCount = VEMFrMissionCount + 1;
_missionName = param [0, "", [""]];
if isNil "VEMFrAttackCount" then { VEMFrAttackCount = 0 };
VEMFrAttackCount = VEMFrAttackCount + 1;
if (VEMFrAttackCount <= ([[_missionName],["maxAttacks"]] call VEMFr_fnc_getSetting select 0)) then
{
   scopeName "outer";
   if (_missionName in ("missionList" call VEMFr_fnc_getSetting)) then
   {
      _aiSetup = ([[_missionName],["aiSetup"]] call VEMFr_fnc_getSetting) select 0;
      if (_aiSetup select 0 > 0 AND _aiSetup select 1 > 0) then
      {
         _attackedPlayers = uiNamespace getVariable ["VEMFrAttackedPlayers",[]];
         _players = [];
         {
            if (
                (alive _player) AND
                (isPlayer _player) AND
                (speed _x < 25) AND
                (vehicle _x isEqualTo _x) AND
                !(_x in _attackedPlayers)
            ) then
            {
                _players pushBack _x;
            };
         } forEach allPlayers;
         if (count _players > 0) then
         {
            _playerToAttack = selectRandom _players;
            _attackedPlayers pushBack _playerToAttack;
         };
         if not isNil "_playerToAttack" then
         {
            _playerPos = position _playerToAttack;
            _playerName =  name _playerToAttack;
            _playerCount = 0;
            {
               {
                   if (isPlayer _x) then
                   {
                       _playerCount = _playerCount + 1;
                   };
               } forEach (crew _x);
            } forEach (position _playerToAttack nearEntities [["Exile_Unit_Player","LandVehicle", "Air", "Ship"], 100]);
           _groups = _aiSetup select 0;
           _units = _aiSetup select 1;
           _units = _units + _playerCount;
           _paraGroups = [_playerPos, _groups, _units, ([[_missionName],["aiMode"]] call VEMFr_fnc_getSetting select 0), _missionName, 1000 + (random 1000), 150] call VEMFr_fnc_spawnVEMFrAI;
           if (count _paraGroups isEqualTo (_aiSetup select 0)) then
           {
              _unitCount = 0;
              {
                 if (count (units _x) isEqualTo (_units)) then
                 {
                    _unitCount = _unitCount + (count(units _x));
                 };
              } forEach _paraGroups;
              if (_unitCount isEqualTo ((_groups) * (_units))) then
              {
                 _wayPoints = [];
                 _units = [];
                 {
                    _wp = _x addWaypoint [_playerPos, 50, 1];
                    _wp setWaypointBehaviour "COMBAT";
                    _wp setWaypointCombatMode "RED";
                    _wp setWaypointCompletionRadius 10;
                    _wp setWaypointFormation "DIAMOND";
                    _wp setWaypointSpeed "FULL";
                    _wp setWaypointType "SAD";
                    _x setCurrentWaypoint _wp;
                    _wayPoints pushback _wp;
                    {
                       _units pushback _x;
                    } forEach (units _x);
                    [_x] ExecVM "exile_vemf_reloaded\sqf\signAI.sqf";
                 } forEach _paraGroups;
                 _players = nearestObjects [_playerPos, ["Exile_Unit_Player"], 275];
                 [-1, "NEW PLAYER ATTACK", format["A para team is on the way to %1's location!", _playerName], _players] ExecVM "exile_vemf_reloaded\sqf\notificationToClient.sqf";
                 [-1, "PlayerAttack", format["A para team is on the way to %1's location!", _flagName]] ExecVM "exile_vemf_reloaded\sqf\log.sqf";

                 while {true} do
                 {
                    scopeName "loop";
                    _deadCount = 0;
                    {
                       if (damage _x isEqualTo 1 OR isNull _x) then
                       {
                          _deadCount = _deadCount + 1;
                       };
                    } forEach _units;
                    if (_deadCount isEqualTo _unitCount) then
                    {
                       breakOut "loop";
                    } else
                    {
                       uiSleep 4;
                    };
                 };
                 _players = nearestObjects [_playerPos, ["Exile_Unit_Player"], 275];
                 [-1, "DEFEATED", format["Player attack on %1 has been defeated!", _playername], _players] ExecVM "exile_vemf_reloaded\sqf\notificationToClient.sqf";
                 breakOut "outer";
              } else
              {
                 {
                    {
                       deleteVehicle _x;
                    } forEach (units _x);
                 } forEach _paraGroups;
                 ["PlayerAttack", 0, format["Incorrect amount of total units (%1). Should be %2", _unitCount, (_groups) * (_units)]] ExecVM "exile_vemf_reloaded\sqf\log.sqf";
                 breakOut "outer";
              };
           } else
           {
              ["PlayerAttack", 0, format["Incorrect spawned group count (%1). Should be %2", count _paraGroups, _groups]] ExecVM "exile_vemf_reloaded\sqf\log.sqf";
              breakOut "outer";
           };
         } else {
            ["PlayerAttack", 0, "Can not find a player to attack!"] ExecVM "exile_vemf_reloaded\sqf\log.sqf";
            breakOut "outer";
         }
      } else
      {
         ["PlayerAttack", 0, format["invalid aiSetup setting! (%1)", _aiSetup]] ExecVM "exile_vemf_reloaded\sqf\log.sqf";
         breakOut "outer";
      };
   } else
   {
      ["PlayerAttack", 0, format["Failed to start mission. Given _missionName (%1) is not in active missionList", _missionName]] ExecVM "exile_vemf_reloaded\sqf\log.sqf";
      breakOut "outer";
   };
};
VEMFrAttackCount = VEMFrAttackCount - 1;
VEMFrMissionCount = VEMFrMissionCount - 1;
