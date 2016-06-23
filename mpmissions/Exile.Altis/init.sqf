// Advance Banking by Shix and WolfkillArcadia
[] execVM "AdvancedBanking\AdvBanking_Client_Init.sqf";

// Virtual Garage by Shix
[] execVM "VirtualGarage\VirtualGarage_Client_Init.sqf";

// Enigma Revive
[] execVM "EnigmaRevive\init.sqf";

// Igiload
[] execVM "IgiLoad\IgiLoadInit.sqf";

// VEMF
if hasInterface then
{
	[] execVM "VEMFr_client\sqf\initClient.sqf"; // Client-side part of VEMFr
};
