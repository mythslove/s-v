package local.view.shop
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import local.enum.BuildingType;
	import local.view.base.MovieClipView;
	import local.vo.BaseBuildingVO;
	
	public class ShopItemRenderer extends MovieClipView
	{
		public var price:ShopItemPrice ;
		public var txtTitle:TextField ;
		public var imgContainer:Sprite;
		public var txtPop:TextField ;
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
					break ;
				case BuildingType.DECORATION:
					gotoAndStop("decors");
					break ;
				case BuildingType.INDUSTRY:
					gotoAndStop("industry");
					break ;
				case BuildingType.COMMUNITY:
					gotoAndStop("community");
					break ;
				case BuildingType.WONDERS:
					gotoAndStop("wonders");
					break ;
				case BuildingType.BUSINESS:
					gotoAndStop("business");
					break ;
			}
			
			var tf:TextFormat ;
			this.txtTitle.text = baseVO.title ;
			while(txtTitle.textWidth>txtTitle.width){
				tf =txtTitle.defaultTextFormat ;
				tf.size = int(tf.size)-2 ;
				this.txtTitle.text = baseVO.title ;
			}
			if(baseVO.priceCoin>0){
				price.gotoAndStop("coin");
				
			}else{
				price.gotoAndStop("cash");
				
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
		
		override protected function removedFromStageHandler(e:Event):void
		{
			super.removedFromStageHandler(e);
		}
	}
}