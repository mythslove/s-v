package game.core.track
{
	import game.comm.GameSetting;
	import game.core.phyData.Road1PhyData;
	import game.vos.TrackVO;
	
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.Image;

	/**
	 * 竞赛模式地图1 
	 * @author zzhanglin
	 */	
	public class ContestModeTrack1 extends BaseTrack
	{
		private var _road1:Body , _road2:Body , _road3:Body , _road4:Body ;
		
		public function ContestModeTrack1( trackVO:TrackVO, space:Space)
		{
			super(trackVO,space);
		}
		
		override protected function createBody():void
		{
			super.createBody();
			
			var body:Body ;
			for( var i:int  = 1 ; i<5 ; ++i)
			{
				var img:Image = new Image(_textureAltas.getTexture("road"+i));
				body = Road1PhyData.createBody("road"+i);
				body.position.setxy( len ,GameSetting.SCREEN_HEIGHT) ;
				body.type = BodyType.KINEMATIC ;
				body.space = _space ;
				this["_road"+i] = body ;
				len+=body.bounds.width ;
				addChild( img );
			}
			createWall();
		}
	}
}