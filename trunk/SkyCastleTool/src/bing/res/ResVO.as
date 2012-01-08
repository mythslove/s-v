package bing.res
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;

	public class ResVO
	{
		public function ResVO( name:String="" , url:String="" )
		{
			this.name =name ;
			this.url = url ;
		}
		public var name:String ; //文件名或反射类名
		public var url:String ; //资源文件地址
		public var resType:String ; //资源类型
		public var resObject:Object ; //下载完成后的资源
		public var reflectType:String;//反射类型
		public var priority:int = 1;//下载的优先级
		
		public var num:int =1 ; //swf中的数量
		public var row:int =1 ;
		public var col:int =1  ;
		public var frames:int =1 ;
		public var loadError:int = 0 ;//计算加载错误/	错误的次数
		
		
		public function toString():String
		{
			return name+"  "+url ;
		}
		
		public function dispose():void 
		{
			if(resObject is Bitmap)
			{
				if((resObject as Bitmap).bitmapData)
				{
					(resObject as Bitmap).bitmapData.dispose();
				}
			}
			else if( resObject is Vector.<BitmapData>)
			{
				var bmds:Vector.<BitmapData> = resObject as Vector.<BitmapData>;
				for each( var bmd:BitmapData in bmds)
				{
					bmd.dispose();
				}
				bmds = null ;
			}
			else if( resObject is Loader)
			{
				(resObject as Loader).unloadAndStop(true);
			}
			resObject = null ;
		}
	}
}