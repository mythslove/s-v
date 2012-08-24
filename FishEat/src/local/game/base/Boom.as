package local.game.base
{
	import flashx.textLayout.debug.assert;
	
	import local.utils.AssetsManager;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Boom extends MovieClip
	{
		public function Boom()
		{
			super(AssetsManager.createTextureAtlas("fishTexture").getTextures("Boom_") , 20 );
			this.pivotX = this.texture.width>>1 ; 
			this.pivotY = this.texture.height>>1 ; 
			this.loop = false ;
			addEventListener( Event.ADDED_TO_STAGE , added );
		}
		
		private function added( e:Event ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE , added );
			addEventListener( Event.REMOVED_FROM_STAGE , removed );
			addEventListener( Event.COMPLETE , animCom );
			Starling.juggler.add(this);
		}
		
		private function animCom( e:Event ):void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
		
		private function removed( e:Event ):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE , removed );
			removeEventListener( Event.COMPLETE , animCom );
			Starling.juggler.remove(this);
			this.dispose() ;
		}
	}
}