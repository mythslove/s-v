package local.util
{
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	public class TextStyle
	{
		
		/**
		 * 黑色描边 
		 */		
		public static var blackGlowfilters:Array=[ new GlowFilter(0,1,4,4,12)];
		
		/**
		 * 灰色阴影 
		 */		
		public static var grayDropFilters:Array = [new DropShadowFilter(3,90,0,0.5,2,2)];
	}
}