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
		private var _probar:Scale3Image ;
		
		public function LevelBar()
		{
			touchable = false ;
			
			var texture:Scale3Textures = new Scale3Textures(EmbedManager.getUITexture("ExpBarBg"),20,10);
			var scale3Img:Scale3Image = new Scale3Image(texture) ;
			scale3Img.x = 20 ;
			scale3Img.y = 23 ;
			scale3Img.width = 150 ;
			addChild(scale3Img);
			
			texture = new Scale3Textures(EmbedManager.getUITexture("ExpLoadingBar"),20,10);
			_probar = new Scale3Image(texture);
			_probar.x = scale3Img.x  ;
			_probar.y = scale3Img.y  ;
			_probar.width = scale3Img.width/2 ;
			addChild(_probar);
			
			var iconScale:Number = 0.7 ;
			var img:Image = EmbedManager.getUIImage("ExpIcon");
			img.pivotX = img.width>>1 ;
			img.pivotY = img.height>>1 ;
			img.scaleX = img.scaleY = iconScale;
			img.y = img.pivotY*iconScale + 5 ;
			addChild(img);
			
			_tf = new TextField(120,scale3Img.height,"100/300","Verdana",23,0xffffff,true);
			_tf.x = 35;
			_tf.y = 22 ;
			_tf.vAlign = VAlign.CENTER ;
			_tf.hAlign = HAlign.LEFT ;
			addChild( _tf );
			
			_lv = new TextField(img.width*iconScale , scale3Img.height,"13","TitleFont",35,0x663100 ,false);
			_lv.x = img.x - img.width*0.5*iconScale;
			_lv.y = _tf.y ;
			_lv.vAlign = VAlign.CENTER ;
			_lv.hAlign = HAlign.CENTER ;
			addChild( _lv );
		}
	}
}