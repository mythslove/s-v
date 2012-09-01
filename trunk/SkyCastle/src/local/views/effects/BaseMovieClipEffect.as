package local.views.effects
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import local.views.base.BaseView;
	
	
	/**
	 * 基本的特效缓存类 ，只播放一次就消失，如果设置了次数，则根据次数来判断
	 * @param bmpMC
	 * @param loopTime 循环次数，0为无限
	 * @author zzhanglin
	 */	
	public class BaseMovieClipEffect extends BaseView
	{
		private var _bmpMC:BitmapMovieClip;
		private var _loopTime:int ;
		private var _currentLoop:int ;
		
		public function BaseMovieClipEffect(bmpMC:BitmapMovieClip=null , loopTime:int = 1 )
		{
			super();
			_bmpMC = bmpMC;
			_loopTime = loopTime ;
			addChild(_bmpMC);
		}
		
		override protected function added():void
		{
			addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			_bmpMC.addEventListener(Event.COMPLETE , onAnimComplete);
			_bmpMC.gotoAndPlay(1,_loopTime);
		}
		
		private function onAnimComplete( e:Event ):void
		{
			_bmpMC.stop();
			removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			if(parent){
				parent.removeChild(this);
			}
		}
		
		private function onEnterFrameHandler( e:Event):void
		{
			if(_bmpMC.update()){
				var rect:Rectangle = _bmpMC.getBound();
				_bmpMC.x = rect.x ;
				_bmpMC.y = rect.y ;
			}
		}
		
		override protected function removed():void
		{
			removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			_bmpMC.removeEventListener(Event.COMPLETE , onAnimComplete);
			_bmpMC.dispose();
			_bmpMC = null ;
		}
	}
}