package local.views.friends
{
	import bing.components.button.BaseButton;
	
	import local.views.base.BaseView;

	/**
	 * 好友列表 
	 * @author zzhanglin
	 */	
	public class FriendsBar extends BaseView
	{
		public var btnPrevPage:BaseButton,btnNextPage:BaseButton,btnLastPage:BaseButton,btnFirstPage:BaseButton;
		public var f0:FriendsItemRenderer ,f1:FriendsItemRenderer ,f2:FriendsItemRenderer ;
		public var f3:FriendsItemRenderer,f4:FriendsItemRenderer , f5:FriendsItemRenderer ;
		//========================================================
		
		public function FriendsBar()
		{
			super();
		}
	}
}