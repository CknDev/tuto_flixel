package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
  private var _player:Player;
  public var speed:Float = 200;

  public function new(?X:Float=0, ?Y:Float=0)
  {
    super(X, Y);
    // makeGraphic(16, 16, FlxColor.BLUE);
    loadGraphic(AssetPaths.player__png, true, 16, 16);
    setFacingFlip(FlxObject.LEFT, false, false);
    setFacingFlip(FlxObject.RIGHT, true, false);
    animation.add("lr", [3, 4, 3, 5], 6, false);
    animation.add("u", [6, 7, 6, 8], 6, false);
    animation.add("d", [0, 1, 0, 2], 6, false);
    drag.x = drag.y = 1600;
    setSize(8, 14);
    offset.set(4, 2);
  }

  private function movement():Void
  {
    var _up:Bool = false;
    var _down:Bool = false;
    var _left:Bool = false;
    var _right:Bool = false;
    var mA:Float = 0;

    _up = FlxG.keys.anyPressed([UP]);
    _down = FlxG.keys.anyPressed([DOWN]);
    _left = FlxG.keys.anyPressed([LEFT]);
    _right = FlxG.keys.anyPressed([RIGHT]);

    if (_up && _down)
    {
      _up = _down = false;
    }
    if (_left && _right)
    {
      _left = _right = false;
    }

    if (_up)
    {
      mA = -90;
      if (_left)
      {
        mA -= 45;
      }
      else if (_right)
      {
        mA += 45;
      }
      facing = FlxObject.UP;
    }
    else if (_down)
    {
      mA = 90;
      if (_left)
      {
        mA += 45;
      }
      else if (_right)
      {
        mA -= 45;
      }
      facing = FlxObject.DOWN;
    }
    else if (_left)
    {
      mA = 180;
      facing = FlxObject.LEFT;
    }
    else if (_right)
    {
      mA = 0;
      facing = FlxObject.RIGHT;
    }
    velocity.set(speed, 0);
    velocity.rotate(FlxPoint.weak(0, 0), mA);

    if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
    {
      switch(facing)
      {
        case FlxObject.LEFT, FlxObject.RIGHT:
          animation.play("lr");
        case FlxObject.UP:
          animation.play("u");
        case FlxObject.DOWN:
          animation.play("d");
      }
    }
  }

  override public function update(elapsed:Float):Void
  {
    movement();
    super.update(elapsed);
  }
}
