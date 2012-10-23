package local.comm
{
	import feathers.display.Scale9Image;
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
		public static const tabButtonUpTexture:Texture = EmbedManager.getUITexture("TabMenuButtonUp") ;
		public static function TAB_UP_SKIN():Image{ return new Image( tabButtonUpTexture);  }
		
		public static const tabButtonSelectedTexture:Texture = EmbedManager.getUITexture("TabMenuButtonSelected") ;
		public static function TAB_SELECTED_SKIN():Image{ return new Image( tabButtonSelectedTexture ); }
		
		
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