package map
{
	import bing.iso.IsoGrid;
	import bing.iso.IsoScene;
	import bing.iso.IsoWorld;
	import bing.utils.ContainerUtil;
	import bing.utils.InteractivePNG;
	import bing.utils.ObjectUtil;
	
	import comm.GameData;
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	
	import events.WorldSettingEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import model.MapGridModel;
	import model.vos.BuildingVO;
	
	import utils.BuildingFactory;
	
	public class GameWorld extends IsoWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld{
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//=================================
		private var _mapIsMove:Boolean;
		private var gridScene:IsoScene;
		private var mouseOverBuild:Building;
		private var topBuilding:Building;
		private var topScene:MapScene;
		
		public function GameWorld()
		{
			super(GameSetting.MAX_WIDTH, GameSetting.MAX_HEIGHT, GameSetting.GRID_X, GameSetting.GRID_Z, GameSetting.GRID_SIZE);
			drawZone();
			this.panTo( GameSetting.MAX_WIDTH>>1 , -410);
			//地图的初始位置
			this.x = -2200 ;
			this.y = -1500;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			gridScene = new IsoScene();
			var grid:IsoGrid = new IsoGrid(GameSetting.GRID_X, GameSetting.GRID_Z,_size);
			grid.render();
			gridScene.addChild(grid);
			addScene(gridScene);
			
			topScene = new MapScene();
			addScene(topScene);
			
			configListeners();
		}
		
		/** 画地图区域 */
		protected function drawZone():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x49842D);
			this.graphics.drawRect(0,0,GameSetting.MAX_WIDTH , GameSetting.MAX_HEIGHT);
			this.graphics.endFill();
		}
		
		private function configListeners():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_MOVE , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_OVER , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_OUT , onMouseEventHandler);
			addEventListener(MouseEvent.MOUSE_UP , onMouseEventHandler );
			addEventListener(MouseEvent.ROLL_OUT , onMouseEventHandler);
			stage.addEventListener(MouseEvent.RIGHT_CLICK , rightClickHandler);
			GlobalDispatcher.instance.addEventListener(WorldSettingEvent.ADD_LAYER , worldSettingHandler );
			GlobalDispatcher.instance.addEventListener(WorldSettingEvent.DELETE_LAYER , worldSettingHandler );
		}
		
		private function rightClickHandler( e:MouseEvent ):void{
			clearTopScene();
		}
		
		/** 处理鼠标事件 */		
		protected function onMouseEventHandler(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					if( !topBuilding)
						this.startDrag( false);
					break;
				case MouseEvent.MOUSE_MOVE:
					if(e.buttonDown)	{
						_mapIsMove = true ;
						if(topBuilding) {
							updateTopBuild();
							onClick(e);
						}
					}else if(topBuilding) {
						updateTopBuild();
					}
					break;
				case MouseEvent.MOUSE_OVER:
					if( !topBuilding && e.target is InteractivePNG){
						mouseOverBuild = (e.target as InteractivePNG).parent as Building;
//						_mouseOverBuild.onMouseOver() ;
					}
					break;
				case MouseEvent.MOUSE_UP:
					if(!_mapIsMove) onClick(e);
				case MouseEvent.ROLL_OUT:
					this.stopDrag();
				case MouseEvent.MOUSE_OUT:
					_mapIsMove = false ;
					if(e.type!=MouseEvent.MOUSE_UP && mouseOverBuild){
//						_mouseOverBuild.onMouseOut();
						mouseOverBuild = null ;
					}
					break;
			}
		}
		
		/** 更新顶部建筑的位置和网格 */
		protected function updateTopBuild():void
		{
			var p:Point = pixelPointToGrid(stage.mouseX,stage.mouseY ); 
			if(topBuilding.nodeX!=p.x || topBuilding.nodeZ!=p.y) {
				topBuilding.nodeX = p.x ;
				topBuilding.nodeZ= p.y ;
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(GameData.currentScene && topBuilding && topBuilding.getWalkable(MapGridModel.instance.grid) )
			{
				var vo:BuildingVO = ObjectUtil.copyObj(topBuilding.vo) as BuildingVO ;
				var building:Building = BuildingFactory.createBuildingByType(vo.clsName);
				building.vo.nodeX = topBuilding.nodeX;
				building.vo.nodeZ = topBuilding.nodeZ;
				building.nodeX = topBuilding.nodeX;
				building.nodeZ = topBuilding.nodeZ;
				GameData.currentScene.addIsoObject( building );
				building.setWalkable(false,MapGridModel.instance.grid);
			}
		}
		
		private function worldSettingHandler(e:WorldSettingEvent):void
		{
			switch(e.type)
			{
				case WorldSettingEvent.ADD_LAYER:
					addScene(e.scene);
					break;
				case WorldSettingEvent.DELETE_LAYER:
					removeScene(e.scene);
					break ;
				case WorldSettingEvent.ZOOM:
					this.scaleX = this.scaleY = e.zoom;
					break ;
				case WorldSettingEvent.OFFSEX:
				case WorldSettingEvent.OFFSEY:
					this.panTo(e.offsetX,e.offsetY);
					break ;
			}
		}
		
		private function removeScene( scene:IsoScene):void
		{
			for( var i:int =0 ;  i<scenes.length ; ++i){
				if(scenes[i]==scene){
					this.removeChild(scene);
					scenes.splice(i,1);
					break ;
				}
			}
		}
		
		/**
		 * 将建筑加到topScene,跟随鼠标移动 
		 * @param building
		 */ 		
		public function addBuildingToTop( building:Building ):void
		{
			clearTopScene();
			topBuilding = building ;
			topScene.addIsoObject( building , false );
			building.itemLayer.alpha = 0.5 ;
			building.selectedStatus(false); //选择设置成false
			topScene.visible = true  ;
		}
		
		/**
		 * 清除topScene 
		 */		
		public function clearTopScene():void
		{
			ContainerUtil.removeChildren(topScene);
			topScene.visible = false  ;
			if(topBuilding){
				topBuilding.itemLayer.alpha = 1;
			}
			topBuilding = null ;
		}
	}
}