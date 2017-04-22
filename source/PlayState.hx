package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.tweens.FlxTween;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _level:Level;

	override public function create():Void
	{
		_level = new Level("assets/data/levels/test_level.tmx");
		add(_level.floors);
		add(_level.walls);

		_player = new Player(_level.spawn.x, _level.spawn.y);
		add(_player);
		FlxG.camera.setScrollBoundsRect(-10, -10, _level.fullWidth+20, _level.fullHeight+20, true);
		FlxG.camera.follow(_player);

//		FlxG.worldBounds.set(-10, -10, _level.fullWidth+20, _level.fullHeight+20);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _level.walls);
		if(!FlxG.overlap(_player, _level.floors))
		{
			FlxTween.tween(_player, {x: _level.spawn.x, y: _level.spawn.y}, 0.5);
		}

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
		for(wall in _level.walls)
		{
			wall.scaleDown(_player);
		}
		for(floor in _level.floors)
		{
			floor.scaleDown(_player);
		}
	}

	// function to make the world larger (and player smaller in comparison)
	public function scaleUp():Void
	{
		for(wall in _level.walls)
		{
			wall.scaleUp(_player);
		}
		for(floor in _level.floors)
		{
			floor.scaleUp(_player);
		}
	}
}
