package local.map.cell
{
	import bing.iso.path.Grid;
	
	import flash.display.Bitmap;
	
	import local.model.MapGridDataModel;
	import local.util.EmbedsManager;
	
	/**
	 * 建筑底座的单个格子 
	 * @author zhouzhanglin
	 */	
	public class BuildingGridRhombus extends Bitmap
	{
		public var nodeX:int ;
		public var nodeZ:int ;
		public var walkable:Boolean = true ;
		
		public function BuildingGridRhombus(nodeX:int , nodeZ:int)
		{
			super();
			this.nodeX = nodeX;
			this.nodeZ = nodeZ ;
		}
		
		/**
		 * 更新单元格
		 * @param parentNodeX
		 * @param parentNodeZ
		 */		
		public function updateBuildingGridRhombus(parentNodeX:int , parentNodeZ:int ):void
		{
			var curNodeX:int = parentNodeX + nodeX ;
			var curNodeZ :int = parentNodeZ + nodeZ;
			
			var gameGrid:Grid = MapGridDataModel.instance.gameGridData ;
			if(gameGrid.checkInGrid(curNodeX,curNodeZ)  && gameGrid.getNode(curNodeX,curNodeZ).walkable  )
			{
				setWalkabled(true);
			}else{
				setWalkabled(false);
			}
		}
		
		/**
		 *  设置是否可行，主要改变颜色
		 * @param value
		 */		
		public function setWalkabled( value:Boolean ):void
		{
			walkable = value ;
			if( value ) {
				bitmapData = EmbedsManager.instance.getBitmapByName("BuildingBottomGridGreen").bitmapData ;
			} else {
				bitmapData = EmbedsManager.instance.getBitmapByName("BuildingBottomGridRed").bitmapData ;
			}
		}
	}
}