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
		public const MAP_WID:int = 1024*20 ;
		
		private var _road1:Body , _road2:Body , _road3:Body , _road4:Body;
		private var _space:Space ;
		private var _car:Car ;
		private var _wall:Body ;
		private var _map:Sprite = new Sprite();
		private var _gui:CarControlGUI ;
		private var _listener:InteractionListener ;
		private var _groundType:CbType = new CbType() ;
		private var _carType:CbType = new CbType();
		private var _w1OnGround:Boolean , _w2OnGround:Boolean ;
		private var _debug:BitmapDebug ; //=new BitmapDebug(960,640);
		
		public function Road1Scene()
		{
			super();
			_map.touchable = false ;
			addChild(_map);
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			if(_debug){
				_debug.drawConstraints = true;
				_debug.drawCollisionArbiters=true;
//				_debug.drawBodyDetail=true;
				Starling.current.nativeOverlay.addChild(_debug.display);
			}
		}
				
		
		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			PhysicsData.registerMaterial("default",Material.sand());
			PhysicsData.registerMaterial("road",Material.sand());
			var tie:Material = Material.wood();
			PhysicsData.registerMaterial("tie",tie );
			PhysicsData.registerCbType("road",_groundType);
			
			
			_space = new Space( new Vec2(0,2000));
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
				_w1OnGround =  arbiter.body2==_car.w1 ;
				_w2OnGround =  arbiter.body2==_car.w2 ;
			}
		}
		
		private function addWall():void
		{
			_wall = new Body(BodyType.STATIC);
			_wall.shapes.add( new Polygon(Polygon.rect(-50,0,50,stage.stageHeight)));
			_wall.shapes.add( new Polygon(Polygon.rect(MAP_WID,0,50,stage.stageHeight)));
			_wall.shapes.add( new Polygon(Polygon.rect(0,stage.stageHeight-50,stage.stageWidth,50)));
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
			_road2.position.setxy( 1024 ,GameSetting.SCREEN_HEIGHT-img.texture.height) ;
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
			
			for(var i:int = 4 ; i<20; i+=4){
				
				//===============
				img = new Image(AssetsManager.createTextureAtlas("RoadTexture").getTexture("road1"));
				_road1 = PhysicsData.createBody("road1",img);
				_road1.position.setxy( 1024*i,GameSetting.SCREEN_HEIGHT-img.texture.height) ;
				_road1.type = BodyType.KINEMATIC ;
				_road1.space = _space ;
				_map.addChild( img );
				
				img = new Image(AssetsManager.createTextureAtlas("RoadTexture").getTexture("road2"));
				_road2 = PhysicsData.createBody("road2",img);
				_road2.type = BodyType.KINEMATIC ;
				_road2.position.setxy( 1024*(i+1) ,GameSetting.SCREEN_HEIGHT-img.texture.height) ;
				_road2.space = _space ;
				_map.addChild( img );
				
				img = new Image(AssetsManager.createTextureAtlas("RoadTexture").getTexture("road3"));
				_road3 = PhysicsData.createBody("road3",img);
				_road3.type = BodyType.KINEMATIC ;
				_road3.position.setxy( 1024*(i+2) ,GameSetting.SCREEN_HEIGHT-img.texture.height) ;
				_road3.space = _space ;
				_map.addChild( img );
				
				img = new Image(AssetsManager.createTextureAtlas("RoadTexture").getTexture("road4"));
				_road4 = PhysicsData.createBody("road4",img);
				_road4.type = BodyType.KINEMATIC ;
				_road4.position.setxy( 1024*(i+3) ,GameSetting.SCREEN_HEIGHT-img.texture.height) ;
				_road4.space = _space ;
				_map.addChild( img );
			}
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
				_car.w1.rotation-=0.2;
				_car.w1.applyLocalImpulse( Vec2.weak(-600,0) );
			}else if(_gui.direction==2){
				_car.w1.rotation+=0.2 ;
				_car.w1.applyLocalImpulse( Vec2.weak(600,0) );
			}
			if(_car.w1.velocity.x<-400) _car.w1.velocity.x = -400 ;
			if(_car.w1.velocity.x>400) _car.w1.velocity.x = 400 ;
		}
		
		private function panForeground():void
		{
			_map.x = GameSetting.SCREEN_WIDTH*0.5  - _car.w1.position.x-200 ;
			if(_map.x>0 ) _map.x =0 ;
			else if(_map.x+MAP_WID<GameSetting.SCREEN_WIDTH) _map.x = GameSetting.SCREEN_WIDTH-MAP_WID ;
			
		}
	}
}