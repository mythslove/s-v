package local.view.topbar
{
	import com.greensock.TweenLite;
	
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
		
		override public function set visible(value:Boolean):void
		{
			if( value){
				super.visible = value ;
				alpha = 1 ;
			}else{
				TweenLite.to( this , 0.2 , {alpha:0 , onComplete: onTweenCom} );
			}
		}
		
		private function onTweenCom():void{
			super.visible = false ;
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