package local.game.elements
{
	import local.enum.BuildingStatus;
	import local.model.buildings.vos.BaseHouseVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 房子 
	 * @author zzhanglin
	 */	
	public class House extends Building
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
		
		override public function onClick():void
		{
//			super.onClick();
			switch( buildingVO.buildingStatus )
			{
				case BuildingStatus.PRODUCT:
					break;
				case BuildingStatus.HARVEST :
					break ;
			}
		}
	}
}