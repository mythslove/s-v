package local.map.cell
{
	import bing.utils.InteractivePNG;
	
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	
	import local.vo.BitmapAnimResVO;

	/**
	 * 显示建筑修建状态 
	 * @author zhouzhanglin
	 */	
	public class BuildStatusObject  extends InteractivePNG
	{
		private var _bmp:Bitmap ;
		private var _tinyBmp:Bitmap ;
		private var _tinyAlpha:Number = 0.05 ;
		
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
			
			
			_tinyBmp = new Bitmap();
			var transform:ColorTransform = _tinyBmp.transform.colorTransform;
			transform.color = 0xffffff;
			_tinyBmp.transform.colorTransform = transform ;
			_tinyBmp.visible=false ;
			addChild(_tinyBmp);
		}
		
		/**
		 *  显示资源
		 */		
		public function show( barvo:BitmapAnimResVO ):void
		{
			_bmp.bitmapData = barvo.bmds[0] ;
			_bmp.x = barvo.offsetX ;
			_bmp.y = barvo.offsetY ;
			_bmp.scaleX = barvo.scaleX ;
			_bmp.scaleY = barvo.scaleY ;
			
			_tinyBmp.bitmapData = barvo.bmds[0] ;
			_tinyBmp.x = barvo.offsetX ;
			_tinyBmp.y = barvo.offsetY ;
			_tinyBmp.scaleX = barvo.scaleX ;
			_tinyBmp.scaleY = barvo.scaleY ;
		}
		
		public function update():void
		{
			if(_tinyBmp.visible){
				_tinyBmp.alpha += _tinyAlpha;
				if(_tinyBmp.alpha>1){
					_tinyAlpha = -0.05 ;
				}else if(_tinyBmp.alpha<-0.5){
					_tinyAlpha = 0.05 ;
				}
			}
		}
		
		public function flash( value:Boolean ):void
		{
			if( _tinyBmp.visible==value) return ;
			
			_tinyBmp.visible=value ;
			if(value){
				_tinyBmp.alpha=0.5;
				_tinyAlpha = 0.1 ;
			}
		}
		
		public function dispose():void
		{
			_bmp = null ;
			_tinyBmp = null ;
			super.disableInteractivePNG() ;
		}
	}
}