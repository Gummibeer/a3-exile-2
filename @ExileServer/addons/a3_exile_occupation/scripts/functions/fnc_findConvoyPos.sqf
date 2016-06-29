private _position       = [0,0,0];
private _nearestRoad    = [0,0,0];

private _middle     = worldSize/2;
private _pos 		= _this select 0;
private _maxDist 	= _middle - 100;
private _minDist    = 15;

if (worldName == 'Esseker') then 
{ 
	_pos = [6502,6217,0];
	_maxDist = 6000;
};

_validspot	= false;

while{!_validspot} do 
{
	sleep 0.2;
    _tempPosition = [_pos,_minDist,_maxDist,15,0,20,0] call BIS_fnc_findSafePos;
    _position = [_tempPosition select 0, _tempPosition select 1, 0];
    _validspot = true;

    // Get position of nearest roads
    _nearRoads = _position nearRoads 500;
    if (isNil "_nearRoads" OR count _nearRoads == 0) then
    {
        _validspot = false;
        diag_log format["BIS_fnc_findSafePos no roads found near position  %1",_position];
    }
    else
    {
        _nearestRoad = _nearRoads select 0;
        _position = position _nearestRoad;
        diag_log format["BIS_fnc_findSafePos checking road found at %1",_position];
    };
    
    if(_validspot) then
    {
        _validspot = [ _position ] call SC_fnc_isSafePos;     
    };
    if (isNil "_validspot") then
    {
        _validspot = false;
    };
};

_position	
