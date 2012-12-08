package game
{
	import game.comm.GameMode;
	import game.core.scene.BaseContestGameScene;
	import game.core.scene.ContestGameScene;
	import game.events.GameControlEvent;
	import game.model.CarModel;
	import game.model.TrackModel;
	import game.util.GameSceneFactory;
	import game.vos.PlayerCarVO;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StarlingAppliaction extends Sprite
	{
		public function StarlingAppliaction()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			var playerCarVO:PlayerCarVO = CarModel.instance.initDefaultPlayerCarVO() ;
			var scene:BaseContestGameScene = GameSceneFactory.createGameSceneFactory(TrackModel.instance.tracks[1],playerCarVO);
			addChild(scene);
			scene.addEventListener(GameControlEvent.GAME_OVER , gameOver);
			scene.addEventListener(GameControlEvent.GAME_SUCCESS , gameOver);
		}
		
		private function gameOver( e:GameControlEvent):void
		{
			e.target.removeEventListener(GameControlEvent.GAME_OVER , gameOver);
			e.target.removeEventListener(GameControlEvent.GAME_SUCCESS , gameOver);
			this.removeChildren(0,-1,true);
			
			
			
			var playerCarVO:PlayerCarVO = CarModel.instance.initDefaultPlayerCarVO() ;
			var scene:ContestGameScene = new ContestGameScene( TrackModel.instance.tracks[1],playerCarVO);
			addChild(scene);
			scene.addEventListener(GameControlEvent.GAME_OVER , gameOver);
			scene.addEventListener(GameControlEvent.GAME_SUCCESS , gameOver);
		}
	}
}