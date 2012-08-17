package tool.local.vos
{
	import bing.iso.path.Grid;
	
	import flash.display.BitmapData;

	public class MapVO
	{
		public var xSpan:int ;
		public var zSpan:int ;
		public var offsetX:int ;
		public var offsetY:int ;
		public var bg:BitmapData ;
		public var gridData:Grid ;
		
		/**
		 * 当xpan 和 zSpan改变时
		 */		
		public function update():void
		{
			var grid:Grid = new Grid(xSpan,zSpan);
			if(gridData){
				for( var i:int = 0 ; i<gridData.numCols ; ++i)
				{
					for( var j:int = 0 ; j<gridData.numRows ; ++j)
					{
						if(i<xSpan && j<zSpan){
							grid.setWalkable( i,j,gridData.getNode( i,j).walkable) ;
						}
					}
				}
			}
			gridData = grid ;
		}
	}
}