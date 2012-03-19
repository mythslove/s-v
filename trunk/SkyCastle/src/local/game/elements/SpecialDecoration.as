package local.game.elements
{
	import local.model.buildings.vos.BuildingVO;
	/**
	 * 另外的普通装饰 ，纯粹的装饰
	 * @author zzhanglin
	 */	
	public class SpecialDecoration extends Decortation
	{
		public function SpecialDecoration(vo:BuildingVO)
		{
			super(vo);
		}
	}
}