package local.game
{
	import bing.iso.IsoGrid;
	import bing.iso.IsoScene;
	import bing.iso.IsoWorld;
	import bing.utils.InteractivePNG;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.comm.GlobalEvent;
	import local.game.elements.Building;
	import local.game.scenes.BuildingScene;
	import local.game.scenes.GroundScene;
	import local.model.buildings.vos.BaseBuildingVO;
	import local.model.map.MapGridDataModel;
	import local.utils.ResourceUtil;
	import local.views.tooltip.BuildingToolTip;
	
	public class BaseWorld extends IsoWorld
	{
		//**----------------------------------------------------------------*
		public var groundScene1:GroundScene;
		public var groundScene2:GroundScene;
		public var groundScene3:GroundScene;
		public var buildingScene1:BuildingScene ;
		public var buildingScene2:BuildingScene ;
		public var buildingScene3:BuildingScene ;
		public var topScene:IsoScene;
		//----------------------------------------------------------------*/
		protected var _mapGridData:MapGridDataModel ; //地图数据
		protected var _tooltip:BuildingToolTip ;
		protected var _mapIsMove:Boolean=false; 
		protected var _topBuilding:Building; 
		protected var _mouseOverBuild:Building ;//当前鼠标在哪个建筑上面
		
		public function BaseWorld()
		{
			super(GameSetting.MAP_WIDTH, GameSetting.MAX_HEIGHT , GameSetting.GRID_X, GameSetting.GRID_Z, GameSetting.GRID_SIZE);
			mouseEnabled = false ;
			//设置背景图片
			var bg:Bitmap = new Bitmap( ResourceUtil.instance.getInstanceByClassName("init_bg","BG") as BitmapData );
			this.setBackGround(bg);
			ResourceUtil.instance.deleteRes("bg"); 
			//设置地图显示参数
			GameSetting.MAX_WIDTH = bg.width;
			GameSetting.MAX_HEIGHT = bg.height ;
			this.panTo( GameSetting.MAX_WIDTH>>1 , -410);
			//地图的初始位置
			this.x = -2200 ;
			this.y = -1500;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			//显示地图网格
			var gridScene:IsoScene = new IsoScene(GameSetting.GRID_SIZE);
			(gridScene.addChild( new IsoGrid(GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE)) as IsoGrid).render() ;
			gridScene.cacheAsBitmap=true;
			this.addScene(gridScene);
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
			//iso顶层场景
			topScene = new IsoScene(GameSetting.GRID_SIZE,GameSetting.GRID_X , GameSetting.GRID_Z);
			topScene.mouseEnabled= topScene.mouseChildren=false;
			addScene( topScene );
			//tooltip
			_tooltip = BuildingToolTip.instance ;
			_tooltip.hideTooltip();
			addChild(_tooltip);
			//配置侦听
			configListeners();
		}
		
		public function zoom( value:Number =1 ):void
		{
			
		}
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
		protected function configListeners():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_MOVE , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_OVER , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_OUT , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_UP , onMouseEventHandler );
			addEventListener(MouseEvent.ROLL_OUT , onMouseEventHandler);
			//global事件
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , onResizeHandler );
		}
		
		//处理鼠标事件 
		protected function onMouseEventHandler(e:MouseEvent):void
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
					if(e.buttonDown)	{
						_mapIsMove = true ;
						_tooltip.hideTooltip();
					}else if(_topBuilding) {
						updateTopBuild();
					}else if(e.target is InteractivePNG){
						_tooltip.updatePosition(e.stageX,e.stageY);
					}
					break;
				case MouseEvent.MOUSE_OVER:
					if( !_topBuilding && e.target is InteractivePNG){
						_mouseOverBuild = (e.target as InteractivePNG).parent as Building;
						_mouseOverBuild.selectedStatus( true );
						var baseVO:BaseBuildingVO = _mouseOverBuild.buildingVO.baseVO;
						_tooltip.showTooltip(baseVO.description , baseVO.name );
					}
					break;
				case MouseEvent.ROLL_OUT:
					this.stopDrag();
				case MouseEvent.MOUSE_OUT:
					_mapIsMove = false ;
					_tooltip.hideTooltip();
					if(e.type!=MouseEvent.MOUSE_UP && _mouseOverBuild){
						_mouseOverBuild.selectedStatus( false );
						_mouseOverBuild = null ;
					}
					break;
			}
		}
		
		/** 窗口大小变化*/		
		protected function onResizeHandler( e:GlobalEvent ):void
		{
			modifyMapPosition();
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
		protected function updateTopBuild():void
		{
			var offsetY:Number = Math.floor( (_topBuilding.buildingVO.baseVO.xSpan+_topBuilding.buildingVO.baseVO.zSpan)*0.5-1)*GameSetting.GRID_SIZE ;
			var p:Point = pixelPointToGrid(stage.mouseX,stage.mouseY , 0 ,offsetY); 
			if(_topBuilding.nodeX!=p.x || _topBuilding.nodeZ!=p.y) {
				_topBuilding.nodeX = p.x ;
				_topBuilding.nodeZ= p.y ;
				_topBuilding.gridLayer.updateBuildingGridLayer( p.x, p.y , _topBuilding.buildingVO.baseVO.layer );
			}
		}
	}
}