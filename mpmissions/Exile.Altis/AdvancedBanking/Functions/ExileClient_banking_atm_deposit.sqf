/*

 	Name: ExileClient_banking_atm_deposit.sqf

 	Author(s): Shix and WolfkillArcadia
    Copyright (c) 2016 Shix and WolfkillArcadia

    This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
    To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

 	Description:
    Handles depositing of money

*/

disableSerialization;
_display = uiNameSpace getVariable ["AdvBankingATM", displayNull];
_editBox = (_display displayCtrl 9008);
_amount = parseNumber(ctrlText _editBox);

try {
    if (_amount == 0) then {
        throw "Requested amount equals 0";
    };
    if (_amount > ExileClientPlayerMoney) then {
        throw "You cannot deposit more than what you have in your wallet";
    };
    _fee = 500 + (_amount / 10);
    if (_moneyRequest < _fee) then {
        throw "You can't deposit less than the fee is (500 + 10%)";
    };
    if (ADVBANKING_CLIENT_DEBUG) then {[format["Deposit request sent to sever. Package: %1",_amount],"ATMDeposit"] call ExileClient_banking_utils_diagLog;};
    ["depositRequest",[str(_amount)]] call ExileClient_system_network_send;
} catch {
    [1,"Error",_exception] call ExileClient_banking_network_handleATMMessage;
    [_exception,"DepositMoney"] call ExileClient_banking_utils_diagLog;
};
