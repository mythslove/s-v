package local.view.shop
{
	import flash.display.MovieClip;
	
	import local.comm.GameSetting;
	import local.view.control.Button;
	
	/**
	 * 商店OverView界面中的按钮基类 
	 * @author zhouzhanglin
	 */	
	public class ShopOverViewButton extends Button
	{
		public var text:MovieClip ;
		
		public function ShopOverViewButton()
		{
			super();
			text.stop();
			text.gotoAndStop(GameSetting.local);
		}
	}
}