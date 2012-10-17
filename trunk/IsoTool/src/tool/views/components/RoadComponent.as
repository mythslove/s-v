package  tool.views.components
{
	import bing.utils.ContainerUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import tool.comm.Setting;
	
	public class RoadComponent extends Sprite
	{
		public var bmd:BitmapData ;
		
		public var rightX:int ; //正确的位置
		public var rightY:int ;
		
		public function RoadComponent()
		{
			super();
			mouseChildren = false ;
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			rightX = x ;
			rightY = y ;
			x  -= Setting.SIZE ;
			y  -=Setting.SIZE*0.5  ;
		}
		
		public function loadRoad( url:String ):void
		{
			ContainerUtil.removeChildren(this);
			bmd = null ;
			if(url)
			{
				var file:File = new File(url);
				if(file.exists)
				{
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , loadErrorHandler );
					loader.contentLoaderInfo.addEventListener( Event.COMPLETE , loadedHandler );
					loader.load( new URLRequest(url));
				}
			}
		}
		
		public function showRoad( x:int , y:int , bitmapData:BitmapData ):void
		{
			this.x = rightX+x ;
			this.y = rightY+y ;
			this.bmd = bitmapData ;
			addChild(new Bitmap(bmd));
		}
		
		public function clear():void
		{
			ContainerUtil.removeChildren(this);
			bmd = null ;
		}
		
		
		private function loadedHandler( e:Event ):void
		{
			var loader:Loader = e.target.loader ;
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR , loadErrorHandler );
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE , loadedHandler );
			var bmp:Bitmap = loader.content as Bitmap ;
			addChild(bmp);
			bmd = bmp.bitmapData ;
		}
		
		private function loadErrorHandler( e:IOErrorEvent ):void
		{
			e.target.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR , loadErrorHandler );
			e.target.loader.contentLoaderInfo.removeEventListener( Event.COMPLETE , loadedHandler );
		}
	}
}