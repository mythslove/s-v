package bing.components.utils
{
	import flash.display.Shape;
	import flash.events.Event;
	
	import bing.components.interfaces.IUIAnimation;

	/**
	 * UI的动画管理类 
	 * @author zhouzhanglin
	 */	
	public class UIAniManager
	{
		private static var _instance:UIAniManager;
		public static function get instance():UIAniManager
		{
			if(!_instance) _instance = new UIAniManager();
			return _instance ;
		}
		
		private var _aniArray:Vector.<IUIAnimation> ;
		private var _obj:Shape ;
		public function UIAniManager()
		{
			_obj = new Shape();
			_aniArray = new Vector.<IUIAnimation>();
			_obj.addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		private function onEnterFrameHandler( e:Event ):void
		{
			var len:int = _aniArray.length ;
			for( var i:int = 0 ; i<len ; ++i){
				_aniArray[i].update();
			}
		}
		
		/** 添加动画视图 */
		public function addAniView( ui:IUIAnimation):void
		{
			_aniArray.push( ui );
		}
		
		/** 移除动画视图 */
		public function removeAniView( ui:IUIAnimation ):void
		{
			for( var i:int = 0 ; i<ui ; ++i){
				if( _aniArray[i]==ui ){
					_aniArray.splice( i  , 1 );
					break ;
				}
			}
		}
	}
}