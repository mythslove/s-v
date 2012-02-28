package local.game
{
	import bing.iso.IsoScene;
	import bing.utils.ContainerUtil;
	import bing.utils.ObjectUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import local.comm.GameData;
	import local.enum.BuildingOperation;
	import local.enum.LayerType;
	import local.game.elements.Building;
	import local.model.buildings.vos.BuildingVO;
	import local.model.map.MapGridDataModel;
	import local.model.shop.ShopModel;
	import local.utils.BuildingFactory;

	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld{
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//------------------------------------------------------------
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			addBuildingToTop( BuildingFactory.createBuildingByVO( ShopModel.instance.roadArray[0] ));
		}
		
		//用于缓存移动的建筑的上次位置
		private var _cacheBuildPos:Point = new Point();
		
		/**
		 * 点击地图 
		 * @param e
		 */		
		override protected function onClick(e:MouseEvent):void 
		{
			if(GameData.buildingCurrOperation==BuildingOperation.ADD) //添加
			{	
				if( _topBuilding && _topBuilding.gridLayer && _topBuilding.gridLayer.getWalkable() )
				{
					var vo:BuildingVO = ObjectUtil.copyObj(_topBuilding.buildingVO) as BuildingVO ;
					var addedBuilding:Building = addBuildingByVO( _topBuilding.nodeX , _topBuilding.nodeZ ,vo );
					_topBuilding.sendOperation(BuildingOperation.ADD); //发送添加到地图上的消息到服务器
					_topBuilding.gridLayer.updateBuildingGridLayer(_topBuilding.nodeX , _topBuilding.nodeZ , vo.baseVO.layer );
				}
			}
			else if(GameData.buildingCurrOperation==BuildingOperation.ROTATE) //旋转
			{	
				//路一层的建筑才可以旋转
				if(_mouseOverBuild && _mouseOverBuild.buildingVO.baseVO.layer==LayerType.BUILDING){
					if(_mouseOverBuild.getRotatable(MapGridDataModel.instance.buildingGrid)) {
						removeBuildFromScene( _mouseOverBuild );
						_mouseOverBuild.scaleX = ~_mouseOverBuild.scaleX+1 ;
						addBuildToScene(_mouseOverBuild);
						_mouseOverBuild.sendOperation(BuildingOperation.ROTATE); //发送旋转建筑消息到服务器
					}
				}
			}
			else if( GameData.buildingCurrOperation==BuildingOperation.MOVE) //移动时点击地面
			{
				if(_topBuilding){
					if( _topBuilding.gridLayer.getWalkable() )
					{
						addBuildToScene( _topBuilding );//添加到场景上
						_topBuilding.sendOperation(BuildingOperation.MOVE); //发送移动建筑的消息
						clearTopScene();
					}
				}
				else if(_mouseOverBuild)
				{
					_cacheBuildPos.x = _mouseOverBuild.nodeX ;
					_cacheBuildPos.y = _mouseOverBuild.nodeZ ;
					removeBuildFromScene( _mouseOverBuild ); //从场景上先移除
					addBuildingToTop( _mouseOverBuild );  //添加在鼠标容器上移动
					_mouseOverBuild = null ;
				}
			}
			else if(GameData.buildingCurrOperation==BuildingOperation.STASH) //收藏
			{
				if(_mouseOverBuild){
					removeBuildFromScene( _mouseOverBuild ); //从场景上先移除
					_mouseOverBuild.selectedStatus(false);
					_mouseOverBuild.sendOperation(BuildingOperation.STASH); //发送收藏建筑信息到服务器
					_mouseOverBuild = null ;
				}
			}
			else if(GameData.buildingCurrOperation==BuildingOperation.SELL) //卖出
			{
				if(_mouseOverBuild){
					//弹出卖出窗口
					_mouseOverBuild = null ;
				}
			}
			else if(_mouseOverBuild)
			{
				_mouseOverBuild.onClick() ;
			}
		}
		
		/**
		 * 移动建筑失败，建筑返回原来的地点 
		 */		
		public function moveFail():void 
		{
			if(_topBuilding){
				_topBuilding.nodeX=_cacheBuildPos.x ;
				_topBuilding.nodeZ=_cacheBuildPos.y ;
				this.addBuildToScene( _topBuilding );
			}
			clearTopScene();
		}
		
		/**
		 * 将建筑加到topScene,跟随鼠标移动 
		 * @param building
		 */ 		
		public function addBuildingToTop( building:Building ):void
		{
			_topBuilding = building ;
			building.drawGrid();
			topScene.addIsoObject( building , false );
			building.itemLayer.alpha = 0.5 ;
			building.selectedStatus(false); //选择设置成false
			topScene.visible = true  ;
		}
		
		/**
		 * 清除topScene 
		 */		
		public function clearTopScene():void
		{
			ContainerUtil.removeChildren(topScene);
			topScene.visible = false  ;
			if(_topBuilding){
				_topBuilding.removeGrid();
				_topBuilding.itemLayer.alpha = 1;
			}
			_topBuilding = null ;
		}
		
		/**
		 * 清空世界 
		 */		
		public function clearWorld():void
		{
			for each( var scene:IsoScene in scenes){
				scene.clear();
			}
			clearTopScene() ;
		}
	}
}