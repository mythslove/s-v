package local.game.elements
{
	import local.enum.MouseStatus;
	import local.model.buildings.vos.BaseStoneVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.MouseManager;

	/**
	 * 装饰之石头 
	 * @author zzhanglin
	 */	
	public class Stone extends Decortation
	{
		public function Stone(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseStoneVO():BaseStoneVO{
			return buildingVO.baseVO as BaseStoneVO ;
		}
		
		override public function onMouseOver():void
		{
			super.onMouseOver();
			if(baseStoneVO.earnStep>buildingVO.step){
				MouseManager.instance.mouseStatus = MouseStatus.BEAT_STONE ;
			}else{
				MouseManager.instance.mouseStatus = MouseStatus.SHOVEL_BUILDING ;
			}
		}
	}
}