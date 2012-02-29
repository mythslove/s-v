package local.game.cell
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * 建筑的动画，主要用于缓存位图动画 
	 * @author zzhanglin
	 */	
	public class BuildingBitmapAnimation extends Sprite
	{
		private var _bmpMC:BitmapMovieClip;
		
		public function BaseMovieClipEffect(bmpMC:BitmapMovieClip=null)
		{
			super();
			_bmpMC = bmpMC;
			addChild(_bmpMC);
		}
		
		public function update():void
		{
			if(_bmpMC.currentFrame==_bmpMC.totalFrame){
				_bmpMC.stop();
				if(parent){
					parent.removeChild(this);
				}
			}
			else
			{
				_bmpMC.play();
				var rect:Rectangle = _bmpMC.getBound();
				_bmpMC.x = rect.x ;
				_bmpMC.y = rect.y ;
			}
		}
		
		public function dispose():void
		{
			_bmpMC.dispose();
			_bmpMC = null ;
		}
	}
}