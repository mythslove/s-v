package local.view.shop
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.enum.VillageMode;
	import local.map.GameWorld;
	import local.map.item.BaseBuilding;
	import local.model.PlayerModel;
	import local.util.BuildingFactory;
	import local.util.PopUpManager;
	import local.view.control.ScrollControllerH;
	import local.vo.BaseBuildingVO;
	import local.vo.PlayerVO;
	
	public class ShopPanel extends Sprite
	{
		public var container:Sprite ;
		protected var _scroll:ScrollControllerH = new ScrollControllerH() ;
		protected var _content:Sprite = new Sprite() ;
		
		public function ShopPanel()
		{
			super();
			container = new Sprite();
			container.x = 5 ;
			container.y = 130 ;
			container.graphics.beginFill(0,0);
			container.graphics.drawRect(0,0,825,370);
			container.graphics.endFill();
			addChild(container);
			
			_content.addEventListener(MouseEvent.CLICK , onItemHandler );
		}
		
		protected function onItemHandler( e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		/**
		 * 将item转换成建筑，放到场景上 
		 * @param item
		 */		
		public function addItemToWorld( render:ShopItemRenderer ):void
		{
			var building:BaseBuilding = BuildingFactory.createBuildingByBaseVO( render.baseVO );
			
			GameWorld.instance.addBuildingToTopScene( building);
			GameData.villageMode=VillageMode.BUILDING_SHOP ;
			PopUpManager.instance.removeCurrentPopup();
		}
		
		/**
		 * 判断钱是否够，如果不够并且提示 
		 * @param render
		 * @return 够返回true 
		 */		
		public function checkMoney(  render:ShopItemRenderer ):Boolean
		{
			var baseVO:BaseBuildingVO = render.baseVO ;
			var me:PlayerVO = PlayerModel.instance.me ;
		
			if( me.cash>= baseVO.priceCash && me.coin>= baseVO.priceCoin){
				return true ;
			}else{
				if( me.cash < baseVO.priceCash ){
					trace("cash 不够");
				}else{
					trace("coin 不够");
				}
			}
			return false ;
		}
	}
}