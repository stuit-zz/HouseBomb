package
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import ui.objects.BitmapDataFrame;

	public class AssetManager
	{
		private static var _instance:AssetManager;
		private const _assets:Dictionary = new Dictionary(true);
		
		public function AssetManager(enforcer:SingletonEnforcer)
		{
		}
		
		//
		// GETTER METHODS
		//
		
		public static function get instance():AssetManager
		{
			if (!_instance)
				_instance = new AssetManager(new SingletonEnforcer());
			return _instance;
		}
		
		public function get assets():Dictionary
		{
			return _assets;
		}
		
		//
		// PUBLIC METHODS
		//
		
		/**
		 *  Parsing loaded assets library
		 */
		public function parseSWF(loader:LoaderInfo):void
		{
			const defs:Vector.<String> = loader.applicationDomain.getQualifiedDefinitionNames();
			var classObj:Class, classInst:Object, assetObj:Object;
			for (var i:int = 0; i < defs.length; i++)
			{
				classObj = loader.applicationDomain.getDefinition(defs[i]) as Class;
				classInst = new classObj();
				if (classInst is MovieClip && MovieClip(classInst).totalFrames > 1)
					assetObj = extractMovieClip(classInst as MovieClip);
				else if (classInst is Sprite)
					assetObj = rasterizeSprite(classInst as Sprite);
				else
					assetObj = classObj;
				_assets[defs[i]] = assetObj;
			}
		}
		
		/**
		 *  Get graphics for simple button
		 */
		public function getSimpleButtonState(text:String, clr:uint, al:Number, w:Number, h:Number, cornerRad:int = 0):DisplayObject
		{
			const state:Sprite = new Sprite();
			state.graphics.beginFill(clr, al);
			state.graphics.drawRoundRect(0, 0, w, h, cornerRad, cornerRad);
			state.graphics.endFill();
			const label:TextField = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.defaultTextFormat = new TextFormat("Arial", 20, 0x222222, true);
			label.text = text;
			label.x = w / 2 - label.width / 2;
			label.y = h / 2 - label.height / 2;
			state.addChild(label);
			return state;
		}
		
		//
		// PRIVATE METHODS
		//
		
		/**
		 *  Slicing movieclip frames into bitmap datas and creates BitmapDataFrames
		 * 	mc: animated movieclip
		 */
		private function extractMovieClip(mc:MovieClip):Vector.<BitmapDataFrame>
		{
			const bmds:Vector.<BitmapDataFrame> = new Vector.<BitmapDataFrame>(mc.totalFrames, true);
			var bmd:BitmapData, rect:Rectangle, bmdFrame:BitmapDataFrame;
			for (var i:int = 0; i < mc.totalFrames; i++, mc.nextFrame())
			{
				if (mc.width && mc.height)
				{
					rect = mc.getBounds(mc);
					bmd = new BitmapData(mc.width, mc.height, true, 0);
					bmd.draw(mc, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
					bmdFrame = new BitmapDataFrame(bmd, new Point(rect.x, rect.y));
					bmds[i] = bmdFrame;
				}
			}
			return bmds;
		}
		
		/**
		 *  Creates bitmap data from Sprite object and returns BitmapDataFrame
		 * 	sprt: flat graphical object
		 */
		private function rasterizeSprite(sprt:Sprite):BitmapDataFrame
		{
			const rect:Rectangle = sprt.getBounds(sprt);
			const bmd:BitmapData = new BitmapData(sprt.width, sprt.height, true, 0);
			bmd.draw(sprt, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
			const bmdFrame:BitmapDataFrame = new BitmapDataFrame(bmd, new Point(rect.x, rect.y));
			return bmdFrame;
		}
	}
}
internal class SingletonEnforcer{}