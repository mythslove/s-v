package local.map
{
	import local.comm.GameSetting;
	
	import starling.animation.Juggler;
	import starling.events.EnterFrameEvent;

	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld {
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//-----------------------------------------------------------------
		private var _juggle:Juggler = new Juggler() ;
		
		public function GameWorld()
		{
			super();
			addEventListener(EnterFrameEvent.ENTER_FRAME , onEnterFrame );
		}
		
		public function run():void{ 
			_juggle.add(this);
			touchable=true ;
		}
		public function stopRun():void{ 
			_juggle.remove(this);
			touchable=false ;
		}
		
		private function onEnterFrame( e:EnterFrameEvent ):void
		{
			if(runUpdate)	{
//				buildingScene.advanceTime(e.passedTime) ;
			}
			if(x!=_endX) x += ( _endX-x)*_moveSpeed ; //缓动地图
			if(y!=_endY) y += (_endY-y)*_moveSpeed ;
		}
		
		public function expandLand():void
		{
			this.panTo(GameSetting.MAP_WIDTH*0.5,230-(GameSetting.MAX_SIZE-GameSetting.DEFAULT_SIZE) *GameSetting.GRID_SIZE*0.5 );
		}
	}
}