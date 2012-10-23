package local.view.products
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.model.PlayerModel;
	import local.util.GameUtil;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.YellowButton;
	import local.view.shop.ShopItemPrice;
	import local.vo.PlayerVO;
	import local.vo.ProductVO;
	
	public class ProductsItemRenderer extends BaseView
	{
		public var txtEarnGoods:TextField ;
		public var txtTitle:TextField ;
		public var price:ShopItemPrice
		public var txtCollect:TextField ;
		public var txtTime:TextField ;
		public var btnStart:YellowButton ;
		public var iconContainer:Sprite;
		//===============================
		public var proVO:ProductVO ;
		
		public function ProductsItemRenderer()
		{
			super();
			mouseEnabled = false ;
			btnStart.label=GameUtil.localizationString("start").toUpperCase();
			
			txtEarnGoods.mouseEnabled = false ;
			txtTitle.mouseEnabled = false ;
			price.mouseChildren = price.mouseEnabled = false ;
			txtCollect.mouseEnabled = false ;
			txtTime.mouseEnabled = false ;
			iconContainer.mouseChildren = iconContainer.mouseEnabled = false ;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			GameUtil.boldTextField( txtEarnGoods ,  "+" + proVO.earnGoods ) ;
			price.gotoAndStop("coin");
			GameUtil.boldTextField( price.txtPrice ,  GameUtil.moneyFormat( proVO.coinCost ) );
			txtCollect.text = GameUtil.localizationString("collect")+":";
			GameUtil.boldTextField( txtTime ,  GameUtil.getTimeString( proVO.time )  ) ;
			
			//标题
			GameUtil.boldTextField( txtTitle , proVO.title );
			
			//玩家等级限制，是否lock
			if(PlayerModel.instance.me.level<proVO.requireLv)
			{
				mouseEnabled = false ;
				var lock:ProductsItemLock = new ProductsItemLock();
				GameUtil.boldTextField( lock.txtInfo , "Level  "+proVO.requireLv );
				addChild(lock);
				price.visible = btnStart.visible = txtCollect.visible =  txtTime.visible = false ;
			}
			
			btnStart.addEventListener(MouseEvent.CLICK , onStartHandler , false , 0 , true );
		}
		
		private function onStartHandler( e:MouseEvent ):void
		{
			e.stopPropagation() ;
			//判断钱是否够
			var me:PlayerVO = PlayerModel.instance.me ;
			if(me.coin>= proVO.coinCost )
			{
				ProductsPopUp.instance.industry.addProduct( proVO );
				PopUpManager.instance.removeCurrentPopup() ;
			}
			else
			{
				trace("coin 不够");
			}
		}
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler( e);
			proVO = null ;
			btnStart.removeEventListener(MouseEvent.CLICK , onStartHandler );
		}
	}
}