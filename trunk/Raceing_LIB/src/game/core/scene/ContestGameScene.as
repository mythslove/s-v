package game.core.scene
{
	import bing.res.ResPool;
	import bing.res.ResVO;
	
	import flash.events.Event;
	
	import game.core.car.BaseCar;
	import game.core.track.BaseTrack;
	import game.util.CarFactory;
	import game.util.TrackFactory;
	import game.vos.AIVO;
	import game.vos.PlayerCarVO;
	import game.vos.TrackVO;
	
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class ContestGameScene extends Sprite
	{
		private var _playerCarVO:PlayerCarVO ;
		private var _carBotVO:AIVO ;
		private var _trackVO:TrackVO ;
		private var _car:BaseCar ;
		private var _carBot:BaseCar ;
		private var _track:BaseTrack ;
		private var _space:Space;
		private var _carGroup:InteractionGroup = new InteractionGroup(true);
		private var _debug:BitmapDebug ;//= new BitmapDebug(GameSetting.SCREEN_WIDTH,GameSetting.SCREEN_HEIGHT);
		private var _map:Sprite; 
		
		/**
		 *  竞赛游戏场景
		 * @param trackVO 赛道
		 * @param playerCarVO 玩家的车
		 * @param competitorIndex 对手的数组索引值
		 */		
		public function ContestGameScene( trackVO:TrackVO , playerCarVO:PlayerCarVO , competitorIndex:int = 0 )
		{
			super();
			this._trackVO = trackVO;
			this._playerCarVO = playerCarVO ;
			this._carBotVO = _trackVO.competitors[competitorIndex] ;
			addEventListener(starling.events.Event.ADDED_TO_STAGE , addedHandler);
		}
		
		private function addedHandler( e:starling.events.Event ):void
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE , addedHandler);
			addEventListener(starling.events.Event.REMOVED_FROM_STAGE , removedHandler );
			loadRes();
		}
		
		//加载此地图中所有要用到的图片
		private function loadRes():void
		{
			//添加loading
			var resVOArray:Array = [
				new ResVO("road",_trackVO.roadUrl),
				new ResVO("roadXML",_trackVO.roadXMLUrl),
				new ResVO("car"+_playerCarVO.carVO.id ,_playerCarVO.carVO.carUrl),
				new ResVO("carXML"+_playerCarVO.carVO.id , _playerCarVO.carVO.carXMLUrl)
			];
			if(_playerCarVO.carVO.id!=_carBotVO.carVO.id)
			{
				resVOArray.push(new ResVO("car"+_carBotVO.carVO.id ,_carBotVO.carVO.carUrl));
				resVOArray.push(new ResVO("carXML"+_carBotVO.carVO.id , _carBotVO.carVO.carXMLUrl));
			}
			ResPool.instance.addEventListener( "ContestGameSceneRes" , resLoadedHandler );
			ResPool.instance.queueLoad( "ContestGameSceneRes" , resVOArray);
		}
		
		private function resLoadedHandler(e:flash.events.Event):void
		{
			ResPool.instance.removeEventListener( "ContestGameSceneRes" , resLoadedHandler );
			_space = new Space(new Vec2(0,500));
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
			_carBot = CarFactory.createCar( _carGroup , _carBotVO.carVO , _space , 100 , 200 );
			_map.addChild(_carBot);
			_car =  CarFactory.createCar( _carGroup , _playerCarVO.carVO , _space , 200 , 200 );
			_map.addChild(_car);
			
			deleteResVOs();
			addEventListener(starling.events.Event.ENTER_FRAME , updateHandler );
		}
		
		private function deleteResVOs():void
		{
			ResPool.instance.deleteRes("road");
			ResPool.instance.deleteRes("roadXML");
			ResPool.instance.deleteRes("car"+_playerCarVO.carVO.id);
			ResPool.instance.deleteRes("carXML"+_playerCarVO.carVO.id);
			if(_playerCarVO.carVO.id!=_carBotVO.carVO.id)
			{
				ResPool.instance.deleteRes("car"+_carBotVO.carVO.id);
				ResPool.instance.deleteRes("carXML"+_carBotVO.carVO.id);
			}
		}
		
		private function updateHandler(e:starling.events.Event):void
		{
			_space.step(1/60);
			if(_debug){
				_debug.clear();
				_debug.draw(_space);
				_debug.flush();
			}
		}
		
		private function removedHandler( e:starling.events.Event ):void
		{
			removeEventListener(starling.events.Event.REMOVED_FROM_STAGE , removedHandler );
			removeEventListener(starling.events.Event.ENTER_FRAME , updateHandler );
			_space.clear();
			_space=  null ;
			_carBotVO = null ;
			_carBot = null ;
			_track=null ;
			_trackVO =null ;
			_map.removeChildren(0,-1,true);
		}
	}
}