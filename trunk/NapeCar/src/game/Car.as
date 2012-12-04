package game
{
	import flash.events.MouseEvent;
	
	import nape.callbacks.CbType;
	import nape.constraint.DistanceJoint;
	import nape.constraint.LineJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Compound;
	import nape.phys.MassMode;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import utils.AssetsManager;
	
	public class Car extends Sprite
	{
		private var _carType:CbType ;
		private var _space:Space ;
		private var _carBody:Body,_w1:Body,_w2:Body ;
		private var _carTexture:Texture , _carWheelTexture:Texture ;
		
		public function get w1():Body{
			return _w1;
		}
		public function get w2():Body{
			return _w2;
		}
		public function get carBody():Body{
			return _carBody ;
		}
		
		public function Car( space:Space , carType:CbType )
		{
			super();
			this._space = space ;
			this._carType = carType;
			addEventListener(Event.ADDED_TO_STAGE, addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler );
			_carTexture = AssetsManager.createTextureByName("CarBodyTexture");
			_carWheelTexture= AssetsManager.createTextureByName("CarWheelTexture");

			
			var compound:Compound = new Compound();

			var img:Image = new Image(_carTexture); 
			_carBody = PhysicsData.createBody("CarBody", img);
			_carBody.mass = _carBody.gravMass = 2;
			_carBody.compound = compound ;
			_carBody.space = _space;
			addChild( img);
			
			
			img = new Image(_carWheelTexture); 
			img.pivotX = _carWheelTexture.width>>1 ;
			img.pivotY = _carWheelTexture.height>>1 ;
			_w1= circle(36,56,_carWheelTexture.width>>1 );
			_w1.compound = compound ;
			_w1.cbType = _carType ;
			_w1.space = _space;
			_w1.graphic = img ;
			_w1.graphicUpdate = graphicUpdate ;
			addChildAt( img,0);
			
			img = new Image(_carWheelTexture); 
			img.pivotX = _carWheelTexture.width>>1 ;
			img.pivotY = _carWheelTexture.height>>1 ;
			_w2 =  circle(139,56,_carWheelTexture.width>>1 );
			_w2.cbType = _carType ;
			_w2.compound = compound ;
			_w2.space = _space;
			_w2.graphic = img;
			_w2.graphicUpdate = graphicUpdate ;
			addChildAt( img,0);
			
			var lin1:LineJoint = new LineJoint(_carBody,_w1,new Vec2(36,60),new Vec2(),
				new Vec2(0,1), 0,5);
			lin1.compound = compound ;
			lin1.stiff = false;
			lin1.frequency = 5 ;
			lin1.space = _space;
			lin1.ignore = true; //prevent wheel colliding
			
			var lin2:LineJoint = new LineJoint(_carBody,_w2,new Vec2(139,60),new Vec2(),
				new Vec2(0,1), 0 ,5 );
			lin2.compound = compound ;
			lin2.stiff = false;
			lin2.frequency = 5 ;
			lin2.space = _space;
			lin2.ignore = true; //prevent wheel colliding
			
//			var spr1:DistanceJoint = new DistanceJoint(_carBody,_w1,new Vec2(36,0), new Vec2(),0,60);
//			spr1.compound = compound ;
//			spr1.frequency = 0.1 ;
//			spr1.stiff = false;
//			spr1.ignore = true ;
//			spr1.space = _space;
//			
//			var spr2:DistanceJoint= new DistanceJoint(_carBody,_w2,new Vec2(139,0), new Vec2(),0,60);
//			spr2.compound = compound ;
//			spr2.frequency =0.1 ;
//			spr2.stiff = false;
//			spr2.ignore = true ;
//			spr2.space = _space;
			
			compound.translate( Vec2.weak(100,200));
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
		
		private function circle(x:Number,y:Number,r:Number):Body {
			var b:Body = new Body();
			var materail:Material = Material.rubber() ;
			materail.density = 1 ;
			b.shapes.add(new Circle(r,null,materail));
			b.position.setxy(x,y);
			return b;
		}
	}
}