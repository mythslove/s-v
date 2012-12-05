package game
{
	import game.core.scene.ContestGameScene;
	import game.events.GameControlEvent;
	import game.model.CarModel;
	import game.model.TrackModel;
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
			var scene:ContestGameScene = new ContestGameScene( TrackModel.instance.tracks[0],playerCarVO);
			addChild(scene);
			scene.addEventListener(GameControlEvent.GAME_OVER , gameOver);
		}
		
		private function gameOver( e:GameControlEvent):void
		{
			e.target.removeEventListener(GameControlEvent.GAME_OVER , gameOver);
			this.removeChildren(0,-1,true);
			
			var playerCarVO:PlayerCarVO = CarModel.instance.initDefaultPlayerCarVO() ;
			var scene:ContestGameScene = new ContestGameScene( TrackModel.instance.tracks[0],playerCarVO);
			addChild(scene);
			scene.addEventListener(GameControlEvent.GAME_OVER , gameOver);
		}
	}
}