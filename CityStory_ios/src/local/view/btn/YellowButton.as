package local.view.btn
{
	import local.util.TextStyle;

	/**
	 * 默认字体大小为24 
	 * @author zhouzhanglin
	 * 
	 */	
	public class YellowButton extends LabelButton
	{
		public function YellowButton()
		{
			super();
		}
		
		override public function setStyle():void
		{
			txtLabel.size="24";
			txtLabel.filters= TextStyle.yellowGlowFilters ;
		}
	}
}