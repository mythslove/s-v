package local.views.friends
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.model.PlayerModel;
	import local.model.vos.FriendVO;
	
	public class FriendsItemRenderer extends MovieClip
	{
		private var _friendVO:FriendVO ;
		
		public function FriendsItemRenderer()
		{
			super();
			buttonMode = true ;
			mouseChildren = false ;
			stop();
		}
		
		public function show( vo:FriendVO ):void
		{
			_friendVO = vo ;
			gotoAndStop(1);
			if( _friendVO)
			{
				gotoAndStop(2);
			}
			addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		private function onClickHandler( e:MouseEvent ):void
		{
			e.stopPropagation();
			if(currentFrame==1)
			{
				//添加好友
			}
			else
			{
				//拜访好友
				PlayerModel.instance.getPlayer( _friendVO.friendId , GameData.currentMapId );
			}
		}
	}
}