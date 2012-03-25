package local.game.elements
{
	import local.model.buildings.vos.BaseDecorationVO;
	import local.model.buildings.vos.BuildingVO;
	import local.utils.CharacterManager;
	import local.utils.CollectQueueUtil;

	/**
	 * 装饰类建筑 
	 * @author zzhanglin
	 */	
	public class Decortation extends Building
	{
		public function Decortation(vo:BuildingVO)
		{
			super(vo);
		}
		
		/** 获取此建筑的基础VO */
		public function get baseDecorationVO():BaseDecorationVO{
			return buildingVO.baseVO as BaseDecorationVO ;
		}
		
		override public function onClick():void
		{
			if(this is BasicDecoration){
				super.onClick();
			}else if(!CollectQueueUtil.instance.currentBuilding){
				characterMoveTo( CharacterManager.instance.hero );
			}
		}
	}
}