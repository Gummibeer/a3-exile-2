/*
	Author: IT07

	Description:
	will put mission notification on either all screens or just on given

	Params:
	_this select 0: SCALAR - mission type (AI mode) // 0 = normal soldier AI | 1 = regular police AI | 2 = S.W.A.T. AI
	_this select 1: STRING - notification title
	_this select 2: STRING - notification message
	_this select 3: ARRAY (optional) - specific clients to (ONLY) send notification to

	Returns:
	nothing
*/

params [["_missionType",-1,[-1]], ["_title","",[""]], ["_msgLine","",[""]], ["_sendTo",[],[[]]]];
if (count _sendTo isEqualTo 0) then { _sendTo = allPlayers };
{
/*
	_toastType = "DefaultTitleAndText";
	switch (_missionType) do {
        case 0: {
            _toastType = "BanditTitleAndText";
        };
        case 1: {
            _toastType = "MilitaryTitleAndText";
        };
        case 2: {
            _toastType = "SwatTitleAndText";
        };
    };
	["toastRequest", [_toastType, [_title, _msgLine]]] call ExileServer_system_network_send_broadcast;
	*/


	VEMFrMsgToClient = [[_missionType, _title, _msgLine], ""];
	(owner _x) publicVariableClient "VEMFrMsgToClient";
} forEach _sendTo;
