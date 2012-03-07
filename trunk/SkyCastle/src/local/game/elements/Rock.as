package local.game.elements
{
	import local.enum.BuildingStatus;
	import local.enum.MouseStatus;
	import local.model.buildings.vos.BaseRockVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.MouseManager;

	/**
	 * 磐石，岩石，结合了石头和树的特点 
	 * @author zzhanglin
	 */	
	public class Rock extends Decortation
	{
		public function Rock(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseRockVO():BaseRockVO{
			return buildingVO.baseVO as BaseRockVO ;
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(!MouseManager.instance.checkControl() )
			{
				if(baseRockVO.earnStep>buildingVO.step){
					MouseManager.instance.mouseStatus = MouseStatus.BEAT_STONE ;
				}else{
					MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
				}
			}
			
		}
	}
}