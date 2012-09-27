package local
{
	import bing.starling.iso.SIsoWorld;
	
	import local.comm.GameSetting;
	import local.util.TextureAssets;
	
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
			
//			var world:GameWorld = new GameWorld();
//			addChild( world );
	
			var img:Image = new Image( TextureAssets.instance.buildingTexture.getTexture("Basic_Tree1_0_0") );
			addChild(img);
		}
	}
}