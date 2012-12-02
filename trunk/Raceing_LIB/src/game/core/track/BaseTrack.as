package game.core.track
{
	import game.vos.TrackVO;
	
	import nape.phys.Material;
	import nape.space.Space;
	
	import starling.display.Sprite;
	
	public class BaseTrack extends Sprite
	{
		protected var _space:Space ;
		protected var _trackVO:TrackVO ;
		
		public function BaseTrack( trackVO:TrackVO , space:Space )
		{
			super();
			this._space = space ;
			this._trackVO = trackVO ;
		}
		
		public function createBody():void
		{
			
		}
	}
}