package local.views.rewards
{
	import flash.display.Sprite;
	
	import local.enum.BasicPickup;
	import local.model.PickupModel;
	import local.model.PlayerModel;
	import local.model.StorageModel;
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.buildings.vos.BaseBuildingVO;
	import local.model.vos.PickupVO;
	import local.model.vos.PlayerVO;
	import local.model.vos.RewardsVO;
	import local.model.vos.StorageItemVO;
	import local.views.base.BaseView;
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
			var rewardsRender:RewardsPanelRender ;
			var count:int ;
			var iconWidth:int = 100 ;
			if(rewardsVO.cash>0)
			{
				me.cash+=rewardsVO.cash ;
				rewardsRender = new RewardsPanelRender("pickupGem","res/pickup/pickupGem.png",rewardsVO.cash+" Gem");
				rewardsRender.x = iconWidth*count;
				++count ;
				_container.addChild(rewardsRender);
			}
			if(rewardsVO.coin>0)
			{
				me.coin+=rewardsVO.coin ;
				rewardsRender = new RewardsPanelRender("pickupCoin"+BasicPickup.COIN,"res/pickup/pickupCoin"+BasicPickup.COIN+".png",rewardsVO.coin+" Coin");
				rewardsRender.x = iconWidth*count;
				++count ;
				_container.addChild(rewardsRender);
			}
			if(rewardsVO.wood>0)
			{
				me.wood+=rewardsVO.wood ;
				rewardsRender = new RewardsPanelRender("pickupWood"+BasicPickup.WOOD,"res/pickup/pickupWood"+BasicPickup.WOOD+".png",rewardsVO.wood+" Wood");
				rewardsRender.x = iconWidth*count;
				++count ;
				_container.addChild(rewardsRender);
			}
			if(rewardsVO.stone>0)
			{
				me.stone+=rewardsVO.stone ;
				rewardsRender = new RewardsPanelRender("pickupStone"+BasicPickup.STONE,"res/pickup/pickupStone"+BasicPickup.STONE+".png",rewardsVO.stone+" Stone");
				rewardsRender.x = iconWidth*count;
				++count ;
				_container.addChild(rewardsRender);
			}
			if(rewardsVO.exp>0)
			{
				me.exp+=rewardsVO.exp ;
				rewardsRender = new RewardsPanelRender("pickupExp"+BasicPickup.EXP,"res/pickup/pickupExp"+BasicPickup.EXP+".png",rewardsVO.exp+" Exp");
				rewardsRender.x = iconWidth*count;
				++count ;
				_container.addChild(rewardsRender);
			}
			if(rewardsVO.energy>0)
			{
				me.exp+=rewardsVO.energy ;
				rewardsRender = new RewardsPanelRender("pickupEnergy"+BasicPickup.ENERGY,"res/pickup/pickupEnergy"+BasicPickup.ENERGY+".png",rewardsVO.energy+" Energy");
				rewardsRender.x = iconWidth*count;
				++count ;
				_container.addChild(rewardsRender);
			}
			if(rewardsVO.buildings)
			{
				var baseVO:BaseBuildingVO ;
				var storageItemVO:StorageItemVO ;
				for( var  key:* in rewardsVO.buildings) //key为baseId 
				{
					baseVO = BaseBuildingVOModel.instance.getBaseVOById( key ) ;
					rewardsRender = new RewardsPanelRender(baseVO.thumbAlias,baseVO.thumb,baseVO.name,"×"+rewardsVO.buildings[key]);
					rewardsRender.x = iconWidth*count;
					++count ;
					_container.addChild(rewardsRender);
					//刷新收藏箱
					StorageModel.instance.refreshStorage()  ;
				}
			}
			if(rewardsVO.pickups)
			{
				var pickVO:PickupVO ;
				for(  key in rewardsVO.pickups) //key为pid
				{
					pickVO = PickupModel.instance.getPickupById( key );
					rewardsRender = new RewardsPanelRender(pickVO.thumbAlias ,pickVO.url , pickVO.name , "×"+rewardsVO.buildings[key]);
					rewardsRender.x = iconWidth*count;
					++count ;
					_container.addChild(rewardsRender);
					PickupModel.instance.addPickup( pickVO.pickupId ,int(rewardsVO.buildings[key]) );
				}
			}
			if(_isCenter && _wid>0){
				_container.x = (_wid- iconWidth*count )*0.5 - iconWidth*0.5 ;
			}
		}
		
		override protected function removed():void
		{
			rewardsVO = null ;
		}
	}
}