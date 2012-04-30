package local.views.pickup
{
	import bing.components.button.BaseButton;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import local.comm.GameSetting;
	import local.views.BaseView;

	/**
	 * 建筑完成时需要的材料窗口 
	 * @author zzhanglin
	 */	
	public class BuildCompleteMaterialPopUp extends BaseView
	{
		public var txtBtn:TextField;
		public var btn:BaseButton;
		public var btnClose:BaseButton;
		public var container:Sprite;
		//==========================
		public var result:Boolean ; //是否能全部通过
		public var costCash:int ; //最后要花多少钱
		
		public function BuildCompleteMaterialPopUp()
		{
			super();
			txtBtn.mouseEnabled=false ;
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
			container.visible=false;
		}
		
		override protected function added():void
		{
			btnClose.addEventListener(MouseEvent.CLICK , onClickCloseHandler );
		}
		
		private function onClickCloseHandler (e:MouseEvent):void
		{
			e.stopPropagation();
			TweenLite.from(this,0.3,{x:-200 , ease:Back.easeOut , onComplete:inTweenOver });
		}
		
		private function inTweenOver():void
		{
			container.visible=true ;
		}
		
		override protected function removed():void
		{
			btnClose.removeEventListener(MouseEvent.CLICK , onClickCloseHandler );
		}
	}
}