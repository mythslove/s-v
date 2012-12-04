package game.core.scene
{
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	import game.comm.GameSetting;
	import game.core.car.BaseCar;
	import game.core.track.BaseTrack;
	import game.util.CarFactory;
	import game.util.TrackFactory;
	import game.vos.PlayerCarVO;
	import game.vos.TrackVO;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.CollisionArbiter;
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.textures.Texture;
	
	public class ContestGameScene extends BaseContestGameScene
	{
		private var _car:BaseCar ;
		private var _carBot:BaseCar ;
		private var _track:BaseTrack ;
		private var _space:Space;
		private var _carGroup:InteractionGroup = new InteractionGroup(true);
		private var _debug:BitmapDebug ;//= new BitmapDebug(GameSetting.SCREEN_WIDTH,GameSetting.SCREEN_HEIGHT);
		private var _map:Sprite; 
		private var _carBodyCbType:CbType = new CbType();
		private var _carWheelCbType:CbType = new CbType();
		private var _robotCarWheelCbType:CbType = new CbType();
		private var _roadCbType:CbType = new CbType();
		private var _carOnRoad:Boolean , _botOnRoad:Boolean  ;
		
		/**
		 *  竞赛游戏场景
		 * @param trackVO 赛道
		 * @param playerCarVO 玩家的车
		 * @param competitorIndex 对手的数组索引值
		 */		
		public function ContestGameScene( trackVO:TrackVO , playerCarVO:PlayerCarVO , competitorIndex:int = 0 )
		{
			super(trackVO,playerCarVO,competitorIndex);
		}
		
		/**
		 * 创建物理空间
		 */		
		override protected function createPhySpace():void
		{
			_space = new Space(new Vec2(0,500));
			addListeners();
			
			if(_debug){
				_debug.drawConstraints = true ;
				_debug.drawCollisionArbiters=true ;
				Starling.current.nativeStage.addChild( _debug.display );
			}
			
			_map = new Sprite();
			_map.touchable = false ;
			addChild(_map);
			
			_track = TrackFactory.createTrack(_trackVO,_space);
			_track.roadCompound.cbType = _roadCbType ;
			_map.addChild(_track);
			
			var dustTexture:Texture =  _track.textureAltas.getTexture("dustTexture") ;
			_carBot = CarFactory.createCar( _carGroup , _carBotVO.carVO , _space , 400 , 300 );
			_carBot.leftWheel.cbType = _robotCarWheelCbType ;
			_carBot.createParticles(dustTexture);
			_map.addChild(_carBot);
			
			_car =  CarFactory.createCar( _carGroup , _playerCarVO.carVO , _space , 300 , 300 );
			_car.leftWheel.cbType = _carWheelCbType ;
			_car.carBody.cbType = _carBodyCbType ;
			_car.createParticles(dustTexture);
			_map.addChild(_car);
			
			deleteResVOs();
			
			addEventListener(starling.events.Event.ENTER_FRAME , updateHandler );
			stage.addEventListener(KeyboardEvent.KEY_DOWN , onKeyDownHandler);
		}
		
		
		
		private function addListeners():void
		{
			_space.listeners.add( new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_robotCarWheelCbType,_roadCbType,
				function carRoadCallBack( callback:InteractionCallback ):void {
					_botOnRoad = true ;
					_carBot.leftWheelParticle.start(.2);
					_carBot.rightWheelParticle.start(.2);
				}
			));
			_space.listeners.add( new InteractionListener(CbEvent.END,InteractionType.COLLISION,_robotCarWheelCbType,_roadCbType,
				function carRoadCallBack( callback:InteractionCallback ):void {
					_botOnRoad = false ;
				}
			));
			_space.listeners.add( new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_carWheelCbType,_roadCbType,
				function carRoadCallBack( callback:InteractionCallback ):void {
					_carOnRoad = true ;
					_car.leftWheelParticle.start(.2);
					_car.rightWheelParticle.start(.2);
				}
			));
			_space.listeners.add( new InteractionListener(CbEvent.END,InteractionType.COLLISION,_carWheelCbType,_roadCbType,
				function carRoadCallBack( callback:InteractionCallback ):void {
					_carOnRoad = false ;
				}
			));
			_space.listeners.add( new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_carBodyCbType,_roadCbType,
				function carRoadCallBack( callback:InteractionCallback ):void {
					var rotate:Number = (_car.carBody.rotation*180/Math.PI)%360 ;
					if(rotate>120 || rotate<-120){
						trace("挂了");
					}
				}
			));
			
		}
		
		
		private function onKeyDownHandler(e:KeyboardEvent):void
		{
			if(e.keyCode==Keyboard.RIGHT){
				_car.leftWheel.rotation+=0.2 ;
				if(_carOnRoad) {
					_car.leftWheel.applyLocalImpulse( Vec2.weak(_playerCarVO.carVO.carParams["impulse"].value,0));
				}
			}else if(e.keyCode==Keyboard.LEFT){
				_car.leftWheel.rotation-=0.2 ;
				if(_carOnRoad) {
					_car.leftWheel.applyLocalImpulse( Vec2.weak(-_playerCarVO.carVO.carParams["impulse"].value,0));
				}
			}
			
			var velocity:Number = _playerCarVO.carVO.carParams["velocity"].value ;
			if(_car.leftWheel.velocity.x<-velocity)  _car.leftWheel.velocity.x = - velocity ;
			if(_car.leftWheel.velocity.x>velocity)  _car.leftWheel.velocity.x = velocity ;
		}
		
		private function updateHandler(e:starling.events.Event):void
		{
			_space.step(1/60);
			if(_debug){
				_debug.clear();
				_debug.draw(_space);
				_debug.flush();
			}
			
			_map.x = GameSetting.SCREEN_WIDTH*0.5 - _car.leftWheel.position.x -  300 ;
			if(_map.x>0 ) _map.x =0 ;
			else if(_map.x+_track.len<GameSetting.SCREEN_WIDTH) _map.x = GameSetting.SCREEN_WIDTH-_track.len ;
			//机器车自动走
			_carBot.leftWheel.rotation+=0.2 ;
			if(_botOnRoad){
				_carBot.leftWheel.applyLocalImpulse( Vec2.weak(_carBotVO.carVO.carParams["impulse"].value,0));
				var velocity:Number = _carBotVO.carVO.carParams["velocity"].value ;
				if(_carBot.leftWheel.velocity.x>velocity) {
					_carBot.leftWheel.velocity.x = velocity ;
				}
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		//===============清除资源=========================
		override protected function removedHandler( e:starling.events.Event ):void
		{
			super.removedHandler(e);
			removeEventListener(starling.events.Event.ENTER_FRAME , updateHandler );
			stage.removeEventListener(KeyboardEvent.KEY_DOWN , onKeyDownHandler);
			_space.clear();
			_space=  null ;
			_carBot = null ;
			_track=null ;
			_carBodyCbType = null ;
			_roadCbType = null ;
			_carWheelCbType = null ;
			_map.removeChildren(0,-1,true);
		}
	}
}