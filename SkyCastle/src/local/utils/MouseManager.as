package local.utils
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import local.enum.MouseStatus;
	import local.views.CenterViewContainer;
	import local.views.icon.*;

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
		
		private const OFFSET:int = 20 ;
		private var _currentMouse:DisplayObject ;
		private var _mouseStatus:String = MouseStatus.NONE ;
		/**
		 * 获得鼠标当前的状态 
		 * @return 
		 */		
		public function get mouseStatus():String {
			return _mouseStatus;
		}
		
		public function set mouseStatus( value:String ):void
		{
			_mouseStatus = value ;
			switch( value )
			{
				case MouseStatus.NONE :
					removeMouseIcon();
					break ;
				case MouseStatus.ROTATE_BUILDING :
					addMouseIcon( new Bitmap( new RotateIconBitmapData ));
					break ;
				case MouseStatus.UPDATE_HOUSE :
					break ;
				case MouseStatus.STASH_BUILDING :
					addMouseIcon( new Bitmap( new StashIconBitmapData ));
					break ;
				case MouseStatus.SELL_BUILDING :
					addMouseIcon( new Bitmap( new SellIconBitmapData ));
					break ;
				case MouseStatus.BUILD_BUILDING :
					break ;
				case MouseStatus.MOVE_BUILDING :
					addMouseIcon(new Bitmap( new MoveIconBitmapData ));
					break ;
				case MouseStatus.BEAT_STONE :
					break ;
				case MouseStatus.CUT_TREES :
					break ;
				case MouseStatus.EARN_COIN :
					break ;
				case MouseStatus.SHOVEL_BUILDING :
					break ;
			}
		}
		
		/**
		 * 判断当前是操作建筑的状态
		 * @return
		 */		
		public function checkControl():Boolean
		{
			if( _mouseStatus==MouseStatus.MOVE_BUILDING || 
				mouseStatus==MouseStatus.UPDATE_HOUSE ||
				mouseStatus==MouseStatus.ROTATE_BUILDING||
				mouseStatus==MouseStatus.SELL_BUILDING||
				mouseStatus==MouseStatus.STASH_BUILDING)
			{
				return true ;
			}
			return false ;
		}
		
		/**
		 * 添加跟随鼠标移动的icon 
		 * @param icon
		 */		
		private function addMouseIcon( icon:DisplayObject ):void
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
		private function removeMouseIcon():void
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