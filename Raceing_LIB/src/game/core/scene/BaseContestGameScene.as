package game.core.scene
{
	import bing.res.ResPool;
	import bing.res.ResVO;
	
	import flash.events.Event;
	
	import game.comm.GameSetting;
	import game.vos.*;
	
	import starling.display.Quad;
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
			loadRes();
		}
		
		//加载此地图中所有要用到的图片
		private function loadRes():void
		{
			//添加loading
			var resVOArray:Array = [
				new ResVO("road"+_trackVO.id , _trackVO.roadUrl),
				new ResVO("roadXML"+_trackVO.id,_trackVO.roadXMLUrl),
				new ResVO("car"+_playerCarVO.carVO.id ,_playerCarVO.carVO.carUrl),
				new ResVO("carXML"+_playerCarVO.carVO.id , _playerCarVO.carVO.carXMLUrl),
				new ResVO("car"+_carBotVO.carVO.id ,_carBotVO.carVO.carUrl),
				new ResVO("carXML"+_carBotVO.carVO.id , _carBotVO.carVO.carXMLUrl)
			];
			ResPool.instance.addEventListener( "ContestGameSceneRes" , resLoadedHandler );
			ResPool.instance.queueLoad( "ContestGameSceneRes" , resVOArray);
		}
		
		private function resLoadedHandler(e:flash.events.Event):void
		{
			ResPool.instance.removeEventListener( "ContestGameSceneRes" , resLoadedHandler );
			createGameBg();
			createPhySpace();
			//地图有点大，所以删除地图
			ResPool.instance.deleteRes("road"+_trackVO.id);
		}
		
		protected function createGameBg():void
		{
			var quad:Quad = new Quad(GameSetting.SCREEN_WIDTH , GameSetting.SCREEN_HEIGHT);
			quad.setVertexColor(0,uint(_trackVO.bgColors[0]));
			quad.setVertexColor(1,uint(_trackVO.bgColors[0]));
			quad.setVertexColor(2,uint(_trackVO.bgColors[1]));
			quad.setVertexColor(3,uint(_trackVO.bgColors[1]));
			addChildAt(quad,0);
		}
		
		/**
		 * 创建物理空间
		 */		
		protected function createPhySpace():void
		{
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			_carBotVO = null ;
			_trackVO =null ;
			_playerCarVO = null ;
		}
	}
}