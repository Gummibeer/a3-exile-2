/**
 * ExileServer_system_group_getOrCreateLoneWolfGroup
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
if (isNull ExileServerLoneWolfGroup) then 
{
	ExileServerLoneWolfGroup = createGroup independent;
	ExileServerLoneWolfGroup setGroupIdGlobal [""]; 
	(format ["Created a new lone wolf group: %1", netId ExileServerLoneWolfGroup]) call ExileServer_util_log;
};
ExileServerLoneWolfGroup
