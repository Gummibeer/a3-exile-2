// Advance Banking by Shix and WolfkillArcadia
[] execVM "AdvancedBanking\AdvBanking_Client_Init.sqf";

// Virtual Garage by Shix
[] execVM "VirtualGarage\VirtualGarage_Client_Init.sqf";

// Enigma Revive
[] execVM "EnigmaRevive\init.sqf";

// Igiload
[] execVM "IgiLoad\IgiLoadInit.sqf";

// VEMF
if (hasInterface) then {
	[] execVM "VEMFr_client\sqf\initClient.sqf";
};

// Hunting
JohnO_fnc_spawnAnimals = compileFinal preprocessFileLineNumbers "Hunting\JohnO_fnc_spawnAnimals.sqf";
JohnO_fnc_isSick = compileFinal preprocessFileLineNumbers "Hunting\JohnO_fnc_isSick.sqf";
if (isServer) then {
	[] execVM "Hunting\Config_animals.sqf";
};

// Taiming
BURK_dogSeek = compileFinal preprocessFileLineNumbers "Taiming\JohnO_fnc_seeking.sqf";
BURK_dogFollowPlayer = compileFinal preprocessFileLineNumbers "Taiming\JohnO_fnc_following.sqf";
BURK_dogMoveToPos = compileFinal preprocessFileLineNumbers "Taiming\JohnO_fnc_moveToPos.sqf";