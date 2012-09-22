package local.view.topbar
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.map.item.BaseBuilding;
	import local.model.PlayerModel;
	import local.util.EmbedsManager;
	import local.view.base.BaseView;
	import local.vo.PlayerVO;
	
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
			mouseEnabled = false ;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			var me:PlayerVO = PlayerModel.instance.me ;
			cashBar.show( me.cash );
			coinBar.show( me.coin );
			goodsBar.show( me.goods );
			energyBar.show( me.energy , me.maxEnergy );
		}
		
		/**
		 * 给建筑加商品 
		 * @param buiding
		 */		
		public function costGoodsToBuilding( building:BaseBuilding):void
		{
			GameData.commPoint.setTo(0,0);
			var globalPoint:Point = building.localToGlobal( GameData.commPoint );
			var temp:Number = Point.distance( globalPoint , new Point(goodsBar.x , goodsBar.y));
			temp = temp>400 ? 0.5 : 0.25 ;
			flyGoods( globalPoint , temp );
			setTimeout( flyGoods , 150 , globalPoint , temp );
			setTimeout( flyGoods , 300 , globalPoint , temp );
		}
		
		private function flyGoods( targetPoint:Point , time:Number ):void
		{
			var bmp:Bitmap = new Bitmap ( EmbedsManager.instance.getBitmapByName("PickupGoods",true).bitmapData  );
			bmp.x = goodsBar.x ;
			bmp.y = goodsBar.y ;
			addChild(bmp);
			TweenLite.to( bmp , time , { x:targetPoint.x , y:targetPoint.y , scaleX:0.5 , scaleY:0.5 , alpha:0.2 , 
				onComplete:flyGoodsOver , onCompleteParams:[bmp] });
		}
		
		private function flyGoodsOver( bmp:Bitmap ):void
		{
			this.removeChild(bmp);
		}
	}
}