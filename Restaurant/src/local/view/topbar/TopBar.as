package local.view.topbar
{
	import local.model.PlayerModel;
	import local.view.base.BaseView;
	import local.vo.PlayerVO;
	
	import starling.events.Event;
	
	public class TopBar extends BaseView
	{
		public var cashBar:CashBar ;
		public var coinBar:CoinBar;
		public var lvBar:LevelBar;
		public var dingBar:DingBar ;
		//============================
		
		public function TopBar()
		{
			super();
			init();
		}
		
		private function init():void
		{
			lvBar = new LevelBar();
			lvBar.x = 30 ;
			addChild( lvBar );
			
			
			cashBar = new CashBar();
			cashBar.x = lvBar.x + 250;
			addChild( cashBar );
			
			coinBar = new CoinBar();
			coinBar.x = cashBar.x +250 ;
			addChild( coinBar );
			
			dingBar = new DingBar();
			dingBar.x = coinBar.x +250 ;
			addChild( dingBar );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			var me:PlayerVO = PlayerModel.instance.me ;
			cashBar.show( me.cash );
			coinBar.show( me.coin );
			
//			addEventListener(MouseEvent.CLICK , onClickHandler );
		}
	}
}