package;

import flixel.util.FlxColor;

class Exit extends Floor
{
    public var destination:String;

    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32, ?dest:String="")
    {
        super(X, Y, width, height, FlxColor.PURPLE);
        destination = dest;
    }

}