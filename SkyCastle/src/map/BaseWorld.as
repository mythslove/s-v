package map
{
	import bing.iso.*;
	import bing.res.ResVO;
	
	import comm.*;
	
	import enums.BuildingType;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import map.elements.BuildingBase;
	
	import models.vos.BuildingVO;
	
	import utils.ResourceUtil;
	
	public class BaseWorld extends IsoWorld
	{
		//***************************************************************
		protected var _buildingScene1:BuildingScene ;
		public function get buildingScene1():BuildingScene{
			return _buildingScene1 ;
		}
		protected var _groundScene1:GroundScene;
		public function get groundScene1():GroundScene{
			return _groundScene1 ;
		}
		protected var _buildingScene2:BuildingScene ;
		public function get buildingScene2():BuildingScene{
			return _buildingScene2 ;
		}
		protected var _groundScene2:GroundScene;
		public function get groundScene2():GroundScene{
			return _groundScene2 ;
		}
		protected var _buildingScene3:BuildingScene ;
		public function get buildingScene3():BuildingScene{
			return _buildingScene3 ;
		}
		protected var _groundScene3:GroundScene;
		public function get groundScene3():GroundScene{
			return _groundScene3 ;
		}
		//**********************************************************/
		protected var _prevMouseX:int ;
		protected var _prevMouseZ:int ;
		
		protected var _gridScene:IsoScene ;
		public function get gridScene():IsoScene{
			return _gridScene;
		}
		
		protected var _mapIsMove:Boolean=false;
		public function get mapIsMove():Boolean{
			return _mapIsMove ;
		}
		protected var _mouseIsMove:Boolean=false;
		public function get mouseIsMove():Boolean{
			return _mouseIsMove ;
		}
		//跟随鼠标移动的建筑
		protected var _mouseContainer:IsoObject;
		public function get mouseContainer():IsoObject{
			return _mouseContainer ;
		}
		
		/**
		 * 游戏世界基类
		 */		
		public function BaseWorld()
		{
			super(GameSetting.MAP_WIDTH , GameSetting.MAP_HEIGHT,GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE);
			this.mouseChildren = false ;
			
			//设置背景图片
			var bg:Bitmap = new Bitmap( ResourceUtil.instance.getInstanceByClassName("bg","BG") as BitmapData );
			this.setBackGround(bg);
			ResourceUtil.instance.deleteRes("bg"); //把加载的背景图片卸载了
			
			//设置地图显示参数
			GameSetting.MAX_WIDTH = bg.width;
			GameSetting.MAX_HEIGHT = bg.height ;
			this.panTo( GameSetting.MAX_WIDTH>>1 , -410);
			
			//地图的初始位置
			this.x = -2200 ;
			this.y = -1500;
		}
		
		/**
		 * 添加到舞台上时 
		 * @param e
		 */		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			//显示地图网格
//			_gridScene = new IsoScene(GameSetting.GRID_SIZE);
//			(_gridScene.addChild( new IsoGrid(GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE)) as IsoGrid).render() ;
//			_gridScene.cacheAsBitmap=true;
//			this.addScene(_gridScene);
			
			var gridResVO:ResVO = ResourceUtil.instance.getResVOByName("mapdata");
			//地图区域1
			_groundScene1 = new GroundScene();
			_groundScene1.gridData = gridResVO.resObject.groundGrid1 ;
			addScene(_groundScene1);
			_buildingScene1 = new BuildingScene();
			_buildingScene1.gridData = gridResVO.resObject.buildingGrid1 ;
			addScene(_buildingScene1);
			//地图区域2
			_groundScene2 = new GroundScene();
			_groundScene2.gridData = gridResVO.resObject.groundGrid2 ;
			addScene(_groundScene2);
			_buildingScene2 = new BuildingScene();
			_buildingScene2.gridData = gridResVO.resObject.buildingGrid2 ;
			addScene(_buildingScene2);
			//地图区域3
			_groundScene3 = new GroundScene();
			_groundScene3.gridData = gridResVO.resObject.groundGrid3 ;
			addScene(_groundScene3);
			_buildingScene3 = new BuildingScene();
			_buildingScene3.gridData = gridResVO.resObject.buildingGrid3 ;
			addScene(_buildingScene3);
			//删除地图数据
			ResourceUtil.instance.deleteRes("mapdata"); 
			//跟随鼠标移动的建筑
			_mouseContainer = new IsoObject(GameSetting.GRID_SIZE,GameSetting.GRID_X , GameSetting.GRID_Z);
			_mouseContainer.visible=false;
			_buildingScene3.addChild( _mouseContainer );
			//配置侦听
			configListeners();
		}
		
		/**
		 * 侦听事件  
		 */		
		protected function configListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE , onMouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_UP , onMouseUpHandler );
			this.addEventListener(MouseEvent.ROLL_OUT , onMouseRollOut);
			
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , onResizeHandler );
		}
		
		/**
		 * 窗口大小变化
		 * @param e
		 */		
		protected function onResizeHandler( e:GlobalEvent ):void
		{
			modifyMapPosition();
		}
		
		/**
		 * 鼠标移出地图区域时 
		 * @param e
		 */		
		protected function onMouseRollOut(e:MouseEvent):void
		{
			this.stopDrag();
			_mapIsMove = false ;
			if(GameData.mouseBuilding) {
				GameData.mouseBuilding.selectedStatus(false);
			}
		}
		/**
		 * 鼠标按下 
		 * @param e
		 */		
		protected function onMouseDownHandler(e:MouseEvent):void
		{
			var rect:Rectangle = new Rectangle();
			rect.x = -GameSetting.MAX_WIDTH*scaleX+stage.stageWidth ;
			rect.y = -GameSetting.MAX_HEIGHT*scaleX+stage.stageHeight ;
			rect.width =GameSetting.MAX_WIDTH*scaleX-stage.stageWidth ;
			rect.height = GameSetting.MAX_HEIGHT*scaleX-stage.stageHeight ;
			this.startDrag( false  , rect );
		}
		
		/**
		 * 鼠标按下弹起时 
		 * @param e
		 */		
		protected function onMouseUpHandler(e:MouseEvent):void
		{
			this.stopDrag();
			if(!_mapIsMove) {
				onClick(e);
			}
			_mapIsMove = false ;
		}
		
		/** 鼠标点击 */
		protected function onClick(e:MouseEvent):void
		{ }
		
		/**
		 * 根据node位置，添加建筑 
		 * @param nodeX
		 * @param nodeZ
		 * @reutrn 添加成功建筑
		 */		
		protected function addBuilding( nodeX:int , nodeZ:int , vo:BuildingVO ):BuildingBase
		{
			var dx:int = nodeX*GameSetting.GRID_SIZE ;
			var dz:int = nodeZ*GameSetting.GRID_SIZE ;
			
			var result:BuildingBase  ;
			if(nodeX<0 || nodeZ<0 || nodeX>=GameSetting.GRID_X || nodeZ>=GameSetting.GRID_Z) return result ;
			
			if(vo.baseVO.type==BuildingType.ROAD)
			{
				var groundScene:GroundScene = getMouseGroundScene (nodeX,nodeZ);
				if(groundScene) {
					result = groundScene.addBuildingByVO( dx,dz,vo);
				}
			}
			else
			{
				var buildingScene:BuildingScene = getMouseBuildingScene(nodeX,nodeZ);
				if(buildingScene) {
					result = buildingScene.addBuildingByVO( dx,dz,vo);
				}
			}
			return result;
		}
		
		/**
		 * 当前鼠标在哪个 GroundScene上是walkable=true
		 * @param nodeX
		 * @param nodeZ
		 * @return 
		 */		
		protected function getMouseGroundScene( nodeX:int , nodeZ:int ):GroundScene
		{
			var groundScene:GroundScene = _groundScene3.gridData.getNode(nodeX,nodeZ).walkable? _groundScene3: 
				(_groundScene2.gridData.getNode(nodeX,nodeZ).walkable?_groundScene2:
				(_groundScene1.gridData.getNode(nodeX,nodeZ).walkable?_groundScene1:null) );
			return groundScene;
		}
		
		/**
		 * 当前鼠标在哪个 BuildingScene上是walkable=true
		 * @param nodeX
		 * @param nodeZ
		 * @return 
		 */		
		protected function getMouseBuildingScene( nodeX:int , nodeZ:int ):BuildingScene
		{
			var buildingScene:BuildingScene = _buildingScene3.gridData.getNode(nodeX,nodeZ).walkable? _buildingScene3: 
				(_buildingScene2.gridData.getNode(nodeX,nodeZ).walkable?_buildingScene2:
				(_buildingScene1.gridData.getNode(nodeX,nodeZ).walkable?_buildingScene1:null) );
			return buildingScene;
		}
		
		/**
		 * 鼠标移动时 
		 * @param e
		 */		
		protected function onMouseMoveHandler(e:MouseEvent):void
		{
			if(e.buttonDown)
			{
				_mapIsMove = true ;
			}
			else if(_mouseContainer.numChildren>0) 
			{
				updateMouseBuildingGrid();
				_mouseIsMove = false ;
				return ;
			}
			_mouseIsMove = true ;
			if(GameData.mouseBuilding){
				GameData.mouseBuilding.selectedStatus(true);	
			}
		}
		
		/**
		 *更新鼠标上面的建筑占用的网格的颜色
		 */		
		protected function updateMouseBuildingGrid():void
		{
			var xx:int = (stage.mouseX-this.x)/scaleX -sceneLayerOffsetX ;
			var yy:int = (stage.mouseY -this.y)/scaleX-sceneLayerOffsetY;
			var p:Point = IsoUtils.screenToIsoGrid( GameSetting.GRID_SIZE,xx,yy);
			if(_mouseContainer.nodeX!=p.x || _mouseContainer.nodeZ!=p.y)
			{
				_mouseContainer.nodeX = p.x ;
				_mouseContainer.nodeZ = p.y ;
				var build:BuildingBase = _mouseContainer.getChildAt(0) as BuildingBase;
				if( build.buildingVO.baseVO.type==BuildingType.ROAD)
				{
					var scene:GroundScene = this.getMouseGroundScene(p.x,p.y);
					if(scene && scene.gridData.getNode(p.x,p.y).walkable){
						build.gridLayer.setWalkabled(true);
					}else{
						build.gridLayer.setWalkabled(false);
					}
				}
				else
				{
					p = IsoUtils.screenToIsoGrid( GameSetting.GRID_SIZE,xx,yy);
					build.gridLayer.update( p.x,p.y);
				}
			}
		}
		
		/**
		 *  纠正地图位置，防止出界
		 */		
		protected function modifyMapPosition():void
		{
			if(x>0) x=0 ;
			else if(x<-GameSetting.MAX_WIDTH*scaleX+stage.stageWidth){
				x = -GameSetting.MAX_WIDTH*scaleX+stage.stageWidth ;
			}
			if(y>0) y=0 ;
			else if(y<-GameSetting.MAX_HEIGHT*scaleX+stage.stageHeight){
				y = -GameSetting.MAX_HEIGHT*scaleX+stage.stageHeight ;
			}
		}
	}
}