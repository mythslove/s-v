package local.view.topbar
{
	import local.map.item.BaseBuilding;
	import local.view.base.BaseView;
	
	public class TopBar extends BaseView
	{
		public var cashBar:CashBar ;
		public var coinBar:CoinBar;
		public var energyBar:EnergyBar;
		public var goodsBar:GoodsBar;
		public var lvBar:LevelBar;
		//============================
		
		public function TopBar()
		{
			super();
		}
		
		/**
		 * 给建筑加商品 
		 * @param buiding
		 */		
		public function addGoodsToBuilding( buiding:BaseBuilding):void
		{
			
		}
	}
}