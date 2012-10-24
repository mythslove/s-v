package local.view.base
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class Thumb extends Bitmap
	{
		protected var _url:String;
		protected var _scale:Number ;
		protected var _isCenter:Boolean;
		protected var _loader:Loader ;
		public function get url():String{
			return _url ;
		}
		
		public function Thumb(  url:String , scale:Number = 1.0  )
		{
			super();
			this._url = url ;
			this._scale = scale;
			addEventListener(Event.ADDED_TO_STAGE , added );
		}
		
		public function center():void
		{
			_isCenter = true ;
		}
		
		protected function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , added);
			addEventListener(Event.REMOVED_FROM_STAGE , removed );
			
			//加载图片资源
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , errorHandler);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE  , loadedHandler );
			_loader.load( new URLRequest(_url));
		}
		
		private function errorHandler(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		protected function loadedHandler( e:Event):void
		{
			this.bitmapData = (_loader.content as Bitmap).bitmapData;
			scaleX = scaleY  = _scale ;
			if(_isCenter){
				x=-(width>>1);
				y=-(height>>1);
			}
		}
		
		public function scale( value:Number ):void
		{
			if(bitmapData){
				scaleX = scaleY  = value ;
				if(_isCenter){
					x=-(width>>1);
					y=-(height>>1);
				}
			}else{
				_scale = value ;
			}
		}
		
		protected function removed(e:Event):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , removed );
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR , errorHandler);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE  , loadedHandler );
			_loader.unloadAndStop();
			_loader = null ;
			if(bitmapData){
				bitmapData.dispose();
			}
		}
	}
}