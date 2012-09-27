package local
{
	import bing.starling.iso.SIsoObject;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	public class Birds extends SIsoObject
	{
		
		private var _mc:MovieClip ;
		
		public function Birds(size:Number, xSpan:int=1, zSpan:int=1)
		{
			super(size, xSpan, zSpan);
			addEventListener(Event.ADDED_TO_STAGE , addedHandler );
		}
		
		private function addedHandler ( e:Event ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , addedHandler );
			_mc = new MovieClip( EmbedManager.createTextureAtlas("Atlas").getTextures("GhostHouse") );
			_mc.touchable = false ;
			addChild(_mc);
			_mc.x = -90 ;
			_mc.y = -67 ;
			Starling.juggler.add(_mc);
		}
	}
}