package local.map.cell
{
	import local.util.TextureAssets;
	import local.vo.RoadResVO;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class RoadObject extends Image
	{
		public var roadResVO:RoadResVO ;
		
		public function RoadObject( name:String , roadResVO:RoadResVO )
		{
			super();
			this.name = name ;
			this.roadResVO = roadResVO ;
		}
		
		public function show( direction:String ):void
		{
			texture = TextureAssets.instance.createGDLayerPixelsImage( name+direction);
			this.x =  roadResVO.offsetXs[name+direction ] ;
			this.y =  roadResVO.offsetYs[name+direction ] ;
		}
		
		override public function dispose():void
		{
			super.dispose();
			roadResVO = null ;
		}
	}
}