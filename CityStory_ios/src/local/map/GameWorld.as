package local.map
{
	import bing.iso.IsoObject;
	
	import flash.events.MouseEvent;
	
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.item.BaseBuilding;
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
		private var _mouseBuilding:BaseBuilding; //按下时点击到的建筑
		
		/** 显示所有的建筑 */
		public function showBuildings():void
		{
			var baseVO:BaseBuildingVO = new BaseBuildingVO();
			baseVO.name = "Road";
			baseVO.type = BuildingType.DECORATION ;
			baseVO.subClass = BuildingType.DECORATION_ROAD ;
			var roadVO:BuildingVO = new BuildingVO();
			roadVO.baseVO = baseVO ;
			roadVO.name = "Road";
			
			var road:Road ;
			for( var i:int = 0 ; i<3; ++i){
				for ( var j:int = 0 ; j<3;++j){
					road = new Road(roadVO);
					road.nodeX = 8*4+i ;
					road.nodeZ =  8*4+j ;
					roadScene.addRoad( road , false , false );
				}
			}
			
			
			for( i = 4 ; i<6; ++i){
				road = new Road(roadVO);
				road.nodeX = 8*4+i ;
				road.nodeZ = 8*4+0 ;
				roadScene.addRoad( road , false , false );
			}
			//
			road = new Road(roadVO);
			road.nodeX = 8*4+1 ;
			road.nodeZ = 8*4+3 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 8*4+5 ;
			road.nodeZ = 8*4+3 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 8*4+6 ;
			road.nodeZ = 8*4+2 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 8*4+6 ;
			road.nodeZ = 8*4+3 ;
			roadScene.addRoad( road , false , false );
			road = new Road(roadVO);
			road.nodeX = 8*4+7 ;
			road.nodeZ = 8*4+3 ;
			roadScene.addRoad( road , false , false );
			road = new Road(roadVO);
			road.nodeX = 8*4+8 ;
			road.nodeZ = 8*4+3 ;
			roadScene.addRoad( road , false , false );
			road = new Road(roadVO);
			road.nodeX = 8*4+7 ;
			road.nodeZ = 8*4+4 ;
			roadScene.addRoad( road, false , false  );
			road = new Road(roadVO);
			road.nodeX = 8*4+7 ;
			road.nodeZ = 8*4+4 ;
			roadScene.addRoad( road, false , false  );
			//
			var temp:Road; 
			for( i = 1 ; i<4; ++i){
				for ( j =4 ; j<7;++j){
					road = new Road(roadVO);
					road.nodeX = 8*4+i ;
					road.nodeZ =  8*4+j ;
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
			road.nodeX = 8*4+7 ;
			road.nodeZ = 8*4+7 ;
			roadScene.addRoad( road , false , false  );
			
			roadScene.updateAllUI();
			roadScene.sortAll() ;
			
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
			baseVO.span = 2 ;
			var bvo:BuildingVO = new BuildingVO();
			bvo.name = "Home1";
			bvo.baseVO = baseVO ;
			bvo.nodeX = 9*4   ;
			bvo.nodeZ = 8*4+1 ;
			var building:Building=new Building( bvo);
			buildingScene.addBuilding( building, false);
			
			bvo = new BuildingVO();
			bvo.name = "Home1";
			bvo.baseVO = baseVO ;
			bvo.nodeX = 9*4   ;
			bvo.nodeZ = 10*4-2 ;
			building=new Building( bvo);
			buildingScene.addBuilding( building, false);
			
			
			
			buildingScene.sortAll();
			
			run() ;
		}
		
		
		override protected function configListeners():void
		{
			super.configListeners() ;
			this.addEventListener(MouseEvent.MOUSE_DOWN , onMouseEvtHandler); 
		}
		
		protected function onMouseEvtHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			switch( e.type )
			{
				case MouseEvent.MOUSE_DOWN:
					_isGesture = false ;
					_isMove = false ;
					_moveSpeed = 0.36 ;
					_mouseDownPos.x = root.mouseX ;
					_mouseDownPos.y = root.mouseY ;
					_worldPos.x = x ;
					_worldPos.y = y ;
					if(e.target.parent is BaseBuilding){
						_mouseBuilding = e.target.parent as BaseBuilding ;
					}
					addEventListener(MouseEvent.MOUSE_MOVE , onMouseEvtHandler); 
					addEventListener(MouseEvent.MOUSE_UP , onMouseEvtHandler );
					break ;
				case MouseEvent.MOUSE_MOVE:
					_isMove = true ;
					mouseChildren = false; 
					if(e.buttonDown && !_isGesture ){
						_endX =  _worldPos.x + root.mouseX-_mouseDownPos.x ;
						_endY = _worldPos.y + root.mouseY-_mouseDownPos.y ;
						modifyEndPosition();
					}
					break ;
				case MouseEvent.MOUSE_UP:
					if(!_isGesture && !_isMove){
						if(e.target.parent is BaseBuilding && e.target.parent==_mouseBuilding)
						{
							if(e.target.parent!=currentSelected  ){
								if(currentSelected) currentSelected.flash(false);
								currentSelected = e.target.parent as BaseBuilding ;
								currentSelected.flash(true);
								//移动到中间
								_endX =  GameSetting.SCREEN_WIDTH*0.5 - (sceneLayerOffsetX+currentSelected.screenX)*scaleX ;
								_endY = GameSetting.SCREEN_HEIGHT*0.5 -(currentSelected.screenY +sceneLayerOffsetY+GameSetting.GRID_SIZE*2)*scaleY ;
								modifyEndPosition();
								_moveSpeed = 0.15 ;
							}
						}
						else if(currentSelected) 
						{
							currentSelected.flash(false);
							currentSelected = null ;
						}
					}
				default :
					mouseChildren = true ;
					_isMove = false ;
					removeEventListener(MouseEvent.MOUSE_MOVE , onMouseEvtHandler); 
					removeEventListener(MouseEvent.MOUSE_UP , onMouseEvtHandler );
					break ;
			}
		}
		
	}
}