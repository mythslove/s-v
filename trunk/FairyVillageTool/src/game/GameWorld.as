package game
{
	import bing.iso.IsoGrid;
	import bing.iso.IsoScene;
	import bing.iso.IsoUtils;
	import bing.iso.IsoWorld;
	
	import comm.GameSetting;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	public class GameWorld extends IsoWorld
	{
		public var roadScene:RoadScene;
		
		public function GameWorld()
		{
			super(3000,2000,GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.SIZE);
			mouseEnabled = mouseChildren = false ;
			this.panTo(500 , 60);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			var gridScene:IsoScene = new IsoScene(GameSetting.SIZE);
			(gridScene.addChild( new IsoGrid(GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.SIZE)) as IsoGrid).render() ;
			gridScene.cacheAsBitmap=true;
			addScene(gridScene);
			
			roadScene = new RoadScene();
			addScene(roadScene);
		}
	
		
		public function showRoad( url:String , alias:String ):void
		{
			var road:Road ;
			for( var i:int = 0 ; i<3; ++i){
				for ( var j:int = 0 ; j<3;++j){
					road = new Road(url,alias);
					road.nodeX = i ;
					road.nodeZ =  j ;
					roadScene.addBuilding( road );
				}
			}
			for( i = 4 ; i<6; ++i){
				road = new Road(url,alias);
				road.nodeX = i ;
				road.nodeZ = 0 ;
				roadScene.addBuilding( road );
			}
			//
			road = new Road(url,alias);
			road.nodeX = 5 ;
			road.nodeZ = 3 ;
			roadScene.addBuilding( road );
			road = new Road(url,alias);
			road.nodeX = 6 ;
			road.nodeZ = 2 ;
			roadScene.addBuilding( road );
			road = new Road(url,alias);
			road.nodeX = 6 ;
			road.nodeZ = 3 ;
			roadScene.addBuilding( road );
			road = new Road(url,alias);
			road.nodeX = 7 ;
			road.nodeZ = 3 ;
			roadScene.addBuilding( road );
			road = new Road(url,alias);
			road.nodeX = 8 ;
			road.nodeZ = 3 ;
			roadScene.addBuilding( road );
			road = new Road(url,alias);
			road.nodeX = 7 ;
			road.nodeZ = 4 ;
			roadScene.addBuilding( road );
			road = new Road(url,alias);
			road.nodeX = 7 ;
			road.nodeZ = 4 ;
			roadScene.addBuilding( road );
			//
			var temp:Road; 
			for( i = 1 ; i<4; ++i){
				for ( j =4 ; j<7;++j){
					road = new Road(url,alias);
					road.nodeX = i ;
					road.nodeZ =  j ;
					if(i==2&&j==5){
						temp = road ;
					}
					roadScene.addBuilding( road );
				}
			}
			roadScene.removeBuilding(temp);
			//
			roadScene.addBuilding( road );
			road = new Road(url,alias);
			road.nodeX = 7 ;
			road.nodeZ = 7 ;
			roadScene.addBuilding( road );
			
			roadScene.sortAll();
		}
	}
}