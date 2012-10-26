package local.model
{
	import flash.utils.Dictionary;
	
	import local.enum.ItemType;
	import local.vo.BaseItemVO;

	/**
	 * 商店数据 
	 * @author zzhanglin
	 */	
	public class ShopModel
	{
		private static var _instance:ShopModel;
		public static function get instance():ShopModel
		{
			if(!_instance) _instance = new ShopModel();
			return _instance; 
		}
		//=================================
		
		/** 所有的建筑BaseItemVO */
		public var baseItems:Vector.<BaseItemVO> ;
		
		/** 商店里所有的建筑 数据，key为name , value 为BaseItemVO */
		public var allItemsHash:Dictionary  ;
	
		
		public var baseWallpaper:Vector.<BaseItemVO> = new Vector.<BaseItemVO>() ;
		
		public var baseDecors:Vector.<BaseItemVO> = new Vector.<BaseItemVO>() ;
		
		public var baseWalldecor:Vector.<BaseItemVO> = new Vector.<BaseItemVO>() ;
		
		public var baseFloor:Vector.<BaseItemVO> = new Vector.<BaseItemVO>() ;
		
		public var baseTable:Vector.<BaseItemVO> = new Vector.<BaseItemVO>() ;
		
		public var baseChair:Vector.<BaseItemVO> = new Vector.<BaseItemVO>() ;
		
		public var baseStove:Vector.<BaseItemVO> = new Vector.<BaseItemVO>() ;
		
		public var baseCounter:Vector.<BaseItemVO> = new Vector.<BaseItemVO>() ;
		
		public var baseCharacter:Vector.<BaseItemVO> = new Vector.<BaseItemVO>() ;
		
		/**
		 * 初始化商店数据和ShopItemRender 
		 */		
		public function initShopData():void
		{
			//遍历所有的建筑数据
			for each(var baseVO:BaseItemVO in baseItems)
			{
				switch( baseVO.type)
				{
					case ItemType.DECOR :
						baseDecors.push( baseVO );
						break ;
					case ItemType.WALL_PAPER :
						baseWallpaper.push( baseVO  );
						break ;
					case ItemType.WALL_DECOR :
						baseWalldecor.push( baseVO  );
						break ;
					case ItemType.CHAIR :
						baseChair.push( baseVO );
						break ;
					case ItemType.COUNTER :
						baseCounter.push( baseVO );
						break ;
					case ItemType.FLOOR :
						baseFloor.push( baseVO );
						break ;
					case ItemType.STOVE :
						baseStove.push( baseVO );
						break ;
					case ItemType.TABLE :
						baseTable.push( baseVO );
						break ;
					case ItemType.CHARACTER :
						baseCharacter.push( baseVO );
						break ;
				}
			}
		}
	}
}