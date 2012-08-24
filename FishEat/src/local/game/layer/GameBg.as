package local.game.layer
{
	import flash.geom.Point;
	
	import local.utils.AssetsManager;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	
	public class GameBg extends Sprite
	{
		private var _wave:Image ;
		
		public function GameBg()
		{
			super();
			touchable = false ;
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			//背景颜色
			var quad:Quad = new Quad( 960 , 640);
			quad.setVertexColor(0, 0x01617E ) ;
			quad.setVertexColor(1, 0xD6EDF6 ) ;
			quad.setVertexColor(2, 0x014D5F ) ;
			quad.setVertexColor(3, 0x014D5F ) ;
			quad.blendMode = BlendMode.NONE ;
			addChild(quad);
			
			//后地
			var ground:Image = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("Bg2") ) ;
			ground.x = -400 ;
			ground.y = 400;
			addChild(ground);
			
			//船
			ground = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("Ship") ) ;
			ground.rotation = deg2rad(-10) ;
			ground.x = 300 ;
			ground.y = 200;
			addChild(ground);
			
			//箱子
			ground = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("Box") ) ;
			ground.x = 650 ;
			ground.y = 330;
			addChild(ground);
			
			
			//水草
			var grass:MovieClip = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("Grass1_") ) ;
			grass.x = 200 ;
			grass.y = 335;
			addChild(grass);
			Starling.juggler.add( grass );
			grass = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("Grass2_") ) ;
			grass.x = 540 ;
			grass.y = 360;
			addChild(grass);
			Starling.juggler.add( grass );
			grass = new MovieClip( AssetsManager.createTextureAtlas("uiTexture").getTextures("Grass1_") ) ;
			grass.x = 840 ;
			grass.y = 400 ;
			addChild(grass);
			Starling.juggler.add( grass );
			
			
			//前地
			ground = new Image( AssetsManager.createTextureAtlas("uiTexture").getTexture("Bg1") ) ;
			ground.scaleX = ground.scaleY = 1.5 ;
			ground.x = -100 ;
			ground.y = 460;
			addChild(ground);
			
			//波纹
			var wave:Wave = new Wave();
			wave.y = 300 ;
			addChild(wave);
			
			wave = new Wave();
			wave.scaleX = wave.scaleY=2 ;
			addChild(wave);
		}
	}
}



//=======================
import local.utils.AssetsManager;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

class Wave extends Sprite
{
	private var _waves:Vector.<Image> ;
	public function Wave()
	{
		_waves = new Vector.<Image>(2,true);
		 var wave:Image = new Image(AssetsManager.createTextureAtlas("uiTexture").getTexture("Wave_000") ) ;
		addChild(wave);
		_waves[0] = wave ;
		
		wave = new Image(AssetsManager.createTextureAtlas("uiTexture").getTexture("Wave_000") ) ;
		wave.x = wave.texture.width  ;
		addChild(wave);
		_waves[1] = wave ;
		
		addEventListener(Event.ENTER_FRAME , update );
	}
	
	private function update( e:Event):void
	{
		for each( var img:Image in _waves)
		{
			img.x+=3;
			if(img.x>img.texture.width){
				img.x=-img.texture.width+3  ;
			}
		}
	}
}