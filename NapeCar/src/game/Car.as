package game
{
	import flash.display.Bitmap;
	
	import nape.constraint.DistanceJoint;
	import nape.constraint.LineJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Car extends Sprite
	{
		[Embed(source="../assets/CarBody.png")]
		private const CARBODY:Class;
		[Embed(source="../assets/CarWheel.png")]
		private const CARWHELL:Class;
		//=================================
		
		private var _carBody:Body,w1:Body,w2:Body ;
		private var _carTexture:Texture , _carWheelTexture:Texture ;
		
		private var _space:Space ;
		
		public function Car( space:Space )
		{
			super();
			this._space = space ;
			addEventListener(Event.ADDED_TO_STAGE, addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler );
			_carTexture = Texture.fromBitmap( new CARBODY as Bitmap,false) ;
			_carWheelTexture = Texture.fromBitmap( new CARWHELL as Bitmap,false) ;
			
			var offsetX:Number=100 , offsetY:Number = 300;
			var body:Body = new Body();
			body.shapes.add(new Polygon(Polygon.box(100,40)));
			body.position.setxy(offsetX,offsetY);
			img = new Image(_carTexture); 
			body.graphic = img;
			body.graphicUpdate = graphicUpdate ;
			body.space = _space;
			addChild( img);
			
			var img:Image ;
			w1= circle(offsetX+5,offsetY+_carTexture.height-_carWheelTexture.height*0.5,_carWheelTexture.width*0.5);
			w1.space = _space;
			img = new Image(_carWheelTexture); 
			img.pivotX = _carWheelTexture.width>>1 ;
			img.pivotY = _carWheelTexture.height>>1 ;
			w1.graphic = img ;
			w1.graphicUpdate = graphicUpdate ;
			addChild( img);
			
			w2 = circle(offsetX+_carTexture.width-_carWheelTexture.width-5, w1.position.y,_carWheelTexture.width*0.5);
			w2.space = _space;
			img = new Image(_carWheelTexture); 
			img.pivotX = _carWheelTexture.width>>1 ;
			img.pivotY = _carWheelTexture.height>>1 ;
			w2.graphic = img;
			w2.graphicUpdate = graphicUpdate ;
			addChild( img);
			
			var lin1:LineJoint = new LineJoint(body,w1,new Vec2(5,0),new Vec2(27,27),
				new Vec2(0,1), 0,60);
			lin1.space = _space;
			lin1.ignore = true; //prevent wheel colliding
			
			var lin2:LineJoint = new LineJoint(body,w2,new Vec2(80,0),new Vec2(27,27),
				new Vec2(0,1), 0,60);
			lin2.space = _space;
			lin2.ignore = true; //prevent wheel colliding
			
//			var spr1:DistanceJoint = new DistanceJoint(body,w1,new Vec2(5,-10), new Vec2(27,27),40,40);
//			spr1.stiff = false;
//			spr1.frequency = 5;
//			spr1.damping = 1;
//			spr1.space = _space;
//			
//			var spr2:DistanceJoint= new DistanceJoint(body,w2,new Vec2(80,-10), new Vec2(27,27),40,40);
//			spr2.stiff = false;
//			spr2.frequency = 5;
//			spr2.damping = 1;
//			spr2.space = _space;
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