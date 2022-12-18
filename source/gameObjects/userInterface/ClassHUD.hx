package gameObjects.userInterface;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flash.display.BitmapData;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import meta.CoolUtil;
import meta.InfoHud;
import meta.data.Conductor;
import meta.data.Timings;
import meta.state.PlayState;

using StringTools;

class ClassHUD extends FlxTypedGroup<FlxBasic>
{
	// set up variables and stuff here
	var infoBar:FlxText; // small side bar like kade engine that tells you engine info
	var scoreBar:FlxText;

	var scoreLast:Float = -1;
	var scoreDisplay:String;

	var cornerMark:FlxText; // engine mark at the upper right corner
	var centerMark:FlxText; // song display name and difficulty at the center

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var oriHPBG:FlxSprite;
//	private var oriHPBG:FlxSprite;

	private var hpBGSine:Float = 0;

	var demoshit:FlxText;

	private var demoSine:Float = 0;

	private var SONG = PlayState.SONG;
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	private var stupidHealth:Float = 0;

	private var timingsMap:Map<String, FlxText> = [];

	var infoDisplay:String = CoolUtil.dashToSpace(PlayState.SONG.song);
	var diffDisplay:String = CoolUtil.difficultyFromNumber(PlayState.storyDifficulty);
	var engineDisplay:String = "AXOLOTL ENGINE v" + Main.oriVersion + " (FE v" + Main.gameVersion + ")";

	private var choosenFont:String = 'vcr.ttf';

