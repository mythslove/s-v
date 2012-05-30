package local.views.friends
{
	import bing.utils.ContainerUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameData;
	import local.model.PlayerModel;
	import local.model.vos.FriendVO;
	import local.views.base.AutoImage;
	import local.views.tooltip.GameToolTip;
	
	public class FriendsItemRenderer extends MovieClip
	{
		public var txtName:TextField ;
		public var txtLv:TextField;
		public var container:Sprite;
		//=========================
		
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
			if(container) {
				ContainerUtil.removeChildren( container );
			}
			_friendVO = vo ;
			gotoAndStop(1);
			if( _friendVO)
			{
				gotoAndStop(2);
				GameToolTip.instance.register( this , stage , "Invite Friend" );
				if(_friendVO.image){
					var img:AutoImage = new AutoImage( _friendVO.image , true , true , 50,50);
					container.addChild(img);
				}
				txtName.text = _friendVO.name ;
				txtLv.text = _friendVO.level+""; 
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