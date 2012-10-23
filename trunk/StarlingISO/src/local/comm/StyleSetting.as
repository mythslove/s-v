package local.comm
{
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import local.util.EmbedManager;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class StyleSetting
	{
		
		
		public static const POPUPBG :String= "popupbg";
		
		public static const SHOPITEMBGUP :String= "ShopItemBgUp";
		
		public static const POPUPCLOSEBUTTONUP:String = "PopUpCloseButtonUp";
		
		
		
		//tabButton
		public static const tabButtonUpTexture:Scale3Textures = new Scale3Textures(EmbedManager.getUITexture("TabButtonUp"),10*GameSetting.GAMESCALE,10*GameSetting.GAMESCALE) ;
		public static function TAB_UP_SKIN():Scale3Image{ return new Scale3Image( tabButtonUpTexture);  }
		
		public static const tabButtonDownTexture:Scale3Textures = new Scale3Textures(EmbedManager.getUITexture("TabButtonDown"),10*GameSetting.GAMESCALE,10*GameSetting.GAMESCALE) ;
		public static function TAB_DOWN_SKIN():Scale3Image{ return new Scale3Image( tabButtonDownTexture ); }
		
		public static const tabButtonSelectedTexture:Scale3Textures = new Scale3Textures(EmbedManager.getUITexture("TabButtonSelected"),10*GameSetting.GAMESCALE,10*GameSetting.GAMESCALE) ;
		public static function TAB_SELECTED_BUTTON():Scale3Image{ return new Scale3Image( tabButtonSelectedTexture ); }
		
		
		//shopItemBg
		public static const shopItemBgUpTexture:Scale9Textures = new Scale9Textures(EmbedManager.getUITexture("ShopItemBgUp"),new Rectangle(10*GameSetting.GAMESCALE,10*GameSetting.GAMESCALE,10*GameSetting.GAMESCALE,10*GameSetting.GAMESCALE)) ;
		public static function SHOP_ITEM_BG_UP():Scale9Image{ return new Scale9Image(  shopItemBgUpTexture ); }
		
		
		//弹窗的关闭按钮 
		public static const popupCloseBtnTexture:Texture = EmbedManager.getUITexture("PopUpCloseButtonUp");
		public static function POPUP_CLOSE_BTN():Image{ return new Image(popupCloseBtnTexture) ;}
		
		public static const StorageTabBtnUpTexutre:Texture = EmbedManager.getUITexture("StorageMenuButtonUp") ;
		public static const StorageTabBtnSelectedTexutre:Texture = EmbedManager.getUITexture("StorageMenuButtonSelected") ;
	}
}