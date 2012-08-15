package local.views.effects
{
	import flash.display.MovieClip;
	
	public class MouseClickEffect extends MovieClip
	{
		public function MouseClickEffect()
		{
			super();
			mouseEnabled = mouseChildren  = false ;
			addFrameScript( this.totalFrames-1 , end );
		}
		
		private function end():void
		{
			this.stop();
			if(parent)parent.removeChild(this);
		}
	}
}