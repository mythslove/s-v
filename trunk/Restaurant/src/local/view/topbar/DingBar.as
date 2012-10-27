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
	
	public class DingBar extends Sprite
	{
		private var _tf:TextField ;
		
		public function DingBar()
		{
			touchable = false ;
			
			var texture:Scale3Textures = new Scale3Textures(EmbedManager.getUITexture("TopbarDefaultBG"),20,10);
			var scale3Img:Scale3Image = new Scale3Image(texture) ;
			scale3Img.y = 10 ;
			scale3Img.width = 150 ;
			addChild(scale3Img);
			
			var img:Image = EmbedManager.getUIImage("DingIcon");
			img.pivotX = img.width>>1 ;
			img.pivotY = img.height>>1 ;
			img.scaleX = img.scaleY = 0.7;
			img.y = img.pivotY*0.7 + 5 ;
			addChild(img);
			
			_tf = new TextField(120,scale3Img.height,"100","Verdana",30,0xffffff,true);
			_tf.x = 35;
			_tf.y = 10 ;
			_tf.vAlign = VAlign.CENTER ;
			_tf.hAlign = HAlign.LEFT ;
			addChild( _tf );
		}
		
		public function show(value:int ):void
		{
			
		}
	}
}