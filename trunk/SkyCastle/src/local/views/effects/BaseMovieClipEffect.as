package local.views.effects
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	
	/**
	 * 基本的特效缓存类 ，只播放一次就消失，如果设置了次数，则根据次数来判断
	 * @param bmpMC
	 * @param loopTime 循环次数，0为无限
	 * @author zzhanglin
	 */	
	public class BaseMovieClipEffect extends Sprite
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
			addEventListener(Event.ADDED_TO_STAGE , addedHandler , false , 0 , true );
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			addEventListener(Event.REMOVED_FROM_STAGE , removedHander , false , 0 , true );
			addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			onEnterFrameHandler(null);
		}
		
		private function onEnterFrameHandler( e:Event):void
		{
			if(_bmpMC.currentFrame==_bmpMC.totalFrame){
				++_currentLoop ;
				if(_loopTime>0 && _loopTime==_currentLoop)
				{
					_bmpMC.stop();
					removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
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
			else 
			{
				_bmpMC.play();
				rect = _bmpMC.getBound();
				_bmpMC.x = rect.x ;
				_bmpMC.y = rect.y ;
			}
		}
		
		private function removedHander( e:Event ):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE , removedHander);
			removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			_bmpMC.dispose();
			_bmpMC = null ;
		}
	}
}