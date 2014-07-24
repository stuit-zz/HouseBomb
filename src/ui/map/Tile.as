package ui.map
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import enums.TileType;
	
	public class Tile extends Sprite
	{
		// UI OBJECTS
		private const _highlight:Shape = new Shape();
		
		// Tile wall type
		private var _type:TileType;
		
		/**
		 *  Map tile object
		 */
		public function Tile()
		{
			super();
			initTile();
		}
		
		//
		// GETTER/SETTERS
		//
		
		/**
		 *  Tile type
		 */
		public function get type():TileType
		{
			return _type;
		}
		
		public function set type(t:TileType):void
		{
			_type = t;
			
			graphics.lineStyle(1, 0, .2);
			if (_type == TileType.TOP_LEFT || 
				_type == TileType.TOP_CENTER ||
				_type == TileType.TOP_RIGHT ||
				_type == TileType.TOP_CAP ||
				_type == TileType.RIGHT_CAP ||
				_type == TileType.SOLID_TILE)
			{
				graphics.beginFill(0, .2);
				graphics.moveTo(Board.CELL_WIDTH / 2, 0);
				graphics.lineTo(Board.CELL_WIDTH, Board.CELL_HEIGHT / 2);
				graphics.lineTo(Board.CELL_WIDTH, 0);
				graphics.lineTo(Board.CELL_WIDTH / 2, -Board.CELL_HEIGHT / 2);
				graphics.endFill();
			}
			
			if (_type == TileType.TOP_RIGHT ||
				_type == TileType.MID_RIGHT ||
				_type == TileType.BOTTOM_RIGHT ||
				_type == TileType.TOP_CAP ||
				_type == TileType.RIGHT_CAP ||
				_type == TileType.BOTTOM_CAP ||
				_type == TileType.SOLID_TILE)
			{
				graphics.beginFill(0, .2);
				graphics.moveTo(Board.CELL_WIDTH, Board.CELL_HEIGHT / 2);
				graphics.lineTo(Board.CELL_WIDTH / 2, Board.CELL_HEIGHT);
				graphics.lineTo(Board.CELL_WIDTH / 2, Board.CELL_HEIGHT / 2);
				graphics.lineTo(Board.CELL_WIDTH, 0);
				graphics.endFill();
			}
			
			if (_type == TileType.BOTTOM_RIGHT ||
				_type == TileType.BOTTOM_CENTER ||
				_type == TileType.BOTTOM_LEFT ||
				_type == TileType.RIGHT_CAP ||
				_type == TileType.BOTTOM_CAP ||
				_type == TileType.LEFT_CAP ||
				_type == TileType.SOLID_TILE)
			{
				graphics.beginFill(0, .2);
				graphics.moveTo(Board.CELL_WIDTH / 2, Board.CELL_HEIGHT);
				graphics.lineTo(0, Board.CELL_HEIGHT / 2);
				graphics.lineTo(0, 0);
				graphics.lineTo(Board.CELL_WIDTH / 2, Board.CELL_HEIGHT / 2);
				graphics.endFill();
			}
			
			if (_type == TileType.TOP_LEFT ||
				_type == TileType.MID_LEFT ||
				_type == TileType.BOTTOM_LEFT ||
				_type == TileType.BOTTOM_CAP ||
				_type == TileType.LEFT_CAP ||
				_type == TileType.TOP_CAP ||
				_type == TileType.SOLID_TILE)
			{
				graphics.beginFill(0, .2);
				graphics.moveTo(0, Board.CELL_HEIGHT / 2);
				graphics.lineTo(Board.CELL_WIDTH / 2, 0);
				graphics.lineTo(Board.CELL_WIDTH / 2, -Board.CELL_HEIGHT / 2);
				graphics.lineTo(0, 0);
				graphics.endFill();
			}
		}
		
		//
		// PUBLIC METHODS
		//
		
		/**
		 *  Show/hide tile highlight
		 */
		public function showHighlight(show:Boolean):void
		{
			_highlight.visible = show;
		}
		
		//
		// PRIVATE METHODS
		//
		
		/**
		 *  Initialize with highlight graphic
		 */
		private function initTile():void
		{
			_highlight.graphics.lineStyle(0, 0, 0);
			_highlight.graphics.beginFill(0xffffff, .5);
			_highlight.graphics.moveTo(Board.CELL_WIDTH / 2, 0);
			_highlight.graphics.lineTo(Board.CELL_WIDTH, Board.CELL_HEIGHT / 2);
			_highlight.graphics.lineTo(Board.CELL_WIDTH / 2, Board.CELL_HEIGHT);
			_highlight.graphics.lineTo(0, Board.CELL_HEIGHT / 2);
			_highlight.graphics.endFill();
			_highlight.visible = false;
			this.addChild(_highlight);
		}
	}
}