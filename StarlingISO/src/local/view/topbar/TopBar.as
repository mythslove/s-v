package local.view.topbar
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.model.FriendVillageModel;
	import local.model.PlayerModel;
	import local.util.EmbedManager;
	import local.view.base.BaseView;
	import local.vo.PlayerVO;
	
	import starling.display.Image;
	import starling.events.Event;
	
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
			init();
		}
		
		private function init():void
		{
			cashBar = new CashBar();
			addChild( cashBar );
			
			coinBar = new CoinBar();
			addChild( coinBar );
			
			energyBar = new EnergyBar();
			addChild( energyBar );
			
			goodsBar = new GoodsBar();
			addChild( goodsBar );
			
			lvBar = new LevelBar();
			addChild( lvBar );
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			var me:PlayerVO = PlayerModel.instance.me ;
			cashBar.show( me.cash );
			coinBar.show( me.coin );
			goodsBar.show( me.goods );
			energyBar.show( me.energy , me.maxEnergy );
			
//			addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			if(e.target is GoodsBar){
				FriendVillageModel.instance.loadFridendVillage("dd");
			}else if(e.target is EnergyBar){
				GameWorld.instance.goHome();
			}
		}
		
		/**
		 * 给建筑加商品 
		 * @param buiding
		 */		
		public function costGoodsToBuilding( building:BaseBuilding):void
		{
			GameData.commPoint.setTo(0,0);
			var globalPoint:Point = building.localToGlobal( GameData.commPoint );
			var temp:Number = Point.distance( globalPoint , new Point(goodsBar.x+x , goodsBar.y ));
			temp = temp>400*GameSetting.GAMESCALE ? 0.5 : 0.25 ;
			flyGoods( globalPoint , temp );
			setTimeout( flyGoods , 150 , globalPoint , temp );
			setTimeout( flyGoods , 300 , globalPoint , temp );
		}
		
		private function flyGoods( targetPoint:Point , time:Number ):void
		{
			var bmp:Image = EmbedManager.getUIImage("GoodsIcon");
			bmp.x = goodsBar.x+x  ;
			bmp.y = goodsBar.y ;
			addChild(bmp);
			TweenLite.to( bmp , time , { x:targetPoint.x/root.scaleX , y:targetPoint.y/root.scaleX , scaleX:0.5 , scaleY:0.5 , alpha:0.2 , 
				onComplete:flyGoodsOver , onCompleteParams:[bmp] });
		}
		
		private function flyGoodsOver( bmp:Image ):void
		{
			this.removeChild(bmp);
		}
	}
}