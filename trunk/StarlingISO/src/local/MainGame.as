package local
{
	import bing.starling.iso.SIsoWorld;
	
	import local.comm.GameSetting;
	import local.map.GameWorld;
	import local.util.PopUpManager;
	import local.util.TextureAssets;
	import local.view.CenterViewLayer;
	
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
			
			
			addChild( GameWorld.instance );
			
			addChild(CenterViewLayer.instance);
			
			addChild(PopUpManager.instance);
			
//			var bmp:Bitmap = new Bitmap( TextureAssets.instance.groundLayerBmd);
//			bmp.scaleX  = bmp.scaleY = .4 ;
//			Starling.current.nativeStage.addChild(bmp);
		}
	}
}