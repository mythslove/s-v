package local.game.elements
{
	import local.model.buildings.vos.BuildingVO;
	/**
	 * 动物 
	 * @author zzhanglin
	 */	
	public class Animail extends Building
	{
		public function Animail(vo:BuildingVO)
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