package local.map
{
	import bing.iso.IsoObject;
	import bing.iso.IsoUtils;
	import bing.iso.path.Grid;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.item.BasicBuilding;
	import local.map.item.Car;
	import local.map.item.Character;
	import local.map.item.Road;
	import local.model.LandModel;
	import local.model.MapGridDataModel;
	import local.util.EmbedsManager;
	import local.vo.BaseBuildingVO;
	import local.vo.BuildingVO;
	import local.vo.LandVO;

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
					if(road.direction!=""){
						var car:Car = new Car( EmbedsManager.instance.getAnimResVOByName("Truck")[0] );
						car.nodeX  = road.nodeX;
						car.nodeZ = road.nodeZ;
						buildingScene.addIsoObject( car , false ) ;
						car.init();
					}
				}
			}
			buildingScene.sortAll();
			
			run() ;
		}
		
		
		/** 显示所有的建筑 */
		public function showBuildings():void
		{
			var i:int , j:int ;
			var gameGridData:Grid = MapGridDataModel.instance.gameGridData ;
			
			//添加地图区域
			var maxX:int ,maxZ:int ;
			for each( var landVO:LandVO in LandModel.instance.lands) {
				drawLandZone(landVO);
				MapGridDataModel.instance.landGridData.setWalkable( landVO.nodeX , landVO.nodeZ , true );
				//将GameGridData的数据设置为可行
				maxX = landVO.nodeX*4+4 ;
				maxZ = landVO.nodeZ*4+4 ;
				for( i = landVO.nodeX*4 ; i<maxX ; ++i){
					for( j = landVO.nodeZ*4 ; j<maxZ ; ++j){
						gameGridData.setWalkable( i , j , true ) ;
					}
				}
			}
			
			//随机添加树，石头
			var basicBuild:BasicBuilding ;
			for( i = 0 ; i<GameSetting.GRID_X ; ++i){
				for( j = 0 ; j<GameSetting.GRID_Z ; ++j){
					if( !gameGridData.getNode(i,j).walkable && Math.random()>0.92 ){
						
						maxX = i*_size - j*_size +sceneLayerOffsetX;
						maxZ =   (i*_size + j*_size) * .5 + sceneLayerOffsetY ;
						if(maxX>0 && maxZ>0 && maxX<GameSetting.MAP_WIDTH && maxZ<GameSetting.MAP_HEIGHT-200 )
						{
							var index:int = (Math.random()*8+1 )>>0 ;
							basicBuild = new BasicBuilding( EmbedsManager.instance.getAnimResVOByName("Basic_Tree"+index)) ;
							basicBuild.nodeX = i ;
							basicBuild.nodeZ = j ;
							buildingScene.addBasicBuilding( basicBuild , false  );
						}
					}
				}
			}
			buildingScene.sortAll();
		}
		
		/** 画这个土地区域*/
		public function drawLandZone( landVO:LandVO ):void
		{
			var p:Vector3D = GameData.commVec ;
			p.setTo(0,0,0);
			var screenPos:Point = GameData.commPoint ;
			screenPos.setTo(0,0);
			roadScene.graphics.beginFill( 0x97B425 , 1 );
			p.x = landVO.nodeX; p.z=landVO.nodeZ;
			screenPos = IsoUtils.isoToScreen(p);
			var px:int = screenPos.x*_size*4 ;
			var py:int = screenPos.y*_size*4 ;
			roadScene.graphics.moveTo(  px , py );
			
			p.x = landVO.nodeX+1; p.z=landVO.nodeZ;
			screenPos = IsoUtils.isoToScreen(p);
			roadScene.graphics.lineTo( screenPos.x*_size*4 , screenPos.y*_size*4);
			
			p.x = landVO.nodeX+1; p.z=landVO.nodeZ+1;
			screenPos = IsoUtils.isoToScreen(p);
			roadScene.graphics.lineTo( screenPos.x*_size*4 ,screenPos.y*_size*4);
			
			p.x = landVO.nodeX; p.z=landVO.nodeZ+1;
			screenPos = IsoUtils.isoToScreen(p);
			roadScene.graphics.lineTo( screenPos.x*_size*4 ,screenPos.y*_size*4);
			
			roadScene.graphics.lineTo( px , py );
			roadScene.graphics.endFill();
		}
	}
}