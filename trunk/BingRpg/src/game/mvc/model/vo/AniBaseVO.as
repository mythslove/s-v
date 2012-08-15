package game.mvc.model.vo
{
	import bing.animation.ActionVO;

	public class AniBaseVO
	{
		public var name:String ; 
		public var url:String ; //swf地址
		public var resType:String="swf" ;
		public var reflectType:String="bitmapData" ;
		public var frameRate:int ;
		public var totalFrame:int ;
		public var offsetX:int ;
		public var offsetY:int ;
		public var priority:int = 1 ;
		public var actions:Vector.<ActionVO> ;
	}
}