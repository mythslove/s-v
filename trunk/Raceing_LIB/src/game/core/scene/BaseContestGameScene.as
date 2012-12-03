package game.core.scene
{
	import bing.res.ResPool;
	import bing.res.ResVO;
	
	import flash.events.Event;
	
	import game.vos.*;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BaseContestGameScene extends Sprite
	{
		protected var _playerCarVO:PlayerCarVO ;
		protected var _carBotVO:AIVO ;
		protected var _trackVO:TrackVO ;
		
		public function BaseContestGameScene(trackVO:TrackVO , playerCarVO:PlayerCarVO , competitorIndex:int = 0 )
		{
			super();
			this._trackVO = trackVO;
			this._playerCarVO = playerCarVO ;
			this._carBotVO = _trackVO.competitors[competitorIndex] ;
			
			addEventListener(starling.events.Event.ADDED_TO_STAGE , addedHandler);
		}
		
		protected function addedHandler( e:starling.events.Event ):void
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
			if(_playerCarVO.carVO.id != _carBotVO.carVO.id){
				resVOArray.push(new ResVO("car"+_carBotVO.carVO.id ,_carBotVO.carVO.carUrl));
				resVOArray.push(new ResVO("carXML"+_carBotVO.carVO.id , _carBotVO.carVO.carXMLUrl));
			}
			ResPool.instance.addEventListener( "ContestGameSceneRes" , resLoadedHandler );
			ResPool.instance.queueLoad( "ContestGameSceneRes" , resVOArray);
		}
		
		private function resLoadedHandler(e:flash.events.Event):void
		{
			ResPool.instance.removeEventListener( "ContestGameSceneRes" , resLoadedHandler );
			createPhySpace();
		}
		
		/**
		 * 创建物理空间
		 */		
		protected function createPhySpace():void
		{
			
		}
		
		protected function deleteResVOs():void
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
		
		protected  function removedHandler( e:starling.events.Event ):void
		{
			removeEventListener(starling.events.Event.REMOVED_FROM_STAGE , removedHandler );
			_carBotVO = null ;
			_trackVO =null ;
			_playerCarVO = null ;
		}
	}
}