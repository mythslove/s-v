package utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import views.CenterViewContainer;

	/**
	 * 鼠标管理 ，物品跟随鼠标移动
	 * @author zhouzhanglin
	 */	
	public class MouseManager
	{
		private static var _instance:MouseManager ;
		public static function get instance():MouseManager
		{
			if(!_instance) _instance = new MouseManager();
			return _instance ;
		}
		//================================
		
		public const OFFSET:int = 10 ;
		
		private var _currentMouse:DisplayObject ;
		
		/**
		 * 添加跟随鼠标移动的icon 
		 * @param icon
		 */		
		public function addMouseIcon( icon:DisplayObject ):void
		{
			removeMouseIcon();
			if( CenterViewContainer.instance.stage)
			{
				_currentMouse = icon ;
				CenterViewContainer.instance.stage.addChild( _currentMouse );
				CenterViewContainer.instance.stage.addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			}
		}
		
		/**
		 * 移除当前跟随鼠标移动的icon 
		 */		
		public function removeMouseIcon():void
		{
			if(_currentMouse&&_currentMouse.parent){
				_currentMouse.parent.removeChild(_currentMouse);
				if(_currentMouse is Bitmap && (_currentMouse as Bitmap).bitmapData){
					(_currentMouse as Bitmap).bitmapData.dispose();
				}
				_currentMouse = null ;
			}
			if( CenterViewContainer.instance.stage) {
				CenterViewContainer.instance.stage.removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			}
		}
		
		private function onEnterFrameHandler(e:Event):void
		{
			if(_currentMouse){
				_currentMouse.x = CenterViewContainer.instance.stage.mouseX+OFFSET ;
				_currentMouse.y = CenterViewContainer.instance.stage.mouseY+OFFSET ;
			}else if( CenterViewContainer.instance.stage) {
				CenterViewContainer.instance.stage.removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			}
		}
	}
}