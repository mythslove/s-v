package game.mvc.view
{
	import bing.utils.SystemUtil;
	
	import flash.display.Sprite;
	import flash.system.Security;
	
	import game.mvc.base.GameContext;
	import game.mvc.view.components.WindowsPopUpBg;
	import game.utils.PopUpManager;
	
	[SWF(width="1000",height="600" ,frameRate="30" , backgroundColor="0x000000")]
	public class BingRpg extends Sprite
	{
		public var gameLayer:GameLayer ; //游戏层
		public var uiLayer:UILayer ; //UI层
		
		private var _mediator:BingRpgMediator ;
		private var _appContext:GameContext;
		
		public function BingRpg()
		{
			super();
//			Security.allowDomain("http://riablog.eu5.org");
//			Security.loadPolicyFile("http://riablog.eu5.org/crossdomain.xml");
			
			SystemUtil.showDebug = false ;
			_appContext = new GameContext( this) ;
			_mediator = new BingRpgMediator( this );
		}
		
		public function initLayer():void
		{
			gameLayer = new GameLayer();
			uiLayer = new UILayer();
			addChildAt(uiLayer,0);
			addChildAt(gameLayer,0);
		}
		
	}
}