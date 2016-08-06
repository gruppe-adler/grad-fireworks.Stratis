// check callFireworks.sqf for further instructions!

// FIREWORKS INIT
callFireworks = compile preprocessFileLineNumbers "GRAD_fireworks\callFireworks.sqf";
_nul = [] execVM "GRAD_fireworks\fireworks.sqf";

// EXPLANATION
["<br /><br /><img size= '4' shadow='false' image='pic\gruppe-adler.paa'/><br/><t size='0.6' color='#FFFFFF'>G R A D   F I R E W O R K S</t><br /><br /><t size='0.4' color='#c0c0c0'>Use Radio 1 and 2 to fire random rockets from the boats.<br/>Or use the action on the infostand.</t>",0,0,2,2] spawn BIS_fnc_dynamicText;

// START POSITION ARRAY
startpositions = [boat1,boat2,boat3];

// addaction example for remote control infostand
firebase addAction["<t color=""#93E352"">Shoot random with red color ",{[[getPos (startpositions call BIS_fnc_selectRandom), 'normal','red'],"callFireworks",true,true] spawn BIS_fnc_MP; }, _Args, 1, false, false, "","_target distance _this < 1.5"];