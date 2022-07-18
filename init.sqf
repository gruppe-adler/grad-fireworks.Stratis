// check callFireworks.sqf for further instructions!

// FIREWORKS INIT

// needed by server machine only
if (isServer) then
{
	GRAD_fnc_callFireworks = compile preprocessFileLineNumbers "GRAD_fireworks\callFireworks.sqf";
};

// only needed by machines with screen output
if (hasInterface) then
{
	GRAD_fnc_Fireworks = compile preprocessFileLineNumbers "GRAD_fireworks\fireworks.sqf";
};

// EXPLANATION
["<br /><br /><img size= '4' shadow='false' image='pic\gruppe-adler.paa'/><br/><t size='0.6' color='#FFFFFF'>G R A D   F I R E W O R K S</t><br /><br /><t size='0.4' color='#c0c0c0'>Use Radio 1 and 2 to fire random rockets from the boats.<br/>Or use the action on the infostand.</t>",0,0,2,2] spawn BIS_fnc_dynamicText;

// addaction example for remote control infostand - executes GRAD_fnc_callFireworks on server - server then calls GRAD_fnc_Fireworks on all clients
firebase addAction [ "<t color=""#93E352"">Shoot random with random color ", { [ getPos ( selectRandom [boat1,boat2,boat3] ), 'random', 'random'] remoteExec ["GRAD_fnc_callFireworks", 2 ]; }, _Args, 1, false, false, "" ];
