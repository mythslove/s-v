package local.map.item
{
	import local.vo.ItemVO;
	
	public class WallPaper extends BaseItem
	{
		public var direction:int ;
		
		public function WallPaper(itemVO:ItemVO)
		{
			super(itemVO);
		}
	}
}