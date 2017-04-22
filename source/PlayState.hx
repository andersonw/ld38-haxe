package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
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
		for(i in 0...30){
			var wall = new Wall(FlxG.random.float(0., 600.),
								 FlxG.random.float(0., 600.),
								 FlxG.random.int(20, 30),
								 FlxG.random.int(20, 30));
			_grpWalls.add(wall);
		}
		add(_grpWalls);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _grpWalls);

		if(FlxG.keys.justPressed.Z)
		{
			scaleDown();
		}

		if(FlxG.keys.justPressed.X)
		{
			scaleUp();
		}
	}

	// function to make the world smaller (and player larger in comparison)
	public function scaleDown():Void
	{
		for(wall in _grpWalls)
		{
			FlxTween.tween(wall, {x: 0.5*(wall.x + _player.x), y:0.5*(wall.y + _player.y)}, 1);
			FlxTween.tween(wall.scale, 
						   {x: 0.5*wall.scale.x, y: 0.5*wall.scale.y}, 
						   1, 
						   {onComplete: function(tween:FlxTween){
							   		wall.updateHitbox();
						   	}});
		}
	}

	// function to make the world larger (and player smaller in comparison)
	public function scaleUp():Void
	{
		for(wall in _grpWalls)
		{
			FlxTween.tween(wall, {x: 2*wall.x - _player.x, y:2*wall.y - _player.y}, 1);
			FlxTween.tween(wall.scale, 
						   {x: 2*wall.scale.x, y: 2*wall.scale.y}, 
						   1, 
						   {onComplete: function(tween:FlxTween){
							   		wall.updateHitbox();
						   	}});
		}
	}
}
