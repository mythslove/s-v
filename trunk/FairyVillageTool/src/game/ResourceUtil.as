package game
{
	import bing.animation.AnimationBitmap;
	import bing.res.ResPool;
	import bing.res.ResType;
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.IOErrorEvent;
	
	public class ResourceUtil extends ResPool
	{
		private static var _instance:ResourceUtil; 
		public static function get instance():ResourceUtil
		{
			if(!_instance) _instance = new ResourceUtil();
			return _instance ;
		}
		//==================================
		public function ResourceUtil()
		{
			super();
			if(_instance){
				throw new Error("重复实例化");
			}
			this.cdns = Vector.<String>([""]);
			this.maxLoadNum = 10 ;
			this.addEventListener(IOErrorEvent.IO_ERROR , resLoadErrorHandler );
		}
		
		override protected function handleRes(resVO:ResVO , resLoader:Object):void
		{
			switch(resVO.resType)
			{
				case ResType.IMG :
					var bmd:BitmapData= (resLoader.contentLoaderInfo.content as Bitmap).bitmapData;
					if(resVO.frames>1){
						resVO.resObject = AnimationBitmap.splitBitmap( bmd,resVO.row,resVO.col,resVO.frames);
						bmd.dispose();
					}else{
						resVO.resObject = bmd ;
					}
					resLoader.unloadAndStop();
					break ;
				default:
					resVO.resObject = resLoader ;
					break;
			}
		}
		
		private function resLoadErrorHandler( e:IOErrorEvent ):void
		{
			trace( e.text );
		}
	}
}