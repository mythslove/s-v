package game.mvc.control
{
	import game.events.ChangeMapEvent;
	import game.global.GameEngine;
	import game.mvc.base.GameCommand;
	import game.mvc.model.MapDataModel;
	
	public class ChangeMapCommand extends GameCommand
	{
		private var _mapId:int ;
		public function ChangeMapCommand( mapId:int )
		{
			this._mapId = mapId ;
			super();
		}
		override public function execute():void
		{
			super.execute() ;
			this.dispatchContextEvent( new ChangeMapEvent(ChangeMapEvent.CHANGE_MAP_START));
			
			GameEngine.instance.stop() ;
			
			MapDataModel.instance.loadMap( _mapId );
		}
	}
}