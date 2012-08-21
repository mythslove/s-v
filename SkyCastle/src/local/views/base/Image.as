package local.views.base
{
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import local.utils.ResourceUtil;
	import local.views.loading.LoaderSmall;
	
	public class Image extends BaseView
	{
		private var _resId:String;
		private var _url:String;
		private var _bitmap:Bitmap;
		private var _isCenter:Boolean;
		private var _showLoading:Boolean;
		private var _smallLoading:LoaderSmall;
		
		/**
		 * @param resId
		 * @param url
		 * @param tempBmd 加载时临时显示的图像
		 */		
		public function Image( resId:String , url:String , isCenter:Boolean = true , showLoading:Boolean= true  )
		{
			super();
			this._resId = resId ;
			this._url = url ;
			this._isCenter = isCenter; 
			this._showLoading = showLoading ;
		}
		
		override protected function added():void
		{
			if(_showLoading){
				_smallLoading = new LoaderSmall();
				addChild(_smallLoading);
			}
			//加载图片资源
			if(ResourceUtil.instance.checkResLoaded(_resId)){
				loadedHandler(null);
			}else{
				ResourceUtil.instance.addEventListener( _resId , loadedHandler );
				ResourceUtil.instance.loadRes( new ResVO(_resId , _url));
			}
		}
		
		private function loadedHandler(e:Event):void
		{
			removeSmallLoading();
			_bitmap = new Bitmap(ResourceUtil.instance.getResVOByResId(_resId).resObject as BitmapData);
			if(_isCenter){
				_bitmap.x = -_bitmap.width>>1;
				_bitmap.y = - _bitmap.height>>1;
			}
			addChild(_bitmap);
		}
		
		private function removeSmallLoading():void{
			if(_smallLoading){
				_smallLoading.stop();
				if(_smallLoading.parent){
					_smallLoading.parent.removeChild(_smallLoading);
					_smallLoading = null ;
				}
			}
		}
		
		override protected function removed():void
		{
			ResourceUtil.instance.removeEventListener( _resId , loadedHandler );
			_bitmap = null ;
			removeSmallLoading();
		}
	}
}