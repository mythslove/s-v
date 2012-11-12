package local.map.item
{
	import bing.starling.component.FrameSprite;
	
	import flash.utils.setTimeout;
	
	import local.util.ResourceUtil;
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;
	import local.vo.ItemVO;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Door extends WallDecor
	{
		private var _frameSprite:FrameSprite;
		
		public function Door(itemVO:ItemVO)
		{
			super(itemVO);
		}
		
		override public function showUI():void
		{
			removeChildren(0,-1,true);
			_frameSprite = new FrameSprite();
			
			var vo:BitmapAnimResVO=(ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO>)[0] ;
			var textures:Vector.<Texture> = TextureAssets.instance.groundLayerTexture.getTextures(vo.resName+"_") ;
			var fps:int = (Starling.current.nativeStage.frameRate/vo.rate)>>0 ;
			_frameSprite.addFrame( new MovieClip( textures.slice(0,1) as Vector.<Texture> , fps ) ,"normal") ;
			_frameSprite.addFrame( new MovieClip( textures.slice(1,6) as Vector.<Texture> , fps )  ,"open") ;
			_frameSprite.addFrame( new MovieClip( textures.slice(6) as Vector.<Texture>, fps )  ,"close")  ;
			_frameSprite.x = vo.offsetX>>0 ;
			_frameSprite.y = vo.offsetY>>0 ;
			_frameSprite.scaleX = vo.scaleX ;
			_frameSprite.scaleY = vo.scaleY ;
			addChild(_frameSprite);
			_frameSprite.play("normal");
			_frameSprite.stop();
		}
		
		public function openDoor():void
		{
			if(_frameSprite.getCurrentFrameLabel()=="normal") {
				_frameSprite.play("open");
				_frameSprite.getCurrentFrameMovieClip().addEventListener(Event.COMPLETE , animCompleteHandler );
			}
		}
		
		private function animCompleteHandler( e:Event ):void
		{
			_frameSprite.getCurrentFrameMovieClip().removeEventListener(Event.COMPLETE , animCompleteHandler );
			if(_frameSprite.getCurrentFrameLabel()=="open") {
				setTimeout(closeDoor , 500 );
			}else{
				_frameSprite.play("normal");
			}
			_frameSprite.stop();
		}
		
		private function closeDoor():void
		{
			_frameSprite.play("close");
			_frameSprite.getCurrentFrameMovieClip().addEventListener(Event.COMPLETE , animCompleteHandler );
		}
	}
}