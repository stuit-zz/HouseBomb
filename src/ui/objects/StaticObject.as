package ui.objects
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	public class StaticObject extends TileObject
	{
		/**
		 *  Class for creating static game object
		 * 	data: information regarding image of the object
		 * 	block: coordinate and dimensions in game map
		 */
		public function StaticObject(data:BitmapDataFrame, block:Rectangle)
		{
			super(block);
			
			var img:Bitmap = new Bitmap(data.data);
			img.x = data.origin.x;
			img.y = data.origin.y;
			this.addChild(img);
		}
	}
}