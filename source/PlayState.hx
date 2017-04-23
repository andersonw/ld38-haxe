package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _levelFile:String;
	private var _level:Level;

	override public function create():Void
	{
		_levelFile = Registry.levelList[Registry.currLevel];
		_level = new Level(_levelFile);
		add(_level.floors);
		add(_level.scaleFloors);
		add(_level.walls);
		add(_level.exits);

		_player = new Player(_level.spawn.x, _level.spawn.y);
		add(_player);
		FlxG.camera.setScrollBoundsRect(-10, -10, _level.fullWidth+20, _level.fullHeight+20, true);
		FlxG.camera.follow(_player);
		
		super.create();
	}

	public function takeExit(player:Player, exit:Exit)
	{
		if(exit.containsSprite(player)){
			Registry.currLevel += 1;
			FlxG.switchState(new PlayState());
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _level.walls);
		if(!FlxG.overlap(_player, _level.floors))
		{
			FlxG.switchState(new PlayState());
		}

		FlxG.overlap(_player, _level.exits, takeExit);

		if(FlxG.keys.justPressed.Z && _player.active)
		{
			var canScaleDown:Bool = false;
			for(scaleFloor in _level.scaleFloors)
			{
				if(scaleFloor.containsSprite(_player))
					canScaleDown = true;
			}
			if(canScaleDown)
				scaleDown();
		}

		if(FlxG.keys.justPressed.X && _player.active)
		{
			var canScaleUp:Bool = false;
			for(scaleFloor in _level.scaleFloors)
			{
				if(_player.containsSprite(scaleFloor))
					canScaleUp = true;
			}
			if(canScaleUp)
				scaleUp();
		}
	}

	// function to make the world smaller (and player larger in comparison)
	public function scaleDown():Void
	{
		_player.active = false;
		for(wall in _level.walls)
		{
			wall.scaleDown(_player);
		}
		for(floor in _level.floors)
		{
			floor.scaleDown(_player);
		}
		for(exit in _level.exits)
		{
			exit.scaleDown(_player);
		}
		for(scaleFloor in _level.scaleFloors)
		{
			scaleFloor.scaleDown(_player);
		}
	}

	// function to make the world larger (and player smaller in comparison)
	public function scaleUp():Void
	{
		_player.active = false;
		for(wall in _level.walls)
		{
			wall.scaleUp(_player);
		}
		for(floor in _level.floors)
		{
			floor.scaleUp(_player);
		}
		for(exit in _level.exits)
		{
			exit.scaleUp(_player);
		}
		for(scaleFloor in _level.scaleFloors)
		{
			scaleFloor.scaleUp(_player);
		}
	}
}