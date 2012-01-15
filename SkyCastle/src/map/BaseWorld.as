package map
{
	import bing.iso.*;
	import bing.utils.InteractivePNG;
	
	import comm.*;
	
	import enums.LayerType;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import map.elements.Building;
	import map.elements.BuildingBase;
	
	import models.MapGridDataModel;
	import models.vos.BuildingBaseVO;
	import models.vos.BuildingVO;
	
	import utils.ResourceUtil;
	
	import views.tooltip.BuildingToolTip;
	
	public class BaseWorld extends IsoWorld
	{
		//**----------------------------------------------------------------*
		public var groundScene1:GroundScene;
		public var groundScene2:GroundScene;
		public var groundScene3:GroundScene;
		
		public var buildingScene1:BuildingScene ;
		public var buildingScene2:BuildingScene ;
		public var buildingScene3:BuildingScene ;
		//----------------------------------------------------------------*/
		/** 鼠标的node位置 */
		public var mouseNodePoint:Point = new Point();
		/** 跟随鼠标移动的建筑 */
		public var mouseContainer:IsoObject; 
		/** 当前鼠标在哪个建筑上面 */
		public var mouseOverBuild:Building ; 
		//----------------------------------------------------------------*/
		protected var _gridScene:IsoScene ; //网格层
		protected var _mapGridData:MapGridDataModel ; //地图数据
		protected var _tooltip:BuildingToolTip ;
		protected var _mapIsMove:Boolean=false; 
		/** 地图是否在移动 */
		public function mapIsMove():Boolean{ 
			return _mapIsMove ; 
		}
		//----------------------------------------------------------------*/
		/**游戏世界基类*/		
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
			
			_mapGridData = MapGridDataModel.instance;
			//地图区域1
			groundScene1 = new GroundScene();
			addScene(groundScene1);
			buildingScene1 = new BuildingScene();
			addScene(buildingScene1);
			//地图区域2
			groundScene2 = new GroundScene();
			addScene(groundScene2);
			buildingScene2 = new BuildingScene();
			addScene(buildingScene2);
			//地图区域3
			groundScene3 = new GroundScene();
			addScene(groundScene3);
			buildingScene3 = new BuildingScene();
			addScene(buildingScene3);
			//删除地图数据
			ResourceUtil.instance.deleteRes("mapdata"); 
			//跟随鼠标移动的建筑
			mouseContainer = new IsoObject(GameSetting.GRID_SIZE,GameSetting.GRID_X , GameSetting.GRID_Z);
			mouseContainer.mouseEnabled= mouseContainer.mouseChildren=false;
			mouseContainer.visible=false;
			buildingScene3.addChild( mouseContainer );
			//tooltip
			_tooltip = BuildingToolTip.instance ;
			_tooltip.hideTooltip();
			addChild(_tooltip);
			//配置侦听
			configListeners();
		}
		
		/**  侦听事件   */		
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
						_tooltip.hideTooltip();
					}else if(mouseContainer.numChildren>0) {
						updateMouseBuildingGrid();
						return ;
					}else if(e.target is InteractivePNG){
						_tooltip.updatePosition(e.stageX,e.stageY);
					}
					break;
				case MouseEvent.MOUSE_OVER:
					if(mouseContainer.numChildren==0 && e.target is InteractivePNG){
						mouseOverBuild = (e.target as InteractivePNG).parent as Building;
						mouseOverBuild.selectedStatus( true );
						var baseVO:BuildingBaseVO = mouseOverBuild.buildingVO.baseVO;
						_tooltip.showTooltip(baseVO.info , baseVO.title );
					}
					break;
				case MouseEvent.MOUSE_UP:
					if(!_mapIsMove) onClick(e);
					this.stopDrag();
				case MouseEvent.ROLL_OUT:
					this.stopDrag();
				case MouseEvent.MOUSE_OUT:
					_mapIsMove = false ;
					_tooltip.hideTooltip();
					if(e.type!=MouseEvent.MOUSE_UP && mouseOverBuild){
						mouseOverBuild.selectedStatus( false );
						mouseOverBuild = null ;
					}
					break;
			}
		}
		
		/** 窗口大小变化*/		
		protected function onResizeHandler( e:GlobalEvent ):void
		{
			modifyMapPosition();
		}
		
		/** 鼠标点击 */
		protected function onClick(e:MouseEvent):void
		{ }
		
		
		/**
		 * 当前鼠标在哪个 GroundScene上是walkable=true
		 * @param nodeX
		 * @param nodeZ
		 * @return 
		 */		
		public function getGroundScene( nodeX:int , nodeZ:int ):GroundScene
		{
			var index:int = int(_mapGridData.sceneHash[nodeX+"-"+nodeZ]) ;
			if(index==1) return groundScene1 ;
			else if( index==2 ) return groundScene1 ;
			else if( index==3 ) return groundScene1 ;
			return null ;
		}
		
		/**
		 * 当前鼠标在哪个 BuildingScene上是walkable=true
		 * @param nodeX
		 * @param nodeZ
		 * @return 
		 */		
		public function getBuildingScene( nodeX:int , nodeZ:int ):BuildingScene
		{
			var index:int = int(_mapGridData.sceneHash[nodeX+"-"+nodeZ]) ;
			if(index==1) return buildingScene1 ;
			else if( index==2 ) return buildingScene2 ;
			else if( index==3 ) return buildingScene3 ;
			return null ;
		}
		
		/** 更新鼠标上面的建筑占用的网格的颜色 */		
		protected function updateMouseBuildingGrid():void
		{
			if(mouseContainer.nodeX!=mouseNodePoint.x || mouseContainer.nodeZ!=mouseNodePoint.y)
			{
				mouseContainer.nodeX = mouseNodePoint.x ;
				mouseContainer.nodeZ =mouseNodePoint.y ;
				var build:BuildingBase = mouseContainer.getChildAt(0) as BuildingBase;
				build.gridLayer.updateBuildingGridLayer( mouseNodePoint.x, mouseNodePoint.y , build.buildingVO.baseVO.layerType );
			}
		}
		
		/** 从场景上移除一个建筑 */
		protected function removeBuildFromScene( build:Building ):void
		{
			if(build.parent is BuildingScene) {
				(build.parent as BuildingScene).removeBuilding( build );
			} else if(build.parent is GroundScene) {
				(build.parent as GroundScene).removeBuilding( build );
			}
		}
		
		/** 添加一个建筑到场景上*/
		protected function addBuildToScene( build:Building ):void
		{
			if(build.buildingVO.baseVO.layerType==LayerType.BUILDING) {
				getBuildingScene(build.nodeX,build.nodeZ).addBuilding( build );
			} else if(build.buildingVO.baseVO.layerType==LayerType.GROUND) {
				getGroundScene(build.nodeX,build.nodeZ).addBuilding( build );
			}
		}
		
		/**
		 * 根据node位置和buildingVO，添加建筑 
		 * @param nodeX
		 * @param nodeZ
		 * @param isSort 
		 * @param updateDirection
		 * @reutrn 添加成功建筑
		 */		
		protected function addBuildingByVO( nodeX:int , nodeZ:int , vo:BuildingVO , isSort:Boolean=true , updateDirection:Boolean=true ):BuildingBase
		{
			var dx:int = nodeX*GameSetting.GRID_SIZE ;
			var dz:int = nodeZ*GameSetting.GRID_SIZE ;
			
			var result:BuildingBase  ;
			if(nodeX<0 || nodeZ<0 || nodeX>=GameSetting.GRID_X || nodeZ>=GameSetting.GRID_Z) return result ;
			
			if(vo.baseVO.layerType==LayerType.GROUND) //添加到地面层
			{
				var groundScene:GroundScene = getGroundScene (nodeX,nodeZ);
				if(groundScene) {
					result = groundScene.addBuildingByVO( dx,dz,vo,isSort,updateDirection);
				}
			}
			else if(vo.baseVO.layerType==LayerType.BUILDING)//添加到建筑层
			{
				var buildingScene:BuildingScene = getBuildingScene(nodeX,nodeZ);
				if(buildingScene) {
					result = buildingScene.addBuildingByVO( dx,dz,vo,isSort);
				}
			}
			return result;
		}
		
		/**纠正地图位置，防止出界*/		
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