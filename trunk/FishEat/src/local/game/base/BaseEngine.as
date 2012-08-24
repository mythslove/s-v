package local.game.base
{
	import local.comm.GameData;
	import local.game.fish.*;
	import local.game.hero.Hero;
	import local.game.layer.UILayer;
	import local.level.BaseLevel;
	import local.utils.FishPool;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BaseEngine extends Sprite
	{
		public var hero:Hero = new Hero() ;
		public var biteFishs:Vector.<BaseFish> ;
		public var eatFish1:int; //吃的鱼1的数量
		public var eatFish2:int;//吃的鱼2的数量
		public var eatFish3:int;//吃的鱼3的数量
		public var eatFish4:int ;//吃的鱼4的数量
		public var score:int ; //分数
		public var uiLayer:UILayer;
		
		public function BaseEngine()
		{
			super();
			touchable = false ;
			addEventListener( Event.ADDED_TO_STAGE , addedHandler );
			addEventListener(Event.REMOVED_FROM_STAGE , removedHandler );
			
			uiLayer = new UILayer();
		}
		
		protected function addedHandler( e:Event ):void
		{
			removeAll();
			addChild(hero);
			hero.x=400 ;
			hero.y=200 ;
			hero.init();
			initBiteFishs();
			
			eatFish1 = 0 ; //吃的鱼1的数量
			eatFish2 = 0;//吃的鱼2的数量
			eatFish3 = 0 ;//吃的鱼3的数量
			eatFish4 = 0 ;//吃的鱼4的数量
			score =0 ; //分数
			
			addChild(uiLayer);
			uiLayer.init();
		}
		
		protected function initBiteFishs():void
		{
			biteFishs = new Vector.<BaseFish>();
			var level:BaseLevel = GameData.currentLv ;
			var fish:BaseFish ;
			for( var i:int =0  ; i<level.fish1Count ; ++i ) {
				fish= FishPool.getFish( Fish1 );
				fish.mx = level.fish1Speed;
				biteFishs.push( fish );
			}
			for( i =0  ; i<level.fish2Count ; ++i ) {
				fish=FishPool.getFish( Fish2 );
				fish.mx = level.fish2Speed;
				biteFishs.push( fish );
			}
			for( i =0  ; i<level.fish3Count ; ++i ) {
				fish=FishPool.getFish( Fish3 );
				fish.mx = level.fish3Speed;
				biteFishs.push( fish );
			}
			for( i =0  ; i<level.fish4Count ; ++i ) {
				fish=FishPool.getFish( Fish4 );
				fish.mx = level.fish4Speed;
				biteFishs.push( fish );
			}
			for( i =0  ; i<level.fish5Count ; ++i ) {
				fish=FishPool.getFish( Fish5 );
				fish.mx = level.fish5Speed;
				biteFishs.push( fish );
			}
			for( i =0  ; i<level.starCount ; ++i ) {
				fish=FishPool.getFish( Star );
				fish.mx = level.starSpeed;
				biteFishs.push( fish );
			}
			//设置位置
			for each(fish in biteFishs )
			{
				if(Math.random()>.5){
					fish.x = - (fish.texture.width*4)*Math.random() ;
				}else{
					fish.x = 960 + (fish.texture.width*4)*Math.random() ;
				}
				fish.y = Math.random()*640 ;
				addChildAt( fish,0);
				Starling.juggler.add( fish );
			}
		}
		
		protected function removeAll():void
		{
			var obj:DisplayObject ;
			while(numChildren>0){
				obj = this.removeChildAt(0);
				if(obj is IAnimatable){
					Starling.juggler.remove( obj as IAnimatable ) ;
				}
				if(obj is BaseFish){
					FishPool.addFishToPool( obj as BaseFish );
				}
			}
		}
		
		protected function removedHandler( e:Event ):void
		{
			removeAll();
			biteFishs = null ;
		}
	}
}