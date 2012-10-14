package local.map.scene
{
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.map.item.BasicBuilding;
	import local.map.item.Building;
	import local.map.item.MoveItem;
	import local.map.item.Road;
	import local.model.MapGridDataModel;
	import local.util.ObjectPool;
	
	/**
	 * 建筑层 
	 * @author zhouzhanglin
	 */	
	public class BuildingScene extends IsoScene
	{
		public var moveItems:Array = []; //可移动的对象
		
		public function BuildingScene()
		{
			super(GameSetting.GRID_SIZE , GameSetting.GRID_X , GameSetting.GRID_Z );
			mouseEnabled = false ;
			this.gridData = MapGridDataModel.instance.gameGridData ;
		}
		
		/**
		 * 添加可移动和车和人到场景上 
		 * @param item
		 * @param isSort
		 */		
		public function addMoveItem( item:MoveItem , isSort:Boolean ):void
		{
			moveItems.push( item );
			addIsoObject( item , isSort );
		}
		
		
		/**
		 * 添加建筑 
		 * @param building
		 * @param isSort是否进行深度排序
		 * @return 
		 */		
		public function addBuilding( building:BaseBuilding , isSort:Boolean=true , isInit:Boolean=false ):BaseBuilding
		{
			this.addIsoObject( building,isSort );
			building.setWalkable( false , gridData );
			MapGridDataModel.instance.addBuildingGridData(building);
			if(isInit && building is Building){
				( building as Building).recoverStatus() ;
			}
			return building;
		}
		
		/**
		 * 移除建筑 
		 * @param building
		 */		
		public function removeBuilding( building:BaseBuilding):void
		{
			this.removeIsoObject( building );
			building.setWalkable( true , this.gridData );
			MapGridDataModel.instance.removeBuildingGridData(building);
		}
		
		/**
		 * 旋转建筑 
		 * @param buildingBase
		 */		
		public function rotateBuilding( building:BaseBuilding ):void
		{
			if(building.getRotatable(gridData))
			{
				building.setWalkable(true,gridData);
				MapGridDataModel.instance.removeBuildingGridData(building);
				building.scaleX = ~building.scaleX+1;
				building.setWalkable(false,gridData);
				MapGridDataModel.instance.addBuildingGridData(building);
			}
		}
		
		/**
		 * 准备保存 
		 */		
		public function readySave():void
		{
			var time:Number = GameData.commDate.time ;
			var build:Building ;
			for each( var obj:IsoObject in children){
				if( obj is Building && !(obj is BasicBuilding)  ){
					build = obj as Building;
					build.buildingVO.statusTime = 0 ;
					if( build.gameTimer){
						build.buildingVO.statusTime = time+build.gameTimer.duration*1000 ;
					}
				}
			}
		}
		
		/**
		 * 刷新建筑的状态 
		 */		
		public function refreshBuildingStatus():void
		{
			for each( var obj:IsoObject in children){
				if( obj is Building && !(obj is BasicBuilding) ){
					(obj as Building).recoverStatus();
				}
			}
		}
		
		/**
		 * 判断是否在路旁边 
		 */		
		public function checkRoadsAndIcons():void
		{
			for each( var obj:IsoObject in children){
				if( obj is Building && !(obj is BasicBuilding) ){
					(obj as Building).checkRoadAndIcon();
				}
			}
		}
		
		/** 添加场景上走路的人 */
		public function addMoveItems():void
		{
			var roads:Array =[];
			var road:Road ;
			for each( var obj:IsoObject in GameWorld.instance.roadScene.children)
			{
				if( ( obj as BaseBuilding).buildingVO.baseVO.subClass==BuildingType.DECORATION_ROAD ){
					road = obj as Road ;
					if(road && road.direction!="" && road.direction!="_M" ){
						roads.push( road );
					}
				}
			}
			var carRate:int = GameSetting.SCREEN_WIDTH>=1024 ? 4 : 5 ;
			var characterRate:int = GameSetting.SCREEN_WIDTH>=1024 ? 3 : 4 ;
			var len:int = roads.length ;
			for(var i:int = 0 ; i<len ; ++i)
			{
				if( Math.random()>0.3 && i%characterRate==0 ){ 
					road = roads[i];
					var fairy:MoveItem = ObjectPool.instance.getCharacter() ;
					fairy.nodeX  = road.nodeX;
					fairy.nodeZ = road.nodeZ;
					addMoveItem( fairy , false ) ;
					fairy.init();
				}
				if(Math.random()>0.4 && i%carRate==0 ){ 
					road = roads[i];
					if(road.direction!=""){
						var car:MoveItem = ObjectPool.instance.getCar() ;
						car.nodeX  = road.nodeX;
						car.nodeZ = road.nodeZ;
						addMoveItem( car , false ) ;
						car.init();
					}
				}
			}
		}
		
		/** 移除场景上走路的人 */
		public function removeMoveItems():void
		{
			var len:int = moveItems.length ;
			for( var i:int = 0 ; i <len ; ++i ){
				if(moveItems[i].parent){
					this.removeIsoObject( moveItems[i] );
					ObjectPool.instance.addObjectToPool( moveItems[i] );
				}
			}
			moveItems = [] ;
		}
		
		
		/**        排序算法           */
		override protected function sortCompare( target:IsoObject , item:IsoObject ):int
		{
			var centerX:Number=target.screenX+target.xSpan*_size  - item.screenX-item.xSpan*_size  ;
			var centerY:Number=target.screenY+target.xSpan*_size*0.5  - item.screenY - item.xSpan*_size*0.5  ;
			if(centerY>0){
				return 1;
			}
			if(centerY<0){
				return -1;
			}
			return centerX ;
		}
	}
}