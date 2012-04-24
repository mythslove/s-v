package local.views.effects
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import local.game.cell.BitmapMovieClip;
	
	/**
	 * 基本的特效缓存类 ，只播放一次就消失
	 * @author zzhanglin
	 */	
	public class BaseMovieClipEffect extends Sprite
	{
		private var _bmpMC:BitmapMovieClip;
		
		public function BaseMovieClipEffect(bmpMC:BitmapMovieClip=null)
		{
			super();
			_bmpMC = bmpMC;
			addChild(_bmpMC);
			addEventListener(Event.ADDED_TO_STAGE , addedHandler , false , 0 , true );
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			addEventListener(Event.REMOVED_FROM_STAGE , removedHander , false , 0 , true );
			addEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
		}
		
		private function onEnterFrameHandler( e:Event):void
		{
			if(_bmpMC.currentFrame==_bmpMC.totalFrame){
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
		
		private function removedHander( e:Event ):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE , removedHander);
			removeEventListener(Event.ENTER_FRAME , onEnterFrameHandler );
			_bmpMC.dispose();
			_bmpMC = null ;
		}
	}
}