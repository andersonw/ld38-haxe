package;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Ball extends ScalableSprite
{
    public var pickedUp:Bool = false;
    public var inBin:Bool = false;
    public var carrier:ScalableSprite;

    public var speed:Float = 210;

    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32)
    {
        super(X, Y);
        makeGraphic(width, height, FlxColor.TRANSPARENT, true);
    }

    public override function update(elapsed:Float):Void
    {
        movement();
        super.update(elapsed);
    }

    private function movement()
    {
        if(!pickedUp)
            return;
        
        var myCenter:FlxPoint = getGraphicMidpoint();
        var targetCenter:FlxPoint = carrier.getGraphicMidpoint();

        velocity.x = 2*(targetCenter.x - myCenter.x);
        velocity.y = 2*(targetCenter.y - myCenter.y);
    }

    public override function getHelpText(player:Player):String
    {
        if (!player.isCarrying && !pickedUp)
            return "Press [A] to pick up";
        return "";
    }

    public override function redraw(){
        FlxSpriteUtil.fill(this, FlxColor.TRANSPARENT);
        if(pickedUp)
        {
            if(inBin)
                FlxSpriteUtil.drawEllipse(this, 0, 0, frameWidth, frameHeight, FlxColor.GREEN);
            else
                FlxSpriteUtil.drawEllipse(this, 0, 0, frameWidth, frameHeight, FlxColor.RED);
            FlxSpriteUtil.drawEllipse(this, 2, 2, frameWidth-4, frameHeight-4, FlxColor.ORANGE);
        }else{
            FlxSpriteUtil.drawEllipse(this, 0, 0, frameWidth, frameHeight, FlxColor.ORANGE);
        }
        
    }
}
