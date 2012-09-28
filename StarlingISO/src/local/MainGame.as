package local
{
	import bing.starling.iso.SIsoWorld;
	
	import flash.display.Bitmap;
	
	import local.comm.GameSetting;
	import local.util.TextureAssets;
	
	import starling.core.Starling;
	import starling.display.*;
	import starling.events.Event;
	
	public class MainGame extends SIsoWorld
	{
		
		public function MainGame()
		{
			super( GameSetting.GRID_X,GameSetting.GRID_Z,GameSetting.GRID_SIZE );
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			//动态生成材质
			TextureAssets.instance.createBuildingTexture() ;
			
			
			var world:GameWorld = new GameWorld();
			addChild( world );
			
			var bmp:Bitmap = new Bitmap( TextureAssets.instance.buildingBmd);
			bmp.scaleX  = bmp.scaleY = .4 ;
			Starling.current.nativeStage.addChild(bmp);
		}
	}
}