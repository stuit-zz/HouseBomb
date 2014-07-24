package ui.objects
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	public class AnimatedObject extends TileObject
	{
		// OPERATIONAL PROPS
		private var _isPlaying:Boolean = false;
		private var _currentFrame:int = 0;
		private var _delay:Number = 0;
		
		/**
		 *  Class for creating animated game object
		 * 	bitmapDatas: collection of information about object
		 * 	block: coordinate and dimensions in game map
		 * 	delay: pause before starting animation
		 */
		public function AnimatedObject(bitmapDatas:Vector.<BitmapDataFrame>, block:Rectangle, delay:Number = 0)
		{
			super(block);
			
			var img:Bitmap;
			for (var i:int = 0; i < bitmapDatas.length; i++)
			{
				if (!bitmapDatas[i])
					continue;
				
				img = new Bitmap(bitmapDatas[i].data);
				img.x = bitmapDatas[i].origin.x;
				img.y = bitmapDatas[i].origin.y;
				img.visible = false;
				this.addChild(img);
			}
			_delay = delay;
			
			addEventListener(Event.ADDED_TO_STAGE, anim_onAddedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, anim_onRemovedFromStageHandler);
		}
		
		//
		// PRIVATE METHODS
		//
		
		private function startAnimation():void
		{
			dispatchEvent(new Event(Event.ACTIVATE));
			addEventListener(Event.ENTER_FRAME, anim_onEnterFrameHandler);
		}
		
		//
		// HANDLER METHODS
		//
		
		/**
		 *  Animation tick
		 */
		private function anim_onEnterFrameHandler(event:Event):void
		{
			if (_isPlaying)
			{
				if (_currentFrame > 0)
					this.getChildAt(_currentFrame - 1).visible = false;
				if (this.numChildren > 0)
					this.getChildAt(_currentFrame).visible = true;
				_currentFrame++;
				
				if (_currentFrame >= this.numChildren)
				{
					_isPlaying = false;
					this.removeChildren();
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
		/**
		 *  Trigerred when added to stage
		 */
		private function anim_onAddedToStageHandler(event:Event):void
		{
			_isPlaying = true;
			setTimeout(startAnimation, _delay);
		}
		
		/**
		 *  Trigerred when removed from stage
		 */
		private function anim_onRemovedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, anim_onEnterFrameHandler);
			removeEventListener(Event.ADDED_TO_STAGE, anim_onAddedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, anim_onRemovedFromStageHandler);
		}
	}
}