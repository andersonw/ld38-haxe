package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Player extends ScalableSprite
{
    public static var DEFAULT_ALPHA = 0.6;

    public var speed:Float = 200;
    public var isCarrying:Bool = false;
    public var carrying:Ball;

    public var isHuggingWall:Bool = false;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        makeGraphic(32, 32, FlxColor.RED);
        alpha = DEFAULT_ALPHA;
    }

    public function pickUp(ball:Ball)
    {
        isCarrying = true;
        carrying = ball;
        ball.pickedUp = true;
        ball.carrier = this;
        ball.redraw();
    }

    public function dropBall():Void
    {
        if(!isCarrying)
            return;
        
        isCarrying = false;
        carrying.pickedUp = false;
        carrying.carrier = null;
        // uncomment this if you want the ball to stop
        // carrying.velocity.x = 0;
        // carrying.velocity.y = 0;
        carrying.redraw();
    }

    public override function update(elapsed:Float):Void
    {
        movement();
        super.update(elapsed);
    }

    private function movement():Void
    {
        // adapted from http://haxeflixel.com/documentation/groundwork/
        var _up:Bool = false;
        var _down:Bool = false;
        var _left:Bool = false;
        var _right:Bool = false;

        _up = FlxG.keys.anyPressed([UP]);
        _down = FlxG.keys.anyPressed([DOWN]);
        _left = FlxG.keys.anyPressed([LEFT]);
        _right = FlxG.keys.anyPressed([RIGHT]);

        if (FlxG.keys.anyPressed([SHIFT]))
            speed = 50;
        else
            speed = 200;

        if (_up && _down)
            _up = _down = false;
        if (_left && _right)
            _left = _right = false;

        if (_up || _down || _left || _right) {
            var mA:Float = 0;
            if(_up){
                mA = -90;
                if (_left){
                    mA -= 45;
                }else if(_right){
                    mA += 45;
                }
            }else if(_down){
                mA = 90;
                if(_left){
                    mA += 45;
                }else if(_right){
                    mA -= 45;
                }
            }else if(_left){
                mA = 180;
            }else if(_right){
                mA = 0;
            }
            velocity.set(speed, 0);
            velocity.rotate(FlxPoint.weak(0,0), mA);
        }
        else {
            velocity.set(0, 0);
        }
    }
}
