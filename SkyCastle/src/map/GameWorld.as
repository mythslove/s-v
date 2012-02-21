package map
{
	import bing.iso.IsoScene;
	import bing.utils.ContainerUtil;
	import bing.utils.ObjectUtil;
	
	import comm.GameData;
	import comm.GameSetting;
	
	import enums.BuildingCurrentOperation;
	import enums.LayerType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import map.elements.Building;
	import map.elements.BuildingBase;
	
	import models.MapGridDataModel;
	import models.ShopModel;
	import models.vos.BuildingVO;

	/**
	 * 游戏世界  
	 * @author zzhanglin
	 */	
	public class GameWorld extends BaseWorld
	{
		protected static var _instance:GameWorld;
		public static function get instance():GameWorld
		{
			if(!_instance) _instance= new GameWorld();
			return _instance ;
		}
		//=====================================
		private var _moveBuildPrevX:int ; //移动建筑之前的位置
		private var _moveBuildPrevZ:int ;
		
		/**
		 * 游戏世界构造函数 
		 */		
		public function GameWorld()
		{
			super();
			if(_instance) throw new Error("只能实例化一个GameWorld");
			else _instance = this ;
		}

		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			//测试添加建筑用----------------ShopModel.instance.roadArray[0]
			var building:BuildingBase = new BuildingBase( ShopModel.instance.roadArray[0]);
			building.drawGrid();
			building.gridLayer.visible=true;
			this.addBuildingOnMouse( building );
			updateMouseNodePoint();
		}
		
		override protected function onClick(e:MouseEvent):void 
		{
			if(GameData.buildingCurrOperation==BuildingCurrentOperation.ADD) //添加
			{	
				var build:BuildingBase = mouseScene.getChildAt(0) as BuildingBase ;
				if( build && build.gridLayer && build.gridLayer.getWalkable() )
				{
					var vo:BuildingVO = ObjectUtil.copyObj(build.buildingVO) as BuildingVO ;
					var addedBuilding:Building = addBuildingByVO( build.nodeX , build.nodeZ ,vo );
					addedBuilding.sendAddedToScene(); //发送添加到地图上的消息到服务器
					build.gridLayer.updateBuildingGridLayer(build.nodeX , build.nodeZ , vo.baseVO.layerType );
				}
			}
			else if(GameData.buildingCurrOperation==BuildingCurrentOperation.ROTATE) //旋转
			{	
				//路一层的建筑才可以旋转
				if(mouseOverBuild && mouseOverBuild.buildingVO.baseVO.layerType==LayerType.BUILDING){
					if(mouseOverBuild.getRotatable(MapGridDataModel.instance.buildingGrid)) {
						removeBuildFromScene( mouseOverBuild );
						mouseOverBuild.scaleX = ~mouseOverBuild.scaleX+1 ;
						addBuildToScene(mouseOverBuild);
						mouseOverBuild.sendRotatedBuilding(); //发送旋转建筑消息到服务器
					}
				}
			}
			else if( GameData.buildingCurrOperation==BuildingCurrentOperation.MOVE) //移动
			{
				if(mouseScene.numChildren==0){
					if(mouseOverBuild){
						_moveBuildPrevX = mouseOverBuild.x ;
						_moveBuildPrevZ = mouseOverBuild.z ;
						removeBuildFromScene( mouseOverBuild ); //从场景上先移除
						mouseOverBuild.selectedStatus(false); //选择设置成false
						addBuildingOnMouse( mouseOverBuild );  //添加在鼠标容器上移动
						mouseOverBuild.drawGrid(); //画建筑网格
						mouseOverBuild = null ;
					}
				}else {
					var building:Building = mouseScene.getChildAt(0) as Building ;
					if( building && building.gridLayer && building.gridLayer.getWalkable() )
					{
						building.removeGrid(); //移除建筑网格
						building.itemLayer.alpha=1;
						addBuildToScene( building );//添加到场景上
						building.sendMovedBuilding(); //发送移动建筑的消息
						ContainerUtil.removeChildren( mouseScene) ; //清除鼠标
					}
				}
			}
			else if(GameData.buildingCurrOperation==BuildingCurrentOperation.STASH) //收藏
			{
				if(mouseOverBuild){
					removeBuildFromScene( mouseOverBuild ); //从场景上先移除
					mouseOverBuild.selectedStatus(false);
					mouseOverBuild.sendStashBuilding(); //发送收藏建筑信息到服务器
					mouseOverBuild = null ;
				}
			}
			else if(GameData.buildingCurrOperation==BuildingCurrentOperation.SELL) //卖出
			{
				if(mouseOverBuild){
					mouseOverBuild = null ;
				}
			}
		}
		
		/**运行 */		
		public function start():void{
			this.removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			this.addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		/**停止*/		
		public function stop():void {
			this.removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		/**不断地执行*/		
		protected function onEnterFrameHandler(e:Event):void
		{
			update() ;
		}
		
		/**地图放大和缩小 */		
		public function zoom( scale:Number):void
		{
			var prevW:Number = GameSetting.MAP_WIDTH*scaleX;
			var prevH:Number = GameSetting.MAP_HEIGHT*scaleX;
			scaleX= scaleY = scale ;
			x+=(prevW-GameSetting.MAP_WIDTH*scaleX)>>1;
			y+=(prevH-GameSetting.MAP_HEIGHT*scaleX)>>1;
			modifyMapPosition();
		}
		
		/**
		 * 添加建筑到鼠标上面跟随 
		 * @param buildingBase
		 */		
		public function addBuildingOnMouse( buildingBase:BuildingBase):void
		{
			ContainerUtil.removeChildren( mouseScene );
			//将位置设置成0
			buildingBase.setScreenPosition(0,0);
			buildingBase.nodeX=buildingBase.nodeZ=0;
			if( buildingBase.buildingVO.baseVO.layerType!=LayerType.GROUND){
				buildingBase.itemLayer.alpha=0.6;
			}
			mouseScene.addChild( buildingBase );
		}
		
		/**
		 * 获取所有的建筑 
		 * @param layerType 层类型
		 * @return 
		 */		
		public function getBuildings( layerType:int ):Vector.<Building>
		{
			var spirtes:Vector.<Building> = new Vector.<Building>();
			if(layerType==LayerType.BUILDING){
				return spirtes.concat(buildingScene1.children).concat(buildingScene2.children).concat(buildingScene3.children)
			}
			return spirtes.concat(groundScene1.children).concat(groundScene2.children).concat(groundScene3.children)
		}
		
		/**
		 *  填充地图 
		 * @param buildingVos 
		 */		
		public function fillMap( buildingVos:Vector.<BuildingVO> ):void
		{
			for each( var vo:BuildingVO in buildingVos) {
				this.addBuildingByVO(vo.nodeX,vo.nodeZ,vo,false,false) ;
			}
			for each( var scene:IsoScene in scenes) {
				scene.sortAll() ;
			}
		}
		
		/** 移动建筑失败,恢复到原来的地方 */
		public function moveFail():void
		{
			if(mouseScene.numChildren>0){
				var building:Building = mouseScene.getChildAt(0) as Building ;
				building.x=_moveBuildPrevX;
				building.z=_moveBuildPrevZ;
				building.itemLayer.alpha=1;
				building.removeGrid();
				addBuildToScene(building);
			}
		}
	}
}