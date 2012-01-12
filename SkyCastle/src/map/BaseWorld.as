package map
{
	import bing.iso.*;
	import bing.res.ResVO;
	import bing.utils.InteractivePNG;
	
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
		public var buildingScene1:BuildingScene ;
		public var groundScene1:GroundScene;
		public var buildingScene2:BuildingScene ;
		public var groundScene2:GroundScene;
		public var buildingScene3:BuildingScene ;
		public var groundScene3:GroundScene;
		//**********************************************************/
		/** 鼠标的node位置*/
		public var mouseNodePoint:Point = new Point();
		public var gridScene:IsoScene ;
		public var mouseContainer:IsoObject; //跟随鼠标移动的建筑
		private var _mapIsMove:Boolean=false; //地图是否在移动
		
		/**
		 * 游戏世界基类
		 */		
		public function BaseWorld()
		{
			super(GameSetting.MAP_WIDTH , GameSetting.MAP_HEIGHT,GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE);
			
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
//			gridScene = new IsoScene(GameSetting.GRID_SIZE);
//			(gridScene.addChild( new IsoGrid(GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE)) as IsoGrid).render() ;
//			gridScene.cacheAsBitmap=true;
//			this.addScene(gridScene);
			
			var gridResVO:ResVO = ResourceUtil.instance.getResVOByName("mapdata");
			//地图区域1
			groundScene1 = new GroundScene();
			groundScene1.gridData = gridResVO.resObject.groundGrid1 ;
			addScene(groundScene1);
			buildingScene1 = new BuildingScene();
			buildingScene1.gridData = gridResVO.resObject.buildingGrid1 ;
			addScene(buildingScene1);
			//地图区域2
			groundScene2 = new GroundScene();
			groundScene2.gridData = gridResVO.resObject.groundGrid2 ;
			addScene(groundScene2);
			buildingScene2 = new BuildingScene();
			buildingScene2.gridData = gridResVO.resObject.buildingGrid2 ;
			addScene(buildingScene2);
			//地图区域3
			groundScene3 = new GroundScene();
			groundScene3.gridData = gridResVO.resObject.groundGrid3 ;
			addScene(groundScene3);
			buildingScene3 = new BuildingScene();
			buildingScene3.gridData = gridResVO.resObject.buildingGrid3 ;
			addScene(buildingScene3);
			//删除地图数据
			ResourceUtil.instance.deleteRes("mapdata"); 
			//跟随鼠标移动的建筑
			mouseContainer = new IsoObject(GameSetting.GRID_SIZE,GameSetting.GRID_X , GameSetting.GRID_Z);
			mouseContainer.visible=false;
			buildingScene3.addChild( mouseContainer );
			//配置侦听
			configListeners();
		}
		
		/**
		 * 侦听事件  
		 */		
		protected function configListeners():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_MOVE , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_OVER , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_OUT , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_UP , onMouseEventHandler );
			addEventListener(MouseEvent.ROLL_OUT , onMouseEventHandler);
			
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , onResizeHandler );
		}
		
		//处理鼠标事件 
		private function onMouseEventHandler(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					var rect:Rectangle = new Rectangle();
					rect.x = -GameSetting.MAX_WIDTH*scaleX+stage.stageWidth ;
					rect.y = -GameSetting.MAX_HEIGHT*scaleX+stage.stageHeight ;
					rect.width =GameSetting.MAX_WIDTH*scaleX-stage.stageWidth ;
					rect.height = GameSetting.MAX_HEIGHT*scaleX-stage.stageHeight ;
					this.startDrag( false  , rect );
					break;
				case MouseEvent.MOUSE_MOVE:
					var xx:int = (stage.mouseX-this.x)/scaleX -sceneLayerOffsetX ;
					var yy:int = (stage.mouseY -this.y)/scaleX-sceneLayerOffsetY;
					mouseNodePoint = IsoUtils.screenToIsoGrid( GameSetting.GRID_SIZE,xx,yy);
					if(e.buttonDown)	{
						_mapIsMove = true ;
					}else if(mouseContainer.numChildren>0) {
						updateMouseBuildingGrid();
						return ;
					}
					break;
				case MouseEvent.MOUSE_OVER:
					if(e.target is InteractivePNG){
						(e.target as InteractivePNG).parent["selectedStatus"](true);
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if(e.target is InteractivePNG){
						(e.target as InteractivePNG).parent["selectedStatus"](false);
					}
					break;
				case MouseEvent.MOUSE_UP:
					this.stopDrag();
					if(!_mapIsMove) {
						onClick(e);
					}
					_mapIsMove = false ;
					break;
				case MouseEvent.ROLL_OUT:
					this.stopDrag();
					_mapIsMove = false ;
					break;
			}
		}
		
		/**
		 * 窗口大小变化
		 * @param e
		 */		
		protected function onResizeHandler( e:GlobalEvent ):void
		{
			modifyMapPosition();
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
			var groundScene:GroundScene = groundScene3.gridData.getNode(nodeX,nodeZ).walkable? groundScene3: 
				(groundScene2.gridData.getNode(nodeX,nodeZ).walkable?groundScene2:
				(groundScene1.gridData.getNode(nodeX,nodeZ).walkable?groundScene1:null) );
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
			var buildingScene:BuildingScene = buildingScene3.gridData.getNode(nodeX,nodeZ).walkable? buildingScene3: 
				(buildingScene2.gridData.getNode(nodeX,nodeZ).walkable?buildingScene2:
				(buildingScene1.gridData.getNode(nodeX,nodeZ).walkable?buildingScene1:null) );
			return buildingScene;
		}
		
		/**
		 *更新鼠标上面的建筑占用的网格的颜色
		 */		
		protected function updateMouseBuildingGrid():void
		{
			
			if(mouseContainer.nodeX!=mouseNodePoint.x || mouseContainer.nodeZ!=mouseNodePoint.y)
			{
				mouseContainer.nodeX = mouseNodePoint.x ;
				mouseContainer.nodeZ =mouseNodePoint.y ;
				var build:BuildingBase = mouseContainer.getChildAt(0) as BuildingBase;
				if( build.buildingVO.baseVO.type==BuildingType.ROAD)
				{
					var scene:GroundScene = this.getMouseGroundScene(mouseNodePoint.x,mouseNodePoint.y);
					if(scene && scene.gridData.getNode(mouseNodePoint.x,mouseNodePoint.y).walkable){
						build.gridLayer.setWalkabled(true);
					}else{
						build.gridLayer.setWalkabled(false);
					}
				}
				else
				{
					var xx:int = (stage.mouseX-this.x)/scaleX -sceneLayerOffsetX ;
					var yy:int = (stage.mouseY -this.y)/scaleX-sceneLayerOffsetY;
					var p:Point = IsoUtils.screenToIsoGrid( GameSetting.GRID_SIZE,xx,yy);
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