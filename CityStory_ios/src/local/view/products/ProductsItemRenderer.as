package local.view.products
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import local.model.PlayerModel;
	import local.util.GameUtil;
	import local.util.PopUpManager;
	import local.view.base.BaseView;
	import local.view.btn.DefaultButton1;
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
		public var btnStart:DefaultButton1 ;
		
		//===============================
		public var proVO:ProductVO ;
		
		public function ProductsItemRenderer()
		{
			super();
			mouseEnabled = false ;
			btnStart.label="Start";
			
			txtEarnGoods.mouseEnabled = false ;
			txtTitle.mouseEnabled = false ;
			price.mouseChildren = price.mouseEnabled = false ;
			txtCollect.mouseEnabled = false ;
			txtTime.mouseEnabled = false ;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			GameUtil.boldTextField( txtEarnGoods ,  "+" + proVO.earnGoods ) ;
			price.gotoAndStop("coin");
			GameUtil.boldTextField( price.txtPrice ,  GameUtil.moneyFormat( proVO.coinCost ) );
			txtCollect.text = "Collect:";
			GameUtil.boldTextField( txtTime ,  GameUtil.getTimeString( proVO.time )  ) ;
			
			//标题
			GameUtil.boldTextField( txtTitle , proVO.title );
			while(txtTitle.textWidth>txtTitle.width){
				var tf:TextFormat =txtTitle.defaultTextFormat ;
				tf.size = int(tf.size)-2 ;
				txtTitle.defaultTextFormat = tf ;
				this.txtTitle.text = proVO.title ;
			}
			txtTitle.y = ( 40 - txtTitle.textHeight)>>1 ;
			
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