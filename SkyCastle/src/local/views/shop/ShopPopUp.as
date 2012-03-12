package local.views.shop
{
	import bing.res.ResVO;
	
	import flash.events.Event;
	
	import local.comm.GameSetting;
	import local.utils.ResourceUtil;
	import local.views.BaseView;
	import local.views.loading.SkinLoading;

	/**
	 * 商店弹窗 
	 * @author zzhanglin
	 */	
	public class ShopPopUp extends BaseView
	{
		private const SKIN:String= "shopSkin";
		private var _skinLoading:SkinLoading ;
		
		override protected function added():void
		{
			_skinLoading = new SkinLoading();
			_skinLoading.x = GameSetting.SCREEN_WIDTH>>1;
			_skinLoading.y = GameSetting.SCREEN_HEIGHT>>1;
			addChild(_skinLoading);
			
			ResourceUtil.instance.addEventListener(SKIN , skinLoadedHandler );
			ResourceUtil.instance.loadRes( new ResVO(SKIN,"res/skin/shop.swf"));
		}
		
		private function skinLoadedHandler( e:Event ):void
		{
			removeChild(_skinLoading);
			addChild(new ShopPopUpSkin());
		}
		
		override protected function removed():void
		{
			_skinLoading =null;
			ResourceUtil.instance.removeEventListener(SKIN , skinLoadedHandler );
		}
	}
}