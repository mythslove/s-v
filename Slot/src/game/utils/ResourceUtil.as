package game.utils
{
	import bing.animation.AnimationBitmap;
	import bing.res.ResPool;
	import bing.res.ResType;
	import bing.res.ResVO;
	import bing.utils.SystemUtil;
	import bing.utils.sys_debug;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.IOErrorEvent;
	
	/**
	 * 游戏资源加载和保存以及处理的管理类 
	 * @author zhouzhanglin
	 */	
	public class ResourceUtil extends ResPool
	{
		private static var _instance:ResourceUtil; 
		
		public function ResourceUtil()
		{
			if(_instance){
				throw new Error("重复实例化");
			}
			
			this.cdns = Vector.<String>(["../"]);
			this.maxLoadNum = 5 ;
			this.addEventListener(IOErrorEvent.IO_ERROR , loadErrorHandler );
		}
		public static function get instance():ResourceUtil
		{
			if(!_instance) _instance = new ResourceUtil();
			return _instance ;
		}
		//==================================
		/**
		 * 处理加载完成的资源 
		 * @param resVO 
		 * @param resLoader 加载完成的数据
		 */		
		override protected function handleRes(resVO:ResVO, resLoader:Object):void
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
		
		/** 最终加载失败 */
		private function loadErrorHandler(e:IOErrorEvent):void
		{
			sys_debug(e.text);
		}
	}
}