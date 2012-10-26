package local.map.cell
{
	import flash.geom.Rectangle;
	
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	
	public class ItemObject extends Sprite implements IAnimatable
	{
		private var _bavos:Vector.<BitmapAnimResVO> ;
		private var _itemOrGround:Boolean ;
		
		public function ItemObject( name:String , bavos:Vector.<BitmapAnimResVO> , itemOrGround:Boolean )
		{
			this._bavos = bavos ;
			this._itemOrGround = itemOrGround ;
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
			
			var textureAtlas :TextureAtlas = _itemOrGround? TextureAssets.instance.buildingLayerTexture : TextureAssets.instance.groundLayerTexture ;
			
			for( var i:int = 0 ; i <len ; ++i ){
				vo = _bavos[i] ;
				tempName = vo.resName+"_" ;
				if(vo.isAnim)
				{
					var regions:Vector.<Rectangle> = new Vector.<Rectangle>(vo.frame , true );
					for( var j:int = 0 ; j<vo.frame ; ++j ){
						var ext:String = j<10?"00"+j :  ( j<100?"0"+j:j+"") ;
						regions[j] = textureAtlas.getRegion(  tempName+ext ) ;
					}
					if(i==0){
						if(_itemOrGround){
							mc =TextureAssets.instance.createBDLayerPixelsMovieClip( tempName,regions , (Starling.current.nativeStage.frameRate/vo.rate)>>0 );
						}else{
							mc =TextureAssets.instance.createGDLayerPixelsMovieClip( tempName,regions , (Starling.current.nativeStage.frameRate/vo.rate)>>0 );
						}
					}else{
						mc = new MovieClip( textureAtlas.getTextures(tempName) , (Starling.current.nativeStage.frameRate/vo.rate)>>0 ) ;
						mc.touchable = false ;
					}
					mc.x = vo.offsetX ;
					mc.y = vo.offsetY ;
					mc.scaleX = vo.scaleX ;
					mc.scaleY = vo.scaleY ;
					addChild( mc );
				}
				else
				{
					if(vo.roads){
						var container:Sprite = new Sprite();
						container.name = "container";
						container.x =vo.offsetX ;
						container.y = vo.offsetY ;
						addChild(container);
					}else{
						tempName = vo.resName+"_000" ;
						if(i==0){
							if(_itemOrGround){
								img = TextureAssets.instance.createBDLayerPixelsImage( tempName );
							}else{
								img = TextureAssets.instance.createGDLayerPixelsImage( tempName );
							}
						}else{
							img = new Image( textureAtlas.getTexture( tempName )  ) ;
							img.touchable = false ;
						}
						img.x =  vo.offsetX ;
						img.y =  vo.offsetY ;
						img.scaleX = vo.scaleX ;
						img.scaleY = vo.scaleY ;
						
						addChild(img);
					}
				}
			}
		}
		
		public function advanceTime(passedTime:Number):void
		{
			for( var i:int = 0 ; i<numChildren ; ++i){
				if(getChildAt(i) is MovieClip ){
					( getChildAt(i) as MovieClip ).advanceTime( passedTime );
				}
			}
		}
		
	}
}