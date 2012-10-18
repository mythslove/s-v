package local.map.cell
{
	import bing.starling.component.PixelsImage;
	
	import flash.display.Bitmap;
	
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.Color;

	/**
	 * 显示建筑修建状态 
	 * @author zhouzhanglin
	 */	
	public class BuildStatusObject  extends Sprite
	{
		private var _tinyAlpha:Number = 0.05 ;
		private var _tinyBmp:Image;
		
		public function BuildStatusObject( name:String , barvs:Vector.<BitmapAnimResVO>  )
		{
			super();
			var barv:BitmapAnimResVO = barvs[0];
			var pixelImg:PixelsImage = TextureAssets.instance.createBDLayerPixelsImage(name);
			addChild(pixelImg);
			_tinyBmp = new Image(TextureAssets.instance.buildingLayerTexture.getTexture(name));
			_tinyBmp.touchable =false ;
			_tinyBmp.blendMode = BlendMode.ADD ;
			_tinyBmp.color = Color.WHITE ;
			_tinyBmp.visible=false ;
			addChild(_tinyBmp);
			
			pixelImg.x = _tinyBmp.x =  barv.offsetX ;
			pixelImg.y = _tinyBmp.y =  barv.offsetY ;
			pixelImg.scaleX = _tinyBmp.scaleX =  barv.scaleX ;
			pixelImg.scaleY = _tinyBmp.scaleY =  barv.scaleY ;
		}
		
		
		public function update():void
		{
			if(_tinyBmp.visible){
				_tinyBmp.alpha += _tinyAlpha;
				if(_tinyBmp.alpha>=1){
					_tinyAlpha = -0.03 ;
				}else if(_tinyBmp.alpha<=0){
					_tinyAlpha = 0.03 ;
				}
			}
		}
		
		public function flash( value:Boolean ):void
		{
			if( _tinyBmp.visible==value) return ;
			
			_tinyBmp.visible=value ;
			if(value){
				_tinyBmp.alpha=0.5;
				_tinyAlpha = 0.1 ;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			_tinyBmp = null ;
		}
	}
}