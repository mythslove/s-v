package local.views.base
{
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import local.utils.ResourceUtil;
	
	public class Thumb extends Bitmap
	{
		private var _resId:String;
		private var _url:String;
		
		/**
		 * @param resId
		 * @param url
		 * @param tempBmd 加载时临时显示的图像
		 */		
		public function Thumb( resId:String , url:String , tempBmd:BitmapData = null )
		{
			super();
			this._resId = resId ;
			this._url = url ;
			this.bitmapData = tempBmd ;
			addEventListener(Event.ADDED_TO_STAGE , added );
		}
		
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , added);
			addEventListener(Event.REMOVED_FROM_STAGE , removed );
			
			//加载图片资源
			ResourceUtil.instance.addEventListener( _resId , loadedHandler );
			ResourceUtil.instance.loadRes( new ResVO(_resId , _url));
		}
		
		private function loadedHandler(e:Event):void
		{
			ResourceUtil.instance.removeEventListener( _resId , loadedHandler );
			this.bitmapData=ResourceUtil.instance.getResVOByResId(_resId).resObject as BitmapData;
		}
		
		private function removed(e:Event):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , removed );
			ResourceUtil.instance.removeEventListener( _resId , loadedHandler );
		}
	}
}