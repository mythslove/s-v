package local.map.scene
{
	import bing.starling.iso.SIsoScene;
	
	import local.comm.GameSetting;
	import local.map.item.BaseItem;
	import local.map.item.WallPaper;
	import local.model.MapGridDataModel;
	
	public class WallPaperScene extends SIsoScene
	{
		public function WallPaperScene()
		{
			super(GameSetting.GRID_SIZE , GameSetting.MAX_SIZE , GameSetting.MAX_SIZE);
		}
		
		/**
		 * 添加Item
		 * @param item
		 * @param isSort是否进行深度排序
		 * @return 
		 */		
		public function addItem( item:WallPaper , isSort:Boolean=true , isInit:Boolean=false ):BaseItem
		{
			this.addIsoObject( item,isSort );
			MapGridDataModel.instance.addWallPaperGridData( item );
			return item;
		}
		
		/**
		 * 移除建筑 
		 * @param building
		 */		
		public function removeItem( item:WallPaper ):void
		{
			this.removeIsoObject( item );
			MapGridDataModel.instance.removeWallPaperGridData(item);
		}
	}
}