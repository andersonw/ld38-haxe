package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

class Wall extends FlxSprite
{
    public function new(?X:Float=0, ?Y:Float=0, ?height:Int=32, ?width:Int=32)
    {
        super(X, Y);
        makeGraphic(height, width, FlxColor.BLUE);
    }
}
