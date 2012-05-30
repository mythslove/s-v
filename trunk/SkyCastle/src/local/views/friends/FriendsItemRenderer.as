package local.views.friends
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import local.comm.GameData;
	import local.model.PlayerModel;
	import local.model.vos.FriendVO;
	import local.views.tooltip.GameToolTip;
	
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
				GameToolTip.instance.register( this , stage , "Invite Friend" );
			}
			else
			{
				GameToolTip.instance.register( this , stage , "Click to add friends!" );
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