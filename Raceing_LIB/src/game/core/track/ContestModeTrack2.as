package game.core.track
{
	import game.comm.GameSetting;
	import game.core.phyData.Road2PhyData;
	import game.vos.TrackVO;
	
	import nape.constraint.DistanceJoint;
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Compound;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	
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
			for( var i:int  = 1 ; i<2 ; ++i)
			{
				var img:Image = new Image(_textureAltas.getTexture("road"+i));
				roadBody = Road2PhyData.createBody("road"+i , img );
				roadBody.cbTypes.add(roadType);
				roadBody.userData.graphicUpdate = Road2PhyData.flashGraphicsUpdate ;
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
			bridge.translate(Vec2.weak(len+20 ,GameSetting.SCREEN_HEIGHT-400) );
			len+=420 ;
			
			for( i  = 2 ; i<5 ; ++i)
			{
				img = new Image(_textureAltas.getTexture("road"+i));
				roadBody = Road2PhyData.createBody("road"+i , img );
				roadBody.cbTypes.add(roadType);
				roadBody.userData.graphicUpdate = Road2PhyData.flashGraphicsUpdate ;
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
			const num:int = 9 ;
			
			var wood:Material = Material.wood() ;
			wood.density=10 ;
			wood.elasticity = 0.05 ;
			wood.staticFriction = 0.05 ;
			wood.dynamicFriction = 0.05 ;
			wood.rollingFriction = 0.1 ;
			
			//碰撞组
			var interGroup:InteractionGroup = new InteractionGroup(false);
			var head:Body ;
			for( var i:int = 0 ; i< num ; ++i)
			{
				var type:BodyType = (i==0||i==num-1)?BodyType.KINEMATIC : BodyType.DYNAMIC ;
				var block:Body = new Body(type,Vec2.weak(wid*i,0) );
				block.shapes.add( new Polygon(Polygon.box(wid,het),wood));
				var img:Image = new Image(_textureAltas.getTexture("bridgeTexture"));
				img.pivotX = img.width>>1 ;
				img.pivotY = img.height>>1 ;
				block.userData.graphic = img ;
				block.userData.graphicOffset = Vec2.get();
				block.userData.graphicUpdate = Road2PhyData.flashGraphicsUpdate ;
				block.cbTypes.add(roadType);
				block.cbTypes.add(bridgeType);
				block.group = interGroup ;
				block.compound = comp; 
				block.mass = block.gravMass=2 ;
				addChildAt(img,0);
				//结点
				if(head){
					var joint:DistanceJoint = new DistanceJoint( head,block, Vec2.weak(wid/2 ,0), Vec2.weak(-wid/2 ,0) , 0 , 1 );
					joint.frequency= 10 ;
					joint.ignore = true ;
					joint.breakUnderForce = false ;
					joint.breakUnderError = false ;
					joint.damping = 5 ;
					joint.stiff = false ;
					joint.compound = comp; 
				}
				head = block ;
			}
			return comp ;
		}
	}
}