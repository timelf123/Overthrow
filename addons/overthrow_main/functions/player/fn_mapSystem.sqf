private ["_eh","_handler"];

if(isMultiplayer) then {
	onEachFrame {
		{
			if !(_x isEqualTo player) then {
				private _dis = round(_x distance player);
				private _t = "m";
				if(_dis > 999) then {
					_dis = round(_dis / 1000);
					_t = "km";
				};
				drawIcon3D ["a3\ui_f\data\map\groupicons\selector_selectable_ca.paa", [1,1,1,0.3], getPosATLVisual _x, 1, 1, 0, format["%1 (%2%3)",name _x,_dis,_t], 0, 0.02, "TahomaB", "center", true];
			};
		}foreach([] call CBA_fnc_players);
	};
};

_handler = {
	private ["_vehs","_dest","_destpos","_passengers"];
	if !(visibleMap or visibleGPS) exitWith {};
	_vehs = [];
	if(isMultiplayer) then {
		{
			_veh = vehicle _x;
			if(_veh == _x) then {
				_color = [0,0.5,0,1];
				if!(captive _x) then {
					_color = [0,0.2,0,1];
				};
				(_this select 0) drawIcon [
					"iconMan",
					_color,
					getpos _x,
					24,
					24,
					getdir _x,
					name _x
				];
			}else{
				if !(_veh in _vehs) then {
					_vehs pushback _veh;
				};
			};
		}foreach([] call CBA_fnc_players);
	};
	_t = 1;
	{
		if (!(isPlayer _x)) then {
			_veh = vehicle _x;
			if(_veh == _x) then {
				_dest = expectedDestination _x;
				_destpos = _dest select 0;
				_color = [0,0.5,0,1];
				if !(captive _x) then {
					_color = [0,0.2,0,1];
				};
				if(_x in groupSelectedUnits player) then {
					(_this select 0) drawIcon [
						"\A3\ui_f\data\igui\cfg\islandmap\iconplayer_ca.paa",
						_color,
						visiblePosition  _x,
						24,
						24,
						0
					];
				};
				if ((_dest select 1)== "LEADER PLANNED") then {
					(_this select 0) drawLine [
						getPos _x,
						_destpos,
						_color
					];
					(_this select 0) drawIcon [
						"\A3\ui_f\data\map\groupicons\waypoint.paa",
						_color,
						_destpos,
						24,
						24,
						0
					];
				};


				(_this select 0) drawIcon [
					"iconMan",
					_color,
					visiblePosition  _x,
					24,
					24,
					getDir _x,
					format["%1",_t]
				];
			}else{
				if !(_veh in _vehs) then {
					_vehs pushback _veh;
				};
			};
		};
		_t = _t + 1;
	}foreach(units (group player));

	{
		(_this select 0) drawIcon [
			"\A3\ui_f\data\map\markers\nato\b_mortar.paa",
			[0,0.3,0.59,(2000 - (_x select 1)) / 2000],
			_x select 2,
			24,
			24,
			0,
			""
		];
	}foreach(spawner getVariable ["NATOmortars",[]]);

	{
		_passengers = "";
		_color = [0,0.5,0,1];
		{
			if(isPlayer _x and _x != player) then {
				_passengers = format["%1 %2",_passengers,name _x];
			};
			if !(captive _x) then {_color = [0,0.2,0,1];};
		}foreach(crew _x);

		(_this select 0) drawIcon [
			getText(configFile >> "CfgVehicles" >> (typeof _x) >> "icon"),
			_color,
			visiblePosition  _x,
			24,
			24,
			getdir _x,
			_passengers
		];
	}foreach(_vehs);

	{
		if(side _x == west) then {
			_u = leader _x;
			_alive = false;
			if(!alive _u) then {
				{
					if(alive _x) exitWith {_u = _x;_alive=true};
				}foreach(units _x);
			}else{
				_alive = true;
			};
			if(_alive) then {
				_ka = resistance knowsabout _u;
				if(_ka > 1.4) then {
					_opacity = (_ka-1.4) / 1;
					if(_opacity > 1) then {_opacity = 1};
					_pos = visiblePosition  _u;
					(_this select 0) drawIcon [
						"\A3\ui_f\data\map\markers\nato\b_inf.paa",
						[0,0.3,0.59,_opacity],
						_pos,
						30,
						30,
						0
					];
				};
			}
		};

		if(side _x == east) then {
			_u = leader _x;
			_alive = false;
			if(!alive _u) then {
				{
					if(alive _x) exitWith {_u = _x;_alive=true};
				}foreach(units _x);
			}else{
				_alive = true;
			};
			if(_alive) then {
				_ka = resistance knowsabout _u;
				if(_ka > 1.4) then {
					_opacity = (_ka-1.4) / 1;
					if(_opacity > 1) then {_opacity = 1};
					_pos = visiblePosition  _u;
					(_this select 0) drawIcon [
						"\A3\ui_f\data\map\markers\nato\b_inf.paa",
						[0.5,0,0,_opacity],
						_pos,
						30,
						30,
						0
					];
				};
			}
		};

	}foreach(allGroups);

	{
		if(side _x == resistance) then {

		};
	}foreach(vehicles);

	_scale = ctrlMapScale (_this select 0);
	if(_scale <= 0.16) then {
		{
		    _x params ["_cls","_name","_side","_flag"];
		    if(_side != 1) then {
		        _pos = server getVariable [format["factionrep%1",_cls],[0,0,0]];
				(_this select 0) drawIcon [
					_flag,
					[1,1,1,1],
					_pos,
					0.6/ctrlMapScale (_this select 0),
					0.5/ctrlMapScale (_this select 0),
					0
				];
		    };
		}foreach(OT_allFactions);

		{
			(_this select 0) drawIcon [
				"ot\ui\markers\shop.paa",
				[1,1,1,1],
				_x select 0,
				0.4/ctrlMapScale (_this select 0),
				0.4/ctrlMapScale (_this select 0),
				0
			];
		}foreach(OT_allActiveShops);
		{
			_pos = server getVariable [format["gundealer%1",_x],[]];
			if(count _pos > 0) then {
				(_this select 0) drawIcon [
					OT_flagImage,
					[1,1,1,1],
					_pos,
					0.6/ctrlMapScale (_this select 0),
					0.5/ctrlMapScale (_this select 0),
					0
				];
			}
		}foreach(OT_allTowns);
		{
			if ((typeof _x != "B_UAV_AI") and !(_x getVariable ["looted",false])) then {
				(_this select 0) drawIcon [
					"ot\ui\markers\death.paa",
					[1,1,1,0.5],
					getpos _x,
					0.2/ctrlMapScale (_this select 0),
					0.2/ctrlMapScale (_this select 0),
					0
				];
			};
		}foreach(alldeadmen);
		{
			if(((typeof _x == OT_item_CargoContainer) or (_x isKindOf "Ship") or (_x isKindOf "Air") or (_x isKindOf "Car")) and (count crew _x == 0) and (_x call OT_fnc_hasOwner)) then {
				(_this select 0) drawIcon [
					getText(configFile >> "CfgVehicles" >> (typeof _x) >> "icon"),
					[1,1,1,1],
					getpos _x,
					0.4/ctrlMapScale (_this select 0),
					0.4/ctrlMapScale (_this select 0),
					getdir _x
				];
			};
			if((_x isKindOf "StaticWeapon") and (isNull attachedTo _x) and (alive _x)) then {
				if(side _x == civilian or side _x == resistance or captive _x) then {
					_col = [0.5,0.5,0.5,1];
					if(!(isNull gunner _x) and (alive gunner _x)) then {_col = [0,0.5,0,1]};
					_i = "\A3\ui_f\data\map\markers\nato\o_art.paa";
					if(_x isKindOf "StaticMortar") then {_i = "\A3\ui_f\data\map\markers\nato\o_mortar.paa"};
					if !(someAmmo _x) then {_col set [3,0.4]};
					(_this select 0) drawIcon [
						_i,
						_col,
						position _x,
						30,
						30,
						0
					];
				};
			};
		}foreach(vehicles);
	};
	private _qrf = server getVariable "QRFpos";
	if(!isNil "_qrf") then {
		private _progress = server getVariable ["QRFprogress",0];
		_col = [];
		if(_progress > 0) then {_col = [0,0,1,_progress]};
		if(_progress < 0) then {_col = [0,1,0,abs _progress]};
		if(_progress != 0) then {
			(_this select 0) drawEllipse [
				_qrf,
				100,
				100,
				0,
				_col,
				"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa"
			];
		};
	};

	if((vehicle player) isKindOf "Air") then {
		_abandoned = server getVariable ["NATOabandoned",[]];
		{
			if !(_x in _abandoned) then {
				(_this select 0) drawEllipse [
					server getvariable _x,
					2000,
					2000,
					0,
					[1, 0, 0, 1],
					"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa"
				];
			};
		}foreach(OT_allAirports);
		private _attack = server getVariable ["NATOattacking",""];
		if(_attack != "") then {
			(_this select 0) drawEllipse [
				server getvariable _attack,
				2000,
				2000,
				0,
				[1, 0, 0, 1],
				"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa"
			];
		};
	};
	mapCenter
};

if(!isNil "OT_OnDraw") then {
	((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw",OT_OnDraw];
};

OT_OnDraw = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", _handler];

//GPS
[_handler] spawn {
	private ['_gps',"_handler"];
	_handler = _this select 0;
	disableSerialization;
	private _gps = controlNull;
	for '_x' from 0 to 1 step 0 do {
		{
			if !(isNil {_x displayCtrl 101}) exitWith {
				_gps = _x displayCtrl 101;
			};
		} foreach(uiNamespace getVariable "IGUI_Displays");
		uiSleep 1;
		if (!isNull _gps) exitWith {
			if(!isNil "OT_GPSOnDraw") then {
				_gps ctrlRemoveEventHandler ['Draw',OT_GPSOnDraw];
			};
			OT_GPSOnDraw = _gps ctrlAddEventHandler ['Draw',_handler];
		};
		uiSleep 0.25;
	};
};
