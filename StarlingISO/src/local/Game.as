package local
{
	import bing.starling.iso.SIsoGrid;
	import bing.starling.iso.SIsoScene;
	import bing.starling.iso.SIsoWorld;
	
	import flash.geom.Point;
	
	import starling.display.*;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Game extends SIsoWorld
	{
		public function Game()
		{
			super( GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE );
			this.panTo(GameSetting.MAP_WIDTH>>1 , 250);
			this.x = (GameSetting.SCREEN_WIDTH-GameSetting.MAP_WIDTH*scaleX)>>1 ;
			y=-120;
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler( e:Event ):void
		{
			addBg();
			
			var gridScene:SIsoScene = new SIsoScene(GameSetting.GRID_SIZE);
			var grid:SIsoGrid = new SIsoGrid(_gridX,_gridZ,_size);
			gridScene.addChild(grid ) ;
			this.addScene(gridScene);
			
//			var img:Image = new Image( Assets.createTextureByName("house1") );
//			addChild(img);
		}
		
		
		private function addBg():void
		{
			var bg:Sprite = new Sprite() ;
			//地面
			var bgTexture:Texture = Assets.createTextureByName("bgFill1");
			bgTexture.repeat = true ;
			var img:Image = new Image(bgTexture);
			var factor:Number = GameSetting.MAP_WIDTH/GameSetting.MAP_HEIGHT ;
			var tile:int = GameSetting.MAP_WIDTH/256 ;
			var horizontally:int = tile ;
			var vertically:int = tile/factor ;
			img.setTexCoords(1,new Point(horizontally,0));
			img.setTexCoords(2,new Point(0,vertically));
			img.setTexCoords(3,new Point(horizontally,vertically));
			img.width = GameSetting.MAP_WIDTH ;
			img.height = GameSetting.MAP_HEIGHT ;
			bg.addChild( img );
			//树
			
			
			this.setBackGround( bg );
			bg.flatten();
		}
	}
}