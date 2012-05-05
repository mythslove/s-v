package local.views.loading
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class BaseStepLoading extends Sprite
	{
		public var txtProgress:TextField;
		public var bar:Sprite ;
		//=======================
		
		public function BaseStepLoading()
		{
			super();
			mouseChildren = mouseEnabled = false ;
		}
		
		public function setValue(current:int , sum:int ):void
		{
			bar.scaleX = current/sum ;
		}
	}
}