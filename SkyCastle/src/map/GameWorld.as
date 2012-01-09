package map
{
	import comm.GameData;
	import comm.GameSetting;
	
	import flash.events.Event;

	/**
	 * 游戏世界  
	 * @author zzhanglin
	 */	
	public class GameWorld extends BaseWorld
	{
		protected static var _instance:GameWorld;
		public static function get instance():GameWorld
		{
			if(!_instance) _instance= new GameWorld();
			return _instance ;
		}
		//=====================================

		
		/**
		 * 游戏世界构造函数 
		 */		
		public function GameWorld()
		{
			super();
			if(_instance) throw new Error("只能实例化一个GameWorld");
			else _instance = this ;
		}
		
		
		
		/**
		 * 运行 
		 */		
		public function start():void{
			this.removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			this.addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		/**
		 * 停止 
		 */		
		public function stop():void {
			this.removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		/**
		 *不断地执行 
		 * @param e
		 */		
		protected function onEnterFrameHandler(e:Event):void
		{
			GameData.mouseBuilding = null ;
			update() ;
		}
		
		
		/**
		 * 地图放大和缩小 
		 * @param scale
		 */		
		public function zoom( scale:Number):void
		{
			var dx:Number=scaleX<1?-GameSetting.SCREEN_WIDTH:GameSetting.SCREEN_WIDTH ;
			var dy:Number=scaleX<1?-GameSetting.SCREEN_HEIGHT:GameSetting.SCREEN_HEIGHT ;
			scaleX = scaleY = scale ;
			x+=dx;
			y+=dy;
			modifyMapPosition();
		}
		
	}
}