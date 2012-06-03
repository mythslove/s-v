package local.game.elements
{
	import local.model.buildings.vos.BuildingVO;
	/**
	 * 怪
	 * @author zzhanglin
	 */	
	public class Mob extends Building
	{
		public function Mob(vo:BuildingVO)
		{
			super(vo);
		}
		
		/**
		 * 攻击此动物 
		 */		
		public function attack():void
		{
			
		}
	}
}