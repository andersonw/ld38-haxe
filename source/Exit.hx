package;

import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Exit extends ScalableSprite
{
    public static inline var UNSCALED_SIZE = 36;

    public static var lineStyle:LineStyle = { color: FlxColor.RED, thickness: 10 };

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        makeGraphic(UNSCALED_SIZE, UNSCALED_SIZE, FlxColor.PURPLE);
    }

    public function isOpen():Bool {
        return (scaleFactor == 0);
    }

    public function canExit(player:Player):Bool
    {
        return (player.scaleFactor == scaleFactor && this.overlapsSprite(player));
    }

    public override function getHelpText(player:Player):String
    {
        if (player.scaleFactor < scaleFactor && this.overlapsSprite(player))
            return "You're too small!";
        if (player.scaleFactor > scaleFactor && player.overlapsSprite(this))
            return "You're too large!";
        if (canExit(player))
            return "[Space] Exit the level!";
        return "";
    }

    public override function redraw()
    {
        if(isOpen())
            FlxSpriteUtil.fill(this, FlxColor.PURPLE);
        else
            FlxSpriteUtil.fill(this, FlxColor.BLACK);
        FlxSpriteUtil.drawRect(this, 0, 0, frameWidth, frameHeight, FlxColor.TRANSPARENT, lineStyle);
    }
}