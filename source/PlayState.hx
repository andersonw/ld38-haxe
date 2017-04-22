package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _grpWalls:FlxTypedGroup<Wall>;

	override public function create():Void
	{
		_player = new Player(20,20);
		add(_player);

		// add some random walls
		
		_grpWalls = new FlxTypedGroup<Wall>();
		for(i in 0...10){
			var _wall = new Wall(FlxG.random.float(0., 600.),
								 FlxG.random.float(0., 600.),
								 FlxG.random.int(20, 100),
								 FlxG.random.int(20, 100));
			_grpWalls.add(_wall);
		}

		add(_grpWalls);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
