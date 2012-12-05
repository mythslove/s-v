package game.core.car
{
	import game.core.phyData.CarBody2PhyData;
	import game.vos.CarVO;
	
	import nape.constraint.LineJoint;
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.phys.Material;
	import nape.space.Space;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class Car2 extends BaseCar
	{
		
		public function Car2(group:InteractionGroup ,carVO:CarVO , space:Space , px:Number, py:Number)
		{
			super(group ,carVO , space , px, py);
		}
		
		override protected function createBody():void
		{
			super.createBody();
			
			var carTexture:Texture = _textureAltas.getTexture("CarBody");
			var carWheelTexture:Texture = _textureAltas.getTexture("CarWheel");
			
			var img:Image = new Image(carTexture); 
			carBody = CarBody2PhyData.createBody("CarBody",img);
			carBody.graphicUpdate = graphicUpdate ;
			carBody.mass = carBody.gravMass = _carVO.carParams["mass"].value ;
			carBody.compound = compound ;
			carBody.space = _space;
			addChild( img);
			
			
			var material:Material = Material.rubber();
			material.density = _carVO.carParams["density"].value  ;
			var w1X:int = -60 , w2X:int = 75 ;
			var wY:int = 35 ;
			
			img = new Image(carWheelTexture); 
			img.pivotX = carWheelTexture.width>>1 ;
			img.pivotY = carWheelTexture.height>>1 ;
			leftWheel= circle(w1X,wY,carWheelTexture.width*0.5-2 ,material);
			leftWheel.compound = compound ;
			leftWheel.space = _space;
			leftWheel.graphic = img ;
			leftWheel.graphicUpdate = graphicUpdate ;
			addChild( img);
			
			img = new Image(carWheelTexture); 
			img.pivotX = carWheelTexture.width>>1 ;
			img.pivotY = carWheelTexture.height>>1 ;
			rightWheel =  circle(w2X,wY,carWheelTexture.width*0.5-2,material ); 
			rightWheel.compound = compound ;
			rightWheel.space = _space;
			rightWheel.graphic = img;
			rightWheel.graphicUpdate = graphicUpdate ;
			addChild( img);
			
			var lin1:LineJoint = new LineJoint( carBody,leftWheel,Vec2.get(w1X,wY),Vec2.get(),
				Vec2.get(0,1), -5,5);
			lin1.compound = compound ;
			lin1.stiff = false;
			lin1.frequency = _carVO.carParams["frequency"].value ;
			lin1.space = _space;
			lin1.damping= lin1.frequency*0.01 ;
			lin1.ignore = true; 
			
			var lin2:LineJoint = new LineJoint(carBody,rightWheel,Vec2.get(w2X,wY),Vec2.get(),
				Vec2.get(0,1), -5 ,5 );
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