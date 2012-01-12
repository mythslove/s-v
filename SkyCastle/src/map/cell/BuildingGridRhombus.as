package map.cell
{
	import bing.iso.Rhombus;
	import bing.utils.ContainerUtil;
	
	import comm.GameSetting;
	
	import flash.display.Sprite;
	
	import map.BuildingScene;
	
	import models.MapGridDataModel;
	
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
		 * 主要用于判断建筑层内容
		 * 单独的检测是否可以放 ，主要是检测 AStarRoadGridModel.instance.roadGrid网格数据。
		 * 即检测buildingScene层的对象，不检测groundScene对象
		 * @param parentNodeX
		 * @param parentNodeZ
		 * @param buildingScene
		 */		
		public function updateBuildingGridRhombus(parentNodeX:int , parentNodeZ:int , buildingScene:BuildingScene ):void
		{
			var curNodeX:int = parentNodeX + nodeX ;
			var curNodeZ :int = parentNodeZ + nodeZ;
			
			var astarModel:MapGridDataModel = MapGridDataModel.instance ;
			if(buildingScene.gridData.checkInGrid(curNodeX,curNodeZ) && 
				buildingScene.gridData.getNode(curNodeX,curNodeZ).walkable &&
				!astarModel.extraHash[curNodeX+"-"+curNodeZ])
			{
				setWalkabled(true);
			}
			else
			{
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