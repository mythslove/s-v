package map
{
	import bing.iso.IsoScene;
	import bing.utils.ContainerUtil;
	import bing.utils.ObjectUtil;
	
	import comm.GameData;
	import comm.GameSetting;
	
	import enums.BuildingCurrentOperation;
	import enums.BuildingType;
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
		private var _moveBuildPrevX:int ;
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
			
			var building:BuildingBase = new BuildingBase( ShopModel.instance.houseArray[0]);
			building.drawGrid();
			building.gridLayer.visible=true;
			this.addBuildingOnMouse( building );
		}
		
		override protected function onClick(e:MouseEvent):void 
		{
			if(GameData.buildingCurrOperation==BuildingCurrentOperation.ADD) //添加
			{	
				var build:BuildingBase = mouseContainer.getChildAt(0) as BuildingBase ;
				if( build && build.gridLayer && build.gridLayer.getWalkable() )
				{
					var vo:BuildingVO = ObjectUtil.copyObj( (mouseContainer.getChildAt(0) as BuildingBase).buildingVO ) as BuildingVO;
					addBuildingByVO( mouseContainer.nodeX , mouseContainer.nodeZ ,vo );
					mouseContainer.parent.setChildIndex( mouseContainer , mouseContainer.parent.numChildren-1);
					build.gridLayer.updateBuildingGridLayer(mouseContainer.nodeX , mouseContainer.nodeZ,vo.baseVO.layerType);
				}
			}
			else if(GameData.buildingCurrOperation==BuildingCurrentOperation.ROTATE) //旋转
			{	
				if(mouseOverBuild && mouseOverBuild.buildingVO.baseVO.layerType==LayerType.BUILDING){
					if(mouseOverBuild.getRotatable(MapGridDataModel.instance.buildingGrid)) {
						removeBuildFromScene( mouseOverBuild );
						mouseOverBuild.scaleX = ~mouseOverBuild.scaleX+1 ;
						addBuildToScene(mouseOverBuild);
						mouseOverBuild.sendRotatedBuilding();
					}
				}
			}
			else if( GameData.buildingCurrOperation==BuildingCurrentOperation.MOVE) //移动
			{
				if(mouseContainer.numChildren==0){
					if(mouseOverBuild){
						_moveBuildPrevX = mouseOverBuild.x ;
						_moveBuildPrevZ = mouseOverBuild.z ;
						removeBuildFromScene( mouseOverBuild ); //从场景上先移除
						mouseOverBuild.selectedStatus(false); //选择设置成false
						addBuildingOnMouse( mouseOverBuild );  //添加在鼠标容器上移动
						mouseOverBuild.drawGrid(); //画建筑网格
						mouseContainer.nodeX = mouseNodePoint.x; //更新当前鼠标容器的位置
						mouseContainer.nodeZ = mouseNodePoint.y ;
						mouseOverBuild = null ;
					}
				}else {
					var building:Building = mouseContainer.getChildAt(0) as Building ;
					if( building && building.gridLayer && building.gridLayer.getWalkable() )
					{
						building.removeGrid(); //移除建筑网格
						building.nodeX = mouseContainer.nodeX; //设置位置
						building.nodeZ = mouseContainer.nodeZ;
						building.itemLayer.alpha=1;
						addBuildToScene( building );//添加到场景上
						building.sendMovedBuilding(); //发送移动建筑的消息
						clearMouse(); //清除鼠标
						mouseContainer.parent.setChildIndex( mouseContainer , mouseContainer.parent.numChildren-1);
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
			var dx:Number=scaleX<1?-GameSetting.SCREEN_WIDTH:GameSetting.SCREEN_WIDTH ;
			var dy:Number=scaleX<1?-GameSetting.SCREEN_HEIGHT:GameSetting.SCREEN_HEIGHT ;
			scaleX = scaleY = scale ;
			x+=dx;
			y+=dy;
			modifyMapPosition();
		}
		
		/**
		 * 添加建筑到鼠标上面跟随 
		 * @param buildingBase
		 */		
		public function addBuildingOnMouse( buildingBase:BuildingBase):void
		{
			mouseContainer.parent.setChildIndex( mouseContainer ,mouseContainer.parent.numChildren-1 );
			clearMouse();
			//将位置设置成0
			buildingBase.setScreenPosition(0,0);
			buildingBase.nodeX=buildingBase.nodeZ=0;
			if( buildingBase.buildingVO.baseVO.type!=BuildingType.ROAD){
				buildingBase.itemLayer.alpha=0.6;
			}
			mouseContainer.addChild( buildingBase );
			mouseContainer.visible=true;
		}
		
		/**
		 *  清除鼠标上面的建筑跟随
		 */		
		public function clearMouse():void
		{
			ContainerUtil.removeChildren( mouseContainer );
			mouseContainer.visible=false;
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
	}
}