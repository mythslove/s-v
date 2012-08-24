package local.game
{
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import local.comm.GameData;
	import local.game.base.*;
	import local.game.fish.*;
	import local.utils.MathUtil;
	
	import starling.events.*;
	
	public class GameEngine extends BaseEngine
	{
		private static var _instance:GameEngine ;
		public static function get instance():GameEngine {
			if(!_instance) _instance = new GameEngine();
			return _instance ;			
		}
		//=======================================
		
		private var _heroLoc:Point = new Point(450,300);
		
		override protected function addedHandler( e:Event ):void
		{
			super.addedHandler(e);
			_heroLoc.x = 450 ;
			_heroLoc.y = 300 ;
			
			setTimeout( run , 500 );
		}
		
		private function run():void
		{
			stage.addEventListener(TouchEvent.TOUCH , onTouchHandler );
			addEventListener(Event.ENTER_FRAME , update );
		}
		
		private function onTouchHandler( e:TouchEvent ):void
		{
			if(e.touches.length>0)
			{
				var touch:Touch = e.touches[0] ;
				if(touch.phase==TouchPhase.MOVED){
					_heroLoc.x = touch.globalX ;
					_heroLoc.y = touch.globalY ;
				}
			}
		}
		
		
		private function update( e:Event ):void
		{
			if( _heroLoc.x -hero.x>0){
				hero.scaleX = -1 ;
			}else{
				hero.scaleX = 1 ;
			}
			hero.x+=( _heroLoc.x -hero.x)*0.04 ;
			hero.y+=( _heroLoc.y -hero.y)*0.04 ;
			for each( var fish:BaseFish in biteFishs ){
				fish.update();
				if(MathUtil.distance(hero.x,hero.y,fish.x,fish.y)<hero.wid + fish.radium)
				{
					if( !hero.isFlash)
					{
						if(hero.level>=fish.lv_score-1)
						{
							if( !hero.isBite )
							{
								var boom:Boom = new Boom();
								boom.x = hero.x ;
								boom.y = hero.y ;
								addChild(boom);
								hero.eat();
								if(fish.lv_score==1){
									++eatFish1 ;
								}else if(fish.lv_score==2){
									++eatFish2 ;
								}else if(fish.lv_score==3){
									++eatFish3 ;
								}else if(fish.lv_score==4){
									++eatFish4 ;
								}
								score+=fish.lv_score ;
								for( var i:int  =0  ; i<2 ; ++i){
									if(score-fish.lv_score<GameData.currentLv.requireFish[i] && score>=GameData.currentLv.requireFish[i]  ){
										hero.grow();
									}
								}
								//重置这条鱼
								if(Math.random()>.5){
									fish.x = - ( fish.texture.width*3 )*Math.random() ;
								}else{
									fish.x = 960 + (fish.texture.width*3)*Math.random() ;
								}
								fish.y = Math.random()*640 ;
								
								uiLayer.showInfo( GameData.currentLv.level+1,hero.hurtValue , score );
								
								//判断过关
								if(score>GameData.currentLv.requireScore){
									stage.removeEventListener(TouchEvent.TOUCH , onTouchHandler );
									removeEventListener(Event.ENTER_FRAME , update );
									removeAll();
									addChild(uiLayer);
									uiLayer.showComplete( eatFish1, eatFish2 , eatFish3 , eatFish4 , score );
									return ;
								}
							}
							
						}
						else
						{
							hero.hurt();
							uiLayer.showInfo( GameData.currentLv.level+1,hero.hurtValue , score );
							if(hero.hurtValue==0){
								stage.removeEventListener(TouchEvent.TOUCH , onTouchHandler );
								removeEventListener(Event.ENTER_FRAME , update );
								removeAll();
								addChild(uiLayer);
								uiLayer.showOver();
								return ;
							}
						}
						
					}
				}
				else if( hero.level>=fish.lv_score-1 && 
					fish.scaleX!=hero.scaleX && ( ( hero.x<fish.x && hero.scaleX==-1 )|| ( hero.x>fish.x && hero.scaleX==1 ) ) &&
					MathUtil.distance(hero.x,hero.y,fish.x,fish.y)<(hero.wid + fish.radium)*2 )
				{
					fish.mx=-fish.mx ;
				}
			}
			
		}
		
		override protected function removedHandler(e:Event):void
		{
			super.removedHandler(e);
			stage.removeEventListener(TouchEvent.TOUCH , onTouchHandler );
			removeEventListener(Event.ENTER_FRAME , update );
		}
	}
}