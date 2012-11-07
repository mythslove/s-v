package local.map.scene
{
	import bing.starling.iso.SIsoScene;
	
	import local.comm.GameSetting;
	import local.map.item.BaseItem;
	import local.map.item.Floor;
	import local.model.MapGridDataModel;
	import local.model.RoomItemsModel;
	import local.model.StorageModel;
	
	public class FloorScene extends SIsoScene
	{
		public function FloorScene()
		{
			super(GameSetting.GRID_SIZE , GameSetting.MAX_SIZE , GameSetting.MAX_SIZE);
		}
		
		/**
		 * 添加Item
		 * @param item
		 * @param isSort是否进行深度排序
		 * @return 
		 */		
		public function addItem( item:Floor , isSort:Boolean=true ):BaseItem
		{
			this.addIsoObject( item,isSort );
			var floor:Floor = MapGridDataModel.instance.getFloorGridData(item.position.x , item.position.z );
			if(floor){
				this.removeItem(floor);
				RoomItemsModel.instance.removeItem(floor);
				StorageModel.instance.addItemToStorage(floor);
			}
			MapGridDataModel.instance.addFloorGridData(item);
			return item;
		}
		
		/**
		 * 移除建筑 
		 * @param building
		 */		
		public function removeItem( item:Floor ):void
		{
			this.removeIsoObject( item );
			MapGridDataModel.instance.removeFloorGridData(item);
		}
	}
}