package local.game
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	
	import local.game.fish.*;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.*;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var _hero:Hero ;
		private var _biteFishs:Vector.<BaseFish> ;
		private var _heroLoc:Point = new Point(450,300);
		
		public function Game()
		{
			super();
			touchable = false ;
			addEventListener(Event.ADDED_TO_STAGE,addedHandler);
		}
		
		private function addedHandler( e:Event ):void
		{
			_hero = new Hero();
			_hero.x=1000 ;
			_hero.y=100 ;
			addChild(_hero);
			Starling.juggler.add( _hero );
			TweenLite.to( _hero , 2 , { x:450 , y:300 , onComplete:run } );
		}
		
		private function run():void
		{
			stage.addEventListener(TouchEvent.TOUCH , onTouchHandler );
			initBiteFishs() ;
			addEventListener(Event.ENTER_FRAME , update );
		}
		
		private function onTouchHandler( e:TouchEvent ):void
		{
			if(e.touches.length>0)
			{
				var touch:Touch = e.touches[0] ;
				_heroLoc.x = touch.globalX ;
				_heroLoc.y = touch.globalY ;
			}
		}
		
		private function initBiteFishs():void
		{
			var num:int = 10 ;
			_biteFishs = new Vector.<BaseFish>(num,true) ;
			var fish:BaseFish ;
			for( var i:int = 0 ; i<num ; ++i )
			{
				if(i<4){
					fish = new BiteFish4();
				}else if(i<6){
					fish = new BiteFish3();
				}else if(i<7){
					fish = new BiteFish1();
				}else if(i<num){
					fish = new BiteFish2();
				}
				_biteFishs[i] = fish  ;
			}
			//设置位置
			for each(fish in _biteFishs )
			{
				if(Math.random()>.5)
				{
					fish.x = -fish.texture.width*Math.random() ;
				}
				else
				{
					fish.x = 960*Math.random() + fish.texture.width ;
				}
				fish.y = Math.random()*500+50 ;
				addChildAt( fish,0);
				Starling.juggler.add( fish );
			}
		}
		
		
		private function update( e:Event ):void
		{
			for each( var fish:BaseFish in _biteFishs )
			{
				fish.update();
			}
			
			if( _heroLoc.x -_hero.x>0){
				_hero.scaleX = -1 ;
			}else{
				_hero.scaleX = 1 ;
			}
			_hero.x+=( _heroLoc.x -_hero.x)*0.1 ;
			_hero.y+=( _heroLoc.y -_hero.y)*0.1 ;
		}
	}
}