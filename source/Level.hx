package;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

// adapted from https://github.com/HaxeFlixel/flixel-demos/blob/master/Editors/TiledEditor/source/TiledLevel.hx
class Level extends TiledMap
{
    public var floors:FlxTypedGroup<Floor>;
    public var walls:FlxTypedGroup<Wall>;

    public var spawn:FlxPoint;
    public var endLocation:FlxPoint;

    public function new(levelPath:String)
    {
        super(levelPath);

        floors = new FlxTypedGroup<Floor>();
        walls = new FlxTypedGroup<Wall>();

        for (layer in layers)
        {
            if (layer.type != TiledLayerType.OBJECT) continue;

            var objectLayer:TiledObjectLayer = cast layer;
            if (objectLayer.name == "Floor Rectangles")
                loadFloor(objectLayer);
            else if (objectLayer.name == "Wall Rectangles")
                loadWalls(objectLayer);
            else if (objectLayer.name == "Locations")
                loadLocations(objectLayer);

        }
    }

    private function loadFloor(floorLayer:TiledObjectLayer)
    {
        for (floorObj in floorLayer.objects)
        {
            var floorRect:Floor = new Floor(floorObj.x, floorObj.y, floorObj.width, floorObj.height);
            floors.add(floorRect);
        }
    }

    private function loadWalls(wallLayer:TiledObjectLayer)
    {
        for (wallObj in wallLayer.objects)
        {
            var wallRect:Wall = new Wall(wallObj.x, wallObj.y, wallObj.width, wallObj.height);
            walls.add(wallRect);
        }
    }

    private function loadLocations(locLayer:TiledObjectLayer)
    {
        for (locObj in locLayer.objects)
        {
            if (locObj.name == "start")
            {
                spawn = new FlxPoint(locObj.x, locObj.y);
            }
            else if (locObj.name == "end")
            {
                endLocation = new FlxPoint(locObj.x, locObj.y);
            }
        }
    }
}