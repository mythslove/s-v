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
	public class GreenLengthButton extends Button
	{
		public var txtLabel:BitmapTextField;
		
		public function GreenLengthButton()
		{
			super();
			txtLabel.size = "22";
			txtLabel.filters = [ new GlowFilter(0x44946a,1,3,3,20)];
		}
	}
}