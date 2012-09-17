package local.view.shop
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import local.enum.BuildingType;
	import local.util.GameUtil;
	import local.view.base.BuildingThumb;
	import local.view.base.MovieClipView;
	import local.vo.BaseBuildingVO;
	
	public class ShopItemRenderer extends MovieClipView
	{
		public var price:ShopItemPrice ;
		public var txtTitle:TextField ;
		public var imgContainer:Sprite;
		public var txtPopGoods:TextField ; //显示人口和商品数据
		public var txtCoin:TextField ;
		//===========================
		public var baseVO:BaseBuildingVO ;
		private var _inited:Boolean ;
		
		public function ShopItemRenderer( baseVO:BaseBuildingVO=null )
		{
			super();
			mouseChildren = false ;
			this.baseVO = baseVO ;
		}
		
		private function init():void
		{
			switch( baseVO.type)
			{
				case BuildingType.HOME:
					gotoAndStop("homes");
					GameUtil.boldTextField( txtPopGoods ,  "Pop: +" + baseVO.addPop ) ;
					GameUtil.boldTextField( txtCoin ,  "+"+ GameUtil.moneyFormat(baseVO.earnCoin)+" / "+ GameUtil.getTimeString( baseVO.time ) ) ;
					break ;
				case BuildingType.DECORATION:
					gotoAndStop("decors");
					break ;
				case BuildingType.INDUSTRY:
					gotoAndStop("industry");
					GameUtil.boldTextField( txtPopGoods ,  "+" + baseVO.products.length +" Contracts" ) ;
					break ;
				case BuildingType.COMMUNITY:
					gotoAndStop("community");
					break ;
				case BuildingType.WONDERS:
					gotoAndStop("wonders");
					break ;
				case BuildingType.BUSINESS:
					gotoAndStop("business");
					GameUtil.boldTextField( txtPopGoods ,  "-" + baseVO.goodsCost ) ;
					GameUtil.boldTextField( txtCoin ,  "+"+ GameUtil.moneyFormat(baseVO.earnCoin)+" / "+ GameUtil.getTimeString( baseVO.time ) ) ;
					break ;
			}
			//图片
			var img:BuildingThumb = new BuildingThumb( baseVO.name , 200 , 150 );
			imgContainer.addChild( img );
			if(baseVO.span==1) img.setScale(1.5) ; 
			img.center();
			//标题
			GameUtil.boldTextField( txtTitle , baseVO.title );
			while(txtTitle.textWidth>txtTitle.width){
				var tf:TextFormat =txtTitle.defaultTextFormat ;
				tf.size = int(tf.size)-2 ;
				txtTitle.defaultTextFormat = tf ;
				this.txtTitle.text = baseVO.title ;
			}
			txtTitle.y = ( 40 - txtTitle.textHeight)>>1 ;
			//价格
			if(baseVO.priceCoin>0){
				price.gotoAndStop("coin");
				GameUtil.boldTextField( price.txtPrice ,  GameUtil.moneyFormat( baseVO.priceCoin ) );
			}else{
				price.gotoAndStop("cash");
				GameUtil.boldTextField( price.txtPrice ,  GameUtil.moneyFormat( baseVO.priceCash ) );
			}
			price.txtPrice.width = price.txtPrice.textWidth+10;
			price.x=(width-price.width)>>1 ;
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			if(!_inited){
				init();
				_inited = true ;
			}
		}
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}
	}
}