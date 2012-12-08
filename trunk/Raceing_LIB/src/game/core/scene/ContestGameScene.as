package game.core.scene
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import game.comm.GameSetting;
	import game.core.car.BaseCar;
	import game.core.track.BaseTrack;
	import game.events.GameControlEvent;
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
	import nape.phys.Body;
	import nape.phys.Compound;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class ContestGameScene extends BaseContestGameScene
	{
		protected var _gameOver:Boolean;
		protected var _startFlag:Boolean ;
		protected var _carX:Number = 300 ;
		protected var _botX:Number =400 ;
		protected var _car:BaseCar ;
		protected var _carBot:BaseCar ;
		protected var _moveDirection:int = 0 ;//无,1为left,2为right 
		
		protected var _track:BaseTrack ;
		protected var _space:Space;
		protected var _carGroup:InteractionGroup = new InteractionGroup(true);
		protected var _debug:BitmapDebug;//= new BitmapDebug(GameSetting.SCREEN_WIDTH,GameSetting.SCREEN_HEIGHT);
		protected var _map:Sprite; 
		protected var _carBodyCbType:CbType = new CbType();
		protected var _carWheelCbType:CbType = new CbType();
		protected var _carLeftWheelOnRoad:Boolean , _carRightWheelOnRoad:Boolean ;
		protected var _botCarLeftWheelOnRoad:Boolean, _botCarRightWheelOnRoad:Boolean  ;
		
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
			_space = new Space(Vec2.weak(0,_trackVO.gravity));
			
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
			_carBot = CarFactory.createCar( _carGroup , _carBotVO.carVO , _space , _botX , GameSetting.SCREEN_HEIGHT-_trackVO.position );
			_carBot.leftWheel.cbTypes.add( _carWheelCbType) ;
			_carBot.rightWheel.cbTypes.add( _carWheelCbType) ;
			_map.addChild(_carBot);
			
			_car =  CarFactory.createCar( _carGroup , _playerCarVO.carVO , _space , _carX , GameSetting.SCREEN_HEIGHT-_trackVO.position );
			_car.leftWheel.cbTypes.add( _carWheelCbType) ;
			_car.rightWheel.cbTypes.add( _carWheelCbType) ;
			_car.carBody.cbTypes.add(_carBodyCbType);
			_map.addChild(_car);
			//初始化位置
			refreshAllBodies();
			//添加侦听
			addListeners();
			updateHandler(null);
			addEventListener(starling.events.Event.ENTER_FRAME , updateHandler );
			stage.addEventListener(TouchEvent.TOUCH , onTouchHandler);
			
			//开始计时器
			var timer:Timer = new Timer(1000,3);
			timer.addEventListener(TimerEvent.TIMER , onTimerHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE , onTimerHandler);
			timer.start();
		}
		
		protected function onTimerHandler( e:TimerEvent ):void
		{
			switch(e.type)
			{
				case TimerEvent.TIMER:
					trace("Time:"+ (e.target as Timer).currentCount );
					break ;
				case TimerEvent.TIMER_COMPLETE:
					e.target.removeEventListener(TimerEvent.TIMER , onTimerHandler);
					e.target.removeEventListener(TimerEvent.TIMER_COMPLETE , onTimerHandler);
					startGame();
					break ;
			}
		}
		
		protected function startGame():void
		{
			_startFlag = true ;
		}
		
		protected function refreshAllBodies():void
		{
			var len:int = _space.bodies.length ;
			for (var i:int = 0; i <len ; ++i) {
				var body:Body = _space.bodies.at(i);
				if (body.userData.graphicUpdate) {
					body.userData.graphicUpdate(body);
				}
			}
			len = _space.compounds.length;
			for( i = 0 ; i<len ; ++i){
				var compound:Compound =_space.compounds.at(i);
				for( var j:int = 0 ; j<compound.bodies.length ; ++j){
					body = compound.bodies.at(j);
					if (body.userData.graphicUpdate) {
						body.userData.graphicUpdate(body);
					}
				}
			}
		}
		
		protected function onTouchHandler(e:TouchEvent):void
		{
			var beginTouch:Touch = e.getTouch(stage,TouchPhase.BEGAN) ;
			if(beginTouch){
				if(beginTouch.globalX<GameSetting.SCREEN_WIDTH*0.5) _moveDirection = 1 ;
				else _moveDirection = 2 ;
			}
			var endTouch:Touch= e.getTouch(stage,TouchPhase.ENDED) ;
			if(endTouch){
				_moveDirection = 0 ;
			}
		}
		
		protected function addListeners():void
		{
			_space.listeners.add( new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_carWheelCbType,_track.roadType,
				function( callback:InteractionCallback ):void 
				{
					switch(callback.int1.castBody) {
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
			));
			_space.listeners.add( new InteractionListener(CbEvent.END,InteractionType.COLLISION,_carWheelCbType,_track.roadType,
				function( callback:InteractionCallback ):void 
				{
					switch(callback.int1.castBody) {
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
			));
			
			_space.listeners.add( new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,_carBodyCbType,_track.roadType,
				function():void{
					var rotate:Number = (_car.carBody.rotation*180/Math.PI)%360 ;
					if(rotate>120 || rotate<-120){
						_gameOver = true ;
						_car.breakCar();
						stage.removeEventListener(TouchEvent.TOUCH , onTouchHandler);
						_car.dustParticle.stop();
						setTimeout(gameOver,3000);
					}
				}
			));
		}
		
		protected function gameOver():void
		{
			removeEventListener(starling.events.Event.ENTER_FRAME , updateHandler );
			this.dispatchEvent(new GameControlEvent(GameControlEvent.GAME_OVER));
		}
		
		
		protected function moveCar():void
		{
			if(_moveDirection==2){
				_car.leftWheel.rotation+=0.2 ;
				if(_carLeftWheelOnRoad) {
					_car.carBody.applyImpulse( Vec2.fromPolar(_car.maxImpulse,_car.carBody.rotation) );
				}
				if(_playerCarVO.carVO.drive==2){
					_car.rightWheel.rotation+=0.2 ;
					if(_carRightWheelOnRoad ){
						_car.carBody.applyImpulse( Vec2.fromPolar(_car.maxImpulse,_car.carBody.rotation)  );
					}
				}
			}else if(_moveDirection==1){
				_car.leftWheel.rotation-=0.2 ;
				if(_carLeftWheelOnRoad) {
					_car.carBody.applyImpulse( Vec2.fromPolar( -_car.maxImpulse,_car.carBody.rotation)  );
				}
				if(_playerCarVO.carVO.drive==2){
					_car.rightWheel.rotation-=0.2 ;
					if(_carRightWheelOnRoad ){
						_car.carBody.applyImpulse( Vec2.fromPolar( -_car.maxImpulse,_car.carBody.rotation)  );
					}
				}
			}
			
			if(_car.leftWheel.velocity.x<-_car.maxVelocity)  _car.leftWheel.velocity.x = - _car.maxVelocity ;
			if(_car.leftWheel.velocity.x>_car.maxVelocity)  _car.leftWheel.velocity.x = _car.maxVelocity ;
			if(_car.rightWheel.velocity.x<-_car.maxVelocity)  _car.rightWheel.velocity.x = - _car.maxVelocity ;
			if(_car.rightWheel.velocity.x>_car.maxVelocity)  _car.rightWheel.velocity.x = _car.maxVelocity ;
		}
		
		/**
		 * 移动机器人 
		 */		
		protected function moveRobot():void
		{
			if(_botCarLeftWheelOnRoad){
				_carBot.carBody.applyImpulse( Vec2.fromPolar( _carBot.maxImpulse,_carBot.carBody.rotation));
			}
			if(_carBotVO.drive == 2 ){
				if(_botCarRightWheelOnRoad){
					_carBot.carBody.applyImpulse( Vec2.fromPolar( _carBot.maxImpulse,_carBot.carBody.rotation) );
				}
			}
			if(_carBot.leftWheel.velocity.x>_carBot.maxVelocity)  _carBot.leftWheel.velocity.x = _carBot.maxVelocity ; 
			if(_carBot.rightWheel.velocity.x>_carBot.maxVelocity)  _carBot.rightWheel.velocity.x = _carBot.maxVelocity ;
		}
		
		protected function updateHandler(e:starling.events.Event):void
		{
			_space.step(1/60);
			var len:int = _space.liveBodies.length; 
			for (var i:int = 0; i <len ; ++i) {
				var body:Body = _space.liveBodies.at(i);
				if (body.userData.graphicUpdate) {
					body.userData.graphicUpdate(body);
				}
			}
	
			if(_startFlag && !_gameOver ) moveCar();
			
			_map.x = GameSetting.SCREEN_WIDTH*0.5 - _car.carBody.position.x-100 ;
			if(_map.x>0 ) _map.x =0 ;
			else if(_map.x+_track.len<GameSetting.SCREEN_WIDTH) _map.x = GameSetting.SCREEN_WIDTH-_track.len ;
			_map.y = GameSetting.SCREEN_HEIGHT*0.5 - _car.carBody.position.y ;
			if(_map.y<0) _map.y = 0 ;
			else if(_map.y>300) _map.y=300 ;
			
			//机器车自动走
			if(_startFlag && !_gameOver ) moveRobot();
			
			//debug
			if(_debug){
				_debug.clear();
				_debug.draw(_space);
				_debug.flush();
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		//===============清除资源=========================
		override public function dispose():void
		{
			super.dispose();
			removeEventListener(starling.events.Event.ENTER_FRAME , updateHandler );
			_space.clear();
			_space=  null ;
			_carBot = null ;
			_track=null ;
			_carBodyCbType = null ;
			_carWheelCbType = null ;
			_map = null ;
		}
	}
}