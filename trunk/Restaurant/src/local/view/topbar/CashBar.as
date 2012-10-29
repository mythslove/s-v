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
	
	public class CashBar extends Sprite
	{
		private var _tf:TextField ;
		
		public function CashBar()
		{
			super();
			
			var texture:Scale3Textures = new Scale3Textures(EmbedManager.getUITexture("TopbarDefaultBG"),20,10);
			var scale3Img:Scale3Image = new Scale3Image(texture) ;
			scale3Img.y = 10 ;
			scale3Img.width = 180 ;
			addChild(scale3Img);
			
			var img:Image = EmbedManager.getUIImage("CashIcon");
			img.pivotX = img.width>>1 ;
			img.pivotY = img.height>>1 ;
			img.scaleX = img.scaleY = 0.8 ;
			img.y = img.pivotY*0.8 + 5 ;
			addChild(img);
			
			_tf = new TextField(130,scale3Img.height,"300","Verdana",25,0xffffff,true);
			_tf.x = 50;
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