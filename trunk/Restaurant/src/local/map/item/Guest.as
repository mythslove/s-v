package local.map.item
{
	import bing.starling.component.FrameSprite;
	
	import local.vo.ItemVO;
	
	/**
	 * 客人 
	 * @author zhouzhanglin
	 */	
	public class Guest extends BaseItem
	{
		private var _frameSprite:FrameSprite ;
		
		public function Guest(itemVO:ItemVO)
		{
			super(itemVO);
			touchable = false ;
		}
		
		override public function showUI():void
		{
			removeChildren(0,-1,true);
			_frameSprite = new FrameSprite();
			
//			var vo:BitmapAnimResVO=(ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO>)[0] ;
//			var textures:Vector.<Texture> = TextureAssets.instance.groundLayerTexture.getTextures(vo.resName+"_") ;
//			var fps:int = (Starling.current.nativeStage.frameRate/vo.rate)>>0 ;
//			_frameSprite.addFrame( new MovieClip( textures.slice(0,1) as Vector.<Texture> , 1000 ) ,"normal") ;
//			_frameSprite.addFrame( new MovieClip( textures.slice(0,6) as Vector.<Texture> , fps )  ,"open") ;
//			_frameSprite.addFrame( new MovieClip( textures.slice(7) as Vector.<Texture>, fps )  ,"close")  ;
//			_frameSprite.x = vo.offsetX  ;
//			_frameSprite.y = vo.offsetY  ;
//			_frameSprite.scaleX = vo.scaleX ;
//			_frameSprite.scaleY = vo.scaleY ;
//			addChild(_frameSprite);
//			_frameSprite.play("normal");
//			_frameSprite.stop();
		}
		
		
		
		override public function dispose():void{
			_frameSprite.destroy();
			_frameSprite = null ;
			super.dispose();
		}
	}
}