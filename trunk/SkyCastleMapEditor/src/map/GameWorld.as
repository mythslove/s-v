package map
{
	import bing.iso.IsoGrid;
	import bing.iso.IsoScene;
	import bing.iso.IsoWorld;
	import bing.utils.InteractivePNG;
	
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	
	import events.WorldSettingEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GameWorld extends IsoWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld{
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//=================================
		private var _gridScene:IsoScene;
		private var _mapIsMove:Boolean;
		private var _mouseOverBuild:Building;
		private var _topBuilding:Building;
		private var _topScene:MapScene;
		
		public function GameWorld()
		{
			super(GameSetting.MAX_WIDTH, GameSetting.MAX_HEIGHT, GameSetting.GRID_X, GameSetting.GRID_Z, GameSetting.GRID_SIZE);
			drawZone();
			this.panTo( 0 , -GameSetting.MAX_HEIGHT>>1);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			_gridScene = new IsoScene(_size);
			var grid:IsoGrid = new IsoGrid(GameSetting.GRID_X, GameSetting.GRID_Z,_size);
			grid.render();
			_gridScene.addChild(grid);
			addScene(_gridScene);
			
			_topScene = new MapScene();
			addScene(_topScene);
			
			configListeners();
		}
		
		/** 画地图区域 */
		protected function drawZone():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x49842D);
			this.graphics.drawRect(-GameSetting.MAX_WIDTH,-GameSetting.MAX_HEIGHT,GameSetting.MAX_WIDTH*2 , GameSetting.MAX_HEIGHT*2);
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
			
			GlobalDispatcher.instance.addEventListener(WorldSettingEvent.ADD_LAYER , worldSettingHandler );
			GlobalDispatcher.instance.addEventListener(WorldSettingEvent.DELETE_LAYER , worldSettingHandler );
		}
		
		/** 处理鼠标事件 */		
		protected function onMouseEventHandler(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					this.startDrag( false);
					break;
				case MouseEvent.MOUSE_MOVE:
					if(e.buttonDown)	{
						_mapIsMove = true ;
					}
					break;
				case MouseEvent.MOUSE_OVER:
					if( !_topBuilding && e.target is InteractivePNG){
						_mouseOverBuild = (e.target as InteractivePNG).parent as Building;
//						_mouseOverBuild.onMouseOver() ;
					}
					break;
				case MouseEvent.MOUSE_UP:
					if(!_mapIsMove) onClick(e);
				case MouseEvent.ROLL_OUT:
					this.stopDrag();
				case MouseEvent.MOUSE_OUT:
					_mapIsMove = false ;
					if(e.type!=MouseEvent.MOUSE_UP && _mouseOverBuild){
//						_mouseOverBuild.onMouseOut();
						_mouseOverBuild = null ;
					}
					break;
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			
		}
		
		private function worldSettingHandler(e:WorldSettingEvent):void
		{
			switch(e.type)
			{
				case WorldSettingEvent.ADD_LAYER:
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
	}
}