package ui.map
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import enums.TileType;
	
	import ui.objects.AnimatedObject;
	import ui.objects.BitmapDataFrame;
	import ui.objects.StaticObject;
	import ui.objects.TileObject;
	
	import utils.Enumeration;
	
	public class Board extends Sprite
	{
		// TILE DIMENSION CONSTANTS
		public static const CELL_WIDTH:int = 60;
		public static const CELL_HEIGHT:int = 35;
		
		// SHORTCUT TO ASSETS
		private const assets:Dictionary = AssetManager.instance.assets;
		
		// GRAPHICAL LAYERS
		private const _tileLayer:Sprite = new Sprite();
		private const _groundLayer:Sprite = new Sprite();
		private const _actionLayer:Sprite = new Sprite();
		
		// GAME OBJECTS
		private var _map:Vector.<Vector.<int>>;
		private var _gameObjects:Dictionary;
		
		// OPERATIONAL PROPERTIES
		private var _col:int;
		private var _row:int;
		private var _offsetX:int;
		private var _xp:Number;
		private var _yp:Number;
		private var _tileID:int = -1;
		
		/**
		 *  Game area
		 * 	map: game map
		 */
		public function Board(column:int, row:int)
		{
			super();
			
			_col = column;
			_row = row;
			_map = MapManager.generateMap(_col, _row);
			_gameObjects = new Dictionary(true);
			this.mouseChildren = false;
			
			if (!_map.length)
				throw new Error("Map is empty");
			
			// Area to simulate mouse detection
			graphics.beginFill(0, 0);
			graphics.moveTo(0, 0);
			graphics.lineTo(CELL_WIDTH * _map[0].length, 0);
			graphics.lineTo(CELL_WIDTH * _map[0].length, CELL_HEIGHT * _map.length);
			graphics.lineTo(0, CELL_HEIGHT * _map.length);
			graphics.endFill();
			
			this.addChild(_groundLayer);
			this.addChild(_actionLayer);
			this.addChild(_tileLayer);
			
			addEventListener(MouseEvent.MOUSE_MOVE, board_onMouseMoveHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, board_onMouseDownHandler, false, 0, true);
			addEventListener(Event.ENTER_FRAME, board_onEnterFrameHandler, false, 0, true);
		}
		
		//
		// PUBLIC METHODS
		//
		
		/**
		 *  Build play area
		 */
		public function build():void
		{			
			var tile:Tile;
			const col:int = _map.length;
			const row:int = _map[0].length;
			_offsetX = CELL_WIDTH / 2 * (_map.length - 1);
			
			for (var y:int = 0; y < col; y++)
			{
				for (var x:int = 0; x < row; x++)
				{
					tile = new Tile();
					tile.type = getTileType(y, x);
					tile.x = (CELL_WIDTH / 2) * (x - y) + _offsetX;
					tile.y = (CELL_HEIGHT / 2) * (x + y);
					tile.name = "tile_" + y + x;
					_gameObjects[tile.name] = tile;
					_tileLayer.addChild(tile);
				}
			}
		}
		
		public function reset():void
		{
			_map = MapManager.generateMap(_col, _row);
			_gameObjects = new Dictionary(true);
			
			if (!_map.length)
				throw new Error("Map is empty");
			
			_groundLayer.removeChildren();
			_actionLayer.removeChildren();
			_tileLayer.removeChildren();
			
			build();
		}
		
		//
		// PRIVATE METHOD
		//
		
		/**
		 *  Creating and caching block of ground
		 * 	block: rect with dimensions of ground
		 */
		private function getBlockGround(block:Rectangle):StaticObject
		{
			var groundName:String = "ground_" + block.width + "x" + block.height;
			var bmdFrame:BitmapDataFrame;
			if (_gameObjects[groundName])
				bmdFrame = _gameObjects[groundName];
			else
			{
				var groundBmp:Sprite;
				const groundSprite:Sprite = new Sprite();
				for (var y:int = 0; y < block.height; y++)
				{
					for (var x:int = 0; x < block.width; x++)
					{
						groundBmp = new StaticObject(assets[Assets.GROUND], new Rectangle(x, y, 1, 1));
						groundBmp.x = (CELL_WIDTH / 2) * (x - y);
						groundBmp.y = (CELL_HEIGHT / 2) * (x + y);
						groundSprite.addChild(groundBmp);
					}
				}
				const rect:Rectangle = groundSprite.getBounds(groundSprite);
				const bmd:BitmapData = new BitmapData(groundSprite.width, groundSprite.height, true, 0);
				bmd.draw(groundSprite, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
				bmdFrame = new BitmapDataFrame(bmd, new Point(rect.x, rect.y));
				_gameObjects[groundName] = bmdFrame;
			}
			return new StaticObject(bmdFrame, block);
		}
		
		/**
		 *  Getting wall type of the tile
		 * 	x: position in row of _map object
		 *  y: position in column of _map object
		 */
		private function getTileType(y:int, x:int):TileType
		{
			var top:int, right:int, bottom:int, left:int;
			top = right = bottom = left = 0;
			const id:int = _map[y][x];
			
			if (!y || (y > 0 && id != _map[y - 1][x]))
				top = 1;
			if (x == _map[y].length - 1 || (x < _map[y].length - 1 && id != _map[y][x + 1]))
				right = 2;
			if (y == _map.length - 1 || (y < _map.length - 1 && id != _map[y + 1][x]))
				bottom = 4;
			if (!x || (x > 0 && id != _map[y][x - 1]))
				left = 8;
			
			return Enumeration.getElementByValue(top ^ right ^ bottom ^ left, TileType) as TileType;
		}
		
		/**
		 *  Removing unnecessary tiles
		 */
		private function removeDestroyedTiles():void
		{
			for (var y:int = 0; y < _map.length; y++)
			{
				for (var x:int = 0; x < _map[0].length; x++)
				{
					if (_map[y][x] == -1)
					{
						_tileLayer.removeChild(_gameObjects["tile_" + y + x]);
						_map[y][x] = -2;
					}
				}
			}
		}
		
		//
		// EVENT HANDLERS
		//
		
		/**
		 *  Handler of clicking on play ground which starts the explosion
		 */
		private function board_onMouseDownHandler(event:MouseEvent):void
		{
			if (_tileID > -1)
			{
				const block:Rectangle = MapManager.defineBlock(_map, _tileID);
				const blasts:Vector.<Rectangle> = MapManager.getBlastCoords(block);
				var blast:AnimatedObject;
				
				for (var i:int = 0; i < blasts.length; i++)
				{
					if (blasts[i].width > 1)
						blast = new AnimatedObject(assets[Assets.BIG_BLAST], blasts[i], Math.random() * 500);
					else
						blast = new AnimatedObject(assets[Assets.SMALL_BLAST], blasts[i], Math.random() * 500);
					blast.addEventListener(Event.ACTIVATE, blast_onActivateHandler);
					blast.addEventListener(Event.COMPLETE, blast_onCompleteHandler);
					MapManager.populateBlock(blasts[i], _map, -1);
					removeDestroyedTiles();
					blast.x = (CELL_WIDTH / 2) * (blasts[i].x - blasts[i].y) + _offsetX;
					blast.y = (CELL_HEIGHT / 2) * (blasts[i].x + blasts[i].y);
					
					_actionLayer.addChild(blast);
				}
				
				const ground:Sprite = getBlockGround(block);
				ground.x = (CELL_WIDTH / 2) * (block.x - block.y) + _offsetX;
				ground.y = (CELL_HEIGHT / 2) * (block.x + block.y);
				_groundLayer.addChild(ground);
			}
		}
		
		/**
		 *  Handler of mouse moving over the play ground
		 */
		private function board_onMouseMoveHandler(event:MouseEvent):void
		{
			const ty:Number = ((CELL_WIDTH / CELL_HEIGHT) * event.localY - (event.localX - _offsetX)) / 2;
			const tx:Number = (event.localX - _offsetX) + ty;
			
			_yp = Math.round(ty / (CELL_WIDTH / 2));
			_xp = Math.round(tx / (CELL_WIDTH / 2)) - 1;
		}
		
		/**
		 *  Handler of time tick
		 */
		private function board_onEnterFrameHandler(event:Event):void
		{
			var y:int, x:int;
			const col:int = _map.length;
			const row:int = _map[0].length;
			if (_yp < _map.length && _xp < _map[0].length && _yp > -1 && _xp > -1)
			{
				const id:int = _map[_yp][_xp];
				if (_tileID != id)
				{
					for (y = 0; y < col; y++)
					{
						for (x = 0; x < row; x++)
						{
							Tile(_gameObjects["tile_" + y + x]).showHighlight(false);
							if (id == _map[y][x])
								Tile(_gameObjects["tile_" + y + x]).showHighlight(true);
						}
					}
					_tileID = id;
				}
			}
			else
			{
				if (_tileID > -1)
				{
					for (y = 0; y < col; y++)
					{
						for (x = 0; x < row; x++)
						{
							Tile(_gameObjects["tile_" + y + x]).showHighlight(false);
						}
					}
					_tileID = -1;
				}
			}
		}
		
		/**
		 *  Trigerred when exlopsion starts playing
		 */
		private function blast_onActivateHandler(event:Event):void
		{
			const tile:TileObject = event.target as TileObject;
			var xpos:Number, ypos:Number, debris:Sprite, garbage:Sprite;
			
			if (tile.block.width > 1)
			{
				debris = new StaticObject(assets[Assets.BIG_DEBRIS], tile.block);
				garbage = Math.random() > .5 ? new StaticObject(assets[Assets.GARBAGE], tile.block) : null;
			}
			else
				debris = new StaticObject(assets[Assets.SMALL_DEBRIS], tile.block);
			
			xpos = debris.x = tile.x;
			ypos = debris.y = tile.y;
			
			if (garbage)
			{
				garbage.x = xpos;
				garbage.y = ypos;
				_actionLayer.addChildAt(garbage, 0);
			}
			
			_actionLayer.addChildAt(debris, 0);
		}
		
		/**
		 *  Trigerred when exlopsion stops playing
		 */
		private function blast_onCompleteHandler(event:Event):void
		{
			const blast:AnimatedObject = AnimatedObject(event.target);
			blast.removeEventListener(Event.ACTIVATE, blast_onActivateHandler);
			blast.removeEventListener(Event.COMPLETE, blast_onCompleteHandler);
			_actionLayer.removeChild(blast);
		}
	}
}