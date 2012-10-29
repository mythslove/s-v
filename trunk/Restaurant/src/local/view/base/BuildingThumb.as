package local.view.base
{
	import bing.res.ResVO;
	import bing.utils.FixScale;
	
	import local.util.ResourceUtil;
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class BuildingThumb extends Sprite
	{
		private var _img:Image ;
		
		/**
		 * 建筑的缩略图构造函数 
		 * @param name 建筑的名称
		 * @param maxW 最大的宽度
		 * @param maxH 最大的高度
		 */	
		public function BuildingThumb(name:String , isWallLayer:Boolean,  maxW:int , maxH:int)
		{
			var resVO:ResVO = ResourceUtil.instance.getResVOByResId(name);
			if(resVO.resObject is Vector.<BitmapAnimResVO>)
			{
				var barvo:Vector.<BitmapAnimResVO> = resVO.resObject as Vector.<BitmapAnimResVO> ;
				if(isWallLayer){
					_img = new Image(TextureAssets.instance.groundLayerTexture.getTexture(barvo[0].resName+"_000"));
				}else{
					_img = new Image(TextureAssets.instance.buildingLayerTexture.getTexture(barvo[0].resName+"_000"));
				}
				_img.x=barvo[0].offsetX ;
				_img.y=barvo[0].offsetY ;
			}
			addChild(_img);
			FixScale.setScale( this , maxW , maxH );
		}
		
		public function setScale( value:Number):void
		{
			_img.scaleX = _img.scaleY = value ;
			_img.x*=value;
			_img.y*=value;
		}
		
		public function center():void
		{
			_img.x = -_img.width>>1 ;
			_img.y = -_img.height>>1 ;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_img){
				_img.dispose() ;
				_img = null ;
			}
		}
	}
}