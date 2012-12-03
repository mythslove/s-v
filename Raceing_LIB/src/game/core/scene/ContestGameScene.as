package game.core.scene
{
	import game.core.car.BaseCar;
	import game.core.track.BaseTrack;
	import game.vos.PlayerCarVO;
	import game.vos.TrackVO;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ContestGameScene extends Sprite
	{
		private var _playerCarVO:PlayerCarVO ;
		private var _trackVO:TrackVO ;
		private var _car:BaseCar ;
		private var _carBot:BaseCar ;
		private var _track:BaseTrack ;
		
		public function ContestGameScene( trackVO:TrackVO , playerCarVO:PlayerCarVO )
		{
			super();
			this._trackVO = trackVO;
			this._playerCarVO = playerCarVO ;
			addEventListener(Event.ADDED_TO_STAGE , addedHandler);
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
			loadRes();
		}
		
		//加载此地图中所有要用到的图片
		private function loadRes():void
		{
			//添加loading
		}
		
		private function removedHandler( e:Event ):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
		}
	}
}