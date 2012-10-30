package local.util
{
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import local.view.control.BitmapTextField;

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
		
		
		
		public static var blueGlowFilters:Array = [ new GlowFilter(0x007ab6,1,4,4,12)];
		
		public static var yellowGlowFilters:Array = [ new GlowFilter(0xae7000,1,4,4,12)];
		
		public static var greenGlowFilters:Array = [ new GlowFilter(0x009345,1,4,4,12)];
		
		
		//tabMenu标题样式 ========================
		public static var tabDefaultGlowfilters:Array=[ new GlowFilter(0x3082ab,1,4,4,20)];
		public static var tabSeletectedGlowfilters:Array=[ new GlowFilter(0xAE7000,1,4,4,20)];
		public static function setTabMenuFormat( tf:BitmapTextField ):void{
			var format:TextFormat = tf.defaultTextFormat ;
			format.font = "Verdana";//Trebuchet MS
			format.bold = true ;
			format.size = 17 ;
			format.letterSpacing = 0 ;
			format.color = 0xffffff ;
			format.align = TextAlign.CENTER ;
			tf.defaultTextFormat = format ;
			tf.filters = tabDefaultGlowfilters ;
		}
		
		
		
		
		
		
		
		/**
		 * 设置按钮的样式 
		 * @param tf
		 * @param color
		 * @param size
		 */		
		public static function setWhiteGropFilter( tf:BitmapTextField ,color:int = 0xffffff , size:int=20 ):void
		{
			var format:TextFormat = tf.defaultTextFormat ;
			format.font = "Verdana";
			format.size = size ;
			format.bold = true ;
			format.color = color ;
			format.bold = true ;
			format.letterSpacing = 0 ;
			format.align = TextAlign.CENTER ;
			tf.filters = grayDropFilters ;
			tf.defaultTextFormat = format ;
		}
	}
}