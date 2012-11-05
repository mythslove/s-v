package local.model
{
	import local.enum.ItemType;
	import local.map.item.BaseItem;
	import local.vo.ItemVO;
	import local.vo.StorageItemVO;

	public class StorageModel
	{
		private static var _instance:StorageModel;
		public static function get instance():StorageModel
		{
			if(!_instance) _instance = new StorageModel();
			return _instance; 
		}
		//=================================
		
		public var wallPapers:Vector.<StorageItemVO> = new Vector.<StorageItemVO>() ;
		
		public var decors:Vector.<StorageItemVO> = new Vector.<StorageItemVO>() ;
		
		public var wallDecors:Vector.<StorageItemVO> = new Vector.<StorageItemVO>() ;
		
		public var floors:Vector.<StorageItemVO> = new Vector.<StorageItemVO>() ;
		
		public var tables:Vector.<StorageItemVO> = new Vector.<StorageItemVO>() ;
		
		public var chairs:Vector.<StorageItemVO> = new Vector.<StorageItemVO>() ;
		
		public var stoves:Vector.<StorageItemVO> = new Vector.<StorageItemVO>() ;
		
		public var counters:Vector.<StorageItemVO> = new Vector.<StorageItemVO>() ;
		
		/**
		 *  添加Item到收藏箱
		 * @param baseItem
		 */		
		public function addItemToStorage( baseItem:BaseItem ):void
		{
			addItemVOToStorage( baseItem.itemVO );
		}
		
		/**
		 * 添加一个Item到收藏箱 
		 * @param bitemVO
		 */		
		public function addItemVOToStorage( itemVO:ItemVO ):void
		{
			var arr:Vector.<StorageItemVO> ;
			switch( itemVO.baseVO.type  )
			{
				case ItemType.WALL_DECOR:
					if(!wallDecors) wallDecors = new Vector.<StorageItemVO>();
					arr = wallDecors ;
					break ;
				case ItemType.WALL_PAPER:
					if(!wallPapers) wallPapers = new Vector.<StorageItemVO>();
					arr = wallPapers ;
					break ;
				case ItemType.CHAIR:
					if(!chairs) chairs = new Vector.<StorageItemVO>();
					arr = chairs ;
					break ;
				case ItemType.TABLE:
					if(!tables) tables = new Vector.<StorageItemVO>();
					arr = tables ;
					break ;
				case ItemType.COUNTER:
					if(!counters) counters = new Vector.<StorageItemVO>();
					arr = counters ;
					break ;
				case ItemType.FLOOR:
					if(!floors) floors = new Vector.<StorageItemVO>();
					arr = floors ;
					break ;
				case ItemType.STOVE:
					if(!stoves) stoves = new Vector.<StorageItemVO>();
					arr = stoves ;
					break ;
			}
			var vo:StorageItemVO = getStorageVO( itemVO.name  , arr );
			if(vo) {
				vo.num++;
			}else{
				vo = new StorageItemVO();
				vo.name = itemVO.name ;
				vo.num = 1 ;
				vo.type = itemVO.baseVO.type ;
				arr.push( vo );
			}
		}
		
		/**
		 * 删除一个StorageVO
		 * @param name
		 * @param type
		 */		
		public function deleteStorageVO( name :String , type:String ):void
		{
			var arr:Vector.<StorageItemVO> ;
			switch( type )
			{
				case ItemType.WALL_DECOR:
					arr = wallDecors ;
					break ;
				case ItemType.WALL_PAPER:
					arr = wallPapers ;
					break ;
				case ItemType.CHAIR:
					arr = chairs ;
					break ;
				case ItemType.TABLE:
					arr = tables ;
					break ;
				case ItemType.COUNTER:
					arr = counters ;
					break ;
				case ItemType.FLOOR:
					arr = floors ;
					break ;
				case ItemType.STOVE:
					arr = stoves ;
					break ;
			}
			if(arr){
				var len:int = arr.length ;
				for( var i:int = 0 ; i<len ; ++i ){
					if(arr[i].name==name){
						arr[i].num--;
						if(arr[i].num<=0){
							arr.splice( i , 1 );
						}
						break ;
					}
				}
			}
		}
		
		
		private function getStorageVO( name :String , arr:Vector.<StorageItemVO> ):StorageItemVO
		{
			for each( var vo:StorageItemVO in arr){
				if( vo.name ==name ) return vo ;
			}
			return null ;
		}
		
	}
}