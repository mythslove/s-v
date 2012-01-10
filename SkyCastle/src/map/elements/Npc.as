package map.elements
{
	import models.vos.BuildingVO;
	
	/**
	 * 行走的NPC 
	 * @author zhouzhanglin
	 */	
	public class Npc extends Character
	{
		public function Npc(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
	}
}