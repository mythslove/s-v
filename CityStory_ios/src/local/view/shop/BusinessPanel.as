package local.view.shop
{
	import bing.utils.ContainerUtil;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import local.enum.BuildingType;
	import local.model.ShopModel;
	import local.view.btn.TabMenuButton;
	import local.view.control.ToggleBar;
	import local.view.control.ToggleBarEvent;

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
		
		
		
		public var mainTypeBar:ToggleBar;
		
		public function BusinessPanel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			mainTypeBar = new ToggleBar();
			var mcs:Vector.<MovieClip>= Vector.<MovieClip>([
				new TabMenuButton(TAB_ALL) ,new TabMenuButton(TAB_SHOPS),new TabMenuButton(TAB_RESTAURANTS) ,
				new TabMenuButton(TAB_SERVICES) , new TabMenuButton(TAB_OFFICES) 
			]);
			mainTypeBar.buttons = mcs ;
			addChild(mainTypeBar);
			mainTypeBar.x = 10 ;
			mainTypeBar.y= 50 ;
			mainTypeBar.addEventListener(ToggleBarEvent.TOGGLE_CHANGE , toggleChangeHandler);
			mainTypeBar.selected = mcs[0];
		}
		
		private function toggleChangeHandler( e:ToggleBarEvent ):void
		{
			ContainerUtil.removeChildren(_content);
			_scroll.removeScrollControll();
			_scroll.addScrollControll( _content , container , 3);
			
			var itemRenders:Vector.<ShopItemRenderer> = ShopModel.instance.businessRenderers ;
			if(!itemRenders) return ;
			var len:int =itemRenders.length  ;
			var render:ShopItemRenderer ;
			for( var i:int = 0 ; i <len ; ++i ) {
				render = itemRenders[i] ;
				if(e.selectedName==TAB_ALL){
					_scroll.addItem( render );
				}
				else if(e.selectedName==TAB_SHOPS){
					if( render.baseVO.subClass==BuildingType.BUSINESS_SHOPS){
						_scroll.addItem( render );
					}
				}
				else if(e.selectedName==TAB_RESTAURANTS){
					if( render.baseVO.subClass==BuildingType.BUSINESS_RESTAURANTS){
						_scroll.addItem( render );
					}
				}
				else if(e.selectedName==TAB_SERVICES){
					if( render.baseVO.subClass==BuildingType.BUSINESS_SERVICES){
						_scroll.addItem( render );
					}
				}
				else if(e.selectedName==TAB_OFFICES){
					if( render.baseVO.subClass==BuildingType.BUSINESS_OFFICES){
						_scroll.addItem( render );
					}
				}
			}
		}
		
		
		override protected function onItemHandler( e:MouseEvent ):void
		{
			super.onItemHandler(e);
			if(e.target is ShopItemRenderer)
			{
				var render:ShopItemRenderer = e.target as ShopItemRenderer ;
				if( checkMoney(render)){
					addItemToWorld( render );
				}
			}
		}
	}
}