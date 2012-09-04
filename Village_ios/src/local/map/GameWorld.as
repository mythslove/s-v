package local.map
{
	import bing.iso.IsoObject;
	
	import flash.geom.Point;
	
	import local.enum.BuildingType;
	import local.map.item.Building;
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
		
		/** 显示所有的建筑 */
		public function showBuildings():void
		{
			var baseVO:BaseBuildingVO = new BaseBuildingVO();
			baseVO.name = "Default Road";
			baseVO.type = BuildingType.DECO ;
			baseVO.subClass = BuildingType.DECO_ROAD ;
			var roadVO:BuildingVO = new BuildingVO();
			roadVO.baseVO = baseVO ;
			roadVO.name = "Default Road";
			
			var road:Road ;
			for( var i:int = 0 ; i<3; ++i){
				for ( var j:int = 0 ; j<3;++j){
					road = new Road(roadVO);
					road.nodeX = 6*4+i ;
					road.nodeZ =  6*4+j ;
					roadScene.addRoad( road , false , false );
				}
			}
			
			
			for( i = 4 ; i<6; ++i){
				road = new Road(roadVO);
				road.nodeX = 6*4+i ;
				road.nodeZ = 6*4+0 ;
				roadScene.addRoad( road , false , false );
			}
			//
			road = new Road(roadVO);
			road.nodeX = 6*4+1 ;
			road.nodeZ = 6*4+3 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 6*4+5 ;
			road.nodeZ = 6*4+3 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 6*4+6 ;
			road.nodeZ = 6*4+2 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 6*4+6 ;
			road.nodeZ = 6*4+3 ;
			roadScene.addRoad( road , false , false );
			road = new Road(roadVO);
			road.nodeX = 6*4+7 ;
			road.nodeZ = 6*4+3 ;
			roadScene.addRoad( road , false , false );
			road = new Road(roadVO);
			road.nodeX = 6*4+8 ;
			road.nodeZ = 6*4+3 ;
			roadScene.addRoad( road , false , false );
			road = new Road(roadVO);
			road.nodeX = 6*4+7 ;
			road.nodeZ = 6*4+4 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 6*4+7 ;
			road.nodeZ = 6*4+4 ;
			roadScene.addRoad( road, false , false  );
			//
			var temp:Road; 
			for( i = 1 ; i<4; ++i){
				for ( j =4 ; j<7;++j){
					road = new Road(roadVO);
					road.nodeX = 6*4+i ;
					road.nodeZ =  6*4+j ;
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
			road.nodeX = 6*4+7 ;
			road.nodeZ = 6*4+7 ;
			roadScene.addRoad( road , false , false  );
			
			roadScene.updateAllUI();
			
			var roads:Array =[];
			for each( var obj:IsoObject in roadScene.children)
			{
				if(obj is Road){
					road = obj as Road ;
					if(road && road.direction!="" && road.direction!="_M" ){
						roads.push( road );
					}
				}
			}
			
			var carNum:int ;
			var characNum:int ;
			for( i = 0 ; i<roads.length ; ++i)
			{
				if(Math.random()>0.6 && characNum<10 ){
					road = roads[i];
					var fairy:Character = new Character( EmbedsManager.instance.getAnimResVOByName("Fairy")[0] );
					fairy.nodeX  = road.nodeX;
					fairy.nodeZ = road.nodeZ;
					buildingScene.addIsoObject( fairy , false ) ;
					fairy.init();
					++ characNum ;
				}else if(Math.random()>0.6 && carNum<3){
					road = roads[i];
					if(road.direction!=""){
						var car:Car = new Car( EmbedsManager.instance.getAnimResVOByName("Truck")[0] );
						car.nodeX  = road.nodeX;
						car.nodeZ = road.nodeZ;
						buildingScene.addIsoObject( car , false ) ;
						car.init();
						++carNum;
					}
				}
			}
			
			//添加home1
			baseVO = new BaseBuildingVO();
			baseVO.name="Home1";
			baseVO.type=BuildingType.HOME ;
			baseVO.xSpan = baseVO.zSpan = 2 ;
			var bvo:BuildingVO = new BuildingVO();
			bvo.name = "Home1";
			bvo.baseVO = baseVO ;
			bvo.nodeX = 6*4 + 2  ;
			bvo.nodeZ = 8*4 ;
			var building:Building=new Building( bvo);
			buildingScene.addBuilding( building, false);
			
			buildingScene.sortAll();
			
			run() ;
		}
		
	}
}