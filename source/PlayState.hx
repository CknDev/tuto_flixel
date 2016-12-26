package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxBaseTilemap;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	private var _map:TiledMap;
	private var _mWalls:FlxTilemap;
	private var _player:Player;
	private var _grpCoins:FlxTypedGroup<Coin>;
	private var _grpEnnemies:FlxTypedGroup<Ennemy>;
	private var _hud:HUD;
	private var _money:Int = 0;
	private var _health:Int = 3;

	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "coin")
		{
			_grpCoins.add(new Coin(x + 4, y + 4));
		}
		else if (entityData.get("name") == "ennemy")
		{
			_grpEnnemies.add(new Ennemy(x + 4, y, Std.parseInt(entityData.get("type"))));
		}
	}

	override public function create():Void
	{
		_map = new TiledMap(AssetPaths.room_001__tmx);
		_mWalls = new FlxTilemap();
		_mWalls.loadMapFromArray(
			cast(_map.getLayer("walls"), TiledTileLayer).tileArray,
			_map.width,
			_map.height,
			AssetPaths.tiles__png,
			_map.tileWidth,
			_map.tileHeight,
			FlxTilemapAutoTiling.OFF,
			1,
			1,
			3
		);
		_mWalls.follow();
		_mWalls.setTileProperties(2, FlxObject.NONE);
		_mWalls.setTileProperties(3, FlxObject.ANY);
		add(_mWalls);

		var tmpCoinMap:TiledObjectLayer = cast(_map.getLayer("coin"));
		_grpCoins = new FlxTypedGroup<Coin>();
		for (e in tmpCoinMap.objects)
		{
			placeEntities(e.type, e.xmlData.x);
		}
		add(_grpCoins);

		var tmpEnemyMap:TiledObjectLayer = cast(_map.getLayer("ennemy"));
		_grpEnnemies = new FlxTypedGroup<Ennemy>();
		for (e in tmpEnemyMap.objects)
		{
			placeEntities(e.type, e.xmlData.x);
		}
		add(_grpEnnemies);

		var tmpMap:TiledObjectLayer = cast(_map.getLayer("player"));
		_player = new Player();
		for (e in tmpMap.objects)
		{
			placeEntities(e.type, e.xmlData.x);
		}
		add(_player);
		FlxG.camera.follow(_player, TOPDOWN, 1);

		_hud = new HUD();
		add(_hud);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _grpCoins, playerTouchCoin);
		FlxG.collide(_grpEnnemies, _mWalls);
		_grpEnnemies.forEachAlive(checkEnnemyVision);
	}

	private function playerTouchCoin(P:Player, C:Coin) : Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			C.kill();
			_money++;
			_hud.updateHUD(_health, _money);
		}
	}

	private function checkEnnemyVision(e:Ennemy):Void
	{
		if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()))
		{
			e.seesPlayer = true;
			e.playerPos.copyFrom(_player.getMidpoint());
		}
		else
		{
			e.seesPlayer = false;
		}

	}
}
