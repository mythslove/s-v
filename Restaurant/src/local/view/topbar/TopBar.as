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
		//============================
		
		public function TopBar()
		{
			super();
			init();
		}
		
		private function init():void
		{
			cashBar = new CashBar();
			addChild( cashBar );
			
			coinBar = new CoinBar();
			addChild( coinBar );
			
			lvBar = new LevelBar();
			addChild( lvBar );
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