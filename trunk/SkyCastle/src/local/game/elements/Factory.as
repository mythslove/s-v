package local.game.elements
{
	import local.enum.BasicPickup;
	import local.enum.BuildingStatus;
	import local.game.GameWorld;
	import local.model.PlayerModel;
	import local.model.buildings.vos.BaseFactoryVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.PickupUtil;
	import local.views.effects.MapWordEffect;

	/**
	 * 工厂 
	 * @author zzhanglin
	 */	
	public class Factory extends Architecture
	{
		public function Factory(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseFactoryVO():BaseFactoryVO{
			return buildingVO.baseVO as BaseFactoryVO ;
		}
		
		/**
		 * 掉物品 ，并接着下一个收集
		 */		
		override public function showPickup():void
		{
			if( _timeoutFlag && _executeBack)
			{
				//如果是修建状态，掉修建的pickup。
				if( buildingVO.buildingStatus==BuildingStatus.BUILDING)
				{
					//减木头和石头
					var effect:MapWordEffect ;
					if(PlayerModel.instance.me.wood<baseBuildingVO["buildWood"]){
						effect = new MapWordEffect("You don't have enough Wood!");
						GameWorld.instance.addEffect(effect,screenX-120,screenY);
						return ;
					}else if(PlayerModel.instance.me.stone<baseBuildingVO["buildStone"]){
						effect = new MapWordEffect("You don't have enough Stone!");
						GameWorld.instance.addEffect(effect,screenX+120,screenY);
						return ;
					}
					
					var value:int = baseBuildingVO["buildWood"] ;
					if(value>0) effect = new MapWordEffect("Wood -"+value);
					PlayerModel.instance.me.wood-=value ; 
					GameWorld.instance.addEffect(effect,screenX-120 , screenY);
					value = baseBuildingVO["buildStone"] ;
					if(value>0) effect = new MapWordEffect("Stone -"+value);
					PlayerModel.instance.me.stone-=value ; 
					GameWorld.instance.addEffect(effect , screenX+120 , screenY);
					//增加经验
					value = baseBuildingVO.buildEarnExp ;
					PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP ,  value , screenX,screenY-offsetY);
					buildingVO.currentStep++;
				}
				else if( buildingVO.buildingStatus==BuildingStatus.HARVEST)
				{
					//如果是收获，掉收获的pickup，子类判断
				}
				//特殊物品
				showRewardsPickup();
				//=======================
				_timeoutFlag=false ;
				_executeBack = false ;
				_currentRewards = null ;
				super.showPickup();
			}
		}
	}
}