package local.map.cell
{
	import bing.animation.AnimationEvent;
	
	import flash.events.Event;
	
	import local.util.ObjectPool;
	import local.vo.BitmapAnimResVO;
	
	/**
	 * 有次数限制的动画 
	 * @author zhouzhanglin
	 */	
	public class TimeAnimObject extends BaseAnimObject
	{
		public var time:int  =1 ; //默认运行一次
		
		/**
		 * 有次数限制的动画 
		 * @param vo 
		 */		
		public function TimeAnimObject(vo:BitmapAnimResVO  )
		{
			super(vo);
		}
		
		override protected function init():void
		{
			super.init();
			_anim.addEventListener(AnimationEvent.ANIMATION_COMPLETE , animCompleteHandler );
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			if(_anim && time>0){
				_anim.cycleTime = time ;
				_anim.start();
			}
			addEventListener(Event.ENTER_FRAME , onEnterFrame );
		}
		
		private function onEnterFrame( e:Event ):void
		{
			super.update() ;
		}
		
		private function animCompleteHandler( e:AnimationEvent ):void
		{
			removeEventListener(Event.ENTER_FRAME , onEnterFrame );
			if(parent) {
				parent.removeChild(this);
			}
			ObjectPool.instance.addObjectToPool( this );
		}
		
	}
}