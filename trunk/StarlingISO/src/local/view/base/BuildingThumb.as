package local.view.base
{
	import bing.res.ResVO;
	import bing.utils.FixScale;
	
	import local.util.ResourceUtil;
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;
	import local.vo.RoadResVO;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class BuildingThumb extends Sprite
	{
		private var _img:Image ;
		
		/**
		 * 建筑的缩略图构造函数 
		 * @param name 建筑的名称
		 * @param maxW 最大的宽度
		 * @param maxH 最大的高度
		 */	
		public function BuildingThumb(name:String ,  maxW:int , maxH:int)
		{
			var tempName:String = name+"_0_000" ;
			_img = new Image(TextureAssets.instance.buildingTexture.getTexture(tempName));
			var resVO:ResVO = ResourceUtil.instance.getResVOByResId(name);
			if(resVO.resObject is Vector.<BitmapAnimResVO>)
			{
				var barvo:Vector.<BitmapAnimResVO> = resVO.resObject as Vector.<BitmapAnimResVO> ;
				_img.x=barvo[0].offsetX ;
				_img.y=barvo[0].offsetY ;
			}
			else if( resVO.resObject is RoadResVO )
			{
				var roadResVO:RoadResVO = resVO.resObject as RoadResVO ;
				_img.x=roadResVO.offsetXs[name];
				_img.y=roadResVO.offsetYs[name];
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