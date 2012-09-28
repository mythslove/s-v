package local
{
	import bing.starling.component.PixelsMovieClip;
	import bing.starling.iso.SIsoObject;
	
	import flash.geom.Rectangle;
	
	import local.util.EmbedManager;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	
	public class Birds extends SIsoObject
	{
		
		private var _mc:PixelsMovieClip ;
		
		public function Birds(size:Number, xSpan:int=1, zSpan:int=1)
		{
			super(size, xSpan, zSpan);
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler ( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			
			var atalsTexture:TextureAtlas = EmbedManager.createTextureAtlas("Atlas") ;
			
			_mc = new PixelsMovieClip( atalsTexture.getTextures("GhostHouse")  , 
				EmbedManager.getBmd("Atlas") , new<Rectangle>[
					atalsTexture.getRegion("GhostHouseLv3000"),atalsTexture.getRegion("GhostHouseLv3001"),
					atalsTexture.getRegion("GhostHouseLv3002"),atalsTexture.getRegion("GhostHouseLv3003"),
					atalsTexture.getRegion("GhostHouseLv3004"),atalsTexture.getRegion("GhostHouseLv3005"),
					atalsTexture.getRegion("GhostHouseLv3006"),atalsTexture.getRegion("GhostHouseLv3007"),
					atalsTexture.getRegion("GhostHouseLv3008"),atalsTexture.getRegion("GhostHouseLv3009")
				] );

			addChild(_mc);
			_mc.x = -90 ;
			_mc.y = -67 ;
			Starling.juggler.add(_mc);
		}
	}
}