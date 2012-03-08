package local.views.effects
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MapWordEffect extends MovieClip
	{
		public var mcInfo:Sprite ;
		//=============================
		public static const RED:uint = 0xff0000 ;
		public static const WHITE:uint = 0xffffff ;
		
		
		public function MapWordEffect( info:String = null , color:uint= RED )
		{
			super();
			mouseChildren = false ;
			mouseEnabled = false ;
			
			var format:TextFormat = new TextFormat();
			format.color = color ;
			(mcInfo["txtInfo"] as TextField).defaultTextFormat = format ;
			mcInfo["txtInfo"].text = info ;
			addFrameScript( totalFrames-1 , removeFromParent);
		}
		
		private function removeFromParent():void
		{
			stop() ;
			if(parent){
				parent.removeChild(this);
			}
		}
	}
}