package map
{
	import bing.iso.IsoGrid;
	import bing.iso.IsoScene;
	import bing.iso.IsoWorld;
	
	import comm.GameSetting;
	import comm.GlobalDispatcher;
	
	import events.WorldSettingEvent;
	
	import flash.events.Event;
	
	public class GameWorld extends IsoWorld
	{
		private static var _instance:GameWorld;
		public static function get instance():GameWorld{
			if(!_instance) _instance = new GameWorld();
			return _instance ;
		}
		//=================================
		private var _gridScene:IsoScene;
		
		public function GameWorld()
		{
			super(GameSetting.MAX_WIDTH, GameSetting.MAX_HEIGHT, GameSetting.GRID_X, GameSetting.GRID_Z, GameSetting.GRID_SIZE);
			drawZone(GameSetting.GRID_X, GameSetting.GRID_Z);
			this.x = -GameSetting.MAX_WIDTH*scaleX*0.5+GameSetting.SCREEN_WIDTH*0.5 ;
			y=-100;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			_gridScene = new IsoScene(_size);
			var grid:IsoGrid = new IsoGrid(GameSetting.GRID_X, GameSetting.GRID_Z,_size);
			grid.render();
			_gridScene.addChild(grid);
			addScene(_gridScene);
			configListeners();
		}
		
		/** 画地图区域 */
		protected function drawZone( xPan:int , zPan:int  ):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x49842D);
			this.graphics.drawRect(0,0,GameSetting.MAX_WIDTH , GameSetting.MAX_HEIGHT);
			this.graphics.endFill();
		}
		
		private function configListeners():void
		{
			GlobalDispatcher.instance.addEventListener(WorldSettingEvent.ADD_LAYER , worldSettingHandler );
			GlobalDispatcher.instance.addEventListener(WorldSettingEvent.DELETE_LAYER , worldSettingHandler );
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