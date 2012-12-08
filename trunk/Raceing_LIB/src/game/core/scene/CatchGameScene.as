package game.core.scene
{
	import flash.utils.setTimeout;
	
	import game.vos.PlayerCarVO;
	import game.vos.TrackVO;
	
	import nape.geom.Vec2;
	
	import starling.events.Event;
	
	/**
	 * 追赶模式 
	 * @author zzhanglin
	 */	
	public class CatchGameScene extends ContestGameScene
	{
		private var _botFlag:Boolean ;
		
		public function CatchGameScene(trackVO:TrackVO, playerCarVO:PlayerCarVO, competitorIndex:int=0)
		{
			super(trackVO, playerCarVO, competitorIndex);
			_botX = 300 ;
			_carX = 400 ;
		}
		
		override protected function moveRobot():void
		{
			if(_botFlag){
				super.moveRobot();
			}
		}
		
		override protected function startGame():void
		{
			super.startGame();
			setTimeout( moveBot , 3000 );
		}
		
		private function moveBot():void
		{
			_botFlag = true ;
		}
		
		override  protected function updateHandler(e:Event):void
		{
			super.updateHandler(e);
			if(_carBot.carBody.position.x>_car.carBody.position.x){
				gameOver();
			}
		}
	}
}