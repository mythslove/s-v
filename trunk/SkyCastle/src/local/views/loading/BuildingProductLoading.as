package local.views.loading
{
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * 生产的进度条
	 * @author zzhanglin
	 */	
	public class BuildingProductLoading extends BaseStepLoading
	{
		override public function setValue(current:int , sum:int ):void
		{
			super.setValue(current,sum);
			txtProgress.text = "used "+current+"/"+sum ;
		}
	}
}