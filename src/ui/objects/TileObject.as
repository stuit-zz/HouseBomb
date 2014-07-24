package ui.objects
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class TileObject extends Sprite
	{
		// PRIVATE PROP
		private var _block:Rectangle;
		
		/**
		 *  Base game object
		 * 	block: coordinate and dimensions in game map
		 */
		public function TileObject(block:Rectangle)
		{
			_block = block;
		}
		
		//
		// GETTER/SETTERS
		//
		
		/**
		 *  Object coordinate and dimensions in game map
		 */
		public function get block():Rectangle
		{
			return _block;
		}
	}
}