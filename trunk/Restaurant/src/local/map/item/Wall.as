package local.map.item
{
	import bing.starling.component.PixelsImage;
	
	import local.util.ResourceUtil;
	import local.util.TextureAssets;
	import local.vo.BitmapAnimResVO;

	public class Wall extends BaseMapObject
	{
		public var direction:int ;
		
		public function Wall()
		{
			super();
		}
		
		override public function showUI():void
		{
			var temp:String = direction==2 ? "WALL_LEFT" : "WALL_RIGHT" ;
			var barVO:BitmapAnimResVO = (ResourceUtil.instance.getResVOByResId(temp).resObject as Vector.<BitmapAnimResVO>)[0];
			var img:PixelsImage = TextureAssets.instance.createGDLayerPixelsImage(barVO.resName+"_000");
			img.x = barVO.offsetX ;
			img.y = barVO.offsetY ;
			img.scaleX = barVO.scaleX ;
			img.scaleY = barVO.scaleY ;
			addChild(img);
		}
	}
}