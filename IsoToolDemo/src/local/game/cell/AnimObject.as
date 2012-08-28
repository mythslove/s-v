package local.game.cell
{
	import bing.animation.ActionVO;
	import bing.animation.AnimationBitmap;
	
	import flash.display.Bitmap;
	
	import local.vos.BitmapAnimResVO;
	
	public class AnimObject extends Bitmap
	{
		private var _anim:AnimationBitmap ;
		private var _vo:BitmapAnimResVO ;
		
		public function AnimObject( vo:BitmapAnimResVO )
		{
			super();
			this._vo = vo ;
			init();
		}
		
		private function init():void
		{
			x = _vo.offsetX;
			y = _vo.offsetY ;
			if(_vo.isAnim)
			{
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
			_anim.dispose() ;
			_anim = null ;
			_vo = null ;
			bitmapData =null ;
		}
	}
}