package game.mvc.model.vo
{
	public class MapVO
	{
		public var id:int ;  //此地图的id
		public var url:String ; //地图文件夹路径
		public var mapName:String ; //地图名称
		public var alias:String; //地图的别名，通常为英文
		public var tileWidth:int ; //一个格子的宽
		public var tileHeight:int ; //一个格子的高
		public var segmentation:Boolean; //是否是分块加载
		public var segW:int ; //分块的宽
		public var segH:int ; //分块的高
		public var segRow:int ;
		public var segCol:int ;
		public var rowCount:int ; //网格行数
		public var colCount:int ; //网格列数
		public var mapWidth:int ; //地图宽
		public var mapHeight:int ; //地图高
		public var scale:int ; //小地图缩放比例
	}
}