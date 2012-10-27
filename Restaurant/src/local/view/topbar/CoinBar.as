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

	public class CoinBar extends Sprite
	{
		private var _tf:TextField ;
		
		public function CoinBar()
		{
			super();
			
			var texture:Scale3Textures = new Scale3Textures(EmbedManager.getUITexture("TopbarDefaultBG"),20,10);
			var scale3Img:Scale3Image = new Scale3Image(texture) ;
			scale3Img.y = 10 ;
			scale3Img.width = 180 ;
			addChild(scale3Img);
			
			var img:Image = EmbedManager.getUIImage("CoinIcon");
			img.pivotX = img.width>>1 ;
			img.pivotY = img.height>>1 ;
			img.scaleX = img.scaleY = 0.6;
			img.y = img.pivotY*0.6 + 5 ;
			addChild(img);
			
			_tf = new TextField(150,scale3Img.height,"40,000","Verdana",30,0xffffff,true);
			_tf.x = 35;
			_tf.y = 10 ;
			_tf.touchable = false ;
			_tf.vAlign = VAlign.CENTER ;
			_tf.hAlign = HAlign.LEFT ;
			addChild( _tf );
		}
		
		public function show( value:int ):void
		{
		}
	}
}