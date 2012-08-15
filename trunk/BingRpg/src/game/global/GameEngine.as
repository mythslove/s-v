package game.global
{
	import flash.events.Event;
	
	import game.elements.items.Hero;
	import game.mvc.base.GameContext;
	import game.mvc.model.MapItemsModel;
	import game.mvc.view.GameLayerMediator;

	public class GameEngine
	{
		private static var _instance:GameEngine;
		public static function get instance():GameEngine
		{
			if(!_instance) _instance = new GameEngine();
			return _instance ;
		}
		//====================================

		private  var _gameLayerMediator:GameLayerMediator ;
		private function get gameLayerMediator():GameLayerMediator
		{
			if(!_gameLayerMediator)
				_gameLayerMediator = context.retrieveMediator( GameLayerMediator ) as GameLayerMediator ;
			return _gameLayerMediator ;
		}
		
		public function start():void
		{
			GameContext.instance.contextView.addEventListener(Event.ENTER_FRAME , update );
			
			GameData.hero = new Hero(1 , 1 ,"臭小子<font color='#ff0000'>(Lv1)</font>") ;
			GameData.hero.direction = 5 ;
			GameData.hero.setTilePoint( 25,40 ); 
			GameData.hero.mouseEnabled=false ;
			MapItemsModel.instance.addItem( GameData.hero ); 
		}
		
		private function update(e:Event):void
		{
			MapItemsModel.instance.updateAll() ;
			gameLayerMediator.updateHandler();
		}
		
		public function stop():void
		{
			GameContext.instance.contextView.removeEventListener(Event.ENTER_FRAME , update );
		}
		
		private function get context():GameContext
		{
			return GameContext.instance ;
		}
	}
}