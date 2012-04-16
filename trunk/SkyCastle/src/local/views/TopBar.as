package  local.views
{
	import flash.display.Sprite;
	
	import local.model.PlayerModel;
	import local.model.vos.PlayerVO;
	import local.views.topbar.AddEnergyBar;
	import local.views.topbar.TopBarCoin;
	import local.views.topbar.TopBarEnergy;
	import local.views.topbar.TopBarExp;
	import local.views.topbar.TopBarGem;
	import local.views.topbar.TopBarRank;
	import local.views.topbar.TopBarStone;
	import local.views.topbar.TopBarUserName;
	import local.views.topbar.TopBarWood;
	
	public class TopBar extends Sprite
	{
		public var coinBar:TopBarCoin ;
		public var energyBar:TopBarEnergy;
		public var expBar:TopBarExp;
		public var stoneBar:TopBarStone;
		public var woodBar:TopBarWood;
		public var userBar:TopBarUserName;
		public var gemBar:TopBarGem;
		public var rankBar:TopBarRank;
		public var addEnergyBar:AddEnergyBar ;
		
		public function TopBar()
		{
			super();
		}
		
		
		public function updateCoin():void
		{
			coinBar.update( PlayerModel.instance.me.coin );
		}
		
		public function updateCash():void
		{
			gemBar.update( PlayerModel.instance.me.cash ) ;
		}
		
		public function updateEnergy():void
		{
			energyBar.update( [PlayerModel.instance.me.energy , PlayerModel.instance.me.maxEnergy ]  );
		}
		
		public function updateExp():void
		{
			expBar.update( [PlayerModel.instance.me.exp , PlayerModel.instance.me.maxExp , PlayerModel.instance.me.level ] );
		}
		
		public function updateWood():void
		{
			woodBar.update( PlayerModel.instance.me.wood );
		}
		
		public function updateStone():void
		{
			stoneBar.update( PlayerModel.instance.me.stone );
		}
		
		public function updateName():void
		{
			userBar.update( PlayerModel.instance.me.name ) ;
		}
		
		public function updateRank():void
		{
			rankBar.update( PlayerModel.instance.me.rank );
		}
		
		/**更新topbar信息*/
		public function updateTopBar():void
		{
			setUserInfo( PlayerModel.instance.me );
		}
		private function setUserInfo( user:PlayerVO ):void
		{
			coinBar.update( user.coin );
			energyBar.update( [user.energy , user.maxEnergy ]  );
			expBar.update( [user.exp , user.maxExp , user.level ] );
			stoneBar.update( user.stone );
			woodBar.update( user.wood );
			gemBar.update( user.cash ) ;
			userBar.update( user.name ) ;
			rankBar.update( user.rank );
		}
	}
}