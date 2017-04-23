package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

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

		resetLevelBounds();
		FlxG.camera.follow(_player);
		
		_tooltip = new FlxText();
		_tooltip.setFormat(AssetPaths.squaredpixel__ttf, 16, FlxColor.YELLOW);
		_tooltip.visible = false;
		_tooltip.alpha = 0.6;
		add(_tooltip);

		bgColor = new FlxColor(0xff303030);

		super.create();
	}

	public function takeExit(player:Player, exit:Exit)
	{
		Registry.currLevel += 1;
		player.active = false;
		FlxG.switchState(new PlayState());
	}

	public function pickupCoin(player:Player, coin:Coin)
	{
		coin.kill();
		scaleDown();
	}

	public function pickupBall(player:Player, ball:Ball)
	{
		if(!ball.pickedUp && !player.isCarrying)
			player.pickUp(ball);
	}

	public function ballToTheWall(ball:Ball, wall:Wall)
	{
		if(!ball.inBin)
			ball.kill();
	}

	public function ballToTheGate(ball:Ball, gate:Floor)
	{
		if(!ball.inBin)
			ball.kill();
	}

	public function ballToTheBin(ball:Ball, bin:Bin)
	{
		if(!ball.pickedUp && !bin.hasBall && ball.scaleFactor == bin.scaleFactor)
		{
			ball.pickedUp=true;
			ball.inBin=true;
			ball.isScalable=true; // so the ball always stays in the bin
			ball.carrier=bin;
			ball.redraw();

			bin.hasBall = true;

			for(exit in _level.exits)
			{
				exit.redraw();
			}
		}
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

	public function resetLevelBounds()
	{
		_level.updateBounds();
		FlxG.worldBounds.set(_level.bounds.x, _level.bounds.y, _level.bounds.width, _level.bounds.height);
	}

	public function previousLevel()
	{
		if(Registry.currLevel > 0) {
			Registry.currLevel -= 1;
		}
		FlxG.switchState(new PlayState());
	}

	public function nextLevel()
	{
		if(Registry.currLevel < (Registry.levelList.length - 1)) {
			Registry.currLevel += 1;
		}
		FlxG.switchState(new PlayState());
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_tooltip.visible = false;

		FlxG.collide(_player, _level.walls);
		if(!FlxG.overlap(_player, _level.floors) && 
		   !FlxG.overlap(_player, _level.scaleFloors) && 
		   !FlxG.overlap(_player, _level.exits))
		{
			resetLevel();
		}

		FlxG.overlap(_player, _level.coins, pickupCoin);

		FlxG.overlap(_player, _level.exits, updateTooltip);
		FlxG.overlap(_player, _level.scaleFloors, updateTooltip);
		FlxG.overlap(_player, _level.balls, updateTooltip);

		FlxG.overlap(_level.balls, _level.bins, ballToTheBin);
		FlxG.overlap(_level.balls, _level.gates, ballToTheGate);

		if(FlxG.keys.justPressed.R)
		{
			resetLevel();
		}

		if(FlxG.keys.justPressed.B)
		{
			previousLevel();
		}

		if(FlxG.keys.justPressed.N)
		{
			nextLevel();
		}

		// for the remainder of options, require that the player is active
		if(!_player.active)
			return;

		FlxG.overlap(_level.balls, _level.walls, ballToTheWall);

		if(FlxG.keys.justPressed.SPACE)
		{
			for(exit in _level.exits)
			{
				if (exit.canExit(_player))
				{
					takeExit(_player, exit);
					break;
				}
			}
		}

		if(FlxG.keys.justPressed.Z)
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

		if(FlxG.keys.justPressed.X)
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

		if(FlxG.keys.justPressed.A)
		{
			if(_player.isCarrying)
			{
				_player.dropBall();
			}
			else
			{
				FlxG.overlap(_player, _level.balls, pickupBall);
			}
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
				if (entity.isScalable)
					entity.scaleDown(_player);
			}
		}
		resetLevelBounds();
	}

	// function to make the world larger (and player smaller in comparison)
	public function scaleUp():Void
	{
		_player.active = false;
		for(entityGroup in _level.entityGroups)
		{
			for(entity in entityGroup)
			{
				if (entity.isScalable)
					entity.scaleUp(_player);
			}
		}
		resetLevelBounds();
	}
}