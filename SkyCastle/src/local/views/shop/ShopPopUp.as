package local.views.shop
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	import local.comm.GameSetting;
	import local.views.BaseView;

	/**
	 * 商店弹窗 
	 * @author zzhanglin
	 */	
	public class ShopPopUp extends BaseView
	{
		public var tabMenu:ShopMainTab;
		public var container:Sprite ;
		//==============================
		
		public function ShopPopUp()
		{
			super();
		}
		
		override protected function added():void
		{
			x = GameSetting.SCREEN_WIDTH>>1;
			y = GameSetting.SCREEN_HEIGHT>>1;
			TweenLite.from(this,0.2,{x:-GameSetting.SCREEN_WIDTH});
		}
		
		override protected function removed():void
		{
			
		}
	}
}