package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import ui.map.Board;
	import ui.map.MapManager;
	
	[SWF(width="640",height="412")]
	public class HouseBomb extends Sprite
	{
		// SHORTCUT TO ASSETS
		private var assets:Dictionary;
		
		// GAME OBJECTS
		private var board:Board;
		
		public function HouseBomb()
		{
			loadAssets();
		}
		
		//
		// PRIVATE METHODS
		//
		
		/**
		 *  Creating background, generating map and building play area
		 */
		private function init():void
		{
			const pgBD:BitmapData = new assets[Assets.PLAY_GROUND]();
			const pg:Bitmap = new Bitmap(pgBD);
			this.addChild(pg);
			
			board = new Board(4, 4);
			board.build();
			board.x = 218;
			board.y = 139;
			this.addChild(board);
			
			const upState:DisplayObject = AssetManager.instance.getSimpleButtonState("Reset", 0xffffff, 0.3, 80, 40, 15);
			const downState:DisplayObject = AssetManager.instance.getSimpleButtonState("Reset", 0xffffff, 0.5, 80, 40, 15);
			const resetBtn:SimpleButton = new SimpleButton(upState, upState, downState, upState);
			resetBtn.addEventListener(MouseEvent.CLICK, resetBtn_onClickHandler);
			resetBtn.x = stage.stageWidth - 100;
			resetBtn.y = stage.stageHeight - 60;
			this.addChild(resetBtn);
		}
		
		/**
		 *  Loading assets file from {root}/assets/assets.swf
		 */
		private function loadAssets():void
		{
			const request:URLRequest = new URLRequest("assets.swf");
			const loader:Loader = new Loader();
			loader.load(request);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, assets_onLoadCompleteHandler);
		}
		
		//
		// EVENT HANDLERS
		//
		
		/**
		 *  Assets loading completed
		 */
		private function assets_onLoadCompleteHandler(event:Event):void
		{
			AssetManager.instance.parseSWF(event.target as LoaderInfo);
			assets = AssetManager.instance.assets;
			init();
		}
		
		private function resetBtn_onClickHandler(event:MouseEvent):void
		{
			board.reset();
		}
	}
}