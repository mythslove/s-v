package game
{
	import comm.GameSetting;
	
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
	import nape.util.BitmapDebug;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import utils.AssetsManager;
	
	public class Road1Scene extends Sprite
	{
		public const MAP_WID:int = 2048*20 ;
		
		private var _road1:Body , _road2:Body , _road3:Body , _road4:Body;
		private var _space:Space ;
		private var _car:Car ;
		private var _wall:Body ;
		private var _map:Sprite = new Sprite();
		private var _gui:CarControlGUI ;
		private var _listener:InteractionListener ;
		private var _groundType:CbType = new CbType() ;
		private var _carType:CbType = new CbType();
		private var _debug:BitmapDebug = null ;//new BitmapDebug(960,640);
		
		public function Road1Scene()
		{
			super();
			_map.touchable = false ;
			addChild(_map);
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			if(_debug){
				_debug.drawConstraints = true;
				Starling.current.nativeOverlay.addChild(_debug.display);
			}
		}
				
		
		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			PhysicsData.registerMaterial("road",Material.wood());
			PhysicsData.registerMaterial("tie",Material.steel());
			PhysicsData.registerCbType("road",_groundType);
			
			
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
			var img:Image = new Image(AssetsManager.createTextureAtlas("RoadTexture").getTexture("road1"));
			_road1 = PhysicsData.createBody("road1",img);
			_road1.position.setxy( 0,GameSetting.SCREEN_HEIGHT-img.texture.height) ;
			_road1.type = BodyType.KINEMATIC ;
			_road1.space = _space ;
			_map.addChild( img );
			
			img = new Image(AssetsManager.createTextureAtlas("RoadTexture").getTexture("road2"));
			_road2 = PhysicsData.createBody("road2",img);
			_road2.type = BodyType.KINEMATIC ;
			_road2.position.setxy( 1024 ,GameSetting.SCREEN_HEIGHT-img.texture.height) ;trace(img.texture.height);
			_road2.space = _space ;
			_map.addChild( img );
			
			img = new Image(AssetsManager.createTextureAtlas("RoadTexture").getTexture("road3"));
			_road3 = PhysicsData.createBody("road3",img);
			_road3.type = BodyType.KINEMATIC ;
			_road3.position.setxy( 1024*2 ,GameSetting.SCREEN_HEIGHT-img.texture.height) ;
			_road3.space = _space ;
			_map.addChild( img );
			
			img = new Image(AssetsManager.createTextureAtlas("RoadTexture").getTexture("road4"));
			_road4 = PhysicsData.createBody("road4",img);
			_road4.type = BodyType.KINEMATIC ;
			_road4.position.setxy( 1024*3 ,GameSetting.SCREEN_HEIGHT-img.texture.height) ;
			_road4.space = _space ;
			_map.addChild( img );
		}
		
		private function update(e:Event):void
		{
			_space.step(1/60);
			if(_debug){
				_debug.clear();
				_debug.draw(_space);
				_debug.flush();
			}
			
			panForeground();
			
			if(_gui.direction==1){
				_car.w1.applyLocalImpulse( new Vec2(-100,0));
				if(_car.w1.velocity.x<-300) _car.w1.velocity.x = -300 ;
			}else if(_gui.direction==2){
				_car.w2.applyLocalImpulse( new Vec2(100,0));
				if(_car.w2.velocity.x>300) _car.w2.velocity.x = 300 ;
			}
		}
		
		private function panForeground():void
		{
			_map.x = GameSetting.SCREEN_WIDTH*0.5  - _car.w1.position.x-200 ;
			if(_map.x>0 ) _map.x =0 ;
			else if(_map.x+MAP_WID<GameSetting.SCREEN_WIDTH) _map.x = GameSetting.SCREEN_WIDTH-MAP_WID ;
			
			_road1.graphic.visible = _road1.position.x+_map.x<=GameSetting.SCREEN_WIDTH ? true : false ;
			_road2.graphic.visible = _road1.position.x+_map.x<=GameSetting.SCREEN_WIDTH ? true : false ;
			_road3.graphic.visible = _road1.position.x+_map.x<=GameSetting.SCREEN_WIDTH ? true : false ;
			_road4.graphic.visible = _road1.position.x+_map.x<=GameSetting.SCREEN_WIDTH ? true : false ;
			
			
			if(_road1.position.x+_map.x+1024<0) {
				_road1.position.x = 1024*3 ;
			}else if(_road2.position.x+_map.x+1024<0) {
				_road2.position.x = 1024*3 ;
			}else if(_road3.position.x+_map.x+1024<0) {
				_road3.position.x = 1024*3 ;
			}else if(_road4.position.x+_map.x+1024<0) {
				_road4.position.x = 1024*3 ;
			}
		}
	}
}