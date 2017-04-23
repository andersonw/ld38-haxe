package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _levelFile:String;
	private var _level:Level;

	// the documentation said not to do this, but 
	// seems to work okay.

	// I think we might have issues if we try exporting though?
	public function new(?levelFile:String="test_level.tmx")
	{
		_levelFile = levelFile;
		super();
	}

	override public function create():Void
	{
		_level = new Level(_levelFile);
		for(entityGroup in _level.entityGroups)
		{
			add(entityGroup);
		}

		_player = new Player(_level.spawn.x, _level.spawn.y);
		add(_player);
		FlxG.camera.setScrollBoundsRect(-10, -10, _level.fullWidth+20, _level.fullHeight+20, true);
		FlxG.camera.follow(_player);
		
		super.create();
	}

	public function takeExit(player:Player, exit:Exit)
	{
		if(exit.containsSprite(player)){
			FlxG.switchState(new PlayState(exit.destination));
		}
	}

	public function pickupCoin(player:Player, coin:Coin)
	{
		coin.kill();
		scaleDown();
	}

	public function resetLevel()
	{
		FlxG.switchState(new PlayState(_levelFile));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _level.walls);
		if(!FlxG.overlap(_player, _level.floors))
		{
			resetLevel();
		}

		FlxG.overlap(_player, _level.exits, takeExit);
		FlxG.overlap(_player, _level.coins, pickupCoin);

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

		if(FlxG.keys.justPressed.R)
		{
			resetLevel();
		}
	}

	// function to make the world smaller (and player larger in comparison)
	public function scaleDown():Void
	{
		_player.active = false;
		for(entityGroup in _level.entityGroups)
		{
			for(entity in entityGroup)
			{
				entity.scaleDown(_player);
			}
		}
	}

	// function to make the world larger (and player smaller in comparison)
	public function scaleUp():Void
	{
		_player.active = false;
		for(entityGroup in _level.entityGroups)
		{
			for(entity in entityGroup)
			{
				entity.scaleUp(_player);
			}
		}
	}
}