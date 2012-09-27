package local.map.cell
{
	import bing.starling.component.PixelsImage;
	
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;
	
	import starling.display.Image;
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
			var layer:int ; //层
			var img:Image ;
			var tempName:String ;
			for( var i:int = 0 ; i <len ; ++i ){
				vo = _bavos[i] ;
				if(vo.isAnim)
				{
					
				}
				else
				{
					tempName = name+"_"+layer+"_"+i ;
					if(i==0){
						img = new PixelsImage(TextureAssets.instance.buildingTexture.getTexture(tempName) , TextureAssets.instance.buildingBmd ,
							TextureAssets.instance.buildingTexture.getRegion(tempName)  ); 
					}else{
						img = new Image( TextureAssets.instance.buildingTexture.getTexture( tempName )  ) ;
					}
					img.x = vo.offsetX ;
					img.y = vo.offsetY ;
					addChild(img);
				}
				++layer ;
			}
		}
		
		public function update():void
		{
//			for( var i:int = 0 ; i<numChildren ; ++i){
//				if(getChildAt(i) is BaseAnimObject ){
//					( getChildAt(i) as BaseAnimObject ).update() ;
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
		
		public function dispose():void
		{
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