package local.util
{
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;

	public class StyleSetting
	{
		private static var _instance:StyleSetting ;
		public static function get instance():StyleSetting {
			if(!_instance) _instance = new StyleSetting();
			return _instance;
		}
		//=======================================
		
		public  var verdana:BitmapFont ;
		
		public var btnLabelTextFormat:BitmapFontTextFormat ;
		
		
		
		private  var _verdanaRender:BitmapFontTextRenderer ;
		
		public  function init():void
		{
			verdana = new BitmapFont( EmbedManager.getUITexture("Verdana"),EmbedManager.verdana_fnt );
			EmbedManager.verdana_fnt = null ;
			TextField.registerBitmapFont( verdana , "Verdana" );
			
			btnLabelTextFormat = new BitmapFontTextFormat(verdana,30) ;
			_verdanaRender = new BitmapFontTextRenderer();
		}
		
		public function verdanaRenderFactory():BitmapFontTextRenderer { return _verdanaRender; }
	}
}