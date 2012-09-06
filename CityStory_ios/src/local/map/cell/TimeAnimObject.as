package local.map.cell
{
	import bing.animation.ActionVO;
	import bing.animation.AnimationBitmap;
	import bing.animation.AnimationEvent;
	
	import flash.events.Event;
	
	import local.vos.BitmapAnimResVO;
	
	/**
	 * 有次数限制的动画 
	 * @author zhouzhanglin
	 */	
	public class TimeAnimObject extends BaseAnimObject
	{
		private var _time:int ;
		private var _autoDispose:Boolean ;
		
		/**
		 * 有次数限制的动画 
		 * @param vo 
		 * @param time 次数
		 * @param autoDispose 是否自己清除
		 */		
		public function TimeAnimObject(vo:BitmapAnimResVO , time:int=1 , autoDispose:Boolean=true )
		{
			super(vo);
			_autoDispose = autoDispose ;
			_time = time ;
		}
		
		override protected function init():void
		{
			super.init();
			if(_anim && _time>0){
				_anim.addEventListener(AnimationEvent.ANIMATION_COMPLETE , animCompleteHandler );
				_anim.cycleTime = _time ;
			}
			addEventListener(Event.ENTER_FRAME , onEnterFrame );
		}
		
		private function onEnterFrame( e:Event ):void
		{
			super.update() ;
		}
		
		private function animCompleteHandler( e:AnimationEvent ):void
		{
			_anim.removeEventListener(AnimationEvent.ANIMATION_COMPLETE , animCompleteHandler );
			if(_autoDispose){
				if(parent) parent.removeChild(this);
				this.dispose();
			}
			removeEventListener(Event.ENTER_FRAME , onEnterFrame );
		}
		
	}
}