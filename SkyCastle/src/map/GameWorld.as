package map
{
	import bing.iso.IsoUtils;
	import bing.utils.ContainerUtil;
	import bing.utils.ObjectUtil;
	
	import comm.GameData;
	import comm.GameSetting;
	
	import enums.BuildingCurrentOperation;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import map.elements.BuildingBase;
	
	import models.AStarRoadGridModel;
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
			var building:BuildingBase = new BuildingBase( ShopModel.instance.roadArray[0]);
			building.drawGrid();
			building.gridLayer.visible=true;
			this.addBuilidngOnMouse( building );
		}
		
		override protected function onClick(e:MouseEvent):void
		{
			if(GameData.buildingCurrOperation==BuildingCurrentOperation.ADD)
			{
				var xx:int = (e.stageX-this.x)/scaleX - this.sceneLayerOffsetX ;
				var yy:int = (e.stageY -this.y)/scaleX - this.sceneLayerOffsetY;
				var p:Point = IsoUtils.screenToIsoGrid( GameSetting.GRID_SIZE,xx,yy);
				
				var vo:BuildingVO = ObjectUtil.copyObj( (_mouseContainer.getChildAt(0) as BuildingBase).buildingVO ) as BuildingVO;
				addBuilding( p.x , p.y ,vo );
				_mouseContainer.parent.setChildIndex( _mouseContainer , _mouseContainer.parent.numChildren-1);
			}
			else if( GameData.buildingCurrOperation==BuildingCurrentOperation.ROTATE)
			{
				if( GameData.mouseBuilding){
					GameData.mouseBuilding.rotateBuilding();
				}
			}
		}
		
		/**
		 * 运行 
		 */		
		public function start():void{
			this.removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			this.addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		/**
		 * 停止 
		 */		
		public function stop():void {
			this.removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
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
		 * 地图放大和缩小 
		 * @param scale
		 */		
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
		public function addBuilidngOnMouse( buildingBase:BuildingBase):void
		{
			_mouseContainer.parent.setChildIndex( _mouseContainer ,_mouseContainer.parent.numChildren-1 );
			ContainerUtil.removeChildren( _mouseContainer );
			buildingBase.setScreenPosition(0,0);
			buildingBase.itemLayer.alpha=0.6;
			_mouseContainer.addChild( buildingBase );
		}
		
		/**
		 *  清除鼠标上面的建筑跟随
		 */		
		public function clearMouse():void
		{
			ContainerUtil.removeChildren( _mouseContainer );
		}
	}
}