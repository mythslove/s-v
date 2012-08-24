package local.scenes
{
	import com.greensock.TweenLite;
	
	import local.comm.GameData;
	import local.level.*;
	import local.scenes.component.LevelMap;
	import local.utils.AssetsManager;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class LevelScene extends Sprite
	{
		private var _map:Sprite ;
		private var _island1:MovieClip ;
		private var _island2:MovieClip ;
		private var _fish1:MovieClip ;
		private var _fish2:MovieClip ;
		private var _startBtn:Button ;
		private var _lvMap:LevelMap ;
		private var _lvTf:TextField; 
		
		public function LevelScene()
		{
			super();
			init();
			addEventListener(Event.ADDED_TO_STAGE , added);
			addEventListener(Event.REMOVED_FROM_STAGE , removed);
		}
		
		private function init():void
		{
			_map = new Sprite();
			_map.touchable = false ;
			addChild(_map);
			//背景颜色
			var quad:Quad = new Quad( 960 , 640);
			quad.color = 0x23A7CD ;
			quad.blendMode = BlendMode.NONE ;
			_map.addChild(quad);
			//添加花
			var flowerTexture:Texture = AssetsManager.createTextureAtlas("uiTexture").getTexture("LevelFlower_000");
			var flower:Image = new Image(flowerTexture);
			flower.x = 100 ;
			flower.y = 100 ;
			_map.addChild( flower );
			flower = new Image(flowerTexture);
			flower.scaleX = flower.scaleY = 0.5 ;
			flower.x = 80 ;
			flower.y = 180 ;
			_map.addChild( flower );
			flower = new Image(flowerTexture);
			flower.rotation=deg2rad(90);
			flower.x = 920 ;
			flower.y = 320 ;
			_map.addChild( flower );
			flower = new Image(flowerTexture);
			flower.scaleX = flower.scaleY = 0.7 ;
			flower.x = 480 ;
			flower.y = 50 ;
			_map.addChild( flower );
			//岛
			_island1 = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("LevelIsland_") ) ;
			_island1.x = 200 ;
			_island1.y = 320 ;
			_map.addChild( _island1 );
			_island2 = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("LevelIsland_") ) ;
			_island2.x = 600 ;
			_island2.y = 500 ;
			_island2.scaleX = _island2.scaleY = 0.7 ;
			_map.addChild( _island2 );
			//树
			var tree:Image = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("LevelTree_000") ) ;
			tree.x = 250 ;
			tree.y = 220 ;
			_map.addChild( tree );
			tree = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("LevelTree_000") ) ;
			tree.scaleX = tree.scaleY = 0.7 ;
			tree.x = 650 ;
			tree.y = 440 ;
			_map.addChild( tree );
			//鱼
			_fish1 = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("LevelFish_") ) ;
			_fish1.x = 500 ;
			_fish1.y = 100 ;
			_map.addChild( _fish1 );
			_fish2 = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("LevelFish_") ) ;
			_fish2.x = 400 ;
			_fish2.y = 530 ;
			_map.addChild( _fish2 );
			//船
			var ship:Image = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("LevelShip_000") ) ;
			ship.x = 700 ;
			_map.addChild( ship );
			//地图
			_lvMap = new LevelMap();
			//开始按钮
			_startBtn = new Button( AssetsManager.createTextureAtlas("uiTexture").getTexture("StartButtonUp") ,"",
				AssetsManager.createTextureAtlas("uiTexture").getTexture("StartButtonDown"));
			_startBtn.x = 700;
			_startBtn.y = 220;
			addChild ( _startBtn );
			_startBtn.addEventListener(Event.TRIGGERED , onStartHandler );
			//字
			_lvTf = new TextField(500,120,"" , "desyrel" , 40 , 0xffcc00 );
			_lvTf.x = 120 ;
			_lvTf.y = 640-100 ;
			addChild ( _lvTf );
		}
		
		private function added( e:Event ):void
		{
			Starling.juggler.add( _island1 );
			Starling.juggler.add( _island2 );
			Starling.juggler.add( _fish1 );
			Starling.juggler.add( _fish2 );
			
			
			if(!GameData.currentLv){
				GameData.currentLv = new Level0();
			}else{
				var lv:int = GameData.currentLv.level+1;
				switch( lv){
					case 1:
						GameData.currentLv = new Level1();
						break ;
					case 2:
						GameData.currentLv = new Level2();
						break ;
					case 3:
						GameData.currentLv = new Level3();
						break ;
					case 4:
						GameData.currentLv = new Level4();
						break ;
					case 5:
						GameData.currentLv = new Level5();
						break ;
					case 6:
						GameData.currentLv = new Level6();
						break ;
					case 7:
						GameData.currentLv = new Level7();
						break ;
					case 8:
						GameData.currentLv = new Level8();
						break ;
				}
			}
			_map.addChild( _lvMap );
			
			_lvTf.text = "Level"+(GameData.currentLv.level+1)+" "+GameData.currentLv.name ;
			_lvTf.y = 760;
			TweenLite.to( _lvTf , 0.25 , {y:640-100 } );
		}
		
		private function onStartHandler( e:Event ):void
		{
			World.instance.showGameScene()
		}
		
		private function removed( e:Event ):void
		{
			Starling.juggler.remove( _island1 );
			Starling.juggler.remove( _island2 );
			Starling.juggler.remove( _fish1 );
			Starling.juggler.remove( _fish2 );
			_map.removeChild( _lvMap );
		}
	}
}
