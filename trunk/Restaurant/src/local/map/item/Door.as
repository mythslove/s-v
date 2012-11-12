package local.map.item
{
	import local.util.ResourceUtil;
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;
	import local.vo.ItemVO;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	public class Door extends WallDecor
	{
		private var _mc:MovieClip ;
		
		public function Door(itemVO:ItemVO)
		{
			super(itemVO);
		}
		
		override public function showUI():void
		{
			removeChildren(0,-1,true);
			var barvo:Vector.<BitmapAnimResVO> = ResourceUtil.instance.getResVOByResId( name ).resObject as  Vector.<BitmapAnimResVO> ;
			var vo:BitmapAnimResVO;
			var len:int = barvo.length;
			for( var i:int = 0 ; i <len ; ++i ){
				vo = barvo[i] ;
				if(vo.isAnim)
				{
					_mc = new MovieClip( TextureAssets.instance.groundLayerTexture.getTextures(vo.resName+"_") , (Starling.current.nativeStage.frameRate/vo.rate)>>0 ) ;
					_mc.x = vo.offsetX>>0 ;
					_mc.y = vo.offsetY>>0 ;
					_mc.scaleX = vo.scaleX ;
					_mc.scaleY = vo.scaleY ;
					addChild( _mc );
					_mc.addEventListener(Event.COMPLETE , animCompleteHandler );
				}
			}
		}
		
		
		private function animCompleteHandler( e:Event):void
		{
			_mc.stop();
			Starling.juggler.remove(_mc);
		}
		
		public function playAnim():void
		{
			if(!_mc.isPlaying) {
				Starling.juggler.add(_mc);
				_mc.play() ;
			}
		}
		
		override public function dispose():void{
			Starling.juggler.remove(_mc);
			super.dispose();
		}
	}
}