	// eep
	public function new()
	{
		// call the initializations and stuffs
		super();

		// fnf mods
		var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop';

		// le healthbar setup
		var barY = FlxG.height * 0.875;
		if (Init.trueSettings.get('Downscroll'))
			barY = 64;

		oriHPBG = new FlxSprite(210,0).loadGraphic(Paths.image('UI/default/oristuff/healthbg'));
		if (!Init.trueSettings.get('Downscroll')) oriHPBG.y = 554;
		else oriHPBG.y = 3;	
		oriHPBG.scrollFactor.set();
		oriHPBG.antialiasing = true;
		oriHPBG.alpha = 0.7;
		add(oriHPBG);

		healthBarBG = new FlxSprite(0,
			barY).loadGraphic(Paths.image(ForeverTools.returnSkinAsset('healthBar', PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8));
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(FlxColor.fromRGB(PlayState.dadcolor1, PlayState.dadcolor2, PlayState.dadcolor3), FlxColor.fromRGB(PlayState.bfcolor1, PlayState.bfcolor2, PlayState.bfcolor3));
	//	healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		scoreBar = new FlxText(FlxG.width / 2, healthBarBG.y + 40, 0, scoreDisplay, 20);
		scoreBar.setFormat(Paths.font(choosenFont), 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreBar.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		updateScoreText();
		scoreBar.scrollFactor.set();
		add(scoreBar);

		cornerMark = new FlxText(0, 0, 0, engineDisplay);
		cornerMark.setFormat(Paths.font(choosenFont), 18, FlxColor.WHITE);
		cornerMark.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(cornerMark);
		cornerMark.setPosition(FlxG.width - (cornerMark.width + 5), 5);
		cornerMark.antialiasing = true;

		centerMark = new FlxText(0, 0, 0, '- ${infoDisplay} -');
		centerMark.setFormat(Paths.font(choosenFont), 24, FlxColor.WHITE);
		centerMark.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(centerMark);
		if (Init.trueSettings.get('Downscroll'))
			centerMark.y = (FlxG.height - centerMark.height / 2) - 30;
		else
			centerMark.y = (FlxG.height / 24) - 10;
		centerMark.screenCenter(X);
		centerMark.antialiasing = true;

		var demoDisplay:String = "This mod is currently in a demo state, this is not final.";

		demoshit = new FlxText(0, FlxG.height - 20, 0, demoDisplay, 20);
		demoshit.setFormat(Paths.font(choosenFont), 14, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		demoshit.scrollFactor.set();
		demoshit.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		demoshit.screenCenter(X);
		add(demoshit);

		// counter
		if (Init.trueSettings.get('Counter') != 'None') {
			var judgementNameArray:Array<String> = [];
			for (i in Timings.judgementsMap.keys())
				judgementNameArray.insert(Timings.judgementsMap.get(i)[0], i);
			judgementNameArray.sort(sortByShit);
			for (i in 0...judgementNameArray.length) {
				var textAsset:FlxText = new FlxText(5 + (!left ? (FlxG.width - 10) : 0),
					(FlxG.height / 2)
					- (counterTextSize * (judgementNameArray.length / 2))
					+ (i * counterTextSize), 0,
					'', counterTextSize);
				if (!left)
					textAsset.x -= textAsset.text.length * counterTextSize;
				textAsset.setFormat(Paths.font(choosenFont), counterTextSize, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				textAsset.scrollFactor.set();
				timingsMap.set(judgementNameArray[i], textAsset);
				add(textAsset);
			}
		}
		updateScoreText();
	}

	var counterTextSize:Int = 18;

	function sortByShit(Obj1:String, Obj2:String):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Timings.judgementsMap.get(Obj1)[0], Timings.judgementsMap.get(Obj2)[0]);

	var left = (Init.trueSettings.get('Counter') == 'Left');

	override public function update(elapsed:Float)
	{
		// pain, this is like the 7th attempt
		healthBar.percent = (PlayState.health * 50);

	//	var iconLerp = 0.5;
	//	iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.initialWidth, iconP1.width, iconLerp)));
	//	iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.initialWidth, iconP2.width, iconLerp)));

	//	iconP1.updateHitbox();
	//	iconP2.updateHitbox();

		if(demoshit.visible) { // kinda stole this from Psych Engine, sorry.
			demoSine += 180 * elapsed;
			demoshit.alpha = 1 - Math.sin((Math.PI * demoSine) / 180);
		}

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (PlayState.health <= 0.4 || PlayState.uhOh) {
			iconP1.animation.curAnim.curFrame = 1;
			iconP2.animation.curAnim.curFrame = 2;
		}
		else if (PlayState.health >= 1.6) {
			iconP1.animation.curAnim.curFrame = 2;
			iconP2.animation.curAnim.curFrame = 1;
		}
		else {
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}
	}

	private final divider:String = ' • ';

	private function tweenIcons():Void
		{
			iconP1.scale.set(1.3, 1.3);
			FlxTween.tween(iconP1, {"scale.x": 1, "scale.y": 1}, Conductor.stepCrochet / 500, {ease: FlxEase.cubeOut});
			
			iconP2.scale.set(1.3, 1.3);
			FlxTween.tween(iconP2, {"scale.x": 1, "scale.y": 1}, Conductor.stepCrochet / 500, {ease: FlxEase.cubeOut});
		}

	public function updateScoreText()
	{
		var importSongScore = PlayState.songScore;
		var importPlayStateCombo = PlayState.combo;
		var importMisses = PlayState.misses;

		var ratingCB:String = '';

		if (PlayState.misses > 0 && PlayState.misses < 10) ratingCB = ' [SDCB]';
		if (PlayState.misses >= 10 && PlayState.misses < 65) ratingCB = ' [CB]';
		else if (PlayState.misses >= 65) ratingCB = ' [Skill Issue]';

		scoreBar.text = 'Score: $importSongScore';
		// testing purposes
		var displayAccuracy:Bool = Init.trueSettings.get('Display Accuracy');
		if (displayAccuracy)
		{
			if (PlayState.misses == 0)
			scoreBar.text += divider + 'Accuracy: ' + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%' + Timings.comboDisplay;
			else
			scoreBar.text += divider + 'Accuracy: ' + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%' + ratingCB;
			scoreBar.text += divider + 'Combo Breaks: ' + Std.string(PlayState.misses);
			scoreBar.text += divider + 'Rank: ' + Std.string(Timings.returnScoreRating().toUpperCase());
		}

		scoreBar.x = ((FlxG.width / 2) - (scoreBar.width / 2));

		// update counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			for (i in timingsMap.keys()) {
				timingsMap[i].text = '${(i.charAt(0).toUpperCase() + i.substring(1, i.length))}: ${Timings.gottenJudgements.get(i)}';
				timingsMap[i].x = (5 + (!left ? (FlxG.width - 10) : 0) - (!left ? (6 * counterTextSize) : 0));
			}
		}

		// update playstate
		PlayState.detailsSub = scoreBar.text;
		PlayState.updateRPC(false);
	}

	public function beatHit()
	{
		if (!Init.trueSettings.get('Reduced Movements'))
		{
		tweenIcons();
		}
		//
	}
}
