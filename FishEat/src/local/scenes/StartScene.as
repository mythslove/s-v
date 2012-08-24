package local.scenes
{
	import com.greensock.TweenLite;
	
	import local.utils.AssetsManager;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class StartScene extends Sprite
	{
		private var _fish1:MovieClip ;
		private var _fish2:MovieClip ;
		private var _fish3:MovieClip ;
		private var _fish4:MovieClip ;
		private var _playButton:Button ;
		private var _helpButton:Button ;
		
		public function StartScene()
		{
			super();
			init();
			
			addEventListener(Event.ADDED_TO_STAGE , added );
			addEventListener(Event.REMOVED_FROM_STAGE , removed );
		}
		
		private function init():void
		{
			_fish1 = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("StartFish1_") ) ;
			_fish2 = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("StartFish1_") ) ;
			_fish3 = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("StartFish2_") ) ;
			_fish4 = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("StartFish3_") ) ;
			
			_fish1.scaleX = -1 ;
			_fish2.scaleX = -1 ;
			addChild(_fish4);
			addChild(_fish3);
			addChild(_fish2);
			addChild(_fish1);
			_fish1.touchable = _fish2.touchable =_fish3.touchable =_fish4.touchable =false ;
			
			_playButton = new Button(
				AssetsManager.createTextureAtlas("uiTexture").getTexture("PlayButtonUp"),"",
				AssetsManager.createTextureAtlas("uiTexture").getTexture("PlayButtonDown") );
			_helpButton = new Button(
				AssetsManager.createTextureAtlas("uiTexture").getTexture("HelpButtonUp"),"",
				AssetsManager.createTextureAtlas("uiTexture").getTexture("HelpButtonDown") );
			_playButton.x = 960-350 ;
			_helpButton.x = 960-350 ;
			addChild(_playButton);
			addChild(_helpButton);
			_playButton.addEventListener(Event.TRIGGERED , onClickHandler );
			_helpButton.addEventListener(Event.TRIGGERED , onClickHandler );
		}
		
		private function added( e:Event):void
		{
			_fish1.x = _fish2.x =_fish3.x =_fish4.x =0 ;
			_fish1.y = _fish2.y =_fish3.y =_fish4.y =0 ;
			_fish1.alpha = _fish2.alpha =_fish3.alpha =_fish4.alpha =0 ;
			Starling.juggler.add( _fish1 );
			Starling.juggler.add( _fish2 );
			Starling.juggler.add( _fish3 );
			Starling.juggler.add( _fish4 );
			TweenLite.to( _fish1 , 2 ,{ x:550 , y:400 , alpha:1 } );
			TweenLite.to( _fish2 , 2 ,{ x:440 , y:350 , alpha:1, delay:0.5  } );
			TweenLite.to( _fish3 , 2 ,{ x:250 , y:200 , alpha:1, delay:1 } );
			TweenLite.to( _fish4 , 2 ,{ x:80 , y:120 , alpha:1, delay:2 , onComplete:showButtons } );
			
			//按钮初始位置
			_playButton.y = 640 ;
			_helpButton.y = 640 ;
		}
		
		private function showButtons():void
		{
			TweenLite.to( _playButton , 1 ,{  y:280 } );
			TweenLite.to( _helpButton , 1 ,{  y:400 , delay:0.5 } );
		}
		
		private function onClickHandler( e:Event ):void
		{
			if(e.target == _playButton)
			{
				World.instance.showLevelScene() ;
			}
		}
		
		private function removed( e:Event ):void
		{
			Starling.juggler.remove( _fish1 );
			Starling.juggler.remove( _fish2 );
			Starling.juggler.remove( _fish3 );
			Starling.juggler.remove( _fish4 );
		}
	}
}