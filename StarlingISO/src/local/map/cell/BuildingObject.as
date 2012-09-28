package local.map.cell
{
	import bing.starling.component.PixelsImage;
	import bing.starling.component.PixelsMovieClip;
	
	import flash.geom.Rectangle;
	
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	public class BuildingObject extends Sprite
	{
		private var _bavos:Vector.<BitmapAnimResVO> ;
		private var _tinyImg:Image ;
		private var _tinyAlpha:Number = 0.05 ;
		
		public function BuildingObject( name:String , bavos:Vector.<BitmapAnimResVO> )
		{
			this._bavos = bavos ;
			this.name = name ;
			init();
		}
		
		private function init():void
		{
			var len:int = _bavos.length ;
			var vo:BitmapAnimResVO ;
			var img:Image ;
			var mc:MovieClip ;
			var tempName:String ;
			for( var i:int = 0 ; i <len ; ++i ){
				vo = _bavos[i] ;
				tempName = name+"_"+i+"_" ;
				if(vo.isAnim)
				{
					var regions:Vector.<Rectangle> = new Vector.<Rectangle>(vo.frame , true );
					for( var j:int = 0 ; j<vo.frame ; ++j ){
						regions[j] = TextureAssets.instance.buildingTexture.getRegion(  tempName+j ) ;
					}
					if(i==0){
						mc = new PixelsMovieClip( TextureAssets.instance.buildingTexture.getTextures(tempName),  TextureAssets.instance.buildingBmd ,
							regions , (Starling.current.nativeStage.frameRate/vo.rate)>>0 );
					}else{
						mc = new MovieClip( TextureAssets.instance.buildingTexture.getTextures(tempName) , (Starling.current.nativeStage.frameRate/vo.rate)>>0 ) ;
						mc.touchable = false ;
					}
					mc.x = vo.offsetX ;
					mc.y = vo.offsetY ;
					addChild( mc );
					Starling.juggler.add( mc );
				}
				else
				{
					tempName += "0" ;
					if(i==0){
						img = new PixelsImage(TextureAssets.instance.buildingTexture.getTexture(tempName) , TextureAssets.instance.buildingBmd ,
							TextureAssets.instance.buildingTexture.getRegion(tempName)  ); 
					}else{
						img = new Image( TextureAssets.instance.buildingTexture.getTexture( tempName )  ) ;
						img.touchable = false ;
					}
					img.x = vo.offsetX ;
					img.y = vo.offsetY ;
					addChild(img);
				}
			}
		}
		
		public function update():void
		{
//			for( var i:int = 0 ; i<numChildren ; ++i){
//				if(getChildAt(i) is MovieClip ){
//					trace(( getChildAt(i) as MovieClip ).currentFrame);
//				}
//			}
//			if(_tinyBmp.visible){
//				_tinyBmp.alpha += _tinyAlpha;
//				if(_tinyBmp.alpha>1){
//					_tinyAlpha = -0.05 ;
//				}else if(_tinyBmp.alpha<-0.5){
//					_tinyAlpha = 0.05 ;
//				}
//			}
		}
		
		public function flash( value:Boolean ):void
		{
//			if( _tinyBmp.visible==value) return ;
//			
//			_tinyBmp.visible=value ;
//			if(value){
//				_tinyBmp.alpha=0.5;
//				_tinyAlpha = 0.1 ;
//			}
		}
		
		override public function dispose():void
		{
			super.dispose();
//			for( var i:int = 0 ; i<numChildren ; ++i){
//				if(getChildAt(i) is BaseAnimObject ){
//					( getChildAt(i) as BaseAnimObject ).dispose() ;
//				}
//			}
//			_bavos = null ;
//			_tinyBmp = null ;
//			super.disableInteractivePNG() ;
		}
	}
}