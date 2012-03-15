package local.views.rewards
{
	import local.enum.BasicPickup;
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.buildings.vos.BaseBuildingVO;
	import local.model.rewards.vos.RewardsVO;
	import local.views.BaseView;
	import local.views.base.Image;
	/**
	 * 显示奖励列表 
	 * @author zhouzhanglin
	 */	
	public class RewardsPanel extends BaseView
	{
		public var rewardsVO:RewardsVO;
		
		public function RewardsPanel( vo:RewardsVO=null )
		{
			super();
			this.rewardsVO = vo ;
		}
		
		override protected function added():void
		{
			if(!this.rewardsVO) return ;
			var img:Image ;
			var count:int ;
			var iconWidth:int = 100 ;
			if(rewardsVO.gem>0)
			{
				img = new RewardsPanelRender("pickupGem","res/pickup/pickupGem.png",rewardsVO.gem);
				img.x = iconWidth*count;
				++count ;
				addChild(img);
			}
			if(rewardsVO.coin>0)
			{
				img = new Image("pickupCoin"+BasicPickup.COIN,"res/pickup/pickupCoin"+BasicPickup.COIN+".png",rewardsVO.coin);
				img.x = iconWidth*count;
				++count ;
				addChild(img);
			}
			if(rewardsVO.wood>0)
			{
				img = new Image("pickupWood"+BasicPickup.WOOD,"res/pickup/pickupWood"+BasicPickup.WOOD+".png",rewardsVO.wood);
				img.x = iconWidth*count;
				++count ;
			}
			if(rewardsVO.stone>0)
			{
				img = new Image("pickupStone"+BasicPickup.STONE,"res/pickup/pickupStone"+BasicPickup.STONE+".png",rewardsVO.stone);
				img.x = iconWidth*count;
				++count ;
				addChild(img);
			}
			if(rewardsVO.exp>0)
			{
				img = new Image("pickupExp"+BasicPickup.EXP,"res/pickup/pickupExp"+BasicPickup.EXP+".png",rewardsVO.exp);
				img.x = iconWidth*count;
				++count ;
				addChild(img);
			}
			if(rewardsVO.buildings)
			{
				var baseVO:BaseBuildingVO ;
				for( var i:int = 0 ; i<rewardsVO.buildings.length ; ++i)
				{
					baseVO = BaseBuildingVOModel.instance.getBaseVOById( rewardsVO.buildings[i]);
					if(baseVO){
						img = new Image(baseVO.alias,baseVO.thumb);
						img.x = iconWidth*count;
						++count ;
						addChild(img);
					}
				}
			}
			if(rewardsVO.pickups)
			{
				for( var i:int = 0 ; i<rewardsVO.pickups.length ; ++i)
				{
					img = new Image(rewardsVO.pickups[i],"res/pickup/"+rewardsVO.pickups[i]+".png");
					img.x = iconWidth*count;
					++count ;
					addChild(img);
				}
			}
		}
		
		override protected function removed():void
		{
			rewardsVO = null ;
		}
	}
}