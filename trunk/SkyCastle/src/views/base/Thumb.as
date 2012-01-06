package views.base
{
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import utils.ResourceUtil;
	
	public class Thumb extends Bitmap
	{
		private var _alias:String;
		private var _url:String;
		
		/**
		 * @param alias
		 * @param url
		 * @param tempBmd 加载时临时显示的图像
		 */		
		public function Thumb( alias:String , url:String , tempBmd:BitmapData = null )
		{
			super();
			this._alias = alias ;
			this._url = url ;
			this.bitmapData = tempBmd ;
			addEventListener(Event.ADDED_TO_STAGE , added );
		}
		
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , added);
			addEventListener(Event.REMOVED_FROM_STAGE , removed );
			
			//加载图片资源
			ResourceUtil.instance.addEventListener( _alias , loadedHandler );
			ResourceUtil.instance.loadRes( new ResVO(_alias , _url));
		}
		
		private function loadedHandler(e:Event):void
		{
			ResourceUtil.instance.removeEventListener( _alias , loadedHandler );
			this.bitmapData=ResourceUtil.instance.getResVOByName(_alias).resObject as BitmapData;
		}
		
		private function removed(e:Event):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , removed );
			ResourceUtil.instance.removeEventListener( _alias , loadedHandler );
		}
	}
}