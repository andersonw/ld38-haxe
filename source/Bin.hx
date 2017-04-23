package;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Bin extends ScalableSprite
{
    public var hasBall:Bool = false;

    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32)
    {
        super(X, Y);
        makeGraphic(width, height, FlxColor.ORANGE, true);
        FlxSpriteUtil.drawEllipse(this, 2, 2, frameWidth-4, frameHeight-4, FlxColor.BLACK);
    }
}
