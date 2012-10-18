package local.map.cell
{
	import bing.starling.component.PixelsImage;
	
	import local.util.TextureAssets;
	import local.vo.RoadResVO;
	
	public class RoadObject extends PixelsImage
	{
		public var roadResVO:RoadResVO ;
		
		public function RoadObject( name:String , roadResVO:RoadResVO )
		{
			super( TextureAssets.instance.groundLayerTexture.getTexture(name) , TextureAssets.instance.groundLayerBmd , null )
			this.name = name ;
			this.roadResVO = roadResVO ;
		}
		
		public function show( direction:String ):void
		{
			texture = TextureAssets.instance.groundLayerTexture.getTexture(name+direction);
			this.x =  roadResVO.offsetXs[name+direction ] ;
			this.y =  roadResVO.offsetYs[name+direction ] ;
			this.regionRect = TextureAssets.instance.groundLayerTexture.getRegion(name+direction);
		}
		
		override public function dispose():void
		{
			super.dispose();
			roadResVO = null ;
		}
	}
}