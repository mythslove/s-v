package local.views.storage
{
	import bing.components.button.BaseButton;
	import bing.components.events.ToggleItemEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import local.comm.GameSetting;
	import local.utils.PopUpManager;
	import local.views.BaseView;
	import local.views.shop.ShopMainTab;
	
	public class StoragePopUp extends BaseView
	{
		public var tabMenu:ShopMainTab;
		public var btnClose:BaseButton;
		public var container:Sprite;
		public var btnPrevPage:BaseButton;
		public var btnNextPage:BaseButton;
		//==============================
		//缓存收藏箱查看的位置，以便下次进来还是显示上次的位置
		public static var storageCurrentTab:String ; 
		public static var storageCurrentPage:int = 0  ;
		//=========================
		
		public function StoragePopUp()
		{
			super();
			container.visible=false;
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
		}
		
		override protected function added():void
		{
			TweenLite.from(this,0.3,{x:x-200 , ease:Back.easeOut , onComplete:inTweenOver });
			
			tabMenu.addEventListener(ToggleItemEvent.ITEM_SELECTED , tabMenuHandler , false , 0 , true ) ;
			btnClose.addEventListener( MouseEvent.CLICK , closeClickHandler , false , 0 , true );
		}
		
		private function inTweenOver():void
		{
			container.visible=true;
		}
		
		/* 主分类菜单按钮单击*/
		private function tabMenuHandler( e:ToggleItemEvent):void 
		{
			
		}
		
		private function closeClickHandler( e:MouseEvent ):void
		{
			mouseChildren = false ;
			container.visible=false;
			TweenLite.to(this,0.3,{x:x+200 , ease:Back.easeIn , onComplete:tweenComplete});
		}
		
		private function tweenComplete():void {
			PopUpManager.instance.removeCurrentPopup(); 
		}
	}
}