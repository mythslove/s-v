package local.map
{
	import bing.iso.IsoObject;
	
	import flash.geom.Point;
	
	import local.enum.BuildingType;
	import local.map.item.Car;
	import local.map.item.Character;
	import local.map.item.Road;
	import local.util.EmbedsManager;
	import local.vo.BaseBuildingVO;
	import local.vo.BuildingVO;

	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld {
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//-----------------------------------------------------------------
		private var _mouseMovePoint:Point=new Point();
		
		/** 初始化地图 */
		override protected function initMap():void
		{
			var baseVO:BaseBuildingVO = new BaseBuildingVO();
			baseVO.name = "Maple Leaves Road";
			baseVO.type = BuildingType.ROAD ;
			var roadVO:BuildingVO = new BuildingVO();
			roadVO.baseVO = baseVO ;
			roadVO.name = "Maple Leaves Road";
			
			var road:Road ;
			for( var i:int = 0 ; i<3; ++i){
				for ( var j:int = 0 ; j<3;++j){
					road = new Road(roadVO);
					road.nodeX = i ;
					road.nodeZ =  j ;
					roadScene.addRoad( road , false , false );
				}
			}
			
			
			for( i = 4 ; i<6; ++i){
				road = new Road(roadVO);
				road.nodeX = i ;
				road.nodeZ = 0 ;
				roadScene.addRoad( road , false , false );
			}
			//
			road = new Road(roadVO);
			road.nodeX = 1 ;
			road.nodeZ = 3 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 5 ;
			road.nodeZ = 3 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 6 ;
			road.nodeZ = 2 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 6 ;
			road.nodeZ = 3 ;
			roadScene.addRoad( road , false , false );
			road = new Road(roadVO);
			road.nodeX = 7 ;
			road.nodeZ = 3 ;
			roadScene.addRoad( road , false , false );
			road = new Road(roadVO);
			road.nodeX = 8 ;
			road.nodeZ = 3 ;
			roadScene.addRoad( road , false , false );
			road = new Road(roadVO);
			road.nodeX = 7 ;
			road.nodeZ = 4 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 7 ;
			road.nodeZ = 4 ;
			roadScene.addRoad( road, false , false  );
			//
			var temp:Road; 
			for( i = 1 ; i<4; ++i){
				for ( j =4 ; j<7;++j){
					road = new Road(roadVO);
					road.nodeX = i ;
					road.nodeZ =  j ;
					if(i==2&&j==5){
						temp = road ;
					}
					roadScene.addRoad( road, false , false  );
				}
			}
			roadScene.removeRoad(temp);
			//
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 7 ;
			road.nodeZ = 7 ;
			roadScene.addRoad( road , false , false  );
			
			var roads:Array =[];
			for each( var obj:IsoObject in roadScene.children)
			{
				if(obj is Road){
					road = obj as Road ;
					if(road ){
						roads.push( road );
					}
				}
			}
			
			
			for( i = 0 ; i<roads.length ; ++i)
			{
				if(Math.random()>0.6){
					road = roads[i];
					var fairy:Character = new Character( EmbedsManager.instance.getAnimResVOByName("Fairy")[0] );
					fairy.nodeX  = road.nodeX;
					fairy.nodeZ = road.nodeZ;
					buildingScene.addIsoObject( fairy , false ) ;
					fairy.init();
				}else if(Math.random()>0.6){
					road = roads[i];
					var car:Car = new Car( EmbedsManager.instance.getAnimResVOByName("Truck")[0] );
					car.nodeX  = road.nodeX;
					car.nodeZ = road.nodeZ;
					buildingScene.addIsoObject( car , false ) ;
					car.init();
				}
			}
			
			roadScene.updateAllUI();
			buildingScene.sortAll();
			
			run() ;
		}
		
	}
}