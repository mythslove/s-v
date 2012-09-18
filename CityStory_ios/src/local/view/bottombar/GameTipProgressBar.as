package local.view.bottombar
{
	import bing.utils.DateUtil;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import local.util.GameTimer;
	import local.util.GameUtil;
	
	public class GameTipProgressBar extends Sprite
	{
		public var txtTime:TextField ;
		public var progress:Sprite;
		
		
		public function GameTipProgressBar()
		{
			super();
			mouseChildren = mouseEnabled = false ;
		}
		
		public function showProgress( gameTimer:GameTimer , totalTime:Number ):void
		{
			GameUtil.boldTextField( txtTime , DateUtil.formatTimeToString( gameTimer.duration ) );
			progress.x = - progress.width*gameTimer.duration/totalTime ;
		}
	}
}