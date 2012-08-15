package bing.components
{
	import bing.components.tooltip.ToolTipStage;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	 

	/**
	 *
	 * @author chenying
	 *
	 */
	public class BingComponent extends MovieClip 
	{
	
		
		protected var _toolTipText:String = "";

		/**
		 * 构造函数
		 * @param _icon
		 *
		 */
		public function BingComponent()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, eventHandler);
		}

		public function get toolTipText():String
		{
			return _toolTipText;
		}

		public function set toolTipText(value:String):void
		{
			_toolTipText = value;
		}

		private function eventHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, eventHandler);
			addedToStage();
		}


		protected function addedToStage():void
		{
			
		}

	 
	}
}