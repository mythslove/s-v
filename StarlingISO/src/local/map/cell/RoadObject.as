package local.map.cell
{
	import local.vo.RoadResVO;
	
	import starling.display.Sprite;
	
	public class RoadObject extends Sprite
	{
		public var roadResVO:RoadResVO ;
//		private var _roadBmp:Bitmap = new Bitmap() ;
		
		public function RoadObject( name:String , roadResVO:RoadResVO )
		{
			super();
			this.name = name ;
			this.roadResVO = roadResVO ;
//			addChild(_roadBmp);
		}
		
		public function show( direction:String ):void
		{
//			_roadBmp.bitmapData = roadResVO.bmds[name+direction] ;
//			_roadBmp.x =  roadResVO.offsetXs[name+direction ] ;
//			_roadBmp.y =  roadResVO.offsetYs[name+direction ] ;
		}
		
		override public function dispose():void
		{
			super.dispose();
			roadResVO = null ;
//			_roadBmp = null ;
		}
	}
}