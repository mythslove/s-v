package game.core.car
{
	import game.core.phyData.CarBody1PhyData;
	import game.vos.CarVO;
	
	import nape.constraint.LineJoint;
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.space.Space;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Car1 extends BaseCar
	{
		
		public function Car1(group:InteractionGroup ,carVO:CarVO , space:Space , px:Number, py:Number)
		{
			super(group ,carVO , space , px, py);
		}
		
		override protected function createBody():void
		{
			super.createBody();
			
			var carTexture:Texture = _textureAltas.getTexture("CarBody");
			var carWheelTexture:Texture = _textureAltas.getTexture("CarWheel");

			var img:Image = new Image(carTexture); 
			carBody = CarBody1PhyData.createBody("CarBody",img);
			carBody.graphicUpdate = graphicUpdate ;
			carBody.mass = carBody.gravMass = 2;
			carBody.compound = compound ;
			carBody.space = _space;
			addChild( img);
			
			
			var material:Material = Material.rubber();
			material.density = _carVO.carParams["density"].value  ;
			var w1X:int = -48 , w2X:int = 55 ;
			var wY:int = 30 ;
			
			img = new Image(carWheelTexture); 
			img.pivotX = carWheelTexture.width>>1 ;
			img.pivotY = carWheelTexture.height>>1 ;
			leftWheel= circle(w1X,wY,carWheelTexture.width*0.5-1 ,material);
			leftWheel.compound = compound ;
			leftWheel.space = _space;
			leftWheel.graphic = img ;
			leftWheel.graphicUpdate = graphicUpdate ;
			addChildAt( img,0);
			
			img = new Image(carWheelTexture); 
			img.pivotX = carWheelTexture.width>>1 ;
			img.pivotY = carWheelTexture.height>>1 ;
			rightWheel =  circle(w2X,wY,carWheelTexture.width*0.5-1,material ); 
			rightWheel.compound = compound ;
			rightWheel.space = _space;
			rightWheel.graphic = img;
			rightWheel.graphicUpdate = graphicUpdate ;
			addChildAt( img,0);
			
			var lin1:LineJoint = new LineJoint( carBody,leftWheel,new Vec2(w1X,wY),new Vec2(),
				new Vec2(0,1), -5,5);
			lin1.compound = compound ;
			lin1.stiff = false;
			lin1.frequency = _carVO.carParams["frequency"].value ;
			lin1.space = _space;
			lin1.damping= lin1.frequency*0.01 ;
			lin1.ignore = true; 
			
			var lin2:LineJoint = new LineJoint(carBody,rightWheel,new Vec2(w2X,wY),new Vec2(),
				new Vec2(0,1), -5 ,5 );
			lin2.compound = compound ;
			lin2.stiff = false;
			lin2.damping= lin2.frequency*0.01;
			lin2.frequency = _carVO.carParams["frequency"].value ;
			lin2.space = _space;
			lin2.ignore = true; 
			
			compound.translate( Vec2.weak(_px,_py));
		}
		
		override public function createParticles(dustTexture:Texture ):void
		{
			super.createParticles(dustTexture);
			leftWheelParticle.emitterXVariance = leftWheelParticle.emitterXVariance = 3+ leftWheel.bounds.width*0.5 ;
			rightWheelParticle.emitterXVariance = rightWheelParticle.emitterXVariance = 3+rightWheel.bounds.width*0.5;
			addChild(leftWheelParticle);
			addChild(rightWheelParticle);
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
				if(leftWheelParticle)
				{
					if(body==leftWheel) {
						leftWheelParticle.rotation = carBody.rotation ;
						leftWheelParticle.x = body.position.x ;
						leftWheelParticle.y = body.position.y ;
						if(leftWheel.velocity.x>0){
							leftWheelParticle.emitAngle = 230 ;
						}else{
							leftWheelParticle.emitAngle = 0 ;
						}
						
					}else if(body==rightWheel){
						rightWheelParticle.rotation = carBody.rotation ;
						rightWheelParticle.x = body.position.x ;
						rightWheelParticle.y = body.position.y ;
						if(rightWheel.velocity.x>0){
							rightWheelParticle.emitAngle = 230 ;
						}else{
							rightWheelParticle.emitAngle = 0 ;
						}
					}
				}
			}
		}
		
		private function circle(x:Number,y:Number,r:Number , material:Material ):Body {
			var b:Body = new Body();
			b.shapes.add(new Circle(r,null,material));
			b.position.setxy(x,y);
			return b;
		}
		
	}
}