package;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;


// adapted from https://github.com/HaxeFlixel/flixel-demos/blob/master/Editors/TiledEditor/source/TiledLevel.hx
class Level extends TiledMap
{
    public var floors:FlxTypedGroup<Floor>;
    public var scaleFloors:FlxTypedGroup<Floor>;
    public var walls:FlxTypedGroup<Wall>;
    public var exits:FlxTypedGroup<Exit>;
    public var coins:FlxTypedGroup<Coin>;
    public var balls:FlxTypedGroup<Ball>;

    public var entityGroups:Array<FlxTypedGroup<Dynamic>>;

    public var spawn:FlxPoint;

    public function new(levelPath:String)
    {
        super(levelPath);

        floors = new FlxTypedGroup<Floor>();
        scaleFloors = new FlxTypedGroup<Floor>();
        walls = new FlxTypedGroup<Wall>();
        exits = new FlxTypedGroup<Exit>();
        coins = new FlxTypedGroup<Coin>();
        balls = new FlxTypedGroup<Ball>();

        entityGroups = [floors, scaleFloors, walls, exits, coins, balls];

        for (layer in layers)
        {
            if (layer.type != TiledLayerType.OBJECT) continue;

            var objectLayer:TiledObjectLayer = cast layer;
            for (obj in objectLayer.objects)
            {
                // waste of an object, but if we don't put this compiler complains about levelObj.scaleFactor
                var levelObj:ScalableSprite = new ScalableSprite();
                switch(objectLayer.name)
                {
                    case "Floors":
                        levelObj = new Floor(obj.x, obj.y, obj.width, obj.height);
                        floors.add(cast levelObj);
                    case "ScaleFloors":
                        levelObj = new Floor(obj.x, obj.y, obj.width, obj.height, FlxColor.WHITE);
                        (cast levelObj).isScaleFloor = true;
                        scaleFloors.add(cast levelObj);
                    case "Walls":
                        levelObj = new Wall(obj.x, obj.y, obj.width, obj.height);
                        walls.add(cast levelObj);
                    case "Exits":
                        levelObj = new Exit(obj.x, obj.y, obj.width, obj.height);
                        exits.add(cast levelObj);
                    case "Coins":
                        levelObj = new Coin(obj.x, obj.y);
                        coins.add(cast levelObj);
                    case "Balls":
                        levelObj = new Ball(obj.x, obj.y);
                        balls.add(cast levelObj);
                    case "Locations":
                        if(obj.name == "start")
                            spawn = new FlxPoint(obj.x, obj.y);
                }
                if(obj.properties.contains('scale'))
                    levelObj.scaleFactor = Std.parseInt(obj.properties.get('scale'));
                    levelObj.redraw(); // redraw things in case they depend on scaleFactor
            }

        }
    }

}