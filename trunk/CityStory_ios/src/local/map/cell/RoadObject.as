package local.map.cell
{
	import bing.utils.InteractivePNG;
	
	import flash.display.Bitmap;
	
	import local.vo.RoadResVO;
	
	public class RoadObject extends InteractivePNG
	{
		public var roadResVO:RoadResVO ;
		private var _roadBmp:Bitmap = new Bitmap() ;
		
		public function RoadObject( name:String , roadResVO:RoadResVO )
		{
			super();
			this.name = name ;
			mouseChildren = false ;
			this.roadResVO = roadResVO ;
			addChild(_roadBmp);
		}
		
		public function show( direction:String ):void
		{
			super._bitmapForHitDetection = _roadBmp ;
			_roadBmp.bitmapData = roadResVO.bmds[name+direction] ;
			_roadBmp.x =  roadResVO.offsetXs[name+direction ] ;
			_roadBmp.y =  roadResVO.offsetYs[name+direction ] ;
		}
		
		public function dispose():void
		{
			roadResVO = null ;
			_roadBmp = null ;
			super.disableInteractivePNG() ;
		}
	}
}