package local.scenes
{
	import local.comm.GameData;
	import local.comm.GlobalDispatcher;
	import local.comm.GlobalEventType;
	import local.game.GameEngine;
	import local.game.fish.*;
	import local.game.hero.*;
	import local.game.layer.GameBg;
	import local.scenes.component.SoundButton;
	import local.utils.FishPool;
	import local.utils.SoundManager;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class World extends Sprite
	{
		private static var _instance:World ;
		public static function get instance():World {
			if(!_instance) _instance = new World();
			return _instance ;			
		}
		//=======================================
		
		public var startScene:StartScene = new StartScene();
		public var levelScene:LevelScene = new LevelScene();
		public var overScene:OverScene = new OverScene();
		
		public var soundButton:SoundButton ;
		
		private var _sceneContainer:Sprite ;
		
		public function World()
		{
			super();
			_instance = this ;
			
			FishPool.registerFish( Fish1 );
			FishPool.registerFish( Fish1 );
			FishPool.registerFish( Fish1 );
			
			FishPool.registerFish( Fish2 );
			FishPool.registerFish( Fish2 );
			FishPool.registerFish( Fish2 );
			
			FishPool.registerFish( Fish3 );
			FishPool.registerFish( Fish3 );
			FishPool.registerFish( Fish3 );
			
			FishPool.registerFish( Fish4 );
			FishPool.registerFish( Fish4 );
			
			FishPool.registerFish( Fish5 );
			
			FishPool.registerFish( Hero );
			
			addChild( new GameBg() );
			
			_sceneContainer = new  Sprite();
			addChild( _sceneContainer );
			
			soundButton = new SoundButton();
			soundButton.y = 640 - 150 ;
			addChild(soundButton );
			SoundManager.playSoundBg();
			
			//初始化显示开始场景
			showStartScene();
			
			//侦听全局事件
			GlobalDispatcher.instance.addEventListener( GlobalEventType.HERO_DEAD , globalEvtHandler);
			GlobalDispatcher.instance.addEventListener( GlobalEventType.LEVEL_PASSED , globalEvtHandler);
		}
		
		private function globalEvtHandler( e:Event):void
		{
			if( e.type==GlobalEventType.HERO_DEAD ){
				this.showStartScene() ;
			}else if( e.type==GlobalEventType.LEVEL_PASSED ){
				this.showLevelScene() ;
			}
		}
		
		public function showStartScene():void
		{
			removeScene();
			GameData.currentLv=null;
			_sceneContainer.addChild(startScene);
		}
		
		public function showLevelScene():void
		{
			removeScene();
			_sceneContainer.addChild(levelScene);
		}
		
		public function showOverScene():void
		{
			removeScene();
			_sceneContainer.addChild(overScene);
		}
		
		public function showGameScene():void
		{
			removeScene();
			_sceneContainer.addChild( GameEngine.instance );
		}
		
		private function removeScene():void
		{
			if(_sceneContainer.numChildren>0){
				_sceneContainer.removeChildAt(0);
			}
		}
	}
}