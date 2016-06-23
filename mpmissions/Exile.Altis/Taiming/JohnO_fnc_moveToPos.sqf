/* 

	Code used from ExileClient_system_party_updateMyMarker.sqf
	Credits to EXILE Devs for their work. I simply modified it to suit this script

*/	

private ["_intersectingObjectArray","_distance","_dogPos","_target","_distanceArray","_tar"];

//BURK_dog say3d "dog_ruff";

_safeZoneLocations = [[4915.28,8154.27,0],[4271,9655,0],[6139,5697,0]];

_intersectingObjectArray = lineIntersectsSurfaces [AGLToASL positionCameraToWorld [0, 0, 0], AGLToASL positionCameraToWorld [0, 0, 1600], vehicle player, objNull, true, 1, "VIEW", "FIRE"];

uiSleep 5; // Give the script 3 seconds to exit the current loop

dogMove = player addAction ["Dog: Move to","Taiming\moveTo.sqf","",0,false];

BURK_dog_movingToPos = true;

if !(_intersectingObjectArray isEqualTo []) then 
{
	_position = ASLtoAGL ((_intersectingObjectArray select 0) select 0);	

	while {BURK_dog_movingToPos} do
	{			

		BURK_dog moveTo _position;

		_safeZone = false;
		{
			if (player distance _x < 200) then
			{
				_safeZone = true;
			};
		} forEach _safeZoneLocations;

		if (_safeZone) then
		{
			BURK_dog playMove "Dog_Sit";
			BURK_dog_movingToPos = false;

			if (dogDebug) then
			{
				hint "Dog should be sitting due to safe zone";

			};
		};

		if (dogDebug) then
		{
			hint "Dog is moving to specific location";
		};	

		_distance = BURK_dog distance _position;

		if (Agressive) then // Scan for enemies while moving to position
		{	

			_dogPos = getPos BURK_dog;

			_target = _dogPos nearEntities ["Man",50];
		
			_distanceArray = [];
			{
				if ((_x in units group player) || (_x == player) || (_x isKindOf "animal") || (isPlayer _x)) then
				{
					
				}
				else
				{	
					_tar = BURK_dog distance _x;
					_distanceArray = _distanceArray + [[_tar,_x]];
				};	
			} forEach _target;

			if ((alive BURK_dog) && !(_distanceArray isEqualTo []) && (Agressive)) then 
			{
				_distanceArray sort true;
				_actualTarget = (_distanceArray select 0) select 1;
				_targetPos = getPos _actualTarget;

				_damage = damage _actualTarget;
				
				if (random 1 > 0.2) then
				{	
					[BURK_dog,_actualTarget] say3d "dog_one";
				};	

				BURK_dog moveTo _targetPos;

				if (dogDebug) then
				{
					hint format ["Dog has found a target at:%1 and it is a %2",_targetPos,_actualTarget];
				};	

				if (BURK_dog distance _actualTarget < 2) then
				{
					BURK_dog say3d "dog_ruff";
					_dir = getDir BURK_dog;
					BURK_dog attachTo [_actualTarget, [0, -0.5, 0.1] ];
					BURK_dog setDir _dir;
					uiSleep 0.5; 
					_actualTarget setDamage _damage + 0.2;
					detach BURK_dog;
				};
			};
		}
		else
		{	
			if (dogDebug) then
			{
				hint "Dog is not aggressive and is moving to desired location";
			};	
			if (_distance < 5) then
			{		
				if (dogDebug) then
				{
					hint "Dog has reach its destination and should sit down";
				};
					
				BURK_dog playMove "Dog_Stop";
				BURK_dog_movingToPos = false;
			};
		};	
		uiSleep 1;
		if (!(alive BURK_dog) || !(alive player)) exitWith 
		{
			player removeAction Dogfollow;
			player removeAction Dogseek;
			player removeAction Dogpassive;
			player removeAction Dogstay;
			player removeAction Dogrun;
			player removeAction Dogsprint;
			player removeAction agressiveAction;
			player removeAction passiveAction;
			player removeAction dogMove;
			BURK_dogSeeking = false;
			JohnOplayerHasDog = false;
		};
	};
};	
