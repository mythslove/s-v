package game
{
	import comm.GameSetting;
	
	import flash.display.Bitmap;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Road1Scene extends Sprite
	{
		[Embed(source="../assets/1.png")]
		private var ROAD1:Class ;
		[Embed(source="../assets/2.png")]
		private var ROAD2:Class ;
		//===============================
		
		private var _road1Bmp:Bitmap = new ROAD1();
		private var _road2Bmp:Bitmap = new ROAD2();
		private var _space:Space ;
		private var _roadTextureAtlas:TextureAtlas ;
		private var _road1Texture:Texture , _road2Texture:Texture ;
		private var _road1:Body , _road2:Body;
		private var _road1Polygon:Polygon , _road2Polygon:Polygon ;
		private var _roads:Sprite = new Sprite();
		private var _car:Car ;
		
		public function Road1Scene()
		{
			super();
			touchable=false ;
			addChild(_roads);
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			_road1Texture = Texture.fromBitmap( _road1Bmp , false );
			_road2Texture = Texture.fromBitmap( _road2Bmp , false );
			
			_space = new Space( new Vec2(0,400));
			
			
			createRoads();
			
			_car = new Car(_space);
			addChild(_car);
			
			
			addEventListener(Event.ENTER_FRAME , update );
		}
		
		private function createRoads():void
		{
			var img:Image ;
			_road1=BodyFromGraphic.bitmapToBody(BodyType.STATIC , Material.wood() ,  _road1Bmp.bitmapData );
			_road1.position.setxy( 0,GameSetting.SCREEN_HEIGHT-_road1Texture.height) ;
			_road1.space = _space ;
			img = new Image(_road1Texture);
			_road1.graphic = img;
			_road1.graphicUpdate = graphicUpdate ;
			_roads.addChild( img );
			
			_road2=BodyFromGraphic.bitmapToBody(BodyType.STATIC , Material.wood() , _road2Bmp.bitmapData );
			_road2.position.setxy( GameSetting.SCREEN_WIDTH,GameSetting.SCREEN_HEIGHT-_road2Texture.height) ;
			_road2.space = _space ;
			img = new Image(_road2Texture);
			_road2.graphic = img;
			_road2.graphicUpdate = graphicUpdate ;
			_roads.addChild( img );
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
		
		private function update(e:Event):void
		{
			_space.step(1/60);
		}
	}
}