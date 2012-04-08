package local.model.map.vos
{
	public class MapVO
	{
		/** 地图ID */
		public var mapId:String = "MAP_01";
		
		/** 地图名字 */
		public var name:String  = "sky castle";
		
		/** 地图数据信息文件 ********暂时没用*******/
		public var resUrl:String  = "";
		
		/** 描述 */
		public var describe:String = "default map";
		
		/** 地图上的东西 */
		public var mapItems:Array  ;
		
		/** 已经砍过的基础建筑 ，key为nodeX_nodeZ，value为currentStep*/
		public var basicItems:Object ;
	}
}