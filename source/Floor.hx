package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class Floor extends ScalableSprite
{
    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32)
    {
        super(X, Y);
        makeGraphic(width, height, FlxColor.GREEN);
    }

    public function containsSprite(sprite:FlxSprite):Bool
    {
        if(sprite.x < x)
            return false;
        if(sprite.x+sprite.width > x+width)
            return false;
        if(sprite.y < y)
            return false;
        if(sprite.y+sprite.height > y+height)
            return false;
        return true;
    }
}
