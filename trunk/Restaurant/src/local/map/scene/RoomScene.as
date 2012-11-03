package local.map.scene
{
	import bing.starling.iso.SIsoScene;
	
	import local.comm.GameSetting;
	import local.map.item.BaseItem;
	import local.model.MapGridDataModel;
	
	public class RoomScene extends SIsoScene
	{
		public function RoomScene()
		{
			super(GameSetting.GRID_SIZE , GameSetting.MAX_SIZE , GameSetting.MAX_SIZE );
			this.gridData = MapGridDataModel.instance.gameGridData ;
		}
		
		/**
		 * 添加Item
		 * @param item
		 * @param isSort是否进行深度排序
		 * @return 
		 */		
		public function addItem( item:BaseItem , isSort:Boolean=true , isInit:Boolean=false ):BaseItem
		{
			this.addIsoObject( item,isSort );
			item.setWalkable( false , gridData );
			MapGridDataModel.instance.addRoomItemGridData( item );
			if(isInit && item is BaseItem){
				( item as BaseItem).recoverStatus() ;
			}
			return item;
		}
		
		/**
		 * 移除建筑 
		 * @param building
		 */		
		public function removeItem( item:BaseItem ):void
		{
			this.removeIsoObject( item );
			item.setWalkable( true , this.gridData );
			MapGridDataModel.instance.removeRoomItemGridData(item);
		}
		
		/**
		 * 旋转建筑 
		 * @param buildingBase
		 */		
		public function rotateItem( item:BaseItem ):void
		{
			if(item.getRotatable(gridData))
			{
				item.setWalkable(true,gridData);
				MapGridDataModel.instance.removeRoomItemGridData( item );
				item.rotate();
				item.setWalkable(false,gridData);
				MapGridDataModel.instance.addRoomItemGridData( item );
			}
		}

	}
}