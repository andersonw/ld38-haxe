package;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;


// adapted from https://github.com/HaxeFlixel/flixel-demos/blob/master/Editors/TiledEditor/source/TiledLevel.hx
class Level extends TiledMap
{
    public static inline var levelFilePath="assets/data/levels/";

    public var floors:FlxTypedGroup<Floor>;
    public var scaleFloors:FlxTypedGroup<Floor>;
    public var walls:FlxTypedGroup<Wall>;
    public var exits:FlxTypedGroup<Exit>;

    public var entityGroups:Array<FlxTypedGroup<Dynamic>>;

    public var spawn:FlxPoint;

    public function new(levelName:String)
    {
        super(levelFilePath + levelName);

        floors = new FlxTypedGroup<Floor>();
        scaleFloors = new FlxTypedGroup<Floor>();
        walls = new FlxTypedGroup<Wall>();
        exits = new FlxTypedGroup<Exit>();

        entityGroups = [floors, scaleFloors, walls, exits];

        for (layer in layers)
        {
            if (layer.type != TiledLayerType.OBJECT) continue;

            var objectLayer:TiledObjectLayer = cast layer;
            if (objectLayer.name == "Floors")
                loadFloor(objectLayer);
            if (objectLayer.name == "ScaleFloors")
                loadScaleFloor(objectLayer);
            else if (objectLayer.name == "Walls")
                loadWalls(objectLayer);
            else if (objectLayer.name == "Exits")
                loadExits(objectLayer);
            else if (objectLayer.name == "Locations")
                loadLocations(objectLayer);

        }
    }

    private function loadFloor(floorLayer:TiledObjectLayer)
    {
        for (floorObj in floorLayer.objects)
        {
            var floor:Floor = new Floor(floorObj.x, floorObj.y, floorObj.width, floorObj.height);
            floors.add(floor);
        }
    }

    private function loadScaleFloor(floorLayer:TiledObjectLayer)
    {
        for (floorObj in floorLayer.objects)
        {
            var floor:Floor = new Floor(floorObj.x, floorObj.y, floorObj.width, floorObj.height, FlxColor.WHITE);
            scaleFloors.add(floor);
        }
    }

    private function loadWalls(wallLayer:TiledObjectLayer)
    {
        for (exitObj in wallLayer.objects)
        {
            var wallRect:Wall = new Wall(exitObj.x, exitObj.y, exitObj.width, exitObj.height);
            walls.add(wallRect);
        }
    }

    private function loadExits(exitLayer:TiledObjectLayer)
    {
        for (exitObj in exitLayer.objects)
        {
            var exit:Exit = new Exit(exitObj.x, exitObj.y, exitObj.width, exitObj.height, exitObj.properties.get('destination'));
            exits.add(exit);
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
        }
    }

}