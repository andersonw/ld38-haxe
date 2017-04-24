package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class ScalableSprite extends FlxSprite
{
    public var scaleFactor:Int = 0;
    public var isScalable:Bool = true;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
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

    public function overlapsSprite(sprite:FlxSprite):Bool
    {
        if(sprite.x+sprite.width < x)
            return false;
        if(sprite.x > x+width)
            return false;
        if(sprite.y+sprite.height < y)
            return false;
        if(sprite.y > y+height)
            return false;
        return true;
    }

    public function scaleUp(target:FlxSprite)
    {
        var targetCenter:FlxPoint = target.getGraphicMidpoint();
        var dilate:FlxPoint = new FlxPoint(2*x-targetCenter.x, 2*y-targetCenter.y);
        scaleFactor += 1;
        
        Registry.tweenSem += 1;
        Registry.isTweening = true;

        FlxTween.tween(this, 
                        {
                            x: dilate.x + 0.5*width, 
                            y: dilate.y + 0.5*height
                        }, 
                        1);
        FlxTween.tween(scale, 
                        {x: 2*scale.x, y: 2*scale.y}, 
                        1, 
                        {onComplete: function(tween:FlxTween){
                                x = dilate.x;
                                y = dilate.y;
                                updateHitbox();
                                redraw();
                                Registry.tweenSem -= 1;
                        }});
    }

    public function scaleDown(target:FlxSprite)
    {
        var targetCenter:FlxPoint = target.getGraphicMidpoint();
        var midpoint:FlxPoint = new FlxPoint(0.5*(x+targetCenter.x), 0.5*(y+targetCenter.y));
        scaleFactor -= 1;

        Registry.tweenSem += 1;
        Registry.isTweening = true;

        FlxTween.tween(this, 
                        {
                            x: midpoint.x - 0.25*width, 
                            y: midpoint.y - 0.25*height
                        }, 
                        1);
        FlxTween.tween(scale, 
                        {x: 0.5*scale.x, y: 0.5*scale.y}, 
                        1, 
                        {onComplete: function(tween:FlxTween){
                            x = midpoint.x;
                            y = midpoint.y;
                            updateHitbox();
                            redraw();
                            Registry.tweenSem -= 1;
                        }});
    }

    // Checks whether help text should be displayed.
    // If it should be displayed, returns the help text. If it shouldn't, returns an empty string.
    // Override this!
    public function getHelpText(player:Player):String
    {
        return "";
    }

    public function redraw()
    {
        // override this to redraw things after scaling

        // draw border around things that don't scale
        if(!isScalable)
        {
            var lineStyle:LineStyle = { color: FlxColor.MAGENTA , thickness: 4 };
            FlxSpriteUtil.drawRect(this, 0, 0, frameWidth, frameHeight, FlxColor.TRANSPARENT, lineStyle);
        }

    }
}
