package local.views.loading
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class BuildingStepLoading extends Sprite
	{
		public var bar:Sprite ;
		public var txtLoading:TextField;
		//==================
		
		public function BuildingStepLoading()
		{
			super();
		}
		
		public function setValue(current:int , sum:int ):void
		{
			txtLoading.text = current+" / "+sum ;
			bar.scaleX = current/sum ;
		}
	}
}