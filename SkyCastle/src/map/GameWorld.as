package map
{
	import bing.iso.IsoScene;
	import bing.iso.IsoUtils;
	import bing.iso.IsoWorld;
	import bing.utils.ObjectUtil;
	
	import comm.GameData;
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	import comm.GlobalEvent;
	
	import enums.BuildingCurrentOperation;
	import enums.BuildingType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import models.ShopModel;
	import models.vos.BuildingVO;
	
	import utils.ResourceUtil;

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
		protected var _buildingScene:BuildingScene ;
		public function get buildingScene():BuildingScene{
			return _buildingScene ;
		}
		protected var _groundScene:GroundScene;
		public function get groundScene():GroundScene{
			return _groundScene ;
		}
		protected var _gridScene:IsoScene ;
		public function get gridScene():IsoScene{
			return _gridScene;
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
			var bg:Bitmap = new Bitmap( ResourceUtil.instance.getInstanceByClassName("bg","BG") as BitmapData );
			this.setBackGround(bg);
			ResourceUtil.instance.deleteRes("bg")//把加载的背景图片卸载了
				
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
			
			_groundScene = new GroundScene();
			_groundScene.cacheAsBitmap = true ;
			_groundScene.createGridData(GameSetting.GRID_X,GameSetting.GRID_Z);
			_groundScene.mouseEnabled = false ;
			addScene(_groundScene);
			
			_buildingScene = new BuildingScene();
			_buildingScene.mouseEnabled = false ;
			_buildingScene.createGridData(GameSetting.GRID_X,GameSetting.GRID_Z);
			addScene(_buildingScene);
			
			configListeners();
		}
		
		/**
		 * 侦听事件  
		 */		
		protected function configListeners():void
		{
			this.addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			this.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE , onMouseMoveHandler);
			this.addEventListener(MouseEvent.MOUSE_UP , onMouseUpHandler );
			this.addEventListener(MouseEvent.ROLL_OUT , onMouseRollOut);
			
			GlobalDispatcher.instance.addEventListener(GlobalEvent.RESIZE , globalEventHandler );
		}
		
		/**
		 * 鼠标移出地图区域时 
		 * @param e
		 */		
		protected function onMouseRollOut(e:MouseEvent):void
		{
			this.stopDrag();
			_isMove = false ;
			if(GameData.mouseBuilding) {
				GameData.mouseBuilding.selectedStatus(false);
			}
		}
		
		/**
		 *不断地执行 
		 * @param e
		 */		
		protected function onEnterFrameHandler(e:Event):void
		{
			GameData.mouseBuilding = null ;
			update() ;
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
			if(!_isMove) 
			{
				var xx:int = (e.stageX-this.x)/scaleX - this.sceneLayerOffsetX ;
				var yy:int = (e.stageY -this.y)/scaleX - this.sceneLayerOffsetY;
				
				var p:Point = IsoUtils.screenToIsoGrid( GameSetting.GRID_SIZE,xx,yy);

				var dx:int = p.x*GameSetting.GRID_SIZE ;
				var dz:int = p.y*GameSetting.GRID_SIZE ;
				
				var vo:BuildingVO ;
				if(GameData.buildingCurrOperation==BuildingCurrentOperation.ADD)
				{
					vo = ObjectUtil.copyObj( ShopModel.instance.houseArray[0] ) as BuildingVO;
					var result:Boolean = false ;
					if(vo.baseVO.type==BuildingType.ROAD){
						result = _groundScene.addBuilding( dx,dz,vo);
					}else{
						result = _buildingScene.addBuilding( dx,dz,vo);
					}
				}
			}
			_isMove = false ;
			if(GameData.mouseBuilding) {
				GameData.mouseBuilding.selectedStatus(false);
			}
		}
		
		/**
		 * 鼠标移动时 
		 * @param e
		 */		
		protected function onMouseMoveHandler(e:MouseEvent):void
		{
			if(e.buttonDown)_isMove = true ;
			if(GameData.mouseBuilding) {
				GameData.mouseBuilding.selectedStatus(true);
			}
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
					modifyMapPosition();
					break ;
			}
		}
		
		/**
		 * 地图放大和缩小 
		 * @param scale
		 */		
		public function zoom( scale:Number):void
		{
			this.scaleX = this.scaleY = scale ;
			modifyMapPosition();
		}
		
		/**
		 *  纠正地图位置，防止出界
		 */		
		protected function modifyMapPosition():void
		{
			if(x<-GameSetting.MAX_WIDTH*scaleX+stage.stageWidth){
				x = -GameSetting.MAX_WIDTH*scaleX+stage.stageWidth ;
			}
			if(y<-GameSetting.MAX_HEIGHT*scaleX+stage.stageHeight){
				y = -GameSetting.MAX_HEIGHT*scaleX+stage.stageHeight ;
			}
		}
	}
}