package local.views.loading
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class BuildingStepLoading extends Sprite
	{
		public var bar:Sprite ;
		//==================
		
		public function BuildingStepLoading()
		{
			super();
		}
		
		public function setValue(current:int , sum:int ):void
		{
			bar.scaleX = current/sum ;
		}
	}
}