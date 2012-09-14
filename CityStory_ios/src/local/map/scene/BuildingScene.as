package local.map.scene
{
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	
	import local.comm.GameSetting;
	import local.enum.BuildingType;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
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
		public function addBuilding( building:BaseBuilding , isSort:Boolean=true ):BaseBuilding
		{
			this.addIsoObject( building,isSort );
			building.setWalkable( false , gridData );
			MapGridDataModel.instance.addBuildingGridData(building);
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
			var date:Date = new Date();
			var time:Number = date.time;
			var len:int = numChildren ;
			var build:BaseBuilding ;
			for( var i:int = 0 ; i<len ; ++i)
			{
				build = getChildAt( i ) as BaseBuilding ;
				if( build )
				{
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
			var len:int = numChildren ;
			var build:BaseBuilding ;
			for( var i:int = 0 ; i<len ; ++i)
			{
				build = getChildAt( i ) as BaseBuilding ;
				if( build ) {
					build.recoverStatus();
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
			
			var carNum:int ;
			var characNum:int ;
			for(var i:int = 0 ; i<roads.length ; ++i)
			{
				if(Math.random()>0.6 && characNum<10 ){ //不超过10个人
					road = roads[i];
					var fairy:MoveItem = ObjectPool.instance.getCharacter() ;
					fairy.nodeX  = road.nodeX;
					fairy.nodeZ = road.nodeZ;
					addMoveItem( fairy , false ) ;
					fairy.init();
					++ characNum ;
				}else if(Math.random()>0.4 && carNum<5){ //不超过5辆车
					road = roads[i];
					if(road.direction!=""){
						var car:MoveItem = ObjectPool.instance.getCar() ;
						car.nodeX  = road.nodeX;
						car.nodeZ = road.nodeZ;
						addMoveItem( car , false ) ;
						car.init();
						++carNum;
					}
				}
			}
		}
		
		/** 移除场景上走路的人 */
		public function removeMoveItems():void
		{
			var len:int = moveItems.length ;
			for( var i:int = 0 ; i <len ; ++i ){
				this.removeIsoObject( moveItems[i] );
				ObjectPool.instance.addObjectToPool( moveItems[i] );
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