package local.model
{
	import bing.utils.Guid;
	
	import local.enum.ItemType;
	import local.map.item.BaseItem;
	import local.vo.ItemVO;

	/**
	 * 房间中的所有的物品
	 * @author zzhanglin
	 */	
	public class RoomItemsModel
	{
		private static var _instance:RoomItemsModel;
		public static function get instance():RoomItemsModel
		{
			if(!_instance) _instance = new RoomItemsModel();
			return _instance; 
		}
		//=================================
		
		/** 墙纸 */
		public var wallPapers:Vector.<ItemVO>;
		
		/** 墙装饰*/
		public var wallDecors:Vector.<ItemVO> ;
		
		/** 装饰 */
		public var decorations:Vector.<ItemVO>;
		
		/** 房间中的凳子*/
		public var chairs:Vector.<ItemVO> ;
		
		/** 房间中的桌子*/
		public var tables:Vector.<ItemVO> ;
		
		/** 房间中的柜台*/
		public var counters:Vector.<ItemVO> ;
		
		/** 房间中的灶*/
		public var stoves:Vector.<ItemVO> ;
		
		/** 地板*/
		public var floors:Vector.<ItemVO> ;
		
		
		public function addItem( baseItem:BaseItem ):void
		{
			addItemVO( baseItem.itemVO ); 
		}
		
		public function addItemVO( vo:ItemVO ):void
		{
			if(!vo.id){
				vo.id = Guid.create();
			}
			switch( vo.baseVO.type  )
			{
				case ItemType.WALL_PAPER:
					if(!wallPapers) wallPapers = new Vector.<ItemVO>();
					wallPapers.push( vo );
					break ;
				case ItemType.WALL_DECOR:
					if(!wallDecors) wallDecors = new Vector.<ItemVO>();
					wallDecors.push( vo );
					break ;
				case ItemType.DECOR:
					if(!decorations) decorations = new Vector.<ItemVO>();
					decorations.push( vo );
					break ;
				case ItemType.CHAIR:
					if(!chairs) chairs = new Vector.<ItemVO>();
					chairs.push( vo );
					break ;
				case ItemType.TABLE:
					if(!tables) tables = new Vector.<ItemVO>();
					tables.push( vo );
					break ;
				case ItemType.COUNTER:
					if(!counters) counters = new Vector.<ItemVO>();
					counters.push( vo );
					break ;
				case ItemType.STOVE:
					if(!stoves) stoves = new Vector.<ItemVO>();
					stoves.push( vo );
					break ;
				case ItemType.FLOOR:
					if(!floors) floors = new Vector.<ItemVO>();
					floors.push( vo );
					break ;
			}
		}
		
		public function removeItem( item:BaseItem ):void
		{
			removeItemVO( item.itemVO );
		}
		
		public function removeItemVO( bvo:ItemVO):void
		{
			var arr:Vector.<ItemVO> =getArrByType(bvo.baseVO.type);
			if(arr){
				var len:int = arr.length ;
				for( var i:int = 0 ; i<len ; ++i ){
					if( arr[i] == bvo){
						arr.splice( i , 1 );
						break ;
					}
				}
			}
		}
		
		
		/**
		 * 通过类型获得数组 
		 * @param itemType
		 * @return 
		 */		
		public function getArrByType( itemType:String ):Vector.<ItemVO>
		{
			var arr:Vector.<ItemVO> ;
			switch( itemType)
			{
				case ItemType.WALL_PAPER:
					arr = wallPapers ;
					break ;
				case ItemType.WALL_DECOR:
					arr = wallDecors ;
					break ;
				case ItemType.DECOR:
					arr = decorations ;
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
				case ItemType.STOVE:
					arr = stoves ;
					break ;
				case ItemType.FLOOR:
					arr = floors ;
					break ;
			}
			return arr ;
		}
		
		
		
		
		/**
		 * 返回数量 
		 * @param type 建筑的类型
		 * @param excludeItem 是否排除正在修建的建筑
		 * @return 
		 */		
		public function getCountByType( type:String , excludeItem:Boolean=true ):int
		{
			var arr:Vector.<ItemVO> = getArrByType( type );
			if(arr){
				if(excludeItem){
					var count:int ;
					for each( var vo:ItemVO in arr){
						++count ;
					}
					return count ;
				}
				else
				{
					return arr.length ;
				}
			}
			return 0;
		}
		
		/**
		 * 通过名字和类型来获得类型 
		 * @param type
		 * @param name
		 * @param excludeItem
		 * @return 
		 */		
		public function getCountByName( type:String , name:String , excludeItem:Boolean=true ):int
		{
			var count:int;
			var arr:Vector.<ItemVO> = getArrByType( type );
			if(arr){
				for each( var vo:ItemVO in arr){
					if( name==vo.name){
						++count ;
					}
				}
			}
			return count;
		}
	}
}