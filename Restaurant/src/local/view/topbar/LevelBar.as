package local.view.topbar
{
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import local.util.EmbedManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class LevelBar extends Sprite
	{
		private var _tf:TextField ;
		private var _lv:TextField ;
		private var _lvShadow:TextField ;
		private var _probar:Scale3Image ;
		
		public function LevelBar()
		{
			touchable = false ;
			
			var texture:Scale3Textures = new Scale3Textures(EmbedManager.getUITexture("ExpBarBg"),20,10);
			var scale3Img:Scale3Image = new Scale3Image(texture) ;
			scale3Img.x = 20 ;
			scale3Img.y = 16 ;
			scale3Img.width = 180 ;
			addChild(scale3Img);
			
			texture = new Scale3Textures(EmbedManager.getUITexture("ExpLoadingBar"),20,10);
			_probar = new Scale3Image(texture);
			_probar.x = scale3Img.x  ;
			_probar.y = scale3Img.y  ;
			_probar.width = scale3Img.width/2 ;
			addChild(_probar);
			
			var iconScale:Number = 0.6 ;
			var img:Image = EmbedManager.getUIImage("ExpIcon");
			img.pivotX = img.width>>1 ;
			img.pivotY = img.height>>1 ;
			img.scaleX = img.scaleY = iconScale;
			img.y = img.pivotY*iconScale + 5 ;
			addChild(img);
			
			_tf = new TextField(150,scale3Img.height,"100/300","Verdana",23,0xffffff,true);
			_tf.x = 35;
			_tf.y = 17 ;
			_tf.vAlign = VAlign.CENTER ;
			_tf.hAlign = HAlign.CENTER ;
			addChild( _tf );
			
			_lvShadow = new TextField(img.width*iconScale+5 , scale3Img.height+5 ,"5","TitleFont",38, 0 ,false);
			_lvShadow.x = img.x - img.width*0.5*iconScale-1;
			_lvShadow.y = _tf.y-1 ;
			_lvShadow.vAlign = VAlign.CENTER ;
			_lvShadow.hAlign = HAlign.CENTER ;
			addChild( _lvShadow );
			
			_lv = new TextField(img.width*iconScale , scale3Img.height,"5","TitleFont",32,0xffffff ,false);
			_lv.x = img.x - img.width*0.5*iconScale;
			_lv.y = _tf.y ;
			_lv.vAlign = VAlign.CENTER ;
			_lv.hAlign = HAlign.CENTER ;
			addChild( _lv );
			
		}
	}
}