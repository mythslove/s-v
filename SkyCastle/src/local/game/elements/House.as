package local.game.elements
{
	import local.enum.BuildingStatus;
	import local.game.scenes.BuildingScene;
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
		
		override public function onClick():void
		{
			switch( buildingVO.buildingStatus )
			{
				case BuildingStatus.PRODUCTION:
					break;
				case BuildingStatus.PRODUCT_COMPLETE :
					break ;
			}
		}
	}
}