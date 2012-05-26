package local.model
{
	import bing.amf3.ResultEvent;
	import bing.utils.SystemUtil;
	
	import local.comm.GameRemote;
	import local.comm.GlobalDispatcher;
	import local.enum.ItemType;
	import local.events.StorageEvent;
	import local.model.buildings.BaseBuildingVOModel;
	import local.model.buildings.vos.BuildingVO;
	import local.model.vos.StorageItemVO;
	

	/**
	 * 收藏箱的Model 
	 * @author zzhanglin
	 */	
	public class StorageModel
	{
		private static var _instance:StorageModel;
		public static function get instance():StorageModel
		{
			if(!_instance) _instance = new StorageModel();
			return _instance; 
		}
		//=================================
		private var _isInit:Boolean; //已经调用过
		
		public var buildings:Vector.<StorageItemVO> ;
		
		public var decorations:Vector.<StorageItemVO> ;
		
		public var plants:Vector.<StorageItemVO> ;
		
		private var _ro:GameRemote ;
		public function StorageModel()
		{
			_ro = new GameRemote("PlayerService");
			_ro.addEventListener(ResultEvent.RESULT ,  onResultHandler );
		}
		private function onResultHandler( e:ResultEvent ):void
		{
			SystemUtil.debug("返回数据：",e.service+"."+e.method , e.result );
			switch( e.method )
			{
				case "getStorage":
					_isInit = true ;
					_ro.removeEventListener(ResultEvent.RESULT ,  onResultHandler );
					_ro.dispose();
					_ro = null ;
					//返回的数据
					buildings = Vector.<StorageItemVO>(e.result.buildings);
					decorations = Vector.<StorageItemVO>(e.result.decorations);
					plants = Vector.<StorageItemVO>(e.result.plants);
					GlobalDispatcher.instance.dispatchEvent( new StorageEvent(StorageEvent.GET_STROAGE_ITEMS));
					break ;
			}
		}
		
		/**
		 * 获取收藏箱中的内容 
		 */		
		public function getStorageItems():void
		{
			if(_isInit){
				GlobalDispatcher.instance.dispatchEvent( new StorageEvent(StorageEvent.GET_STROAGE_ITEMS));
			}else{
				_ro.getOperation("getStorage").send();
			}
		}
		
		/**
		 * 刷新收藏箱 
		 */		
		public function refreshStorage():void
		{
			_isInit  = false; 
		}
		
		/**
		 * 从收藏箱中删除一个建筑 
		 * @param buildingVO
		 */		
		public function deleteBuilding( buildingVO:BuildingVO ):void
		{
			var type:String = ItemType.getSumType( BaseBuildingVOModel.instance.getBaseVOById(buildingVO.baseVO.baseId).type ) ;
			var storageItems:Vector.<StorageItemVO>
			switch( type )
			{
				case ItemType.BUILDING:
					storageItems = buildings ;
					break ;
				case ItemType.DECORATION:
					storageItems = decorations ;
					break ;
				case ItemType.PLANT:
					storageItems = plants ;
					break ;
			}
			if(storageItems){
				var len:int = storageItems.length ;
				for(var i:int = 0 ; i<len ; ++i){
					if(storageItems[i].id==buildingVO.id){
						storageItems.splice( i , 1 );
						break ;
					}
				}
			}
		}
		
		/**
		 * 添加一个建筑到收藏箱里 
		 * @param item
		 */		
		public function addStorageItem( item:StorageItemVO ):void
		{
			if(_isInit)
			{
				var type:String = ItemType.getSumType( BaseBuildingVOModel.instance.getBaseVOById(item.baseId).type ) ;
				switch( type )
				{
					case ItemType.BUILDING:
						if(!buildings) buildings = new Vector.<StorageItemVO>();
						buildings.push( item );
						break ;
					case ItemType.DECORATION:
						if(!decorations) decorations = new Vector.<StorageItemVO>();
						decorations.push( item );
						break ;
					case ItemType.PLANT:
						if(!plants) plants = new Vector.<StorageItemVO>();
						plants.push( item );
						break ;
				}
			}
		}
	}
}