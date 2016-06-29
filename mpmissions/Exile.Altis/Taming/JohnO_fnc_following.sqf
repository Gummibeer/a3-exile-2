BURK_dog setVariable ["BIS_fnc_animalBehaviour_disable", false];

BURK_dogFollowing = true;
BURK_dogSeeking = false;
BURK_dog_movingToPos = false;

private ["_safeZoneLocations","_safeZone"];

_safeZoneLocations = [[4915.28,8154.27,0],[0,0,0]]; //Namalsk SafeZone

BURK_dog playMove "Dog_Run";

if (BURK_dogFollowing) then
{	

	while {BURK_dogFollowing} do 
	{
		_safeZone = false;
		{
			if (player distance _x < 200) then
			{
				_safeZone = true;
			};
		} forEach _safeZoneLocations;		
		
		if !(_safeZone) then
		{	
			if (dogDebug) then
			{
				hint format ["Dog should be following player, Aggressive:%1",Agressive];
			};
			if ((alive BURK_dog) && !(Agressive)) then 
			{
				BURK_dog moveTo getPos player;				
			};
			if ((alive BURK_dog) && (Agressive)) then 
			{
				// Scan
				_dogPos = getPos BURK_dog;

				_target = _dogPos nearEntities ["Man",50];
			
				_distanceArray = [];
				{
					if ((_x in units group player) || (_x == player) || (_x isKindOf "animal") || (isPlayer _x)) then
					{
						
					}
					else
					{	
						_tar = player distance _x;
						_distanceArray = _distanceArray + [[_tar,_x]];
					};	
				} forEach _target;

				if (dogDebug) then
				{
					hint format ["Dog is aggressive and has the following targets: %1",_distanceArray];
				};	

				if ((alive BURK_dog) && !(_distanceArray isEqualTo []) && (Agressive)) then 
				{
					_distanceArray sort true;
					_actualTarget = (_distanceArray select 0) select 1;
					_targetPos = getPos _actualTarget;

					_damage = damage _actualTarget;
					//hint str _distanceArray;
					if (random 1 > 0.5) then
					{	
						[BURK_dog,_actualTarget] say3d "dog_one";
					};	

					BURK_dog moveTo _targetPos;

					if (dogDebug) then
					{
						hint format ["Dog is aggressive and is moving to attack the following target:%1 at:%2",_actualTarget,_targetPos];
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

						if (dogDebug) then
						{
							hint "Grrr - Dog is eating some face";
						};	
					};		
				}
				else	
				{
						
					BURK_dog moveTo getPos player;

					if (dogDebug) then
					{
						hint format ["Dog should be following player, Aggressive:%1",Agressive];
					};
				
				};	
			};
		};	
		uiSleep 1;
		if (!(alive BURK_dog) || !(alive player)) exitWith 
		{
			player removeAction Dogfollow;
			player removeAction dogseek;
			player removeAction Dogpassive;
			player removeAction Dogstay;
			player removeAction Dogrun;
			player removeAction Dogsprint;
			player removeAction agressiveAction;
			player removeAction passiveAction;
			player removeAction dogMove;
			BURK_dogFollowing = false;
			JohnOplayerHasDog = false;
		};
		if (_safeZone) exitWith
		{
			BURK_dog playMove "Dog_Sit";
			BURK_dogFollowing = false;
			if (dogDebug) then
			{
				hint "Dog should be sitting due to safe zone";
			};
		};
	};
};	