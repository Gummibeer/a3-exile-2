BURK_dog setVariable ["BIS_fnc_animalBehaviour_disable", false];

BURK_dogFollowing = false;
BURK_dogSeeking = true;
BURK_dog_movingToPos = false;

private ["_safeZoneLocations","_safeZone"];

_safeZoneLocations = [[4915.28,8154.27,0],[0,0,0]]; //Namalsk SafeZone

if (BURK_dogSeeking) then
{	

	while {BURK_dogSeeking} do 
	{
		_safeZone = false;
		{
			if (player distance _x < 200) then
			{
				_safeZone = true;
			};
		} forEach _safeZoneLocations;

		if (dogDebug) then
		{
			hint "Dog is seeking animals";
		};	

		_dogPos = getPos BURK_dog;

		_target = _dogPos nearEntities ["Man",150];

		_distanceArray = [];
		{		

		if ((_x isKindOf "animal") && !(_x == BURK_dog)) then
			{	
				_tar = player distance _x;
				_distanceArray = _distanceArray + [[_tar,_x]];
			};
				
		} forEach _target;
			
		if ((alive BURK_dog) && !(_distanceArray isEqualTo [])) then 
		{
			_distanceArray sort true;

			_actualTarget = (_distanceArray select 0) select 1;
			_targetPos = getPos _actualTarget;
			_distanceToTarget = BURK_dog distance _actualTarget;

			if ((random 1 > 0.5) && (_distanceToTarget > 2)) then
			{	
				[BURK_dog,_actualTarget] say3d "dog_one";
			};

			BURK_dog moveTo _targetPos;

			if (dogDebug) then
			{
				hint format ["Dog has found an animal at:%1 and it is a:%2",_targetPos,_actualTarget];
			};	

			if (_distanceToTarget < 2) then
			{
				BURK_dog playMove "Dog_Sit";
				if (random 1 > 0.5) then
				{
					BURK_dog say3d "dog_whine";
				};	
			}
			else
			{
				BURK_dog moveTo _targetPos;
			};	

		}
		else
		{
			_playerpos = position player;
			_randomPos = [(_playerpos select 0) + random (150) - random (150), (_playerpos select 1) + random (150) - random (150)];
			BURK_dog moveTo _randomPos;

			if (dogDebug) then
			{
				hint "Dog has found no animals and is moving around randomly searching";
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
		if (_safeZone) exitWith
		{
			BURK_dog playMove "Dog_Sit";
			BURK_dogSeeking = false;

			if (dogDebug) then
			{
				hint "Dog should be sitting due to safe zone";
			};	
		};
	};
};		