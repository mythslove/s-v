package local.map.cell
{
	import flash.geom.Rectangle;
	
	import local.comm.GameSetting;
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.utils.Color;
	
	public class BuildingObject extends Sprite implements IAnimatable
	{
		private var _bavos:Vector.<BitmapAnimResVO> ;
		private var _tinyImg:Image ;
		private var _tinyAlpha:Number = 0.03 ;
		public var playAnim:Boolean = true ;
		
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
				tempName = vo.resName+"_" ;
				if(vo.isAnim)
				{
					var regions:Vector.<Rectangle> = new Vector.<Rectangle>(vo.frame , true );
					for( var j:int = 0 ; j<vo.frame ; ++j ){
						var ext:String = j<10?"00"+j :  ( j<100?"0"+j:j+"") ;
						regions[j] = TextureAssets.instance.buildingLayerTexture.getRegion(  tempName+ext ) ;
					}
					if(i==0){
						mc =TextureAssets.instance.createBDLayerPixelsMovieClip( tempName,regions , (Starling.current.nativeStage.frameRate/vo.rate)>>0 );
					}else{
						mc = new MovieClip( TextureAssets.instance.buildingLayerTexture.getTextures(tempName) , (Starling.current.nativeStage.frameRate/vo.rate)>>0 ) ;
						mc.touchable = false ;
					}
					mc.x = vo.offsetX*GameSetting.GAMESCALE ;
					mc.y = vo.offsetY*GameSetting.GAMESCALE ;
					mc.scaleX = vo.scaleX ;
					mc.scaleY = vo.scaleY ;
					addChild( mc );
				}
				else
				{
					tempName = vo.resName+"_000" ;
					if(i==0){
						img = TextureAssets.instance.createBDLayerPixelsImage( tempName );
					}else{
						img = new Image( TextureAssets.instance.buildingLayerTexture.getTexture( tempName )  ) ;
						img.touchable = false ;
					}
					img.x =  _bavos[0].offsetX*GameSetting.GAMESCALE ;
					img.y =  _bavos[0].offsetY*GameSetting.GAMESCALE ;
					img.scaleX =  _bavos[0].scaleX ;
					img.scaleY =  _bavos[0].scaleY ;
					
					addChild(img);
				}
			}
			
			
			_tinyImg = new Image(TextureAssets.instance.buildingLayerTexture.getTexture( _bavos[0].resName+"_000" ) );
			_tinyImg.touchable = false ;
			_tinyImg.blendMode = BlendMode.ADD ;
			_tinyImg.color = Color.WHITE ;
			_tinyImg.x =  _bavos[0].offsetX*GameSetting.GAMESCALE ;
			_tinyImg.y =  _bavos[0].offsetY*GameSetting.GAMESCALE ;
			_tinyImg.scaleX = _bavos[0].scaleX ;
			_tinyImg.scaleY = _bavos[0].scaleY ;
			_tinyImg.visible=false ;
			addChild(_tinyImg);
		}
		
		public function advanceTime(passedTime:Number):void
		{
			if(playAnim){
				for( var i:int = 0 ; i<numChildren ; ++i){
					if(getChildAt(i) is MovieClip ){
						( getChildAt(i) as MovieClip ).advanceTime( passedTime );
					}
				}
			}
			if(_tinyImg.visible){
				_tinyImg.alpha += _tinyAlpha;
				if(_tinyImg.alpha>=1){
					_tinyAlpha = -0.03 ;
				}else if(_tinyImg.alpha<=0){
					_tinyAlpha = 0.03 ;
				}
			}
		}
		
		public function flash( value:Boolean ):void
		{
			if( _tinyImg.visible==value) return ;
			
			_tinyImg.visible=value ;
			if(value){
				_tinyImg.alpha=0.5;
				_tinyAlpha = 0.1 ;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_tinyImg = null ;
		}
	}
}