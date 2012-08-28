package local.game
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import local.comm.GameSetting;
	import local.game.iso.BaseBuilding;

	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld {
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//-----------------------------------------------------------------
		private var _mouseMovePoint:Point=new Point();
		
		override protected function configListeners():void
		{
			super.configListeners();
			
			
			for( var i:int = 0 ; i<GameSetting.GRID_X ; ++i){
				for( var j:int = 0 ; j<GameSetting.GRID_Z ; ++j){
					if(i%2==0 && j%2==0 ){
						var flag:Number = Math.random() ;
						if(flag>0.7){
							var bb:BaseBuilding = new BaseBuilding("Building Ball");
						}else if(flag>0.35){
							bb = new BaseBuilding("Modify Building");
						}else{
							bb = new BaseBuilding("Tree");
						}
						bb.nodeX = i ;
						bb.nodeZ = j ;
						buildingScene.addIsoObject( bb , false );
					}
				}
			}
			buildingScene.sortAll();
			run();
		}
		
		public function run():void
		{
			_endX =x ;
			_endY = y ;
			y++;
			if(!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		public function stopRun():void
		{
			if(hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		private function onEnterFrameHandler(e:Event):void
		{
			update();
			if(x!=_endX){
				x += ( _endX-x)*0.36 ;
			}
			if(y!=_endY){
				y += (_endY-y)*0.36 ;
			}
		}
		
		
	}
}