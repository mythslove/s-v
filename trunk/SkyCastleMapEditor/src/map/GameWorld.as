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
		private var _gridScene:IsoScene;
		
		public function GameWorld()
		{
			super(GameSetting.MAP_WIDTH, GameSetting.MAP_HEIGHT, GameSetting.GRID_X, GameSetting.GRID_Z, GameSetting.GRID_SIZE);
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			_gridScene = new IsoScene(_size);
			var grid:IsoGrid = new IsoGrid(GameSetting.GRID_X, GameSetting.GRID_Z,_size);
			_gridScene.addIsoObject(grid);
			
			configListeners();
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