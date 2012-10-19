package local.map.cell
{
	import bing.starling.component.PixelsImage;
	
	import local.util.TextureAssets;
	import local.vo.RoadResVO;
	
	import starling.display.Sprite;
	
	public class RoadObject extends Sprite
	{
		public var roadResVO:RoadResVO ;
		private var _pixlesImg:PixelsImage ;
		
		public function RoadObject( name:String , roadResVO:RoadResVO )
		{
			super() ;
			this.name = name ;
			this.roadResVO = roadResVO ;
			_pixlesImg = TextureAssets.instance.createBDLayerPixelsImage( name );
			addChild(_pixlesImg);
		}
		
		public function show( direction:String ):void
		{
			_pixlesImg.texture = TextureAssets.instance.buildingLayerTexture.getTexture(name+direction);
			_pixlesImg.x =  roadResVO.offsetXs[name+direction ] ;
			_pixlesImg.y =  roadResVO.offsetYs[name+direction ] ;
			_pixlesImg.regionRect = TextureAssets.instance.buildingLayerTexture.getRegion(name+direction);
		}
		
		override public function dispose():void
		{
			super.dispose() ;
			_pixlesImg = null ;
			roadResVO = null ;
		}
	}
}