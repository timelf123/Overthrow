OT_hasTFAR = false;
if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
    OT_hasTFAR = true;

    if(hasInterface) then {
        [] spawn {
            while {true} do {
                call TFAR_fnc_sendVersionInfo;
                "task_force_radio_pipe" callExtension "dummy~";
                sleep 3;
            };
        };
    };
};
