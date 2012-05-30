package local.views.base
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import local.views.loading.LoaderSmall;

	/**
	 * 自动加载和自动释放资源的图片 
	 * @author zhouzhanglin
	 */	
	public class AutoImage extends BaseView
	{
		private var _url:String;
		private var _bitmap:Bitmap;
		private var _isCenter:Boolean;
		private var _showLoading:Boolean;
		private var _smallLoading:LoaderSmall;
		private var _wid:Number , _het:Number;
		private var _loader:Loader ;
		
		
		public function AutoImage( url:String , isCenter:Boolean = true , showLoading:Boolean= true , wid:Number = NaN , het:Number = NaN )
		{
			super();
			this._url = url ;
			this._isCenter = isCenter; 
			this._showLoading = showLoading ;
			this._wid = wid ;
			this._het = het ;
		}
		
		override protected function added():void
		{
			if(_showLoading){
				_smallLoading = new LoaderSmall();
				addChild(_smallLoading);
			}
			//加载图片资源
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , loadedHandler );
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
			_loader.load( new URLRequest(_url));
		}
		
		private function loadedHandler(e:Event):void
		{
			removeSmallLoading();
			if(_isCenter){
				_bitmap.x = -_bitmap.width>>1;
				_bitmap.y = - _bitmap.height>>1;
			}
			addChild(_bitmap);
			if(_wid) this.width=_wid ;
			if(_het) this.height = _het ;
		}
		
		private function ioErrorHandler( e:IOErrorEvent):void
		{
			removeSmallLoading();
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
			if(_loader){
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE , loadedHandler );
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR , ioErrorHandler );
				_loader.unloadAndStop();
			}
			_bitmap = null ;
			removeSmallLoading();
		}
	}
}