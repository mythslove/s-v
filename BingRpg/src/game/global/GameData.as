package game.global
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.elements.items.Hero;

	public class GameData
	{
		public static var baseURL:String = "../assets/";
		
		public static var basePoint:Point =new Point();
		
		public static var hero:Hero ;
		
		/** 当前屏幕位置 */
		public static var screenRect:Rectangle = new Rectangle();
	}
}