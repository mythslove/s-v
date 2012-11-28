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
		
		private var _space:Space ;
		private var _carBody:Body,_w1:Body,_w2:Body ;
		private var _carTexture:Texture , _carWheelTexture:Texture ;
		
		public function get w1():Body{
			return _w1;
		}
		public function get w2():Body{
			return _w2;
		}
		
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
			var img:Image ;
			
			var offsetX:Number=stage.stageWidth>>1  , offsetY:Number = 360;
			var body:Body = new Body(null, new Vec2(offsetX,offsetY));
			body.shapes.add(new Polygon(Polygon.box(_carTexture.width,_carTexture.height)));
			img = new Image(_carTexture); 
			img.pivotX = _carTexture.width>>1 ;
			img.pivotY = _carTexture.height>>1 ;
			body.graphic = img;
			body.graphicUpdate = graphicUpdate ;
			body.space = _space;
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
			
			var lin1:LineJoint = new LineJoint(body,_w1,new Vec2(-44,0),new Vec2(),
				new Vec2(0,1), 0,50);
			lin1.space = _space;
			lin1.ignore = true; //prevent wheel colliding
			
			var lin2:LineJoint = new LineJoint(body,_w2,new Vec2(60,0),new Vec2(),
				new Vec2(0,1), 0,50);
			lin2.space = _space;
			lin2.ignore = true; //prevent wheel colliding
			
			var spr1:DistanceJoint = new DistanceJoint(body,_w1,new Vec2(-44,-10), new Vec2(),43,50);
			spr1.stiff = false;
			spr1.frequency = 5;
			spr1.damping = 1;
			spr1.space = _space;
			
			var spr2:DistanceJoint= new DistanceJoint(body,_w2,new Vec2(60,-10), new Vec2(),43,50);
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