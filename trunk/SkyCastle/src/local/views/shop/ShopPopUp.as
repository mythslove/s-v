package local.views.shop
{
	import bing.res.ResVO;
	
	import flash.events.Event;
	
	import local.utils.ResourceUtil;
	import local.views.BaseView;

	/**
	 * 商店弹窗 
	 * @author zzhanglin
	 */	
	public class ShopPopUp extends BaseView
	{
		private const SKIN:String= "shopSkin";
		
		override protected function added():void
		{
			ResourceUtil.instance.addEventListener(SKIN , skinLoadedHandler );
			ResourceUtil.instance.loadRes( new ResVO(SKIN,"res/skin/shop.swf"));
		}
		
		private function skinLoadedHandler( e:Event ):void
		{
			addChild(new ShopPopUpSkin());
		}
		
		override protected function removed():void
		{
			ResourceUtil.instance.removeEventListener(SKIN , skinLoadedHandler );
		}
	}
}