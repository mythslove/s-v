package local.map.cell
{
	import bing.utils.InteractivePNG;
	
	import flash.display.Bitmap;
	
	import local.vo.RoadResVO;
	
	public class RoadObject extends InteractivePNG
	{
		private var _roadResVO:RoadResVO ;
		private var _roadBmp:Bitmap = new Bitmap() ;
		
		public function RoadObject( name:String , roadResVO:RoadResVO )
		{
			super();
			this.name = name ;
			mouseChildren = false ;
			this._roadResVO = roadResVO ;
			addChild(_roadBmp);
		}
		
		public function show( direction:String ):void
		{
			super._bitmapForHitDetection = _roadBmp ;
			_roadBmp.bitmapData = _roadResVO.bmds[name+direction] ;
			_roadBmp.x =  _roadResVO.offsetXs[name+direction ] ;
			_roadBmp.y =  _roadResVO.offsetYs[name+direction ] ;
		}
		
		public function dispose():void
		{
			_roadResVO = null ;
			_roadBmp = null ;
			super.disableInteractivePNG() ;
		}
	}
}