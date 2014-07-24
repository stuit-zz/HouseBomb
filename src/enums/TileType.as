package enums
{
	import utils.UintEnumeration;
	
	public class TileType extends UintEnumeration
	{
		public static const TOP_LEFT:TileType = new TileType(1 ^ 0 ^ 0 ^ 8); // 9
		public static const TOP_CENTER:TileType = new TileType(1 ^ 0 ^ 0 ^ 0); // 1
		public static const TOP_RIGHT:TileType = new TileType(1 ^ 2 ^ 0 ^ 0); // 3
		public static const MID_LEFT:TileType = new TileType(0 ^ 0 ^ 0 ^ 8); // 8
		public static const MID_RIGHT:TileType = new TileType(0 ^ 2 ^ 0 ^ 0); // 2
		public static const BOTTOM_LEFT:TileType = new TileType(0 ^ 0 ^ 4 ^ 8); // 12
		public static const BOTTOM_CENTER:TileType = new TileType(0 ^ 0 ^ 4 ^ 0); // 4
		public static const BOTTOM_RIGHT:TileType = new TileType(0 ^ 2 ^ 4 ^ 0); // 6
		public static const LEFT_CAP:TileType = new TileType(1 ^ 0 ^ 4 ^ 8); // 13
		public static const TOP_CAP:TileType = new TileType(1 ^ 2 ^ 0 ^ 8); // 11
		public static const RIGHT_CAP:TileType = new TileType(1 ^ 2 ^ 4 ^ 0); // 7
		public static const BOTTOM_CAP:TileType = new TileType(0 ^ 2 ^ 4 ^ 8); // 14
		public static const SOLID_TILE:TileType = new TileType(1 ^ 2 ^ 4 ^ 8); // 15
		
		public function TileType(val:uint)
		{
			value = val;
			super();
		}
	}
}