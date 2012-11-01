package local.map.item
{
	import local.vo.ItemVO;
	
	public class WallDecor extends BaseItem
	{
		public var direction:int ;
		
		public function WallDecor(itemVO:ItemVO)
		{
			super(itemVO);
		}
	}
}