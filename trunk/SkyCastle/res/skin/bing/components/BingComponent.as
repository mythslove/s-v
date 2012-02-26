package bing.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	 

	/**
	 *
	 * @author chenying
	 *
	 */
	public class BingComponent extends MovieClip 
	{
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