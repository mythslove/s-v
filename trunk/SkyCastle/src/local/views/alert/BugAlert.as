package local.views.alert
{
	import bing.components.button.BaseButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import local.comm.GameSetting;
	/**
	 * 有bug的提示框，然后重新加载页面 
	 * @author zhouzhanglin
	 */	
	public class BugAlert extends Sprite
	{
		public var btnOk:BaseButton;
		
		public function BugAlert()
		{
			super();
			x = GameSetting.SCREEN_WIDTH>>1 ;
			y = GameSetting.SCREEN_HEIGHT>>1 ;
			btnOk.addEventListener(MouseEvent.CLICK , onClickHandler );
		}
		
		private function onClickHandler( e:MouseEvent):void
		{
			e.stopPropagation();
			mouseChildren = false ;
			ExternalInterface.call("function(){location.reload() ;}");
		}
	}
}