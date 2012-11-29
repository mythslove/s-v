package game
{
	import nape.callbacks.CbType;
	import nape.constraint.DistanceJoint;
	import nape.constraint.LineJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	
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
			
			var offsetX:int=100  , offsetY:int = 300;
			
			/*var img:Image= new Image(_carTexture);
			_carBody = PhysicsData.createBody("CarBody",img) ; 
			_carBody.cbType = _carType ;
			_carBody.space = _space;
			_carBody.position.setxy( offsetX , offsetY );
			addChild( img);*/
			
			_carBody = new Body(null, new Vec2(offsetX,offsetY));
			_carBody.cbType = _carType ;
			_carBody.shapes.add(new Polygon(Polygon.box(_carTexture.width,_carTexture.height)));
			var img:Image = new Image(_carTexture); 
			img.pivotX = _carTexture.width>>1 ;
			img.pivotY = _carTexture.height>>1 ;
			_carBody.graphic = img;
			_carBody.graphicUpdate = graphicUpdate ;
			_carBody.space = _space;
			addChild( img);
			
			_w1= circle(offsetX+20,offsetY+_carTexture.height-_carWheelTexture.height*0.5,_carWheelTexture.width*0.5);
			_w1.space = _space;
			img = new Image(_carWheelTexture); 
			img.pivotX = _carWheelTexture.width>>1 ;
			img.pivotY = _carWheelTexture.height>>1 ;
			_w1.graphic = img ;
			_w1.graphicUpdate = graphicUpdate ;
			addChildAt( img,0);
			
			_w2 = circle(offsetX+115, _w1.position.y,_carWheelTexture.width*0.5);
			_w2.space = _space;
			img = new Image(_carWheelTexture); 
			img.pivotX = _carWheelTexture.width>>1 ;
			img.pivotY = _carWheelTexture.height>>1 ;
			_w2.graphic = img;
			_w2.graphicUpdate = graphicUpdate ;
			addChildAt( img,0);
			
			var lin1:LineJoint = new LineJoint(_carBody,_w1,new Vec2(-44,0),new Vec2(),
				new Vec2(0,1), 0,50);
			lin1.space = _space;
			lin1.ignore = true; //prevent wheel colliding
			
			var lin2:LineJoint = new LineJoint(_carBody,_w2,new Vec2(60,0),new Vec2(),
				new Vec2(0,1), 0,50);
			lin2.space = _space;
			lin2.ignore = true; //prevent wheel colliding
			
			var spr1:DistanceJoint = new DistanceJoint(_carBody,_w1,new Vec2(-44,-10), new Vec2(),43,50);
			spr1.stiff = false;
			spr1.frequency = 5;
			spr1.damping = 1;
			spr1.space = _space;
			
			var spr2:DistanceJoint= new DistanceJoint(_carBody,_w2,new Vec2(60,-10), new Vec2(),43,50);
			spr2.stiff = false;
			spr2.frequency = 5;
			spr2.damping = 1;
			spr2.space = _space;
		}
		
		private function graphicUpdate(body:Body):void
		{
			if(body.graphic && body.graphic is DisplayObject)
			{
				var gra:DisplayObject = body.graphic as DisplayObject;
				gra.x = body.position.x;
				gra.y = body.position.y;
				gra.rotation = body.rotation;
			}
		}
		
		private function circle(x:Number,y:Number,r:Number):Body {
			var b:Body = new Body();
			var materail:Material = Material.rubber() ; 
			b.shapes.add(new Circle(r,null,materail));
			b.position.setxy(x,y);
			return b;
		}
	}
}