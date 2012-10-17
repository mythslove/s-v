package tool.local.map
{
	import bing.iso.IsoGrid;
	import bing.iso.IsoScene;
	import bing.iso.IsoWorld;
	
	import flash.events.Event;
	
	import tool.comm.Setting;
	import tool.local.vos.RoadResVO;
	
	public class RoadWorld extends IsoWorld
	{
		public var roadScene:RoadScene;
		
		public function RoadWorld()
		{
			super(Setting.GRID_X,Setting.GRID_Z,Setting.SIZE);
			mouseEnabled = mouseChildren = false ;
			this.panTo(500 , 60);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			var gridScene:IsoScene = new IsoScene(Setting.SIZE);
			(gridScene.addChild( new IsoGrid(Setting.GRID_X,Setting.GRID_Z,Setting.SIZE)) as IsoGrid).render() ;
			gridScene.cacheAsBitmap=true;
			addScene(gridScene);
			
			roadScene = new RoadScene();
			addScene(roadScene);
		}
		
		public function showRoad( name:String , roadResVO:RoadResVO ):void
		{
			var road:Road ;
			for( var i:int = 0 ; i<3; ++i){
				for ( var j:int = 0 ; j<3;++j){
					road = new Road(name,roadResVO);
					road.nodeX = i ;
					road.nodeZ =  j ;
					roadScene.addBuilding( road );
				}
			}
			for( i = 4 ; i<6; ++i){
				road = new Road(name,roadResVO);
				road.nodeX = i ;
				road.nodeZ = 0 ;
				roadScene.addBuilding( road );
			}
			//
			road = new Road(name,roadResVO);
			road.nodeX = 5 ;
			road.nodeZ = 3 ;
			roadScene.addBuilding( road );
			road = new Road(name,roadResVO);
			road.nodeX = 6 ;
			road.nodeZ = 2 ;
			roadScene.addBuilding( road );
			road = new Road(name,roadResVO);
			road.nodeX = 6 ;
			road.nodeZ = 3 ;
			roadScene.addBuilding( road );
			road = new Road(name,roadResVO);
			road.nodeX = 7 ;
			road.nodeZ = 3 ;
			roadScene.addBuilding( road );
			road = new Road(name,roadResVO);
			road.nodeX = 8 ;
			road.nodeZ = 3 ;
			roadScene.addBuilding( road );
			road = new Road(name,roadResVO);
			road.nodeX = 7 ;
			road.nodeZ = 4 ;
			roadScene.addBuilding( road );
			road = new Road(name,roadResVO);
			road.nodeX = 7 ;
			road.nodeZ = 4 ;
			roadScene.addBuilding( road );
			//
			var temp:Road; 
			for( i = 1 ; i<5; ++i){
				for ( j =4 ; j<9;++j){
					if(i==1|| j==4 || i==4 || j==8)
					{
						road = new Road(name,roadResVO);
						road.nodeX = i ;
						road.nodeZ =  j ;
						roadScene.addBuilding( road );
					}
				}
			}

			//
			roadScene.addBuilding( road );
			road = new Road(name,roadResVO);
			road.nodeX = 7 ;
			road.nodeZ = 7 ;
			roadScene.addBuilding( road );
			
			roadScene.sortAll();
		}
	}
}