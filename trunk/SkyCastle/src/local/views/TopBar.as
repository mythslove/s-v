package  local.views
{
	import local.comm.GlobalDispatcher;
	import local.events.UserInfoEvent;
	import local.model.village.VillageModel;
	import local.model.village.vos.PlayerVO;
	import local.views.topbar.TopBarCoin;
	import local.views.topbar.TopBarEnergy;
	import local.views.topbar.TopBarExp;
	import local.views.topbar.TopBarGem;
	import local.views.topbar.TopBarStone;
	import local.views.topbar.TopBarUserName;
	import local.views.topbar.TopBarWood;
	
	public class TopBar extends BaseView
	{
		public var coinBar:TopBarCoin ;
		public var energyBar:TopBarEnergy;
		public var expBar:TopBarExp;
		public var stoneBar:TopBarStone;
		public var woodBar:TopBarWood;
		public var userBar:TopBarUserName;
		public var gemBar:TopBarGem;
		//===========================
		
		public function TopBar()
		{
			super();
		}
		
		override protected function added():void
		{
			GlobalDispatcher.instance.addEventListener( UserInfoEvent.USER_INFO_UPDATED , userInfoUpdateHandler );
		}
		
		private function userInfoUpdateHandler( e:UserInfoEvent ):void
		{
			var user:PlayerVO ;
			if(VillageModel.instance.isHome) {
				user = VillageModel.instance.me; 
			}else{
				user = VillageModel.instance.friend;
			}
			setUserInfo(user);
		}
		
		public function setUserInfo( user:PlayerVO ):void
		{
			
		}
	}
}