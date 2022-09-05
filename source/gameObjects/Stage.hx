package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	private var time:String = '';

	var upperBoppers:FNFSprite;
	var gang:FNFSprite;
	var santa:FNFSprite;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'old-spirit-tree':
					curStage = 'old-forest';
					time = '';
				case 'old-rtl':
					curStage = 'old-forest';
					time = '-dark';
				case 'old-decay':
					curStage = 'old-shrek';
					time = '';
				case 'tutorial' | 'test':
					curStage = 'stage';
					time = '';
				default:
					curStage = 'void';
					time = '';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'old-forest':
				PlayState.defaultCamZoom = 0.6;
				curStage = 'old-forest';

				var skybox:FNFSprite = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/old-nibel/bg' + time));
				skybox.antialiasing = true;
				skybox.setGraphicSize(Std.int(skybox.width * 3));
				skybox.scrollFactor.set(0.01, 0.01);

				var clouds:FNFSprite = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/old-nibel/clouds' + time));
				clouds.antialiasing = true;
				clouds.setGraphicSize(Std.int(clouds.width * 2));
				clouds.scrollFactor.set(0.05, 0.05); // should I lower this?

				var wtfisthatlmao:FNFSprite = new FNFSprite(-100, -300).loadGraphic(Paths.image('backgrounds/old-nibel/thingyintheback' + time));
				wtfisthatlmao.antialiasing = true;
				wtfisthatlmao.setGraphicSize(Std.int(wtfisthatlmao.width * 2));
				wtfisthatlmao.scrollFactor.set(0.07, 0.07);

				var mountains:FNFSprite = new FNFSprite(-100, -300).loadGraphic(Paths.image('backgrounds/old-nibel/twomountains' + time));
				mountains.antialiasing = true;
				mountains.setGraphicSize(Std.int(mountains.width * 2));
				mountains.scrollFactor.set(0.07, 0.07);

				var spirittree:FNFSprite = new FNFSprite(100, -150).loadGraphic(Paths.image('backgrounds/old-nibel/tree' + time));
				spirittree.antialiasing = true;
				spirittree.setGraphicSize(Std.int(spirittree.width * 2));
				spirittree.scrollFactor.set(0.3, 0.3);

				var backgroundtrees:FNFSprite = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/old-nibel/twobushes' + time));
				backgroundtrees.antialiasing = true;
				backgroundtrees.setGraphicSize(Std.int(backgroundtrees.width * 2));
				backgroundtrees.scrollFactor.set(0.7, 0.7);

				var grass:FNFSprite = new FNFSprite(0, 100).loadGraphic(Paths.image('backgrounds/old-nibel/gss' + time));
				grass.antialiasing = true;
				grass.setGraphicSize(Std.int(grass.width * 2));
				grass.scrollFactor.set(1, 1);

				gang = new FNFSprite(200, 400);
				gang.frames = Paths.getSparrowAtlas('backgrounds/old-nibel/thegang');
				gang.animation.addByPrefix('bop', 'thegang idle0', 24, false);
				gang.antialiasing = true;
				gang.scrollFactor.set(0.9, 0.9);
				gang.setGraphicSize(Std.int(gang.width * 1));
				gang.updateHitbox();

				var treeeees:FNFSprite = new FNFSprite(100, 300).loadGraphic(Paths.image('backgrounds/old-nibel/trees' + time));
				treeeees.antialiasing = true;
				treeeees.setGraphicSize(Std.int(treeeees.width * 2));
				treeeees.scrollFactor.set(1.2, 1.2);

				// I know it would be better to put them in each line of code but this is easier where to add shit. Also I use lua lmao.
				add(skybox);
				if (!Init.trueSettings.get('Low Quality')) {
				add(clouds);
				add(wtfisthatlmao);
				add(mountains);
				add(spirittree);
				add(backgroundtrees);
				}
				add(grass);
				if (!Init.trueSettings.get('Low Quality')) {
				add(gang);
				add(treeeees);
				}

			case 'old-shrek':
				PlayState.defaultCamZoom = 0.45;
				curStage = 'old-shrek';

				var skybox:FNFSprite = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/old-niwen/withered sky'));
				skybox.antialiasing = true;
				skybox.setGraphicSize(Std.int(skybox.width * 5));
				skybox.scrollFactor.set(0.01, 0.01);

				var trees:FNFSprite = new FNFSprite(100, -1300).loadGraphic(Paths.image('backgrounds/old-niwen/backgroundtreeslol'));
				trees.antialiasing = true;
				trees.setGraphicSize(Std.int(trees.width * 4.5));
				trees.scrollFactor.set(0.7, 0.7);

				var fuckyouforest:FNFSprite = new FNFSprite(100, -1500).loadGraphic(Paths.image('backgrounds/old-niwen/dieforest'));
				fuckyouforest.antialiasing = true;
				fuckyouforest.setGraphicSize(Std.int(fuckyouforest.width * 4.5));
				fuckyouforest.scrollFactor.set(0.9, 0.9);

				var ground:FNFSprite = new FNFSprite(100, -1500).loadGraphic(Paths.image('backgrounds/old-niwen/gound'));
				ground.antialiasing = true;
				ground.setGraphicSize(Std.int(ground.width * 4.5));
				ground.scrollFactor.set(1, 1);

				var cliff:FNFSprite = new FNFSprite(-200, -1100).loadGraphic(Paths.image('backgrounds/old-niwen/cliff shit'));
				cliff.antialiasing = true;
				cliff.setGraphicSize(Std.int(cliff.width * 4.5));
				cliff.scrollFactor.set(1, 1);

				var sauce:FNFSprite = new FNFSprite(100, -1500).loadGraphic(Paths.image('backgrounds/old-niwen/extradip'));
				sauce.antialiasing = true;
				sauce.setGraphicSize(Std.int(sauce.width * 6));
				sauce.scrollFactor.set(1.1, 1.1);

				add(skybox);
				if (!Init.trueSettings.get('Low Quality')) {
				add(trees);
				add(fuckyouforest);
				}
				add(ground);
				add(cliff);
				if (!Init.trueSettings.get('Low Quality'))
				add(sauce);
			case 'stage':
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
			default:
				PlayState.defaultCamZoom = 0.6;
				curStage = 'void';
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'highway':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray) {
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
				/*
					if (isStoryMode)
					{
						camPos.x += 600;
						tweenCamIn();
				}*/
				/*
				case 'spirit':
					var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
					evilTrail.changeValuesEnabled(false, false, false, false);
					add(evilTrail);
					*/
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'old-forest':
				boyfriend.x = 1110;
				boyfriend.y = 720;

				gf.x = 510;
				gf.y = 420;

				dad.x = 250;
				dad.y = 550;
			case 'old-shrek': // please laugh
				boyfriend.x = 1410;
				boyfriend.y = -500;

				gf.x = 1810;
				gf.y = -700;

				dad.x = -700;
				dad.y = -1200;
			case 'highway':
				boyfriend.y -= 220;
				boyfriend.x += 260;

			case 'mall':
				boyfriend.x += 200;
				dad.x -= 400;
				dad.y += 20;

			case 'mallEvil':
				boyfriend.x += 320;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				dad.x += 200;
				dad.y += 580;
				gf.x += 200;
				gf.y += 320;
			case 'schoolEvil':
				dad.x -= 150;
				dad.y += 50;
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'void':
				dad.x -= 200;
				gf.visible = false;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'old-forest':
				gang.animation.play('bop', true);

			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
