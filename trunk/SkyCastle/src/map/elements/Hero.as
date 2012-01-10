package map.elements
{
	import models.vos.BuildingVO;
	
	/**
	 * 英雄 
	 * @author zhouzhanglin
	 */	
	public class Hero extends Character
	{
		public function Hero(buildingVO:BuildingVO)
		{
			super(buildingVO);
		}
	}
}