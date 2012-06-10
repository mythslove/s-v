package local.views.loading
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * 显示步数的进度条 
	 * @author zzhanglin
	 */	
	public class BuildingStepLoading extends BaseStepLoading
	{
		override public function setValue(current:int , sum:int ):void
		{
			bar.scaleX = current/sum ;
		}
	}
}