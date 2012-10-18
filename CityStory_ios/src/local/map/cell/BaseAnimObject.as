package local.map.cell
{
	import bing.animation.ActionVO;
	import bing.animation.AnimationBitmap;
	
	import flash.display.Bitmap;
	
	import local.vo.BitmapAnimResVO;
	
	public class BaseAnimObject extends Bitmap
	{
		protected var _anim:AnimationBitmap ;
		protected var _vo:BitmapAnimResVO ;
		
		public function BaseAnimObject( vo:BitmapAnimResVO )
		{
			super();
			this._vo = vo ;
			init();
		}
		
		protected function init():void
		{
			x = _vo.offsetX ;
			y = _vo.offsetY ;
			scaleX = _vo.scaleX ;
			scaleY = _vo.scaleY ;
			if(_vo.isAnim){
				_anim = new AnimationBitmap( _vo.bmds,Vector.<ActionVO>([new ActionVO("anim",_vo.frame)]) , _vo.rate ) ;
			}
			bitmapData = _vo.bmds[0] ;
		}
		
		
		public function update():void
		{
			if(_vo.isAnim && _anim){
				_anim.playAction("anim")
				if(_anim.animationBmd!= bitmapData){
					 bitmapData = _anim.animationBmd ;
				}
			}
		}
		
		public function dispose():void
		{
			if(_anim) _anim.dispose() ;
			_anim = null ;
			_vo = null ;
			bitmapData =null ;
		}
	}
}