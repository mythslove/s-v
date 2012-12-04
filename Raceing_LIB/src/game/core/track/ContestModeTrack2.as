package game.core.track
{
	import game.comm.GameSetting;
	import game.core.phyData.Road2PhyData;
	import game.vos.TrackVO;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.DisplayObject;
	import starling.display.Image;

	/**
	 * 竞赛模式地图2 
	 * @author zzhanglin
	 */	
	public class ContestModeTrack2 extends BaseTrack
	{
		public function ContestModeTrack2( trackVO:TrackVO, space:Space)
		{
			super(trackVO,space);
		}
		
		override protected function createBody():void
		{
			super.createBody();
			var material:Material = new Material();
			_trackVO.elasticity = _trackVO.elasticity ;
			_trackVO.dynamicFriction = _trackVO.dynamicFriction ;
			_trackVO.staticFriction = _trackVO.staticFriction ;
			_trackVO.density = _trackVO.density ;
			_trackVO.rollingFriction = _trackVO.rollingFriction ;
				
			var roadBody:Body ;
			for( var i:int  = 0 ; i<20 ; ++i)
			{
				var img:Image = new Image(_textureAltas.getTexture("road1"));
				roadBody = Road2PhyData.createBody("road1" , img );
				roadBody.cbTypes.add(roadType);
				roadBody.graphicUpdate = graphicUpdate ;
				roadBody.compound = roadCompound ;
				roadBody.position.setxy( len ,GameSetting.SCREEN_HEIGHT) ;
				roadBody.type = BodyType.KINEMATIC ;
				roadBody.setShapeMaterials(material);
				roadBody.space = _space ;
				len+=roadBody.bounds.width ;
				addChild( img );
			}
			for( i  = 2 ; i<6 ; ++i)
			{
				img = new Image(_textureAltas.getTexture("road"+i));
				roadBody = Road2PhyData.createBody("road"+i , img );
				roadBody.cbTypes.add(roadType);
				roadBody.graphicUpdate = graphicUpdate ;
				roadBody.compound = roadCompound ;
				roadBody.position.setxy( len ,GameSetting.SCREEN_HEIGHT) ;
				roadBody.type = BodyType.KINEMATIC ;
				roadBody.setShapeMaterials(material);
				roadBody.space = _space ;
				len+=roadBody.bounds.width ;
				addChild( img );
			}
			createWall();
		}
		
		private function graphicUpdate(body:Body):void
		{
			if(body.graphic && body.graphic is DisplayObject)
			{
				var gp:Vec2 = body.localToWorld(body.graphicOffset);
				var gra:DisplayObject = body.graphic as DisplayObject;
				gra.x = gp.x;
				gra.y = gp.y;
				gra.rotation = body.rotation ;
			}
		}
	}
}