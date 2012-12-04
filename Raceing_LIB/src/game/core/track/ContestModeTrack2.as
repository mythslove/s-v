package game.core.track
{
	import game.comm.GameSetting;
	import game.core.phyData.Road2PhyData;
	import game.vos.TrackVO;
	
	import nape.constraint.DistanceJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Compound;
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
			
			var bridge:Compound = createBridgeBlocks() ;
			bridge.space = _space ;
			bridge.translate(Vec2.get(len+25,GameSetting.SCREEN_HEIGHT-270) );
			len+=400 ;
			
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
		
		private function createBridgeBlocks():Compound
		{
			var comp:Compound = new Compound();
			var wid:int = 50 , het:int = 20 ;
			
			var wood:Material = Material.wood() ;
			wood.density=10 ;
			wood.elasticity = 0.01 ;
			
			var head:Body = new Body(BodyType.KINEMATIC);
			head.shapes.add( new Polygon(Polygon.box(wid,het),wood));
			head.compound = comp;
			
			for( var i:int = 1 ; i< 8 ; ++i)
			{
				var type:BodyType = i==7?BodyType.KINEMATIC : BodyType.DYNAMIC ;
				var block:Body = new Body(type,Vec2.weak(wid*i,0) );
				block.shapes.add( new Polygon(Polygon.box(wid,het),wood));
				block.cbTypes.add(roadType);
				block.compound = comp; 
				
				var joint:DistanceJoint = new DistanceJoint( head,block, Vec2.weak(wid/2 ,0), Vec2.get(-wid/2 ,0) , 0 , 1 );
				joint.frequency=0.1 ;
				joint.compound = comp; 
				
				head = block ;
			}
			return comp ;
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