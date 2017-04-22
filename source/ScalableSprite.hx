package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class ScalableSprite extends FlxSprite
{
    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
    }   

    public function scaleUp(target:FlxSprite)
    {
        var dilate:FlxPoint = new FlxPoint(2*x-target.x, 2*y-target.y);

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
                        }});
    }

    public function scaleDown(target:FlxSprite)
    {
        var midpoint:FlxPoint = new FlxPoint(0.5*(x+target.x), 0.5*(y+target.y));
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
                        }});
    }
}
