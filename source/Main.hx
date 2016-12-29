package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import flixel.util.FlxSave;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(320, 240, MenuState));
		var _save:FlxSave = new FlxSave();
		_save.bind("flixel-tutorial");
		if (_save.data.volume != null)
		{
			FlxG.sound.volume = _save.data.volume;
		}
		_save.close();
	}
}
