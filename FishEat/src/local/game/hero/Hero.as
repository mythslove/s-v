package local.game.hero
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import local.comm.GlobalDispatcher;
	import local.comm.GlobalEventType;
	import local.game.base.BaseFish;
	import local.utils.SoundManager;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Hero extends Sprite
	{
		public var hurtValue:int=3 ;//伤害数，每关都有两次生命值
		public var level:int =1 ; //英雄的等级，英雄最高等级为3
		public var isFlash:Boolean ; //是否在闪烁
		private var _flashTimer:Timer = new Timer(20,40);
		
		private var _h1:Hero1 = new Hero1() ;
		private var _hb1:Hero1Bite = new Hero1Bite();
		private var _h2:Hero2 = new Hero2();
		private var _hb2:Hero2Bite = new Hero2Bite();
		private var _h3:Hero3 = new Hero3() ;
		private var _hb3:Hero3Bite = new Hero3Bite();
		
		private var _isBite:Boolean ;
		public function get isBite():Boolean{
			return _isBite ;
		}
		public function get wid():Number
		{
			return (getChildAt(0) as BaseFish).texture.width>>2 ;
		}
		
		public function Hero()
		{
			super();
			_flashTimer.addEventListener(TimerEvent.TIMER , onTimerHandler );
			_flashTimer.addEventListener(TimerEvent.TIMER_COMPLETE , onTimerHandler );
			
			_hb1.addEventListener( "complete" , onAnimComplete );
			_hb2.addEventListener( "complete" , onAnimComplete );
			_hb3.addEventListener( "complete" , onAnimComplete );
			
		}
		
		/**
		 * 初始化 
		 */		
		public function init():void
		{
			visible = true ;
			level = 1 ;
			hurtValue = 3;
			show();
		}
		
		/**
		 * 伤害 
		 */		
		public function hurt():void
		{
			SoundManager.playSoundHurt();
			hurtValue-- ;
			if(hurtValue==0){
				_flashTimer.stop() ;
			}else{
				flash();
			}
		}
		
		/**
		 * 长大一级 
		 */		
		public function grow():void
		{
			if(level<3){
				++level ;
				show();
				flash();
				SoundManager.playSoundGrow();
			}
		}
		
		/**
		 * 闪烁 ，当碰到大鱼和生长时闪烁，在此期间不受伤害
		 */		
		private function flash():void
		{
			if(!isFlash){
				isFlash = true ;
				_flashTimer.reset();
				_flashTimer.start() ;
			}
		}
		
		/**
		 * 吃鱼 
		 */		
		public function eat():void
		{
			show(true);
			SoundManager.playSoundBite() ;
		}
		
		
		private function onTimerHandler( e:TimerEvent ):void
		{
			switch(e.type)
			{
				case TimerEvent.TIMER:
					visible = !visible ;
					break ;
				case TimerEvent.TIMER_COMPLETE:
					isFlash = false ;
					visible = true ;
					break ;
			}
		}
		
		private function show( isBite:Boolean=false ):void
		{
			if(isBite){
				if(_isBite==isBite) return ;
			}
			_isBite = isBite ;
			removeAll();
			switch(level)
			{
				case 1:
					if(isBite) {
						addChild( _hb1 );
						Starling.juggler.add( _hb1 );
					}else{
						addChild( _h1 );
						Starling.juggler.add( _h1 );
					}
					break ;
				case 2:
					if(isBite) {
						addChild( _hb2 );
						Starling.juggler.add( _hb2 );
					}else{
						addChild( _h2 );
						Starling.juggler.add( _h2 );
					}
					break ;
				case 3:
					if(isBite) {
						addChild( _hb3 );
						Starling.juggler.add( _hb3 );
					}else{
						addChild( _h3 );
						Starling.juggler.add( _h3 );
					}
					break ;
			}
		}
		
		private function onAnimComplete( e:Event ):void
		{
			show();
		}
		
		private function removeAll():void
		{
			var obj:DisplayObject ;
			while(numChildren>0){
				obj = this.removeChildAt(0);
				if(obj is IAnimatable){
					Starling.juggler.remove( obj as IAnimatable ) ;
				}
			}
		}
	}
}