package local.map.scene
{
	import bing.starling.iso.SIsoScene;
	
	import local.comm.GameSetting;
	import local.map.item.BaseItem;
	import local.model.MapGridDataModel;
	
	public class WallDecorScene extends SIsoScene
	{
		public function WallDecorScene()
		{
			super(GameSetting.GRID_SIZE , GameSetting.MAX_SIZE , GameSetting.MAX_SIZE );
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
			MapGridDataModel.instance.addWallDecorGridData( item );
			return item;
		}
		
		/**
		 * 移除建筑 
		 * @param building
		 */		
		public function removeItem( item:BaseItem ):void
		{
			this.removeIsoObject( item );
			MapGridDataModel.instance.removeWallDecorGridData(item);
		}
	}
}