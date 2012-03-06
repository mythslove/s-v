package local.views.effects
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class MapWordEffectWhite extends MovieClip
	{
		public var mcInfo:Sprite ;
		//=============================
		
		public function MapWordEffectWhite( info:String = null )
		{
			super();
			mouseChildren = false ;
			mouseEnabled = false ;
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