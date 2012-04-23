package local.views.shop
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import local.enum.ItemType;
	import local.enum.PayType;
	import local.model.buildings.vos.BaseDecorationVO;
	import local.model.buildings.vos.BaseFactoryVO;
	import local.model.buildings.vos.BaseHouseVO;
	import local.model.buildings.vos.BaseRoadVO;
	import local.model.vos.ShopItemVO;
	
	public class ShopItemPayMode extends MovieClip
	{
		public var txtCoin:TextField , txtWood:TextField ,txtStone:TextField  ,txtGem:TextField;
		//===========================
		public static const LABEL_COIN:String = "coin";
		public static const LABEL_COIN_WOOD_STONE:String = "coin_wood_stone";
		public static const LABEL_GEM:String = "gem";
		
		public function ShopItemPayMode()
		{
			super();
			stop();
			mouseChildren = mouseEnabled = false ;
		}
		
		public function showPay( shopItemVO:ShopItemVO ):void
		{
			var payType:int = shopItemVO.payType;
			switch(payType) {
				case PayType.CASH:
					gotoAndStop(LABEL_GEM);
					break ;
				case PayType.COIN:
				case PayType.FREE:
					gotoAndStop(LABEL_COIN);
					break ;
			}
			
			var type:String = shopItemVO.baseVO.type ;
			switch( type )
			{
				case ItemType.BUILDING://建筑
					break ;
				case ItemType.BUILDING_HOUSE: //房子
					gotoAndStop(LABEL_COIN_WOOD_STONE);
					var baseHouseVO:BaseHouseVO = shopItemVO.baseVO as BaseHouseVO ;
					this["txtCoin"].text= shopItemVO.price+"";
					this["txtWood"].text= baseHouseVO.buildWood+"";
					this["txtStone"].text= baseHouseVO.buildStone+"";
					break ;
				case ItemType.BUILDING_FACTORY: //工厂
					gotoAndStop(LABEL_COIN_WOOD_STONE);
					var baseFactoryVO:BaseFactoryVO = shopItemVO.baseVO as BaseFactoryVO ;
					this["txtCoin"].text= shopItemVO.price+"";
					this["txtWood"].text= baseFactoryVO.buildWood+"";
					this["txtStone"].text= baseFactoryVO.buildStone+"";
					break ;
				case ItemType.DECORATION: //装饰
					var baseDecVO:BaseDecorationVO = shopItemVO.baseVO as BaseDecorationVO ;
					if(payType==PayType.CASH){
						this["txtGem"].text= shopItemVO.price+"";
					}else{
						this["txtCoin"].text= shopItemVO.price+"";
					}
					break ;
				case ItemType.DEC_TREE: //树
				case ItemType.DEC_STONE: //石头
				case ItemType.DEC_ROCK: //磐石
					break ;
				case ItemType.DEC_ROAD: //路
					var baseRoadVO:BaseRoadVO = shopItemVO.baseVO as BaseRoadVO;
					if(payType==PayType.CASH){
						this["txtGem"].text= shopItemVO.price+"";
					}else{
						this["txtCoin"].text= shopItemVO.price+"";
					}
					break ;
			}
		}
	}
}