package app.util
{
	import app.comm.Resource;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class ResourceUtil
	{
		private static var _instance:ResourceUtil ;
		public static function get instance():ResourceUtil
		{
			if(!_instance) _instance = new ResourceUtil();
			return _instance; 
		}
		//=======================================
		
		public var _pen:BitmapData ;
		public function get pen():BitmapData
		{
			if(!_pen) _pen = (new Resource.PEN() as Bitmap).bitmapData ;
			return _pen ;
		}
		
		public var _penMask:BitmapData ;
		public function get penMask():BitmapData
		{
			if(!_penMask) _penMask = (new Resource.PENMASK() as Bitmap).bitmapData ;
			return _penMask ;
		}
	}
}