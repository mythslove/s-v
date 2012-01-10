package map.elements
{
	import models.vos.BuildingVO;
	
	/**
	 * 行走的人 
	 * @author zhouzhanglin
	 */	
	public class Character extends BuildingBase
	{
		public function Character(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
	}
}