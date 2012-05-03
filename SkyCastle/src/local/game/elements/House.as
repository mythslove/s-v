package local.game.elements
{
	import local.enum.BasicPickup;
	import local.enum.BuildingStatus;
	import local.model.buildings.vos.BaseHouseVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.PickupUtil;

	/**
	 * 房子 
	 * @author zzhanglin
	 */	
	public class House extends Architecture
	{
		public function House(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseHouseVO():BaseHouseVO{
			return buildingVO.baseVO as BaseHouseVO ;
		}
		
		/** 获取此建筑的标题 */
		override public function get title():String 
		{
			return buildingVO.baseVO.name+"(Lv"+buildingVO.level+")";
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
					PickupUtil.addPickup2Wold(BasicPickup.PICKUP_EXP , baseBuildingVO.buildEarnExp , screenX,screenY-offsetY);
				}
				else if( buildingVO.buildingStatus==BuildingStatus.HARVEST)
				{
					//如果是收获，掉收获的pickup，子类判断
				}
				//特殊物品
				showRewardsPickup();
				//==========================
				_timeoutFlag=false ;
				_executeBack = false ;
				_currentRewards = null ;
				super.showPickup();
			}
		}
	}
}