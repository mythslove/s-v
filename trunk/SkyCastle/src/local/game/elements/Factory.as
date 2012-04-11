package local.game.elements
{
	import local.model.buildings.vos.BaseFactoryVO;
	import local.model.buildings.vos.BuildingVO;

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
		
		/** 获取此建筑的标题 */
		override public function get title():String 
		{
			if( buildingVO.currentStep < baseFactoryVO.step){
				return buildingVO.baseVO.name+"("+buildingVO.currentStep+"/"+baseFactoryVO.step+")";
			}
			return buildingVO.baseVO.name;
		}
	}
}