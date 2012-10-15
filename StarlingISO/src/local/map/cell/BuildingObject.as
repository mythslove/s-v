package local.map.cell
{
	import flash.geom.Rectangle;
	
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.utils.Color;
	
	public class BuildingObject extends Sprite
	{
		private var _bavos:Vector.<BitmapAnimResVO> ;
		private var _tinyImg:Image ;
		private var _tinyAlpha:Number = 0.03 ;
		
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
						var ext:String = j<10?"00"+j :  ( j<100?"0"+j:j+"") ;
						regions[j] = TextureAssets.instance.buildingTexture.getRegion(  tempName+ext ) ;
					}
					if(i==0){
						mc =TextureAssets.instance.createPixelsMovieClip( tempName,regions , (Starling.current.nativeStage.frameRate/vo.rate)>>0 );
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
					tempName += "000" ;
					if(i==0){
						img = TextureAssets.instance.createPixelsImage( tempName );
					}else{
						img = new Image( TextureAssets.instance.buildingTexture.getTexture( tempName )  ) ;
						img.touchable = false ;
					}
					img.x =  _bavos[0].offsetX ;
					img.y =  _bavos[0].offsetY ;
					addChild(img);
				}
			}
			
			
			_tinyImg = new Image(TextureAssets.instance.buildingTexture.getTexture( name+"_0_000" ) );
			_tinyImg.touchable = false ;
			_tinyImg.blendMode = BlendMode.ADD ;
			_tinyImg.color = Color.WHITE ;
			_tinyImg.x =  _bavos[0].offsetX ;
			_tinyImg.y =  _bavos[0].offsetY ;
			_tinyImg.visible=false ;
			addChild(_tinyImg);
		}
		
		public function update():void
		{
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