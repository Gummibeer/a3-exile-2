uiSleep 30;

maxAnimals = 100;
debug = false; //Dodgy but gives you an indication its working

//Dont change
animalCount = 0;
aliveArray = 0;

uiSleep 30;

[] execVM "Hunting\JohnO_fnc_spawnAnimals.sqf";

[360, JohnO_fnc_spawnAnimals, [], true] call ExileServer_system_thread_addtask;

diag_log "ANIMAL Spawn system initiated";
