package utils
{
	import bing.animation.AnimationBitmap;
	import bing.res.ResPool;
	import bing.res.ResType;
	import bing.res.ResVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class ResourceUtil extends ResPool
	{
		private static var _instance:ResourceUtil; 
		
		public function ResourceUtil()
		{
			if(_instance){
				throw new Error("重复实例化");
			}
			this.cdns = Vector.<String>([""]);
			this.maxLoadNum = 5 ;
		}
		public static function get instance():ResourceUtil
		{
			if(!_instance) _instance = new ResourceUtil();
			return _instance ;
		}
		//==================================
		
		override protected function handleRes(resVO:ResVO , resLoader:Object):void
		{
			switch(resVO.resType)
			{
				case ResType.IMG :
					var bmd:BitmapData= (resLoader.contentLoaderInfo.content as Bitmap).bitmapData;
					if(resVO.frames>1){
						resVO.resObject = AnimationBitmap.splitBitmap( bmd,resVO.row,resVO.col,resVO.frames);
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
	}
}