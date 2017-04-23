package;

import flixel.util.FlxColor;

class Floor extends ScalableSprite
{
    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32, ?color:FlxColor=FlxColor.GREEN)
    {
        super(X, Y);
        makeGraphic(width, height, color);
    }

}
