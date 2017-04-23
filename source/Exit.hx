package;

import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Exit extends ScalableSprite
{
    public static var lineStyle:LineStyle = { color: FlxColor.RED, thickness: 10 };

    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32 )
    {
        super(X, Y);
        makeGraphic(width, height, FlxColor.PURPLE);
        FlxSpriteUtil.drawRect(this, 0, 0, width, height, FlxColor.TRANSPARENT, lineStyle);
    }

    public function isOpen():Bool {
        return (scaleFactor == 0);
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