package local.views.shop
{
	import bing.components.button.BaseButton;
	import bing.components.button.ToggleBar;
	import bing.components.events.ToggleItemEvent;
	import bing.utils.ContainerUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.comm.GameSetting;
	import local.comm.GlobalDispatcher;
	import local.enum.BuildingOperation;
	import local.events.ShopEvent;
	import local.game.GameWorld;
	import local.game.elements.Building;
	import local.model.shop.ShopModel;
	import local.utils.BuildingFactory;
	import local.utils.PopUpManager;
	import local.views.BaseView;
	import local.views.shop.subtab.ShopSubBuildingTabBar;
	import local.views.shop.subtab.ShopSubDecorationTabBar;

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
		private var _subTabBar:ToggleBar ;
		private var _buildingPanel:ShopBuildingPanel; 
		
		public function ShopPopUp()
		{
			super();
			_buildingPanel = new ShopBuildingPanel() ;
		}
		
		override protected function added():void
		{
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
			TweenLite.from(this,0.5,{x:-width , ease:Back.easeOut });
			
			tabMenu.addEventListener(ToggleItemEvent.ITEM_SELECTED , tabMenuHandler , false , 0 , true ) ;
			btnClose.addEventListener( MouseEvent.CLICK , closeClickHandler , false , 0 , true );
			tabMenu.selectedName = tabMenu.btnBuilding.name;
			
			GlobalDispatcher.instance.addEventListener(ShopEvent.SELECTED_BUILDING , shopEventHandler );
		}
		
		private function shopEventHandler( e:ShopEvent ):void
		{
			switch( e.type )
			{
				case  ShopEvent.SELECTED_BUILDING:
					GameData.buildingCurrOperation = BuildingOperation.ADD ;
					var building:Building = BuildingFactory.createBuildingByVO(e.selectedBuilding);
					GameWorld.instance.addBuildingToTop( building );
					PopUpManager.instance.removeCurrentPopup();
					break ;
			}
		}
		
		private function tabMenuHandler( e:ToggleItemEvent):void 
		{
			//先清除
			if(_subTabBar){
				_subTabBar.removeEventListener(ToggleItemEvent.ITEM_SELECTED , subTabMenuHandler );
			}
			ContainerUtil.removeChildren( container );
			switch(  e.selectedName )
			{
				case tabMenu.btnBuilding.name:
					container.addChild(_buildingPanel) ;
					_subTabBar = new ShopSubBuildingTabBar();
					_subTabBar.x = 20 ;
					_subTabBar.addEventListener(ToggleItemEvent.ITEM_SELECTED , subTabMenuHandler , false , 0, true );
					container.addChild( _subTabBar);
					_subTabBar.selectedName = ShopSubBuildingTabBar.BTN_ALL;
					break ;
				case tabMenu.btnDecoration.name:
					container.addChild(_buildingPanel) ;
					_subTabBar = new ShopSubDecorationTabBar();
					_subTabBar.x = 20 ;
					_subTabBar.addEventListener(ToggleItemEvent.ITEM_SELECTED , subTabMenuHandler , false , 0, true );
					container.addChild( _subTabBar);
					_subTabBar.selectedName = ShopSubDecorationTabBar.BTN_ALL;
					break ;
			}
			
		}
		
		private function subTabMenuHandler( e:ToggleItemEvent ):void
		{
			if(tabMenu.selectedName==tabMenu.btnBuilding.name)
			{
				switch( e.selectedName )
				{
					case ShopSubBuildingTabBar.BTN_ALL:
						_buildingPanel.dataProvider = ShopModel.instance.buildingArray ;
						break ;
					case ShopSubBuildingTabBar.BTN_HOUSE:
						_buildingPanel.dataProvider = ShopModel.instance.houseArray ;
						break ;
					case ShopSubBuildingTabBar.BTN_FACTOR:
						_buildingPanel.dataProvider = null ;
						break ;
				}
			}
			else if( tabMenu.selectedName==tabMenu.btnDecoration.name)
			{
				switch( e.selectedName)
				{
					case ShopSubDecorationTabBar.BTN_ALL:
						_buildingPanel.dataProvider = ShopModel.instance.decorationArray ;
						break ;
					case ShopSubDecorationTabBar.BTN_GROUND:
						_buildingPanel.dataProvider = ShopModel.instance.roadArray ;
						break ;
				}
			}
		}
		
		private function closeClickHandler( e:MouseEvent ):void
		{
			mouseChildren = false ;
			TweenLite.to(this,0.5,{x:GameSetting.SCREEN_WIDTH+width , ease:Back.easeIn , onComplete:tweenComplete});
		}
		
		private function tweenComplete():void {
			PopUpManager.instance.removeCurrentPopup(); 
		}
		
		override protected function removed():void
		{
			GlobalDispatcher.instance.removeEventListener(ShopEvent.SELECTED_BUILDING , shopEventHandler );
			btnClose.removeEventListener( MouseEvent.CLICK , closeClickHandler);
			if(_subTabBar){
				_subTabBar.removeEventListener(ToggleItemEvent.ITEM_SELECTED , subTabMenuHandler );
			}
			_buildingPanel = null ;
		}
	}
}