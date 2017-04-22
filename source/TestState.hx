package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class TestState extends FlxState
{
	private var _level:TiledLevel;

	override public function create():Void
	{
		_level = new TiledLevel("assets/data/levels/test_level.tmx");
		add(_level.floorRects);
		add(_level.wallRects);
		add(_level.player);
		FlxG.camera.follow(_level.player);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
