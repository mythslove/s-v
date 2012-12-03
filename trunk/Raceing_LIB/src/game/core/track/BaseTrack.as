package game.core.track
{
	import game.comm.GameSetting;
	import game.vos.TrackVO;
	
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.Sprite;
	
	public class BaseTrack extends Sprite
	{
		protected var _space:Space ;
		protected var _trackVO:TrackVO ;
		public var len:int ; //路的长度
		
		public function BaseTrack( trackVO:TrackVO , space:Space )
		{
			super();
			this._space = space ;
			this._trackVO = trackVO ;
			createBody();
		}
		
		protected function createBody():void
		{
			
		}
		
		protected function createWall():void
		{
			var wall:Body = new Body(BodyType.STATIC) ;
			wall.shapes.add( new Polygon(Polygon.rect(0,0,50,GameSetting.SCREEN_HEIGHT)));
			wall.shapes.add( new Polygon(Polygon.rect(len-50,0,50,GameSetting.SCREEN_HEIGHT)));
			wall.space = _space ;
		}
	}
}