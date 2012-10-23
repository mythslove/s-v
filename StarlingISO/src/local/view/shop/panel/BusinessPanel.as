package local.view.shop.panel
{
	import feathers.controls.Button;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	
	import flash.text.TextFormat;
	
	import local.comm.GameSetting;
	import local.comm.StyleSetting;
	import local.model.ShopModel;
	import local.vo.BaseBuildingVO;
	
	import org.osmf.layout.LayoutMode;
	
	import starling.events.Event;
	
	public class BusinessPanel extends ShopPanel
	{
		private static var _instance:BusinessPanel;
		public static function get instance():BusinessPanel{
			if(!_instance) _instance = new BusinessPanel();
			return _instance ;
		}
		//=====================================
		public static const TAB_ALL:String = "ALL";
		public static const  TAB_SHOPS:String = "SHOPS";
		public static const  TAB_RESTAURANTS:String = "RESTAURANTS";
		public static const  TAB_SERVICES:String = "SERVICES";
		public static const  TAB_OFFICES:String = "OFFICES";
		
		
		private var _tabBar:TabBar;
		
		override protected function init():void
		{
			
			this._tabBar = new TabBar();
			_tabBar.direction = LayoutMode.HORIZONTAL;
			_tabBar.tabInitializer = tabInitializer ;
			_tabBar.gap = 8*GameSetting.GAMESCALE ;
			this._tabBar.onChange.add(tabBar_onChange);
			this.addChild(this._tabBar);
			this._tabBar.dataProvider = new ListCollection(
				[
					{ label: TAB_ALL }, { label: TAB_SHOPS }, { label: TAB_RESTAURANTS }, { label: TAB_SERVICES }, { label: TAB_OFFICES }
				]);
			_tabBar.width = _tabBar.maxWidth =_tabBar.dataProvider.data.length*170*GameSetting.GAMESCALE   ;
			
			super.init();
		}
		
		
		override protected function addedToStageHandler(e:Event):void
		{
			super.addedToStageHandler(e);
			
			this._tabBar.selectedIndex = 0 ;
			tabBar_onChange( _tabBar );
		}
		
		private function tabInitializer(tab:Button , item:Object ):void
		{
			tab.defaultSkin = StyleSetting.TAB_UP_SKIN() ;
			tab.downSkin =  StyleSetting.TAB_SELECTED_SKIN() ;
			tab.selectedUpSkin = tab.downSkin ;
			tab.label = item.label ;
			tab.defaultLabelProperties.textFormat = new TextFormat("Verdana",18*GameSetting.GAMESCALE ,0xffffff,true);
			tab.paddingLeft = tab.paddingRight = 4*GameSetting.GAMESCALE  ;
		}
		
		private function tabBar_onChange(tabBar:TabBar):void
		{
			if(tabBar.selectedItem){
				switch(tabBar.selectedItem.label)
				{
					case TAB_ALL:
						_list.dataProvider = new ListCollection( ShopModel.instance.baseBusiness );
						break ;
					default:
						var vos:Vector.<BaseBuildingVO> = new Vector.<BaseBuildingVO>();
						for each(var vo:BaseBuildingVO in ShopModel.instance.baseBusiness){
							if(vo.subClass.toUpperCase()==tabBar.selectedItem.label){
								vos.push( vo );
							}
						}
						_list.dataProvider = new ListCollection( vos );
						break ;
				}
			}
		}
	}
}