package game
{
	import comm.GameSetting;
	
	import flash.display.Bitmap;
	import flash.ui.Keyboard;
	import flash.ui.KeyboardType;
	
	import gui.CarControlGUI;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.CollisionArbiter;
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
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import utils.BodyFromGraphic;
	
	public class Road1Scene extends Sprite
	{
		[Embed(source="../assets/1.png")]
		private var ROAD1:Class ;
		[Embed(source="../assets/2.png")]
		private var ROAD2:Class ;
		//===============================
		public const MAP_WID:int = 2048*20 ;
		
		private var _road1Bmp:Bitmap = new ROAD1();
		private var _road2Bmp:Bitmap = new ROAD2();
		private var _space:Space ;
		private var _roadTextureAtlas:TextureAtlas ;
		private var _road1Texture:Texture , _road2Texture:Texture ;
		private var _road1:Body , _road2:Body;
		private var _road1Polygon:Polygon , _road2Polygon:Polygon ;
		private var _car:Car ;
		private var _wall:Body ;
		private var _map:Sprite = new Sprite();
		private var _gui:CarControlGUI ;
		private var _listener:InteractionListener ;
		private var _groundType:CbType = new CbType() ;
		private var _carType:CbType = new CbType();
		
		public function Road1Scene()
		{
			super();
			_map.y=20;
			_map.touchable = false ;
			addChild(_map);
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
				
		
		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			_road1Texture = Texture.fromBitmap( _road1Bmp , false );
			_road2Texture = Texture.fromBitmap( _road2Bmp , false );
			
			_space = new Space( new Vec2(0,400));
			addWall();
			createRoads();
			_car = new Car(_space , _carType );
			_map.addChild(_car);
			
			_gui = new CarControlGUI();
			addChild(_gui);
			
			//create listener last
			_listener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, _groundType, _carType, onContact);
			_space.listeners.add(_listener);
			
			addEventListener(Event.ENTER_FRAME , update );
		}
		
		private function onContact(callback:InteractionCallback):void
		{
			var i:int = callback.arbiters.length;
			while (--i > -1) {
				
				var arbiter:CollisionArbiter = callback.arbiters.at(i).collisionArbiter;		
				
				trace(arbiter);
			}
		}
		
		private function addWall():void
		{
			_wall = new Body(BodyType.STATIC);
			_wall.shapes.add( new Polygon(Polygon.rect(-50,0,50,stage.stageHeight)));
			_wall.shapes.add( new Polygon(Polygon.rect(MAP_WID,0,50,stage.stageHeight)));
			_wall.space = _space ;
		}
		
		private function createRoads():void
		{
			var img:Image ;
			_road1=BodyFromGraphic.bitmapToBody(BodyType.KINEMATIC , Material.wood() ,  _road1Bmp.bitmapData );
			_road1.position.setxy( 0,GameSetting.SCREEN_HEIGHT-_road1Texture.height) ;
			_road1.cbType = _groundType ;
			_road1.space = _space ;
			img = new Image(_road1Texture);
			_road1.graphic = img;
			_road1.graphicUpdate = graphicUpdate ;
			_map.addChild( img );
			
			_road2=BodyFromGraphic.bitmapToBody(BodyType.KINEMATIC , Material.wood() , _road2Bmp.bitmapData );
			_road2.position.setxy( _road1Texture.width ,GameSetting.SCREEN_HEIGHT-_road2Texture.height) ;
			_road2.cbType = _groundType ;
			_road2.space = _space ;
			img = new Image(_road2Texture);
			_road2.graphic = img;
			_road2.graphicUpdate = graphicUpdate ;
			_map.addChild( img );
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
			panForeground();
			
			_car.carBody.applyLocalImpulse( new Vec2(200,0),new Vec2(80,0));
			if(_car.carBody.velocity.x>800) _car.carBody.velocity.x = 800 ;
			
			if(_gui.direction==1){
				_car.carBody.applyLocalImpulse( new Vec2(0,-10));
				if(_car.w1.velocity.y>50) _car.w1.velocity.y = 50 ;
			}else if(_gui.direction==2){
				_car.w2.applyLocalImpulse( new Vec2(0,-10));
				if(_car.w2.velocity.y>50) _car.w2.velocity.y = 50 ;
			}
		}
		
		private function panForeground():void
		{
			_map.x = GameSetting.SCREEN_WIDTH*0.5  - _car.w1.position.x-50 ;
			if(_map.x>0 ) _map.x =0 ;
			else if(_map.x+MAP_WID<GameSetting.SCREEN_WIDTH) _map.x = GameSetting.SCREEN_WIDTH-MAP_WID ;
			
			if(_road1.position.x+_map.x+1024<0) {
				_road1.position.x = _road2.position.x + 1024 ;
			}else if(_road2.position.x+_map.x+1024<0) {
				_road2.position.x = _road1.position.x + 1024 ;
			}
		}
	}
}