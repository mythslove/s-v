package map
{
	import bing.utils.ContainerUtil;
	import bing.utils.ObjectUtil;
	
	import comm.GameData;
	import comm.GameSetting;
	
	import enums.BuildingCurrentOperation;
	import enums.BuildingType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import map.elements.Building;
	import map.elements.BuildingBase;
	
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
			var building:BuildingBase = new BuildingBase( ShopModel.instance.houseArray[0]);
			building.drawGrid();
			building.gridLayer.visible=true;
			this.addBuilidngOnMouse( building );
		}
		
		override protected function onClick(e:MouseEvent):void
		{
			if(GameData.buildingCurrOperation==BuildingCurrentOperation.ADD)
			{	
				var build:BuildingBase = mouseContainer.getChildAt(0) as BuildingBase ;
				if( build && build.gridLayer && build.gridLayer.getWalkable() )
				{
					var vo:BuildingVO = ObjectUtil.copyObj( (mouseContainer.getChildAt(0) as BuildingBase).buildingVO ) as BuildingVO;
					addBuildingByVO( mouseContainer.nodeX , mouseContainer.nodeZ ,vo );
					mouseContainer.parent.setChildIndex( mouseContainer , mouseContainer.parent.numChildren-1);
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
			mouseContainer.parent.setChildIndex( mouseContainer ,mouseContainer.parent.numChildren-1 );
			ContainerUtil.removeChildren( mouseContainer );
			buildingBase.setScreenPosition(0,0);
			if( buildingBase.buildingVO.baseVO.type!=BuildingType.ROAD){
				buildingBase.itemLayer.alpha=0.6;
			}
			buildingBase.itemLayer.mouseEnabled = false ;
			mouseContainer.addChild( buildingBase );
			mouseContainer.visible=true;
		}
		
		/**
		 *  清除鼠标上面的建筑跟随
		 */		
		public function clearMouse():void
		{
			ContainerUtil.removeChildren( mouseContainer );
			mouseContainer.visible=false;
		}
	}
}