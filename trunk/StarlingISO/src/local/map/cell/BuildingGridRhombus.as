package local.map.cell
{
	import bing.iso.path.Grid;
	
	import local.model.MapGridDataModel;
	import local.util.EmbedManager;
	
	import starling.display.Image;
	
	/**
	 * 建筑底座的单个格子 
	 * @author zhouzhanglin
	 */	
	public class BuildingGridRhombus extends Image
	{
		public var nodeX:int ;
		public var nodeZ:int ;
		public var walkable:Boolean = true ;
		
		public function BuildingGridRhombus()
		{
			super(EmbedManager.getUITexture("BuildingBottomGridGreen"));
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
				this.texture = EmbedManager.getUITexture("BuildingBottomGridGreen");
			} else {
				this.texture = EmbedManager.getUITexture("BuildingBottomGridRed");
			}
		}
	}
}