package local.game.elements
{
	import local.enum.BuildingStatus;
	import local.model.buildings.vos.BaseFactoryVO;
	import local.model.buildings.vos.BuildingVO;

	/**
	 * 工厂 
	 * @author zzhanglin
	 */	
	public class Factory extends Building
	{
		public function Factory(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseFactoryVO():BaseFactoryVO{
			return buildingVO.baseVO as BaseFactoryVO ;
		}
		
		override public function onClick():void
		{
			switch( buildingVO.buildingStatus )
			{
				case BuildingStatus.BUILDING:
					break;
				case BuildingStatus.BUILD_COMPLETE :
					break ;
				case BuildingStatus.PRODUCTION:
					break;
				case BuildingStatus.PRODUCT_COMPLETE :
					break ;
			}
		}
	}
}