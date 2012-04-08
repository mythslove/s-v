package local.game.elements
{
	import local.model.buildings.vos.BaseLandVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.MouseManager;

	/**
	 * 土地，继承自种植类 
	 * @author zzhanglin
	 */	
	public class Land extends Plant
	{
		public function Land(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseLandVO():BaseLandVO{
			return buildingVO.baseVO as BaseLandVO ;
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(!MouseManager.instance.checkControl() )
			{
				//			if(baseLandVO.step<buildingVO.step){
				//				MouseManager.instance.mouseStatus = MouseStatus.BEAT_STONE ;
				//			}else{
				//				MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
				//			}
			}
		}
	}
}