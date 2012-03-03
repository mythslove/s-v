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
		
		/** 获取此建筑的标题 */
		override public function get title():String 
		{
			if( buildingVO.step < baseFactoryVO.buildStep){
				return buildingVO.baseVO.name+"("+buildingVO.step+"/"+baseFactoryVO.buildStep+")";
			}
			return buildingVO.baseVO.name;
		}
		
		override public function onClick():void
		{
			super.onClick();
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