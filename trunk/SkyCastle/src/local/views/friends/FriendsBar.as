package local.views.friends
{
	import bing.components.button.BaseButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import local.comm.GlobalDispatcher;
	import local.events.FriendEvent;
	import local.model.FriendModel;
	import local.model.vos.FriendVO;
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
		
		override protected function added():void
		{
			btnPrevPage.enabled = btnNextPage.enabled = btnLastPage.enabled = btnFirstPage.enabled = false ;
			FriendModel.instance.getFriends( 0 , 6 ) ;
			GlobalDispatcher.instance.addEventListener( FriendEvent.GET_FRIENDS , onGetFriendsHandler );
			btnPrevPage.addEventListener(MouseEvent.CLICK , onClickHandler );
			btnNextPage.addEventListener(MouseEvent.CLICK , onClickHandler );
			btnLastPage.addEventListener(MouseEvent.CLICK , onClickHandler );
			btnFirstPage.addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		private function onGetFriendsHandler ( e:FriendEvent ):void
		{
			var friends:Vector.<FriendVO> = e.friends ;
			for( var i:int = 0 ; i<6 ; ++i)
			{
				if(friends && friends.length<=i+1)
				{
					(this["f"+i] as FriendsItemRenderer).show( friends[i] );		
				}
				else
				{
					(this["f"+i] as FriendsItemRenderer).show( null );	
				}
			}
			if(friends){
				btnPrevPage.enabled = btnNextPage.enabled = btnLastPage.enabled = btnFirstPage.enabled = true ;
				if( FriendModel.instance.friends)
				{
					if(!FriendModel.instance.friends.hasPrevPage()){
						btnPrevPage.enabled  = btnFirstPage.enabled = false ;
					}
					if(!FriendModel.instance.friends.hasNextPage()){
						btnNextPage.enabled  = btnLastPage.enabled = false ;
					}
				}
			}else{
				btnPrevPage.enabled = btnNextPage.enabled = btnLastPage.enabled = btnFirstPage.enabled = false ;
			}
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if( !FriendModel.instance.friends ) return ;
			
			btnPrevPage.enabled = btnNextPage.enabled = btnLastPage.enabled = btnFirstPage.enabled = false ;
			switch( e.target)
			{
				case btnFirstPage:
					FriendModel.instance.getFriends( 0 , 6 ) ;
					break ;
				case btnLastPage:
					FriendModel.instance.getFriends( FriendModel.instance.friends.totalPages-1 , 6 ) ;
					break ;
				case btnPrevPage:
					FriendModel.instance.getFriends( FriendModel.instance.friends.currentPage-- , 6 ) ;
					break ;
				case btnNextPage:
					FriendModel.instance.getFriends( FriendModel.instance.friends.currentPage++ , 6 ) ;
					break ;
			}
		}
	}
}