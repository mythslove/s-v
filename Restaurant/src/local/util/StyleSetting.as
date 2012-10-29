package local.util
{
	import feathers.controls.Button;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.display.Scale3Image;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import local.view.shop.ShopBar;
	
	import starling.display.Image;
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
		public var titleFont:BitmapFont ;
		
		public var btnLabelTextFormat:BitmapFontTextFormat ;
		
		private  var _bitmapFontRender:BitmapFontTextRenderer =new BitmapFontTextRenderer(); 
		
		public var popup1Texture:Scale9Textures ;
		public var popup2Texture:Scale9Textures ;
		
		public var button1Texture:Scale3Textures ;
		public var button2Texture:Scale3Textures ;
		
		public var grayBgTexture:Scale9Textures ;
		
		public  function init():void
		{
			verdana = new BitmapFont( EmbedManager.getUITexture("Verdana"),EmbedManager.verdana_fnt );
			EmbedManager.verdana_fnt = null ;
			TextField.registerBitmapFont( verdana , "Verdana" );
			
			titleFont = new BitmapFont( EmbedManager.getUITexture("TitleFont"),EmbedManager.titleFont_fnt );
			EmbedManager.titleFont_fnt = null ;
			TextField.registerBitmapFont( titleFont , "TitleFont" );
			
			
			btnLabelTextFormat = new BitmapFontTextFormat(verdana,30) ;
			
			popup1Texture = new Scale9Textures(EmbedManager.getUITexture("PopUpBg1"),new Rectangle(82,73,30,37));
			popup2Texture = new Scale9Textures(EmbedManager.getUITexture("PopUpBg2"),new Rectangle(58,47,46,32));
		
			button1Texture = new Scale3Textures(EmbedManager.getUITexture("Button1") , 10 , 30 );
			button2Texture = new Scale3Textures(EmbedManager.getUITexture("Button2") , 10 , 30 );
			
			grayBgTexture = new Scale9Textures(EmbedManager.getUITexture("GrayBg") , new Rectangle(30,30,20,20) );
		}
		
		public function bitmapFontRenderFactory():BitmapFontTextRenderer { return _bitmapFontRender; }
		
		public function tabInitializer(tab:Button , item:Object ):void
		{
			tab.defaultSkin = new Image(EmbedManager.getUITexture("TabMenuDefaultBg"));
			tab.selectedUpSkin =new Image(EmbedManager.getUITexture("TabMenuSelectedBg"));
			switch(item.toString()){
				case ShopBar.TAB_WALL_PAPER:
					tab.defaultIcon = EmbedManager.getUIImage("WPaperIcon");
					break ;
				case ShopBar.TAB_WALL_DECO:
					tab.defaultIcon = EmbedManager.getUIImage("WDecoIcon");
					break ;
				case ShopBar.TAB_TABLE:
					tab.defaultIcon = EmbedManager.getUIImage("TabelIcon");
					break ;
				case ShopBar.TAB_FLOOR:
					tab.defaultIcon = EmbedManager.getUIImage("FloorIcon");
					break ;
				case ShopBar.TAB_CHAIR:
					tab.defaultIcon = EmbedManager.getUIImage("ChairIcon");
					break ;
				case ShopBar.TAB_DECOR:
					tab.defaultIcon = EmbedManager.getUIImage("DecorIcon");
					break ;
				case ShopBar.TAB_STOVE:
					tab.defaultIcon = EmbedManager.getUIImage("StoveIcon");
					break ;
				case ShopBar.TAB_COUNTER:
					tab.defaultIcon = EmbedManager.getUIImage("CounterIcon");
					break ;
					
			}
		}
		
	}
}