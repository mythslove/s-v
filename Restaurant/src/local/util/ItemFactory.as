package local.util
{
	import local.enum.ItemType;
	import local.map.item.BaseItem;
	import local.map.item.Floor;
	import local.map.item.Wall;
	import local.map.item.WallDecor;
	import local.map.item.WallPaper;
	import local.vo.BaseItemVO;
	import local.vo.ItemVO;
	
	public class ItemFactory
	{
		/**
		 * 通过itemVO创建建筑 
		 * @param itemVO
		 * @return 
		 */		
		public static function createItemByVO( itemVO: ItemVO ):BaseItem
		{
			var item:BaseItem ;
			switch( itemVO.baseVO.type)
			{
				case ItemType.FLOOR:
					item = new Floor( itemVO );
					break ;
				case ItemType.WALL_DECOR:
					item = new WallDecor();
					break ;
				case ItemType.WALL_PAPER:
					item = new WallPaper();
					break ;
				default:
					item = new BaseItem( itemVO );
					break ;
			}
			return item ;
		}
		
		/**
		 * 通过BaseItemVO 创建item
		 * @param baseVO
		 * @return 
		 */		
		public static function createItemByBaseVO( baseVO:BaseItemVO ):BaseItem
		{
			var bvo:ItemVO = new ItemVO();
			bvo.name = baseVO.name ;
			bvo.baseVO = baseVO;
			return createItemByVO( bvo );
		}
	}
}