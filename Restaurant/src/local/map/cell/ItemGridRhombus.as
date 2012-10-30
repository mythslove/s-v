package local.map.cell
{
	import bing.iso.path.Grid;
	
	import local.util.EmbedManager;
	
	import starling.display.Image;
	
	/**
	 * 建筑底座的单个格子 
	 * @author zhouzhanglin
	 */	
	public class ItemGridRhombus extends Image
	{
		public var nodeX:int ;
		public var nodeZ:int ;
		public var walkable:Boolean = true ;
		
		public function ItemGridRhombus()
		{
			super(EmbedManager.getUITexture("ItemBottomGridGreen"));
		}
		
		/**
		 * 更新单元格
		 * @param parentNodeX
		 * @param parentNodeZ
		 * @param grid
		 */		
		public function updateItemGridRhombus(parentNodeX:int , parentNodeZ:int , grid:Grid):void
		{
			var curNodeX:int = parentNodeX + nodeX ;
			var curNodeZ :int = parentNodeZ + nodeZ;
			
			if(grid.checkInGrid(curNodeX,curNodeZ)  && grid.getNode(curNodeX,curNodeZ).walkable  )
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
				this.texture = EmbedManager.getUITexture("ItemBottomGridGreen");
			} else {
				this.texture = EmbedManager.getUITexture("ItemBottomGridRed");
			}
		}
	}
}