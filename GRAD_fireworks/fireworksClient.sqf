	params
	[
		"_firing_position", // where rocket starts
		"_type1",
		"_initial_velocity", // rocket initial speed
		"_explosion_power", // how big the explosion radius/force
		"_glitter_count", // how many fragments 
		"_color", // color
		"_explosion_fragments_array",
		"_explosion_subfragments_array",
		"_randomSleep",
		"_randomSleepLong",
		"_randomLaunch",
		"_launchSound",
		"_whistlingSound",
		"_bangSound",
		"_singleFizz",
		"_groupFizz",
		"_randomSleepShort"
	];

	private _chaff ="CMflare_Chaff_Ammo" createVehicleLocal _firing_position; 
	_chaff setVelocity _initial_velocity; 


	private _light1 = "#lightpoint" createVehicleLocal [0,0,0];
	_light1 setLightBrightness 0.1;
	_light1 setLightColor [1,0.3,0];
	_light1 setLightUseFlare true;
	_light1 setLightFlareMaxDistance 1000;
	_light1 setLightFlareSize 5;
	

	private _light2 = "#lightpoint" createVehicleLocal [0,0,0];
	_light2 setLightBrightness 0.08;
	_light2 setLightColor [1,0.8,0];
	_light2 setLightUseFlare true;
	_light2 setLightFlareMaxDistance 1000;
	_light2 setLightFlareSize 4;
	sleep 0.01;

	_light1 lightAttachObject  [ _chaff, [0,0,0] ];
	_light2 lightAttachObject  [ _chaff, [0,0,0] ];

	_chaff say3D [ _launchSound, random [ 450, 500, 550 ] ];

	sleep 1;

	if (_type1 == "fizzer") then {
		_chaff say3D [ _whistlingSound, random [ 1800, 2000, 2200 ] ];
	};

	sleep (2 + _randomSleepShort);

	deleteVehicle _light1;
	deleteVehicle _light2;

	private _nul2 ="FxExploArmor3" createVehicleLocal (getPos _chaff);

	sleep 0.10;
	
	_nul2 say3D [ _bangSound, random [ 2700, 3000, 3300 ] ];

	//solving conditions out of loops
	private _isTypeArray = [ _type1 in [ "normal", "fizzer"], _type1 isEqualTo "normal",  _type1 isEqualTo "fizzer", _type1 isEqualTo "rain"];

	for "_i" from 0 to -1 + count _explosion_fragments_array do 
	{
		[
			_chaff,
			_isTypeArray,
			_explosion_fragments_array,
			_explosion_subfragments_array,
			_color,
			_glitter_count,
			_i,
			_randomSleep,
			_randomSleepLong,
			_singleFizz,
			_groupFizz,
			_bangSound
		] spawn 
		{
			params
			[
				"_rocket",
				"_isTypeArray",
				"_fragments",
				"_subfragments",
				"_color2",
				"_glitter_count2",
				"_selector",
				"_randomSleep2",
				"_randomSleepLong2",
				"_singleFizz1",
				"_groupFizz1",
				"_bangSound1"
			];
				private _nul2 ="CMflare_Chaff_Ammo" createVehicleLocal (getPos _rocket); 
//				_smoke ="SmokeLauncherAmmo" createVehicleLocal (getPos _rocket);	
				
			_nul2 setVelocity (_fragments select _selector);

			private _light2 = "#lightpoint" createVehicleLocal [0,0,0];
			_light2 setLightBrightness 1.0;

			if ( _isTypeArray # 0 ) then { _light2 setLightAmbient [1,0.9,0.6]; } else { _light2 setLightAmbient _color2; };
				
			_light2 setLightColor _color2;
			_light2 lightAttachObject  [_nul2,[0,0,0]];

			_light2 setLightUseFlare true;
			_light2 setLightFlareMaxDistance 1000;
			_light2 setLightFlareSize 3;
				
			_light2 attachTo  [_nul2,[0,0,0]];

			if ( _isTypeArray # 1 ) then 
			{
				sleep (3 + (random 1));
				deleteVehicle _light2;
			};

			sleep 1.0;
			deleteVehicle _light2;
					
			_nul2 say3D [ _bangSound1, random [ 2700, 3000, 3300 ] ];

			private _rocketPos = position _nul2;
			deleteVehicle _nul2;				

			if (_isTypeArray # 2)  then 
			{
				for "_j" from 0 to -1 + count _subfragments do 
				{		
					[
						_rocketPos,
						_isTypeArray,
						_subfragments,
						_color2,
						_j,
						_randomSleep2,
						_randomSleepLong2,
						_singleFizz1,
						_groupFizz1,
						_bangSound1
					] spawn 
					{
						params
						[
							"_rocketPos",
							"_isTypeArray",
							"_subfragments2",
							"_color3",
							"_selector2",
							"_randomSleep3",
							"_randomSleepLong3",
							"_singleFizz2",
							"_groupFizz2",
							"_bangSound2"
						];

						private _posz = _rocketPos select 2;

						_rocketPos = _rocketPos getPos [ random 10, random 360 ];
						_rocketPos set [2, _posz + (random 20) - 10 ];

						private _nul3 ="F_20mm_White" createVehicleLocal _rocketPos;

						_nul3 setVelocity (_subfragments2 select _selector2);

						private _light3 = "#lightpoint" createVehicleLocal [0,0,0];
						_light3 setLightBrightness 2;

						if (_isTypeArray # 0) then { _light3 setLightAmbient [1,0.9,0.6]; } else 
							{ _light3 setLightAmbient _color3; };

						_light3 setLightColor _color3;
						_light3 lightAttachObject  [_nul3,[0,0,0]];

						_light3 setLightUseFlare true;
						_light3 setLightFlareMaxDistance 1000;
						_light3 setLightFlareSize 1;

						sleep (random 1);

						_nul3 say3D [ ( selectRandom _singleFizz2 ), random [ 1800, 2000, 2200 ] ];
							
						sleep (2 - (random 1.5));

						deleteVehicle _light3;
						deleteVehicle _nul3;
					};
				};
			};

			if (_isTypeArray # 3)  then 
			{
				[
					_rocketPos,
					_isTypeArray,_fragments,
					_color2,_selector,
					_randomSleep2,
					_randomSleepLong2,
					_singleFizz1,
					_groupFizz1,
					_bangSound1
				] spawn 
				{
					params
					[
						"_rocketPos",
						"_isTypeArray",
						"_subfragments2",
						"_color3",
						"_selector2",
						"_randomSleep3",
						"_randomSleepLong3",
						"_singleFizz2",
						"_groupFizz2",
						"_bangSound2"
					];

					private _nul3 ="FxWindPollen1" createVehicleLocal _rocketPos;
							
					_nul3 setVelocity (_subfragments2 select _selector2);

					private _light3 = "#lightpoint" createVehicleLocal [0,0,0];
					_light3 setLightBrightness 2;
						
					if ( _isTypeArray # 0 ) then { _light3 setLightAmbient [1,0.9,0.6]; } else 
						{ _light3 setLightAmbient _color3; };

					_light3 setLightColor _color3;
					_light3 lightAttachObject  [_nul3,[0,0,0]];

					_light3 setLightUseFlare true;
					_light3 setLightFlareMaxDistance 1000;
					_light3 setLightFlareSize 1;

					sleep (random 1);

					_nul3 say3D [ ( selectRandom _singleFizz2 ), random [ 1800, 2000, 2200 ] ];

					sleep (2 - (random 1.5));

					deleteVehicle _light3;
					deleteVehicle _nul3;
				};

				sleep 1;
				deleteVehicle _light2;
			};
		};
	};

	sleep 1;

	_nul2 say3D [ (selectRandom _groupFizz ), random [ 1800, 2000, 2200 ] ];
	sleep 2;
	deleteVehicle _nul2;