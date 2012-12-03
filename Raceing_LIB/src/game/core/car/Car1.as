package game.core.car
{
	import game.core.phyData.CarBody1PhyData;
	import game.vos.CarParamVO;
	import game.vos.CarVO;
	
	import nape.constraint.LineJoint;
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.space.Space;
	
	import starling.display.DisplayObject;
	
	public class Car1 extends BaseCar
	{
		public function Car1(group:InteractionGroup ,carVO:CarVO , space:Space , px:Number, py:Number)
		{
			super(group ,carVO , space , px, py);
		}
		
		override protected function createBody():void
		{
			super.createBody();
			
//			var img:Image = new Image(_carTexture); 
			carBody = CarBody1PhyData.createBody("Car1Body");
			carBody.mass = carBody.gravMass = 2;
			carBody.compound = compound ;
			carBody.space = _space;
//			addChild( img);
			
			
			var material:Material = Material.rubber();
			material.density = _carVO.carParams["density"].value  ;
			
//			img = new Image(_carWheelTexture); 
//			img.pivotX = _carWheelTexture.width>>1 ;
//			img.pivotY = _carWheelTexture.height>>1 ;
			leftWheel= circle(36,56,22,material);//_carWheelTexture.width>>1 
			leftWheel.compound = compound ;
			leftWheel.space = _space;
//			leftWheel.graphic = img ;
			leftWheel.graphicUpdate = graphicUpdate ;
//			addChildAt( img,0);
			
//			img = new Image(_carWheelTexture); 
//			img.pivotX = _carWheelTexture.width>>1 ;
//			img.pivotY = _carWheelTexture.height>>1 ;
			rightWheel =  circle(139,56, 22,material ); //_carWheelTexture.width>>1
			rightWheel.compound = compound ;
			rightWheel.space = _space;
//			rightWheel.graphic = img;
			rightWheel.graphicUpdate = graphicUpdate ;
//			addChildAt( img,0);
			
			var lin1:LineJoint = new LineJoint( carBody,leftWheel,new Vec2(36,60),new Vec2(),
				new Vec2(0,1), 0,5);
			lin1.compound = compound ;
			lin1.stiff = false;
			lin1.frequency = _carVO.carParams["frequency"].value ;
			lin1.space = _space;
			lin1.ignore = true; //prevent wheel colliding
			
			var lin2:LineJoint = new LineJoint(carBody,rightWheel,new Vec2(139,60),new Vec2(),
				new Vec2(0,1), 0 ,5 );
			lin2.compound = compound ;
			lin2.stiff = false;
			lin2.frequency = _carVO.carParams["frequency"].value ;
			lin2.space = _space;
			lin2.ignore = true; //prevent wheel colliding
			
			compound.translate( Vec2.weak(_px,_py));
		}
		
		private function graphicUpdate(body:Body):void
		{
			if(body.graphic && body.graphic is DisplayObject)
			{
				var gra:DisplayObject = body.graphic as DisplayObject;
				gra.x = body.position.x;
				gra.y = body.position.y;
				gra.rotation = body.rotation ;
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