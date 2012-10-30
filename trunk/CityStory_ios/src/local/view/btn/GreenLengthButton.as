package local.view.btn
{
	import flash.filters.GlowFilter;
	
	import local.util.TextStyle;
	import local.view.control.BitmapTextField;
	import local.view.control.Button;
	
	/**
	 * 比较长的绿色按钮  
	 * @author zhouzhanglin
	 */	
	public class GreenLengthButton extends LabelButton
	{
		public function GreenLengthButton()
		{
			super();
		}
		
		override public function setStyle():void
		{
			txtLabel.size = "20";
			txtLabel.filters = [ new GlowFilter(0x44946a,1,4,4,20)];
		}
	}
}