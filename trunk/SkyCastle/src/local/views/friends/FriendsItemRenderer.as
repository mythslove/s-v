package local.views.friends
{
	import flash.display.MovieClip;
	
	import local.model.vos.FriendVO;
	
	public class FriendsItemRenderer extends MovieClip
	{
		private var _friendVO:FriendVO ;
		
		public function FriendsItemRenderer()
		{
			super();
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
		}
	}
}