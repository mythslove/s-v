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
		
		
		/**
		 * tabMenu标题样式 
		 * @param tf
		 */		
		public static function setTabMenuFormat( tf:BitmapTextField ):void{
			var format:TextFormat = tf.defaultTextFormat ;
			format.font = "Verdana";
			format.size = 20 ;
			format.color = 0xffffff ;
			tf.filters = blackGlowfilters ;
			tf.bold = true ;
			tf.align = TextAlign.CENTER ;
			tf.defaultTextFormat = format ;
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
			format.color = color ;
			tf.filters = grayDropFilters ;
			tf.bold = true ;
			tf.align = TextAlign.CENTER ;
			tf.defaultTextFormat = format ;
		}
	}
}