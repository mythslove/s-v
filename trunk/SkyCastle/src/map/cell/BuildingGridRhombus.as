package map.cell
{
	import bing.iso.Rhombus;
	import bing.iso.path.Grid;
	
	import comm.GameSetting;
	
	import map.GameWorld;
	
	import models.AStarRoadGridModel;
	
	public class BuildingGridRhombus extends Rhombus
	{
		public var currColor:uint = 0x00ff00 ;
		public var nodeX:int ;
		public var nodeZ:int ;
		
		public function BuildingGridRhombus( nodeX:int , nodeZ:int )
		{
			super(GameSetting.GRID_SIZE , currColor );
			this.nodeX = nodeX;
			this.nodeZ = nodeZ ;
		}
		
		public function update(parentNodeX:int , parentNodeZ:int):void
		{
			var curNodeX:int = parentNodeX + nodeX ;
			var curNodeZ :int = parentNodeZ + nodeZ;
			var astarModel:AStarRoadGridModel = AStarRoadGridModel.instance ;
			if(astarModel.roadGrid.checkInGrid(curNodeX,curNodeZ) && 
				astarModel.roadGrid.getNode(curNodeX,curNodeZ).walkable &&
				!astarModel.extraHash[curNodeX+"-"+curNodeZ])
			{
				if(this.currColor!=0x00ff00){
					this.currColor = 0x00ff00 ;
					this.draw( currColor , GameSetting.GRID_SIZE );
				}
			}
			else
			{
				if(this.currColor!=0xff0000){
					this.currColor = 0xff0000 ;
					this.draw( currColor , GameSetting.GRID_SIZE );
				}
			}
		}
	}
}