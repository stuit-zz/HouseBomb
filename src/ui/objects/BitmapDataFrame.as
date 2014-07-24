package ui.objects
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class BitmapDataFrame
	{
		// PUBLIC PROPS
		public var data:BitmapData;
		public var origin:Point;
		
		/**
		 *  Object for containing information about game object's bitmap data and coorditates in game map
		 * 	data: game object bitmap data
		 * 	origin: coordinate in game map
		 */
		public function BitmapDataFrame(data:BitmapData, origin:Point)
		{
			this.data = data;
			this.origin = origin;
		}
	}
}