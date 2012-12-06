package game.core.car
{
	import game.core.phyData.CarBody1PhyData;
	import game.vos.CarVO;
	
	import nape.constraint.LineJoint;
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.phys.Material;
	import nape.space.Space;
	
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
			carBody.userData.graphicUpdate = CarBody1PhyData.flashGraphicsUpdate ;
			carBody.mass = carBody.gravMass = _carVO.carParams["mass"].value ;
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
			leftWheel= circle(w1X,wY,carWheelTexture.width*0.5-2 ,material);
			leftWheel.compound = compound ;
			leftWheel.space = _space;
			leftWheel.userData.graphic = img ;
			leftWheel.userData.graphicUpdate = graphicUpdate ;
			addChildAt( img,0);
			
			img = new Image(carWheelTexture); 
			img.pivotX = carWheelTexture.width>>1 ;
			img.pivotY = carWheelTexture.height>>1 ;
			rightWheel =  circle(w2X,wY,carWheelTexture.width*0.5-2,material ); 
			rightWheel.compound = compound ;
			rightWheel.space = _space;
			rightWheel.userData.graphic = img;
			rightWheel.userData.graphicUpdate = graphicUpdate ;
			addChildAt( img,0);
			
			var lin1:LineJoint = new LineJoint( carBody,leftWheel,Vec2.weak(w1X,wY),Vec2.weak(),
				Vec2.weak(0,1), -5,5);
			lin1.compound = compound ;
			lin1.stiff = false;
			lin1.frequency = _carVO.carParams["frequency"].value ;
			lin1.space = _space;
			lin1.damping= lin1.frequency*0.01 ;
			lin1.ignore = true; 
			
			var lin2:LineJoint = new LineJoint(carBody,rightWheel,Vec2.weak(w2X,wY),Vec2.weak(),
				Vec2.weak(0,1), -5 ,5 );
			lin2.compound = compound ;
			lin2.stiff = false;
			lin2.damping= lin2.frequency*0.01;
			lin2.frequency = _carVO.carParams["frequency"].value ;
			lin2.space = _space;
			lin2.ignore = true; 
			
			compound.translate( Vec2.weak(_px,_py));
		}
		
	}
}