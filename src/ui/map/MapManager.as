package ui.map
{
	import flash.geom.Rectangle;

	public class MapManager
	{
		// PRIVATE CONSTANTS
		private static const MAX_ROW:int = 2;
		private static const MAX_COL:int = 4;
		
		//
		// PUBLIC STATIC METHODS
		//
		
		/**
		 *  Generate 2D Vector map
		 * 	col: number of columns in map
		 * 	row: number of rows in map
		 */
		public static function generateMap(col:int, row:int):Vector.<Vector.<int>>
		{
			const map:Vector.<Vector.<int>> = cleanMap(col, row);
			const rect:Rectangle = new Rectangle();
			const block:Rectangle = new Rectangle();
			var counter:int = 0;
			
			for (var y:int = 0; y < col; y++)
			{
				for (var x:int = 0; x < row; x++)
				{
					if (map[y][x] == 0)
					{
						counter++;
						defineRect(rect, map, y, x);
						generateBlock(block, rect);
						populateBlock(block, map, counter);
					}
				}
			}
			return map;
		}
		
		/**
		 *  Define cooridantes of explosions
		 * 	block: rect of detonating area
		 */
		public static function getBlastCoords(block:Rectangle):Vector.<Rectangle>
		{
			const blasts:Vector.<Rectangle> = new Vector.<Rectangle>();
			const blockMap:Vector.<Vector.<int>> = cleanMap(block.height, block.width);
			const rect:Rectangle = new Rectangle();
			const blast:Rectangle = new Rectangle();
			const col:int = block.height;
			const row:int = block.width;
			var counter:int = 0;
			for (var y:int = 0; y < col; y++)
			{
				for (var x:int = 0; x < row; x++)
				{
					if (blockMap[y][x] == 0)
					{
						counter++;
						defineRect(rect, blockMap, y, x);
						generateBlock(blast, rect, 2, 2);
						populateBlock(blast, blockMap, counter);
						blasts.push(new Rectangle(block.x + blast.x, block.y + blast.y, blast.width, blast.height));
					}
				}
			}
			return blasts;
		}
		
		/**
		 *  Define block regarding provided 'id'
		 * 	map: search area
		 * 	id: searched ID
		 */
		public static function defineBlock(map:Vector.<Vector.<int>>, id:int):Rectangle
		{
			const rect:Rectangle = new Rectangle();
			for (var y:int = 0; y < map.length; y++)
			{
				for (var x:int = 0; x < map[0].length; x++)
				{
					if (id == map[y][x])
					{
						defineRect(rect, map, y, x, id);
						return rect;
					}
				}
			}
			return null;
		}
		
		/**
		 *  Populate provided rect with ID
		 * 	block: rect with coordinates
		 * 	map: area
		 * 	id: ID with which rect in area will be populated
		 */
		public static function populateBlock(block:Rectangle, map:Vector.<Vector.<int>>, id:int):void
		{
			for (var y:int = block.y; y < block.height + block.y; y++)
			{
				for (var x:int = block.x; x < block.width + block.x; x++)
				{
					map[y][x] = id;
				}
			}
		}
		
		/**
		 *  Returns a clean map with provided dimensions
		 * 	col: number of columns in map
		 * 	row: number of rows in map
		 */
		public static function cleanMap(col:int, row:int):Vector.<Vector.<int>>
		{
			const vec:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(col, true);
			for (var i:int = 0; i < col; i++)
				vec[i] = new Vector.<int>(row, true);
			return vec;
		}
		
		//
		// PRIVATE STATIC METHODS
		//
		
		/**
		 *  Define rect of provided ID in area
		 */
		private static function defineRect(rect:Rectangle, map:Vector.<Vector.<int>>, ypos:int, xpos:int, id:int = 0):void
		{
			rect.y = ypos;
			rect.x = xpos;
			rect.height = map.length - ypos;
			rect.width = map[0].length - xpos;
			for (var y:int = ypos; y < map.length; y++)
			{
				if (map[y][xpos] != id)
				{
					rect.height = y - ypos;
					break;
				}
			}
			for (var x:int = xpos; x < map[ypos].length; x++)
			{
				if (map[ypos][x] != id)
				{
					rect.width = x - xpos;
					break;
				}
			}
		}
		
		/**
		 *  Generate a block according to max and random dimensions in provided rect
		 * 	block: generated block
		 * 	rect: area
		 * 	maxCol: maximum column of block
		 * 	maxRow: maximum row of block
		 */
		private static function generateBlock(block:Rectangle, rect:Rectangle, maxCol:int = MAX_COL, maxRow:int = MAX_ROW):void
		{
			block.x = rect.x;
			block.y = rect.y;
			
			if (Math.random() > .5)
			{
				block.width = Math.ceil(Math.random() * Math.min(Math.min(rect.width, maxCol), rect.height));
				block.height = block.width > 1 ? maxRow : 1;
			}
			else
			{
				block.height = Math.ceil(Math.random() * Math.min(Math.min(rect.height, maxCol), rect.width));
				block.width = block.height > 1 ? maxRow : 1;
			}
		}
	}
}