package game.core.scene
{
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
	import nape.dynamics.Arbiter;
	import nape.dynamics.ArbiterList;
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
		private var _carLeftWheelOnRoad:Boolean , _botCarLeftWheelOnRoad:Boolean , _carRightWheelOnRoad:Boolean , _botCarRightWheelOnRoad:Boolean  ;
		
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
			_space = new Space(Vec2.get(0,500));
			
			if(_debug){
				_debug.drawConstraints = true ;
				_debug.drawCollisionArbiters=true ;
				Starling.current.nativeStage.addChild( _debug.display );
			}
			
			_map = new Sprite();
			_map.touchable = false ;
			addChild(_map);
			
			_track = TrackFactory.createTrack(_trackVO,_space);
			_map.addChild(_track);
			
			var dustTexture:Texture =  _track.textureAltas.getTexture("dustTexture") ;
			_carBot = CarFactory.createCar( _carGroup , _carBotVO.carVO , _space , 400 , 300 );
			_carBot.leftWheel.cbTypes.add( _carWheelCbType) ;
			_carBot.rightWheel.cbTypes.add( _carWheelCbType) ;
			_carBot.createParticles(dustTexture);
			_map.addChild(_carBot);
			
			_car =  CarFactory.createCar( _carGroup , _playerCarVO.carVO , _space , 300 , 300 );
			_car.leftWheel.cbTypes.add( _carWheelCbType) ;
			_car.rightWheel.cbTypes.add( _carWheelCbType) ;
			_car.carBody.cbTypes.add(_carBodyCbType);
			_car.createParticles(dustTexture);
			_map.addChild(_car);
			
			deleteResVOs();
			addListeners();
			
			addEventListener(starling.events.Event.ENTER_FRAME , updateHandler );
			stage.addEventListener(KeyboardEvent.KEY_DOWN , onKeyDownHandler);
		}
		
		
		
		private function addListeners():void
		{
			_space.listeners.add( new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_carWheelCbType,_track.roadType,
				function( callback:InteractionCallback ):void {
					var list:ArbiterList = callback.arbiters ;
					for(var i:int = 0 ; i<list.length ; ++i){
						var arbiter:Arbiter = list.at(i) ;
						switch(arbiter.body2)
						{
							case _car.leftWheel :
								_carLeftWheelOnRoad = true ;
								break ;
							case _car.rightWheel :
								_carRightWheelOnRoad = true ;
								break ;
							case _carBot.leftWheel :
								_botCarLeftWheelOnRoad = true ;
								break ;
							case _carBot.rightWheel :
								_botCarRightWheelOnRoad = true ;
								break ;
						}
					}
				}
			));
			_space.listeners.add( new InteractionListener(CbEvent.END,InteractionType.COLLISION,_carWheelCbType,_track.roadType,
				function( callback:InteractionCallback ):void {
					var list:ArbiterList = callback.arbiters ;
					for(var i:int = 0 ; i<list.length ; ++i){
						var arbiter:Arbiter = list.at(i) ;
						switch(arbiter.body2)
						{
							case _car.leftWheel :
								_carLeftWheelOnRoad = false ;
								break ;
							case _car.rightWheel :
								_carRightWheelOnRoad = false ;
								break ;
							case _carBot.leftWheel :
								_botCarLeftWheelOnRoad = false ;
								break ;
							case _carBot.rightWheel :
								_botCarRightWheelOnRoad = false ;
								break ;
						}
					}
				}
			));
			_space.listeners.add( new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_carBodyCbType,_track.roadType,
				function( callback:InteractionCallback ):void {
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
				if(_carLeftWheelOnRoad) {
					_car.leftWheel.applyLocalImpulse( Vec2.get(_car.maxImpulse,0));
				}
			}else if(e.keyCode==Keyboard.LEFT){
				_car.leftWheel.rotation-=0.2 ;
				if(_carLeftWheelOnRoad) {
					_car.leftWheel.applyLocalImpulse( Vec2.get(-_car.maxImpulse,0));
				}
			}
			
			if(_car.leftWheel.velocity.x<-_car.maxVelocity)  _car.leftWheel.velocity.x = - _car.maxVelocity ;
			if(_car.leftWheel.velocity.x>_car.maxVelocity)  _car.leftWheel.velocity.x = _car.maxVelocity ;
		}
		
		private function updateHandler(e:starling.events.Event):void
		{
			_space.step(1/60);
			if(_debug){
				_debug.clear();
				_debug.draw(_space);
				_debug.flush();
			}
			
			_map.x = GameSetting.SCREEN_WIDTH*0.5 - _car.leftWheel.position.x-100 ;
			if(_map.x>0 ) _map.x =0 ;
			else if(_map.x+_track.len<GameSetting.SCREEN_WIDTH) _map.x = GameSetting.SCREEN_WIDTH-_track.len ;
			//机器车自动走
			_carBot.leftWheel.rotation+=0.2 ;
			if(_botCarLeftWheelOnRoad){
				_carBot.leftWheel.applyLocalImpulse( Vec2.weak(_carBot.maxImpulse,0));
				if(_carBot.leftWheel.velocity.x>_carBot.maxVelocity) {
					_carBot.leftWheel.velocity.x = _carBot.maxVelocity ;
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
			_carWheelCbType = null ;
			_map.removeChildren(0,-1,true);
		}
	}
}