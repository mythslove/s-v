package local.game
{
	import bing.utils.ContainerUtil;
	import bing.utils.ObjectUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import local.comm.GameData;
	import local.enum.BuildingOperation;
	import local.enum.LayerType;
	import local.game.elements.Building;
	import local.model.buildings.vos.BuildingVO;
	import local.model.map.MapGridDataModel;

	public class GameWorld extends BaseWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld{
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//------------------------------------------------------------
		private var _cacheBuildPos:Point = new Point();//用于缓存移动的建筑的上次位置
		
		override protected function onClick(e:MouseEvent):void 
		{
			if(GameData.buildingCurrOperation==BuildingOperation.ADD) //添加
			{	
				if( _topBuilding && _topBuilding.gridLayer && _topBuilding.gridLayer.getWalkable() )
				{
					var vo:BuildingVO = ObjectUtil.copyObj(_topBuilding.buildingVO) as BuildingVO ;
					var addedBuilding:Building = addBuildingByVO( _topBuilding.nodeX , _topBuilding.nodeZ ,vo );
					addedBuilding.sendAddBuilding(); //发送添加到地图上的消息到服务器
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
						_mouseOverBuild.sendRotateBuilding(); //发送旋转建筑消息到服务器
					}
				}
			}
			else if( GameData.buildingCurrOperation==BuildingOperation.MOVE) //移动
			{
				if(_topBuilding){
					if(_mouseOverBuild){
						_cacheBuildPos.x = _mouseOverBuild.x ;
						_cacheBuildPos.y = _mouseOverBuild.z ;
						removeBuildFromScene( _mouseOverBuild ); //从场景上先移除
						_mouseOverBuild.selectedStatus(false); //选择设置成false
						addBuildingToTop( _mouseOverBuild );  //添加在鼠标容器上移动
						_mouseOverBuild.drawGrid(); //画建筑网格
						_mouseOverBuild = null ;
					}
				}else {
					if( _topBuilding && _topBuilding.gridLayer && _topBuilding.gridLayer.getWalkable() )
					{
						_topBuilding.removeGrid(); //移除建筑网格
						_topBuilding.itemLayer.alpha=1;
						addBuildToScene( _topBuilding );//添加到场景上
						_topBuilding.sendMoveBuilding(); //发送移动建筑的消息
						ContainerUtil.removeChildren( topScene) ; //清除鼠标
					}
				}
			}
			else if(GameData.buildingCurrOperation==BuildingOperation.STASH) //收藏
			{
				if(_mouseOverBuild){
					removeBuildFromScene( _mouseOverBuild ); //从场景上先移除
					_mouseOverBuild.selectedStatus(false);
					_mouseOverBuild.sendStashBuilding(); //发送收藏建筑信息到服务器
					_mouseOverBuild = null ;
				}
			}
			else if(GameData.buildingCurrOperation==BuildingOperation.SELL) //卖出
			{
				if(_mouseOverBuild){
					_mouseOverBuild = null ;
				}
			}
		}
		
		/**
		 * 移动建筑失败，建筑返回原来的地点 
		 */		
		public function moveFail():void
		{
			
		}
		
		/**
		 * 将建筑加到topScene,跟随鼠标移动 
		 * @param building
		 */ 		
		public function addBuildingToTop( building:Building ):void
		{
			_topBuilding = building ;
			topScene.addIsoObject( _topBuilding , false );
			topScene.visible = true  ;
		}
		
		/**
		 * 清除topScene 
		 */		
		public function clearTopScene():void
		{
			ContainerUtil.removeChildren(topScene);
			topScene.visible = false  ;
		}
	}
}