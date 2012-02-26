package  local.map.cell
{
	import bing.iso.Rhombus;
	import bing.iso.path.Grid;
	import bing.utils.ContainerUtil;
	
	import flash.display.Sprite;
	
	import local.comm.GameSetting;
	import local.enum.LayerType;
	import local.model.map.MapGridDataModel;
	
	/**
	 *  建筑拥有的格子，单个格子 
	 * @author zhouzhanglin
	 */	
	public class BuildingGridRhombus extends Sprite
	{
		public var currColor:uint = 0x00ff00 ;
		public var nodeX:int ;
		public var nodeZ:int ;
		private var rhombus1:Rhombus ;
		private var rhombus2:Rhombus ;
		public var walkable:Boolean = true ;
		
		public function BuildingGridRhombus( nodeX:int , nodeZ:int )
		{
			rhombus1 = new Rhombus(GameSetting.GRID_SIZE , currColor);
			rhombus2 = new Rhombus(GameSetting.GRID_SIZE , 0xff0000);
			addChild(rhombus1);
			this.nodeX = nodeX;
			this.nodeZ = nodeZ ;
		}
		
		/**
		 * 更新单元格
		 * @param parentNodeX
		 * @param parentNodeZ
		 * @param layerType
		 */		
		public function updateBuildingGridRhombus(parentNodeX:int , parentNodeZ:int , layerType:int ):void
		{
			var curNodeX:int = parentNodeX + nodeX ;
			var curNodeZ :int = parentNodeZ + nodeZ;
			
			var gridDataModel:MapGridDataModel = MapGridDataModel.instance ;
			var grid:Grid ;
			if( layerType==LayerType.GROUND) {
				grid = gridDataModel.groundGrid ;
			} else if( layerType==LayerType.BUILDING) {
				grid = gridDataModel.buildingGrid ;
			}
			
			if(grid.checkInGrid(curNodeX,curNodeZ) 
				&& grid.getNode(curNodeX,curNodeZ).walkable 
				&&!gridDataModel.extraHash[curNodeX+"-"+curNodeZ])
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
			if( value )
			{
				if(this.currColor!=0x00ff00){
					this.currColor = 0x00ff00 ;
					ContainerUtil.removeChildren(this);
					addChild(rhombus1);
				}
			}
			else
			{
				if(this.currColor!=0xff0000){
					this.currColor = 0xff0000 ;
					ContainerUtil.removeChildren(this);
					addChild(rhombus2);
				}
			}
		}
	}
}