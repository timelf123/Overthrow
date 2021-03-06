
private _doSalvage = {
    private _wreck = cursorObject;
    private _steel = 3;
    private _plastic = 0;
    private _cost = cost getVariable [typeof _wreck,[100,0,0,0]];
    if((_cost select 2) > 10) then {
        _steel = 4;
    };
    if((_cost select 2) > 20) then {
        _steel = 5;
    };
    if((_cost select 2) > 40) then {
        _steel = 6;
    };
    if((_cost select 3) > 0 and (random 100) > 90) then {
        _plastic = 1;
    };

    private _veh = _this;

    if(!(_veh isKindOf "Truck_F" or _veh isKindOf "ReammoBox_F") and !(_veh canAdd "OT_Steel")) exitWith {
        "Vehicle is full, use a truck or ammobox for more storage" call OT_fnc_notifyMinor;
    };

	private _toname = (typeof _veh) call OT_fnc_vehicleGetName;
	format["Salvaging wreck into %1",_toname] call OT_fnc_notifyMinor;
    player playMove "AinvPknlMstpSnonWnonDnon_medic_1";
	[14,false] call OT_fnc_progressBar;
	sleep 7;
    player playMove "AinvPknlMstpSnonWnonDnon_medic_1";
    sleep 7;
    _veh addItemCargoGlobal ["OT_Steel", _steel];
    if(_plastic > 0) then {
        _veh addItemCargoGlobal ["OT_Plastic", _plastic];
        format["Salvaged: %1 x Steel, %1 x Plastic",_steel,_plastic] call OT_fnc_notifyMinor;
    }else{
        format["Salvaged: %1 x Steel",_steel] call OT_fnc_notifyMinor;
    };
    deleteVehicle _wreck;
};

private _objects = player nearEntities [["Car","ReammoBox_F","Air","Ship"],20];

if(count _objects == 1) then {
	(_objects select 0) call _doSalvage;
}else{
    if(count _objects > 1) then {
    	private _options = [];
    	{
    		_options pushback [format["%1 (%2m)",(typeof _x) call OT_fnc_vehicleGetName,round (_x distance player)],_doSalvage,_x];
    	}foreach(_objects);
    	"Salvage to which container?" call OT_fnc_notifyBig;
    	_options spawn OT_fnc_playerDecision;
    }else{
        "No nearby containers or vehicles to put salvaged items" call OT_fnc_notifyMinor;
    };
};
