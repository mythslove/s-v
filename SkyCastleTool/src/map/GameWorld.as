package map
{
	import bing.iso.IsoGrid;
	import bing.iso.IsoObject;
	import bing.iso.IsoScene;
	import bing.iso.IsoUtils;
	import bing.iso.IsoWorld;
	import bing.iso.Rhombus;
	
	import comm.Assets;
	import comm.GameData;
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	import comm.GlobalEvent;
	
	import enums.BuildingCurrentOperation;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import models.MapDataModel;

	/**
	 * 游戏世界  
	 * @author zzhanglin
	 */	
	public class GameWorld extends IsoWorld
	{
		protected static var _instance:GameWorld;
		public static function get instance():GameWorld
		{
			if(!_instance) _instance= new GameWorld();
			return _instance ;
		}
		//=====================================
		protected var _mouseContainer:IsoObject ;
		public function get mouseContainer():IsoObject{
			return _mouseContainer ;
		}
		
		protected var _gridScene:IsoScene ;
		public function get gridScene():IsoScene{
			return _gridScene;
		}
		protected var _impactScene:IsoScene ;
		public function get impactScene():IsoScene{
			return _impactScene;
		}
		protected var _forbiddenScene:IsoScene ;
		public function get forbiddenScene():IsoScene{
			return _forbiddenScene;
		}
		protected var _isMove:Boolean=false;
		
		/**
		 * 游戏世界构造函数 
		 */		
		public function GameWorld()
		{
			super(GameSetting.MAP_WIDTH , GameSetting.MAP_HEIGHT,GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE);
			if(_instance) throw new Error("只能实例化一个GameWorld");
			else _instance = this ;
			this.mouseChildren = false ;
			
			//设置背景图片
			var bg:Bitmap = new Assets.BG();
			this.setBackGround(bg);
				
			//设置地图显示参数
			GameSetting.MAX_WIDTH = bg.width;
			GameSetting.MAX_HEIGHT = bg.height ;
			this.panTo( GameSetting.MAX_WIDTH>>1 , -410);
			
		}
		
		/**
		 * 添加到舞台上时 
		 * @param e
		 */		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			//显示地图网格
			_gridScene = new IsoScene(GameSetting.GRID_SIZE);
			(_gridScene.addChild( new IsoGrid(GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE)) as IsoGrid).render() ;
			_gridScene.cacheAsBitmap=true;
			this.addScene(_gridScene);
			
			_forbiddenScene = new IsoScene(GameSetting.GRID_SIZE);
			_forbiddenScene.createGridData( GameSetting.GRID_X , GameSetting.GRID_Z);
			_forbiddenScene.cacheAsBitmap=true;
			this.addScene(_forbiddenScene);
			
			_impactScene = new IsoScene(GameSetting.GRID_SIZE);
			_impactScene.createGridData( GameSetting.GRID_X , GameSetting.GRID_Z);
			_impactScene.cacheAsBitmap=true;
			this.addScene(_impactScene);
			
			_mouseContainer = new IsoObject(GameSetting.GRID_SIZE,1,1);
			_gridScene.addIsoObject(_mouseContainer);
			
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
			this.addEventListener(MouseEvent.RIGHT_CLICK , onRightClickHandler);
			
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , globalEventHandler );
		}
		protected function onRightClickHandler(e:MouseEvent):void
		{
			GameData.buildingCurrOperation = BuildingCurrentOperation.NONE ;
		}
		/**
		 * 鼠标移出地图区域时 
		 * @param e
		 */		
		protected function onMouseRollOut(e:MouseEvent):void
		{
			this.stopDrag();
			_isMove = false ;
		}
		
		/**
		 * 鼠标按下 
		 * @param e
		 */		
		protected function onMouseDownHandler(e:MouseEvent):void
		{
			var rect:Rectangle = new Rectangle();
			rect.x = -GameSetting.MAX_WIDTH*scaleX+stage.stageWidth ;
			rect.y = -GameSetting.MAX_HEIGHT*scaleX+stage.stageHeight-60 ;
			rect.width =GameSetting.MAX_WIDTH*scaleX-stage.stageWidth ;
			rect.height = GameSetting.MAX_HEIGHT*scaleX-stage.stageHeight+50 ;
			this.startDrag( false  , rect );
		}
		
		/**
		 * 鼠标按下弹起时 
		 * @param e
		 */		
		protected function onMouseUpHandler(e:MouseEvent):void
		{
			this.stopDrag();
			if(!_isMove)
			{
				if(GameData.buildingCurrOperation==BuildingCurrentOperation.ADD_IMPACT)
				{
					if(_mouseContainer.getWalkable(_impactScene.gridData))
					{
						var obj:IsoObject = new IsoObject(GameSetting.GRID_SIZE,1,1);
						obj.addChild( new Rhombus(GameSetting.GRID_SIZE , 0xff0000));
						obj.x = _mouseContainer.x;
						obj.z = _mouseContainer.z ;
						obj.setWalkable( false , _impactScene.gridData );
						MapDataModel.instance.addImpact( obj.nodeX , obj.nodeZ , obj );
						_impactScene.addIsoObject( obj );
					}
					else if( e.ctrlKey) //删除
					{
						obj = MapDataModel.instance.deleteImpact( _mouseContainer.nodeX , _mouseContainer.nodeZ ) as IsoObject;
						if(obj){
							obj.setWalkable( true , _impactScene.gridData );
							_impactScene.removeIsoObject( obj );
						}
					}
				}
				else if(GameData.buildingCurrOperation == BuildingCurrentOperation.ADD_FORBIDDEN)
				{
					if(_mouseContainer.getWalkable(_forbiddenScene.gridData))
					{
						obj = new IsoObject(GameSetting.GRID_SIZE,1,1);
						obj.addChild( new Rhombus(GameSetting.GRID_SIZE , 0xffcc00));
						obj.x = _mouseContainer.x;
						obj.z = _mouseContainer.z ;
						obj.setWalkable( false , _forbiddenScene.gridData );
						MapDataModel.instance.addForbidden( obj.nodeX , obj.nodeZ , obj );
						_forbiddenScene.addIsoObject( obj );
					}
					else if( e.ctrlKey) //删除
					{
						obj = MapDataModel.instance.deleteForbidden( _mouseContainer.nodeX , _mouseContainer.nodeZ ) as IsoObject;
						if(obj){
							obj.setWalkable( true , _forbiddenScene.gridData );
							_forbiddenScene.removeIsoObject( obj );
						}
					}
				}
			}
			_isMove = false ;
		}
		
		/**
		 * 鼠标移动时 
		 * @param e
		 */		
		protected function onMouseMoveHandler(e:MouseEvent):void
		{
			if(e.buttonDown)_isMove = true ;
			
			var xx:int = (e.stageX-this.x)/scaleX - this.sceneLayerOffsetX ;
			var yy:int = (e.stageY -this.y-GameSetting.GRID_SIZE)/scaleX - this.sceneLayerOffsetY;
			
			var p:Point = IsoUtils.screenToIsoGrid( GameSetting.GRID_SIZE,xx,yy);
			
			var dx:int = p.x*GameSetting.GRID_SIZE ;
			var dz:int = p.y*GameSetting.GRID_SIZE ;
			_mouseContainer.x = dx;
			_mouseContainer.z = dz;
		}
		
		/**
		 * 处理全局事件  
		 * @param e
		 */		
		protected function globalEventHandler( e:GlobalEvent ):void
		{
			switch( e.type )
			{
				case GlobalEvent.RESIZE:
					//纠正地图位置
					if(x<-GameSetting.MAX_WIDTH*scaleX+stage.stageWidth){
						x = -GameSetting.MAX_WIDTH*scaleX+stage.stageWidth ;
					}
					if(y<-GameSetting.MAX_HEIGHT*scaleX+stage.stageHeight){
						y = -GameSetting.MAX_HEIGHT*scaleX+stage.stageHeight ;
					}
					break ;
			}
		}
	}
}