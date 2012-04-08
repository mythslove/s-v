package local.game.elements
{
	import local.enum.BuildingStatus;
	import local.enum.MouseStatus;
	import local.model.buildings.vos.BaseFactoryVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.MouseManager;

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
			if( buildingVO.currentStep < baseFactoryVO.step){
				return buildingVO.baseVO.name+"("+buildingVO.currentStep+"/"+baseFactoryVO.step+")";
			}
			return buildingVO.baseVO.name;
		}
		
		override public function onClick():void
		{
//			super.onClick();
			switch( buildingVO.buildingStatus )
			{
				case BuildingStatus.BUILDING:
					break;
				case BuildingStatus.FINISH :
					break ;
				case BuildingStatus.PRODUCT:
					break;
				case BuildingStatus.HARVEST :
					break ;
			}
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(!MouseManager.instance.checkControl() )
			{
				if(buildingVO.buildingStatus == BuildingStatus.BUILDING )
				{
					MouseManager.instance.mouseStatus = MouseStatus.BUILD_BUILDING ;
				}
			}
		}
	}
}