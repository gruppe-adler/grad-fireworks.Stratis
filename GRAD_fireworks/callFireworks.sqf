/*

FIREWORKS SCRIPT by nomisum for Gruppe Adler
http://www.gruppe-adler.de

Call Script on Server only!

Example with Marker:
if (isServer) then {
	[[getMarkerPos "markername", 'normal','white'] ,"callFireworks",true,true] spawn BIS_fnc_MP;
};

Example with Object:
if (isServer) then {
	[[getPos objectname, 'random','red'] ,"callFireworks",true,true] spawn BIS_fnc_MP;
};



Input Array constists of:

POSITION (x,y,(z) - always zero above ground)

TYPE OF ROCKET - random, fizzer, normal, rain

COLOR OF ROCKET - random, green, red, blue, white

CREDITS go to j1987, MrAuralization, soundscalpel.com and Quistard of freesound.org

*/

#define GRAD_GREEN			0
#define GRAD_RED			1
#define GRAD_BLUE			2
#define GRAD_WHITE			3

#define GRAD_FIZZER			0
#define GRAD_NORMAL			1
#define GRAD_RAIN			2

if (not isServer) exitWith {};

params
[
	"_firing_position", // [x,y,z]
	"_type",
	"_color" // random, green, red, blue, white
];

private "_dummy";
private _explosion_power = random [ 30, 50, 70 ]; // 30-70 seems reasonable
private _glitter_count = round random [20, 30, 40 ]; // 30 is poor, 50 is ok, 100 might be overkill
private _initial_velocity = [ -5 + random 10, -5 + random 10, random [ 270, 300, 330 ] ]; // firing not perfect but in a slight angle

private _colorArray =
[
	[ random [ 0.378,  0.42, 0.462], random [ 0.729,  0.81, 0.891 ], random [ 0.09,  0.1, 0.11 ] ], //green
	[ random [ 0.72,  0.8, 0.88], random [ 0.09,  0.1, 0.11 ], random [ 0.315,  0.35, 0.385 ] ], // red
	[ random [ 0.18,  0.2, 0.22 ], random [ 0.657,  0.73, 0.803 ], random [ 0.765,  0.85, 0.935 ]], // blue
	[ random [ 0.9,  0.99, 1 ], random [ 0.9,  0.99, 1 ], random [ 0.9,  0.99, 1 ] ] // white
];


private _explosion_fragments_array = [];
private _explosion_subfragments_array = [];


private _randomLaunch = (random 4.5) - 2.3;

private _randomSleep = (random 0.5) - 0.25;
private _randomSleepLong = (random 8) - 4;
private _randomSleepShort = (random 0.1) - 0.05;

private _color = [] call
{
	if (_color isEqualTo "random") exitWith { selectRandom _colorArray };
	if (_color isEqualTo "green") exitWith { _colorArray # GRAD_GREEN };
	if (_color isEqualTo "red") exitWith {  _colorArray # GRAD_RED };
	if (_color isEqualTo "blue") exitWith { _colorArray # GRAD_BLUE };

	//white is default
	_colorArray # GRAD_WHITE
};

//launch sounds
private _launchSound = selectRandom
[
	"launch1",
	"launch2",
	"launch3",
	"launch4",
	"launch5",
	"launch6",
	"launch7"
];

//whistling
private _whistlingSound = selectRandom
[
	"whistling1",
	"whistling2",
	"whistling3",
	"whistling4"
];

//bangs
private _bangSound = selectRandom
[
	"bang01",
	"bang02",
	"bang03",
	"bang04",
	"bang05",
	"bang06",
	"bang07",
	"bang08",
	"bang10",
	"bang11"
];

//fizzes
private _singleFizz =
[
	"fizz_single_type1_1",
	"fizz_single_type1_2",
	"fizz_single_type1_3",
	"fizz_single_type1_4",
	"fizz_single_type2_1",
	"fizz_single_type2_2",
	"fizz_single_type2_3",
	"fizz_single_type2_4"
];

//group fizzes
private _groupFizz =
[
	"fizz_group1",
	"fizz_group2",
	"fizz_group3",
	"fizz_group4"
];

private _types =
[
	"fizzer",
	"normal",
	"rain"
];

_type = if not ( _type in _types ) then { selectRandom _types } else { _type };


if ( _type isEqualTo _types # GRAD_NORMAL ) then
{
	_glitter_count = _glitter_count * 2;
	_explosion_power = _explosion_power / 2;
};

// prepare random explosion values for fragments

for "_i" from 1 to _glitter_count do
{
	_dummy = _explosion_fragments_array pushBack
	[ ( -_explosion_power + 2 * random _explosion_power ) / 2, ( -_explosion_power + 2 * random _explosion_power ) / 2, ( -_explosion_power + 2 * random _explosion_power ) / 2 ];

	if (_i < _glitter_count/3) then
	{
		_dummy = _explosion_subfragments_array pushBack
		[ ( -_explosion_power + random _explosion_power ) / 16, ( -_explosion_power + random _explosion_power ) / 16, ( -_explosion_power + random _explosion_power ) / 16] ;
	};
};


if (_type isEqualTo _types # GRAD_RAIN) then
{
	_color = [1,0.9,0.6];

	for "_i" from 1 to _glitter_count do
	{
		_dummy = _explosion_fragments_array pushBack
		[ ( -_explosion_power + 2 * random _explosion_power ) / 2, ( -_explosion_power + 2 * random _explosion_power ) / 2, random _explosion_power ];

		if (_i < _glitter_count/3) then
		{
			_dummy = _explosion_subfragments_array pushBack
			[ ( -_explosion_power + (random _explosion_power) ) / 16, ( -_explosion_power + (random _explosion_power) ) / 16, (random _explosion_power) / 16 ];
		};
	};
};

// send all precalculated stuff to clients

	[
	_firing_position,
	_type,
	_initial_velocity,
	_explosion_power,
	_glitter_count,
	_color,
	_explosion_fragments_array,
	_explosion_subfragments_array,
	_randomSleep,
	_randomSleepLong,
	_randomLaunch,
	_launchSound,
	_whistlingSound,
	_bangSound,
	_singleFizz,
	_groupFizz,
	_randomSleepShort
	] remoteExec ["GRAD_fnc_Fireworks", [0,-2] select isDedicated];
