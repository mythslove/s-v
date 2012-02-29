package local.game
{
	import bing.iso.*;
	import bing.utils.ContainerUtil;
	import bing.utils.InteractivePNG;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	import local.comm.*;
	import local.enum.*;
	import local.game.elements.*;
	import local.game.scenes.*;
	import local.model.buildings.vos.*;
	import local.model.map.*;
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
		public var effectScene:IsoScene ;
		//----------------------------------------------------------------*/
		protected var _mapGridData:MapGridDataModel ; //地图数据
		protected var _tooltip:BuildingToolTip ;
		protected var _mapIsMove:Boolean=false; 
		protected var _topBuilding:Building; 
		protected var _mouseOverBuild:Building ;//当前鼠标在哪个建筑上面
		
		public function BaseWorld()
		{
			super(GameSetting.MAP_WIDTH, GameSetting.MAX_HEIGHT , GameSetting.GRID_X, GameSetting.GRID_Z, GameSetting.GRID_SIZE);
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
//			var gridScene:IsoScene = new IsoScene(GameSetting.GRID_SIZE);
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
			//iso顶层场景
			topScene = new IsoScene(GameSetting.GRID_SIZE,GameSetting.GRID_X , GameSetting.GRID_Z);
			topScene.visible = topScene.mouseEnabled= topScene.mouseChildren=false;
			addScene( topScene );
			//特效层
			effectScene = new IsoScene(GameSetting.GRID_SIZE,GameSetting.GRID_X , GameSetting.GRID_Z);
			effectScene.mouseEnabled= effectScene.mouseChildren=false;
			addScene(effectScene);
			//tooltip
			_tooltip = BuildingToolTip.instance ;
			_tooltip.hideTooltip();
			addChild(_tooltip);
			//配置侦听
			configListeners();
		}
		
		/**放大缩小地图 */		
		public function zoom( value:Number =1 ):void
		{
			var prevW:Number = GameSetting.MAP_WIDTH*scaleX;
			var prevH:Number = GameSetting.MAP_HEIGHT*scaleX;
			scaleX= scaleY = value ;
			x+=(prevW-GameSetting.MAP_WIDTH*scaleX)>>1;
			y+=(prevH-GameSetting.MAP_HEIGHT*scaleX)>>1;
			modifyMapPosition();
			//更正特效大小
			for(var i:int =0  ; i<effectScene.numChildren ; ++i){
				effectScene.getChildAt(i).scaleX = 1/scaleX;
				effectScene.getChildAt(i).scaleY = 1/scaleX;
			}
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
		
		/**
		 * 添加一个特效 
		 * @param effect
		 */		
		public function addEffect( effect:Sprite ):void
		{
			effect.scaleX = 1/scaleX ;
			effect.scaleY = 1/scaleX; 
			effectScene.addChild( effect );
		}
		
		/**
		 * 从场景上移除一个建筑 
		 * @param build
		 * @param updateDirection 主要用于地面建筑自动更新UI方向
		 */
		protected function removeBuildFromScene( build:Building , updateDirection:Boolean=true   ):void
		{
			if(build.parent is BuildingScene) {
				(build.parent as BuildingScene).removeBuilding( build );
			} else if(build.parent is GroundScene) {
				(build.parent as GroundScene).removeBuilding( build , updateDirection );
			}
		}
		
		/**
		 * 添加一个建筑到场景上 
		 * @param build
		 * @param isSort 是否进行深度排序
		 * @param updateDirection 主要用于地面建筑自动更新UI方向
		 */		
		protected function addBuildToScene( build:Building, isSort:Boolean=true , updateDirection:Boolean=true ):void
		{
			if(build.buildingVO.baseVO.layer==LayerType.BUILDING) {
				getBuildingScene(build.nodeX,build.nodeZ).addBuilding( build , isSort );
			} else if(build.buildingVO.baseVO.layer==LayerType.GROUND) {
				getGroundScene(build.nodeX,build.nodeZ).addBuilding( build , isSort , updateDirection );
			}
		}
		
		/**
		 * 根据node位置和buildingVO，添加建筑 
		 * @param nodeX
		 * @param nodeZ 
		 * @param isSort  是否进行深度排序
		 * @param updateDirection 是否自动改变方向，主要用于Ground层的建筑
		 * @reutrn 添加成功建筑
		 */		
		protected function addBuildingByVO( nodeX:int , nodeZ:int , vo:BuildingVO , isSort:Boolean=true , updateDirection:Boolean=true ):Building
		{
			var dx:int = nodeX*GameSetting.GRID_SIZE ;
			var dz:int = nodeZ*GameSetting.GRID_SIZE ;
			
			var result:Building  ;
			if(nodeX<0 || nodeZ<0 || nodeX>=GameSetting.GRID_X || nodeZ>=GameSetting.GRID_Z) return result ;
			
			if(vo.baseVO.layer==LayerType.GROUND) //添加到地面层
			{
				var groundScene:GroundScene = getGroundScene (nodeX,nodeZ);
				if(groundScene) {
					result = groundScene.addBuildingByVO( dx,dz,vo,isSort,updateDirection);
				}
			}
			else if(vo.baseVO.layer==LayerType.BUILDING)//添加到建筑层
			{
				var buildingScene:BuildingScene = getBuildingScene(nodeX,nodeZ);
				if(buildingScene) {
					result = buildingScene.addBuildingByVO( dx,dz,vo,isSort);
				}
			}
			return result;
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
		
		/** 添加侦听*/
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
		
		/** 处理鼠标事件 */		
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
						_mouseOverBuild.onMouseOver() ;
						_tooltip.showTooltip(_mouseOverBuild.description , _mouseOverBuild.title );
					}
					break;
				case MouseEvent.MOUSE_UP:
					if(!_mapIsMove) onClick(e);
				case MouseEvent.ROLL_OUT:
					this.stopDrag();
				case MouseEvent.MOUSE_OUT:
					_mapIsMove = false ;
					_tooltip.hideTooltip();
					if(e.type!=MouseEvent.MOUSE_UP && _mouseOverBuild){
						_mouseOverBuild.onMouseOut();
						_mouseOverBuild = null ;
					}
					break;
			}
		}
		
		/** 单击*/
		protected function onClick( e:MouseEvent ):void{}
		
		/** 窗口大小变化*/		
		protected function onResizeHandler( e:GlobalEvent ):void {
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
		
		/** 更新顶部建筑的位置和网格 */
		protected function updateTopBuild():void
		{
			var offsetY:Number = Math.floor( (_topBuilding.buildingVO.baseVO.xSpan+_topBuilding.buildingVO.baseVO.zSpan)*0.5-1)*GameSetting.GRID_SIZE ;
			var p:Point = pixelPointToGrid(stage.mouseX,stage.mouseY , 0 ,offsetY); 
			if(_topBuilding.nodeX!=p.x || _topBuilding.nodeZ!=p.y) {
				_topBuilding.nodeX = p.x ;
				_topBuilding.nodeZ= p.y ;
				_topBuilding.gridLayer.updateBuildingGridLayer( p.x, p.y , _topBuilding.baseBuildingVO.layer );
			}
		}
	}
}