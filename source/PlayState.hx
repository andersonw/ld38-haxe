package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _levelFile:String;
	private var _level:Level;
	private var _tooltip:FlxText;

	override public function create():Void
	{
		_levelFile = Registry.levelList[Registry.currLevel];
		_level = new Level(_levelFile);
		for(entityGroup in _level.entityGroups)
		{
			add(entityGroup);
		}

		_player = new Player(_level.spawn.x, _level.spawn.y);
		add(_player);
		FlxG.camera.setScrollBoundsRect(-10, -10, _level.fullWidth+20, _level.fullHeight+20, true);
		FlxG.camera.follow(_player);
		
		_tooltip = new FlxText();
		_tooltip.setFormat(AssetPaths.squaredpixel__ttf, 16, FlxColor.YELLOW);
		_tooltip.visible = false;
		add(_tooltip);

		super.create();
	}

	public function takeExit(player:Player, exit:Exit)
	{
		if(exit.containsSprite(player) && player.active){
			Registry.currLevel += 1;
			player.active = false;
			FlxG.switchState(new PlayState());
		}
	}

	public function pickupCoin(player:Player, coin:Coin)
	{
		coin.kill();
		scaleDown();
	}

	public function updateTooltip(player:Player, scalableSprite:ScalableSprite)
	{
		var helpText:String = scalableSprite.getHelpText(player);
		if (helpText != "" && _player.active)
		{
			_tooltip.text = helpText;
			_tooltip.x = scalableSprite.x+(scalableSprite.width-_tooltip.width)/2;
			_tooltip.y = scalableSprite.y-_tooltip.height;
			_tooltip.visible = true;
		}
	}

	public function resetLevel()
	{
		FlxG.switchState(new PlayState());
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_tooltip.visible = false;

		FlxG.collide(_player, _level.walls);
		if(!FlxG.overlap(_player, _level.floors))
		{
			resetLevel();
		}

		FlxG.overlap(_player, _level.exits, takeExit);
		FlxG.overlap(_player, _level.coins, pickupCoin);
		FlxG.overlap(_player, _level.scaleFloors, updateTooltip);

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