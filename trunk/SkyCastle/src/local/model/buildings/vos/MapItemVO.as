package local.model.buildings.vos
{
	/**
	 * BuildingVO的基类 
	 * @author zzhanglin
	 */	
	public class MapItemVO
	{
		/** 编号 */
		public var id:int = 0;
		
		/** 地图ID */
		public var mapId:String = "1";
		
		/** 建筑ID */
		public var baseId:String ;
		
		/** X坐标 */
		public var nodeX:int = 0;
		
		/** Z坐标 */
		public var nodeZ:int = 0;
		
		/** 当前的方向，如果旋转过就是-1，默认为1 */
		public var scale:int = 1;
	}
}