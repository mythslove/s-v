package local.map.cell
{
	import bing.utils.InteractivePNG;
	
	import flash.display.Bitmap;
	
	import local.vo.BitmapAnimResVO;

	/**
	 * 显示建筑修建状态 
	 * @author zhouzhanglin
	 */	
	public class BuildStatusObject  extends InteractivePNG
	{
		private var _bmp:Bitmap ;
		
		public function BuildStatusObject()
		{
			super();
			mouseChildren = false ;
			init();
		}
		
		private function init():void
		{
			_bmp = new Bitmap();
			addChild(_bmp);
			super._bitmapForHitDetection = _bmp ;
		}
		
		/**
		 *  显示资源
		 */		
		public function show( barvo:BitmapAnimResVO ):void
		{
			_bmp.bitmapData = barvo.bmds[0] ;
			_bmp.x = barvo.offsetX ;
			_bmp.y = barvo.offsetY ;
		}
		
		public function dispose():void
		{
			_bmp = null ;
			super.disableInteractivePNG() ;
		}
	}
}