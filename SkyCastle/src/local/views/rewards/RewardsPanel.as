package local.views.rewards
{
	import flash.display.Sprite;
	
	import local.enum.BasicPickup;
	import local.model.PickupModel;
	import local.model.PlayerModel;
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.buildings.vos.BaseBuildingVO;
	import local.model.buildings.vos.BuildingVO;
	import local.model.vos.PickupVO;
	import local.model.vos.PlayerVO;
	import local.model.vos.RewardsVO;
	import local.views.BaseView;
	import local.views.base.Image;

	/**
	 * 显示奖励列表 
	 * @author zhouzhanglin
	 */	
	public class RewardsPanel extends BaseView
	{
		public var rewardsVO:RewardsVO;
		private var _wid:int ;
		private var _isCenter:Boolean ;
		private var _container:Sprite ;
		
		public function RewardsPanel( vo:RewardsVO=null , wid:int = 400 , isCenter:Boolean = true )
		{
			super();
			mouseChildren = false ;
			this.rewardsVO = vo ;
			this._wid = wid ;
			this._isCenter = isCenter ;
			
			_container = new Sprite();
			addChild(_container);
		}
		
		override protected function added():void
		{
			if(!this.rewardsVO) return ;
			var me:PlayerVO = PlayerModel.instance.me;
			var img:Image ;
			var count:int ;
			var iconWidth:int = 100 ;
			if(rewardsVO.cash>0)
			{
				me.cash+=rewardsVO.cash ;
				img = new RewardsPanelRender("pickupGem","res/pickup/pickupGem.png",rewardsVO.cash+" Gem");
				img.x = iconWidth*count;
				++count ;
				_container.addChild(img);
			}
			if(rewardsVO.coin>0)
			{
				me.coin+=rewardsVO.coin ;
				img = new RewardsPanelRender("pickupCoin"+BasicPickup.COIN,"res/pickup/pickupCoin"+BasicPickup.COIN+".png",rewardsVO.coin+" Coin");
				img.x = iconWidth*count;
				++count ;
				_container.addChild(img);
			}
			if(rewardsVO.wood>0)
			{
				me.wood+=rewardsVO.wood ;
				img = new RewardsPanelRender("pickupWood"+BasicPickup.WOOD,"res/pickup/pickupWood"+BasicPickup.WOOD+".png",rewardsVO.wood+" Wood");
				img.x = iconWidth*count;
				++count ;
				_container.addChild(img);
			}
			if(rewardsVO.stone>0)
			{
				me.stone+=rewardsVO.stone ;
				img = new RewardsPanelRender("pickupStone"+BasicPickup.STONE,"res/pickup/pickupStone"+BasicPickup.STONE+".png",rewardsVO.stone+" Stone");
				img.x = iconWidth*count;
				++count ;
				_container.addChild(img);
			}
			if(rewardsVO.exp>0)
			{
				me.exp+=rewardsVO.exp ;
				img = new RewardsPanelRender("pickupExp"+BasicPickup.EXP,"res/pickup/pickupExp"+BasicPickup.EXP+".png",rewardsVO.exp+" Exp");
				img.x = iconWidth*count;
				++count ;
				_container.addChild(img);
			}
			if(rewardsVO.energy>0)
			{
				me.exp+=rewardsVO.energy ;
				img = new RewardsPanelRender("pickupEnergy"+BasicPickup.ENERGY,"res/pickup/pickupEnergy"+BasicPickup.ENERGY+".png",rewardsVO.energy+" Energy");
				img.x = iconWidth*count;
				++count ;
				_container.addChild(img);
			}
			if(rewardsVO.buildings)
			{
				var baseVO:BaseBuildingVO ;
				for( var i:int = 0 ; i<rewardsVO.buildings.length ; ++i)
				{
					baseVO = BaseBuildingVOModel.instance.getBaseVOById( rewardsVO.buildings[i] ) ;
					img = new RewardsPanelRender(baseVO.thumbAlias,baseVO.thumb,baseVO.name);
					img.x = iconWidth*count;
					++count ;
					_container.addChild(img);
				}
			}
			if(rewardsVO.pickups)
			{
				var pickVO:PickupVO ;
				for(i= 0 ; i<rewardsVO.pickups.length ; ++i)
				{
					pickVO = PickupModel.instance.getPickupById( rewardsVO.pickups[i] );
					img = new RewardsPanelRender(pickVO.thumbAlias ,pickVO.url , pickVO.name);
					img.x = iconWidth*count;
					++count ;
					_container.addChild(img);
				}
			}
			if(_isCenter && _wid>0){
				_container.x = (_wid- iconWidth*(count-1) )>>1 ;
			}
		}
		
		override protected function removed():void
		{
			rewardsVO = null ;
		}
	}
}