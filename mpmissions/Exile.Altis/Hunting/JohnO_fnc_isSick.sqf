private ["_sickDuration"];

_sickDuration = round random 180 + (floor 120);
_notSick = false;

waitUntil 
{
  // code...
	player enableStamina true;
	player allowSprint false;
	enableCamShake true;
	addCamShake [10, 10, 15];
	[120] call BIS_fnc_bloodEffect;
	player setDamage damage player + 0.01;

	titleText ["You are sick if you sit down you will recover faster","PLAIN"];

	if (animationState player in ["amovpsitmstpsnonwpstdnon_ground","amovpsitmstpslowwrfldnon","amovpsitmstpsnonwnondnon_ground"]) then
	{	
		_sickDuration = _sickDuration - 15;
		//hint str _sickDuration;
	}
	else
	{
		_sickDuration = _sickDuration - 5;
		//hint str _sickDuration;
	};
	sleep 15;
	if (_sickDuration <= 0) then
	{
		_notSick = true;
		player enableStamina false;
		player allowSprint true;
		_sickDuration = 0;
		//hint str _sickDuration;
	};
	if (!alive player) then
	{
		_notSick = true;
	};	
  	_notSick
};