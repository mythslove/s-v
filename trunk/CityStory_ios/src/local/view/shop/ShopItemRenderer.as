package local.view.shop
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import local.enum.BuildingType;
	import local.model.PlayerModel;
	import local.util.GameUtil;
	import local.view.base.BuildingThumb;
	import local.view.base.MovieClipView;
	import local.view.tutor.TutorView;
	import local.vo.BaseBuildingVO;
	import local.vo.TutorItemVO;
	
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
		
		private var _itemLock:ShopItemLock ;
		
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
					GameUtil.boldTextField( txtPopGoods ,  GameUtil.localizationString("pop") + ": +" + baseVO.addPop ) ;
					GameUtil.boldTextField( txtCoin ,  "+"+ GameUtil.moneyFormat(baseVO.earnCoin)+" / "+ GameUtil.getTimeString( baseVO.time ) ) ;
					break ;
				case BuildingType.DECORATION:
					gotoAndStop("decors");
					break ;
				case BuildingType.INDUSTRY:
					gotoAndStop("industry");
					GameUtil.boldTextField( txtPopGoods ,  "+" + baseVO.products.length +" "+GameUtil.localizationString("contracts") ) ;
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
			if(baseVO.span==1 && img.height*1.2<150 ) img.setScale(1.2) ; 
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
			
			//判断等级和人口
			var isLock:Boolean , lockText:String ;
			if( baseVO.requireLv>0 && baseVO.requireLv>PlayerModel.instance.me.level){
				isLock = true ;
				lockText="Level\n"+baseVO.requireLv ;
			}else if( baseVO.type==BuildingType.INDUSTRY){
				if(GameUtil.buildIndustryPop()>PlayerModel.instance.getCurrentPop()){
					isLock = true ;
					lockText="Population\n"+GameUtil.buildIndustryPop() ;
				}
			}else if( baseVO.requirePop> 0 && baseVO.requirePop<PlayerModel.instance.getCurrentPop()){
				isLock = true ;
				lockText="Population\n"+baseVO.requirePop ;
			}
			if(isLock){
				mouseEnabled = false ;
				if(!_itemLock) _itemLock = new ShopItemLock();
				_itemLock.x = _itemLock.y = 2 ;
				GameUtil.boldTextField( _itemLock.txtInfo , lockText );
				addChild(_itemLock);
			}else if(_itemLock){
				removeChild( _itemLock );
				_itemLock = null ;
				mouseEnabled = true ;
			}
		}
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			if(!_inited){
				init();
				_inited = true ;
			}
		}
		
		public function showTutor():void
		{
			var globalPoint:Point = localToGlobal( new Point());
			var item:TutorItemVO = new TutorItemVO();
			item.rectType = "roundRect" ;
			item.alpha = .6 ;
			item.rect = new Rectangle( globalPoint.x/root.scaleX,globalPoint.y/root.scaleX,width,height);
			item.showArrow = true ;
			item.arrowPoint = new Point(globalPoint.x/root.scaleX+width , globalPoint.y/root.scaleX+height*0.5);
			item.arrowAngle = 90 ;
			TutorView.instance.showTutor( item );
		}
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}
	}
}