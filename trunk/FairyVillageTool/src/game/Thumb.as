package game
{
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class Thumb extends Bitmap
	{
		private var _alias:String;
		private var _url:String;
		private var _scale:Number ;
		private var _isCenter:Boolean;
		
		/**
		 * @param alias
		 * @param url
		 * @param scale 缩放
		 * @param tempBmd 加载时临时显示的图像
		 */		
		public function Thumb( alias:String , url:String , scale:Number = 1.0 ,  tempBmd:BitmapData = null )
		{
			super();
			this._alias = alias ;
			this._url = url ;
			this._scale = scale;
			this.bitmapData = tempBmd ;
			addEventListener(Event.ADDED_TO_STAGE , added );
		}
		
		public function center():void
		{
			_isCenter = true ;
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
			this.bitmapData=ResourceUtil.instance.getResVOByResId(_alias).resObject as BitmapData;
			scaleX = scaleY  = _scale ;
			if(_isCenter){
				x=-(width>>1);
				y=-(height>>1);
			}
		}
		
		private function removed(e:Event):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , removed );
			ResourceUtil.instance.removeEventListener( _alias , loadedHandler );
		}
	}
}