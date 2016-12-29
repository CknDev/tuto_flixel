package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

class GameOverState extends FlxState
{
  private var _score:Int = 0;
  private var _win:Bool;
  private var _txtTile:FlxText;
  private var _txtMessage:FlxText;
  private var _sprScore:FlxSprite;
  private var _txtScore:FlxText;
  private var _txtHiScore:FlxText;
  private var _btnMainMenu:FlxButton;

  public function new(Win:Bool, Score:Int)
  {
    _win = Win;
    _score = Score;
    super();
  }

  override public function create():Void
  {
    #if FLX_MOUSE
      FlxG.mouse.visible = true;
    #end

    _txtTile = new FlxText(0, 20, 0, _win ? "You win!" : "Game over", 22);
    _txtTile.alignment = CENTER;
    _txtTile.screenCenter(FlxAxes.X);
    add(_txtTile);

    _txtMessage = new FlxText(0, (FlxG.width / 2) - 8, 0, AssetPaths.coin__png);
    _txtMessage.alignment = CENTER;
    _txtMessage.screenCenter(FlxAxes.X);
    add(_txtMessage);

    _sprScore = new FlxSprite((FlxG.width / 2) - 8, 0, Std.string(_score));
    _sprScore.screenCenter(FlxAxes.Y);
    add(_sprScore);

    _txtScore = new FlxText((FlxG.width / 2), 0, 0, Std.string(_score), 0);
    _txtScore.screenCenter(FlxAxes.Y);
    add(_txtScore);

    var _hiscore = checkHiScore(_score);

    _txtHiScore = new FlxText(0, (FlxG.height / 2) + 10, 0, "Hi-Score" + _txtHiScore, 8);
    _txtHiScore.alignment = CENTER;
    _txtHiScore.screenCenter(FlxAxes.Y);
    add(_txtHiScore);

    _btnMainMenu = new FlxButton(0, FlxG.height - 52, "Main Menu", goMainMenu);
    _btnMainMenu.screenCenter(FlxAxes.X);
    _btnMainMenu.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
    add(_btnMainMenu);

    FlxG.camera.fade(FlxColor.BLACK, .33, true);

    super.create();
  }

  private function checkHiScore(Score:Int):Int
  {
    var _hi:Int = Score;
    var _save:FlxSave = new FlxSave();
    if (_save.bind("flixel_tutorial"))
    {
      if (_save.data.hiscore != null && _save.data.hiscore > _hi)
      {
        _hi = _save.data.hiscore;
      }
      else
      {
        _save.data.hiscore = _hi;
      }
    }
    _save.close();
    return _hi;
  }

  private function goMainMenu():Void
  {
    FlxG.camera.fade(FlxColor.BLACK, .33, false, function () {
      FlxG.switchState(new MenuState());
    });
  }
}
