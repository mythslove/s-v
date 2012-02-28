package local.views.shop
{
	import bing.components.button.BaseButton;
	import bing.components.events.ToggleItemEvent;
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import local.comm.GameSetting;
	import local.utils.PopUpManager;
	import local.views.BaseView;
	import local.views.shop.panels.ShopBuildingPanel;

	/**
	 * 商店弹窗 
	 * @author zzhanglin
	 */	
	public class ShopPopUp extends BaseView
	{
		public var tabMenu:ShopMainTab;
		public var container:Sprite ;
		public var btnClose:BaseButton;
		//==============================
		private var _selectedName:String ;
		
		public function ShopPopUp()
		{
			super();
		}
		
		override protected function added():void
		{
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
			TweenLite.from(this,0.5,{x:-width , ease:Back.easeOut });
			
			tabMenu.addEventListener(ToggleItemEvent.ITEM_SELECTED , tabMenuHandler , false , 0 , true ) ;
			btnClose.addEventListener( MouseEvent.CLICK , closeClickHandler , false , 0 , true );
			tabMenu.selectedName = tabMenu.btnBuilding.name;
		}
		
		private function tabMenuHandler( e:ToggleItemEvent):void {
			selectedName = tabMenu.selectedName ;
		}
		
		public function set selectedName( value :String ):void
		{
			_selectedName = value ;
			ContainerUtil.removeChildren( container );
			switch( value )
			{
				case tabMenu.btnBuilding.name:
					container.addChild( new ShopBuildingPanel());
					break ;
			}
		}
		
		
		private function closeClickHandler( e:MouseEvent ):void
		{
			mouseChildren = false ;
			TweenLite.to(this,0.5,{x:GameSetting.SCREEN_WIDTH+width , ease:Back.easeIn , onComplete:tweenComplete});
		}
		
		private function tweenComplete():void
		{
			PopUpManager.instance.removeCurrentPopup(); 
		}
		
		override protected function removed():void
		{
			btnClose.removeEventListener( MouseEvent.CLICK , closeClickHandler);
		}
	}
}